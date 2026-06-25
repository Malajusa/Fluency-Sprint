param(
  [string]$RepoPath = "."
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

function Write-Step($Message) {
  Write-Host ""
  Write-Host "==> $Message" -ForegroundColor Cyan
}

function Fail($Message) {
  throw "Mr Slay patch failed: $Message"
}

$repoFullPath = Resolve-Path $RepoPath
$indexPath = Join-Path $repoFullPath "index.html"

if (-not (Test-Path $indexPath)) {
  Fail "Could not find index.html in '$repoFullPath'. Run this script from the Fluency-Sprint repo folder, or pass -RepoPath."
}

Write-Step "Reading index.html"
$html = Get-Content -Path $indexPath -Raw -Encoding UTF8
$originalHtml = $html

$backupPath = Join-Path $repoFullPath ("index.backup.mr-slay.{0}.html" -f (Get-Date -Format "yyyyMMdd-HHmmss"))
Copy-Item -Path $indexPath -Destination $backupPath -Force
Write-Host "Backup created: $backupPath"

function Add-BeforeFirstAnchor {
  param(
    [string[]]$Anchors,
    [string]$Insertion,
    [string]$Marker,
    [string]$Description
  )

  if ($script:html.Contains($Marker)) {
    Write-Host "Already present: $Description"
    return
  }

  foreach ($anchor in $Anchors) {
    $idx = $script:html.IndexOf($anchor)
    if ($idx -ge 0) {
      $script:html = $script:html.Substring(0, $idx) + $Insertion + $script:html.Substring($idx)
      Write-Host "Inserted: $Description"
      return
    }
  }

  Fail "Could not find anchor for $Description"
}

function Replace-Once {
  param(
    [string]$Search,
    [string]$Replacement,
    [string]$Marker,
    [string]$Description,
    [switch]$Optional
  )

  if ($Marker -and $script:html.Contains($Marker)) {
    Write-Host "Already present: $Description"
    return
  }

  $idx = $script:html.IndexOf($Search)
  if ($idx -lt 0) {
    if ($Optional) {
      Write-Host "Skipped optional replacement: $Description"
      return
    }
    Fail "Could not find search block for $Description"
  }

  $script:html = $script:html.Substring(0, $idx) + $Replacement + $script:html.Substring($idx + $Search.Length)
  Write-Host "Updated: $Description"
}

function Replace-RegexOnce {
  param(
    [string]$Pattern,
    [string]$Replacement,
    [string]$Marker,
    [string]$Description,
    [switch]$Optional
  )

  if ($Marker -and $script:html.Contains($Marker)) {
    Write-Host "Already present: $Description"
    return
  }

  $rx = [regex]$Pattern
  if (-not $rx.IsMatch($script:html)) {
    if ($Optional) {
      Write-Host "Skipped optional regex replacement: $Description"
      return
    }
    Fail "Could not find pattern for $Description"
  }

  $script:html = $rx.Replace($script:html, $Replacement, 1)
  Write-Host "Updated: $Description"
}

Write-Step "Applying Mr Slay CSS"

$mrSlayCss = @'

    /* Mr Slay contextual helper NPC */
    .mr-slay-overlay {
      position: fixed;
      inset: 0;
      z-index: 80;
      display: grid;
      place-items: center;
      padding: 1rem;
      background: rgba(23, 32, 51, 0.42);
    }

    .mr-slay-modal {
      width: min(940px, 100%);
      max-height: min(92vh, 780px);
      overflow: auto;
      border: 3px solid var(--line);
      border-radius: calc(var(--radius) + 4px);
      background: #fffdf7;
      box-shadow: 0 24px 70px rgba(23, 32, 51, 0.24);
    }

    .mr-slay-grid {
      display: grid;
      grid-template-columns: minmax(13rem, 0.85fr) minmax(0, 1.35fr);
      gap: 1rem;
      align-items: stretch;
    }

    .mr-slay-card {
      border: 2px solid #fed7aa;
      border-radius: var(--radius);
      background: linear-gradient(160deg, #fff7ed, #ffffff);
      padding: 1rem;
      display: flex;
      flex-direction: column;
      gap: 0.75rem;
      min-height: 100%;
    }

    .mr-slay-portrait {
      width: 6.25rem;
      height: 6.25rem;
      border-radius: 24px;
      display: grid;
      place-items: center;
      background: #1f2937;
      color: white;
      border: 4px solid #fed7aa;
      font-size: 2rem;
      font-weight: 950;
      box-shadow: var(--shadow);
    }

    .mr-slay-bubble {
      position: relative;
      border: 2px solid var(--blue);
      border-radius: 22px;
      background: white;
      padding: 0.85rem 1rem;
      font-weight: 900;
      line-height: 1.25;
    }

    .mr-slay-bubble::after {
      content: "";
      position: absolute;
      left: 1.2rem;
      bottom: -0.75rem;
      width: 1rem;
      height: 1rem;
      background: white;
      border-left: 2px solid var(--blue);
      border-bottom: 2px solid var(--blue);
      transform: rotate(-25deg);
    }

    .mr-slay-whiteboard {
      border: 3px solid #cbd5e1;
      border-radius: var(--radius);
      background: linear-gradient(180deg, #ffffff 0%, #f8fafc 100%);
      padding: 1rem;
      box-shadow: inset 0 0 0 2px rgba(203, 213, 225, 0.5);
      min-height: 18rem;
    }

    .mr-slay-whiteboard h3 {
      margin-bottom: 0.75rem;
      color: var(--blue);
    }

    .mr-slay-board-lines {
      display: grid;
      gap: 0.45rem;
      font-size: clamp(1.35rem, 3vw, 2rem);
      font-weight: 950;
      line-height: 1.2;
    }

    .mr-slay-board-line {
      padding: 0.15rem 0;
      color: #172033;
    }

    .mr-slay-board-line.final {
      color: var(--teal-dark);
      font-size: 1.12em;
      text-decoration: underline;
      text-decoration-thickness: 3px;
      text-underline-offset: 0.18em;
    }

    .mr-slay-prompt {
      margin-top: 0.85rem;
      border-left: 4px solid var(--gold);
      padding-left: 0.75rem;
      color: var(--muted);
    }

    .mr-slay-results-panel {
      border-color: #fed7aa;
      background: linear-gradient(135deg, #fff7ed 0%, #ffffff 55%, #eefcff 100%);
    }

    @media (max-width: 860px) {
      .mr-slay-grid {
        grid-template-columns: 1fr;
      }

      .mr-slay-portrait {
        width: 5rem;
        height: 5rem;
      }
    }
'@

Add-BeforeFirstAnchor `
  -Anchors @("`r`n    @media (min-width: 861px)", "`n    @media (min-width: 861px)", "`r`n    @media (max-width: 860px)", "`n    @media (max-width: 860px)", "`r`n  </style>", "`n  </style>") `
  -Insertion $mrSlayCss `
  -Marker ".mr-slay-overlay" `
  -Description "Mr Slay CSS"

Write-Step "Adding helper content bank"

$helperRegistry = @'

      var MR_SLAY_HELPERS = {
        general: {
          title: "Mr Slay says...",
          bubble: "Pick a strategy before you rush.",
          board: [
            "1. Read the question",
            "2. Choose a fact you know",
            "3. Check your answer"
          ],
          prompt: "Try the next one carefully first. Speed can come after accuracy."
        },

        multiplicationGeneral: {
          title: "Multiplication strategy",
          bubble: "Swap the order if it helps.",
          board: [
            "7 x 3 = 3 x 7",
            "Both facts have the same product.",
            "3 x 7 = 21"
          ],
          prompt: "Look for the order that feels easier."
        },

        times0: {
          title: "0 times table",
          bubble: "Zero groups means zero altogether.",
          board: [
            "0 x 8 = 0",
            "8 groups of nothing is still 0."
          ],
          prompt: "Any number multiplied by 0 gives 0."
        },

        times1: {
          title: "1 times table",
          bubble: "The 1s keep the number the same.",
          board: [
            "1 x 9 = 9",
            "One group of 9 is 9."
          ],
          prompt: "Think: one group only."
        },

        times2: {
          title: "2 times table",
          bubble: "For 2s, just double it.",
          board: [
            "2 x 8",
            "= 8 + 8",
            "= 16"
          ],
          prompt: "Double the other factor."
        },

        times3: {
          title: "3 times table",
          bubble: "For 3s, check the digit sum.",
          board: [
            "3 x 8 = 24",
            "2 + 4 = 6",
            "6 follows the 3s pattern."
          ],
          prompt: "Use this as a check after you calculate."
        },

        times4: {
          title: "4 times table",
          bubble: "For 4s, double it, then double it again.",
          board: [
            "4 x 6",
            "6 -> 12 -> 24"
          ],
          prompt: "Double once for 2 groups, then again for 4 groups."
        },

        times5: {
          title: "5 times table",
          bubble: "5s end in 0 or 5.",
          board: [
            "5 x 7 = 35",
            "Odd x 5 ends in 5.",
            "5 x 8 = 40",
            "Even x 5 ends in 0."
          ],
          prompt: "Use the final digit to check your answer."
        },

        times6: {
          title: "6 times table",
          bubble: "For 6s, double the 3s fact.",
          board: [
            "6 x 4",
            "= 2 x (3 x 4)",
            "= 2 x 12",
            "= 24"
          ],
          prompt: "If you know the 3s, double it for the 6s."
        },

        times7: {
          title: "7 times table",
          bubble: "For 7s, use 5 groups and 2 groups.",
          board: [
            "7 x 4",
            "= (5 x 4) + (2 x 4)",
            "= 20 + 8",
            "= 28"
          ],
          prompt: "Now try your question using the same 5 + 2 idea."
        },

        times8: {
          title: "8 times table",
          bubble: "For 8s, double three times.",
          board: [
            "8 x 3",
            "3 -> 6 -> 12 -> 24"
          ],
          prompt: "Double, double, then double once more."
        },

        times9: {
          title: "9 times table",
          bubble: "For 9s, do 10 groups then take one group away.",
          board: [
            "9 x 7",
            "= (10 x 7) - 7",
            "= 70 - 7",
            "= 63"
          ],
          prompt: "Use the 10s fact, then subtract one group."
        },

        times10: {
          title: "10 times table",
          bubble: "For 10s, think place value.",
          board: [
            "10 x 6 = 60",
            "6 ones become 6 tens."
          ],
          prompt: "The number shifts into the tens place."
        },

        times11: {
          title: "11 times table",
          bubble: "For 11s up to 9, repeat the digit.",
          board: [
            "11 x 8 = 88",
            "11 x 12",
            "= 110 + 22",
            "= 132"
          ],
          prompt: "For larger facts, break 11 into 10 and 1."
        },

        times12: {
          title: "12 times table",
          bubble: "For 12s, use 10 groups and 2 groups.",
          board: [
            "12 x 7",
            "= (10 x 7) + (2 x 7)",
            "= 70 + 14",
            "= 84"
          ],
          prompt: "Break 12 apart into 10 and 2."
        },

        divisionGeneral: {
          title: "Division fact families",
          bubble: "Turn division into a multiplication fact.",
          board: [
            "42 / 6 = ?",
            "6 x ? = 42",
            "6 x 7 = 42",
            "So 42 / 6 = 7"
          ],
          prompt: "Think of the matching times-table fact."
        }
      };
'@

Add-BeforeFirstAnchor `
  -Anchors @("`r`n      var liveStore = loadStore();", "`n      var liveStore = loadStore();", "`r`n      const liveStore = loadStore();", "`n      const liveStore = loadStore();") `
  -Insertion $helperRegistry `
  -Marker "var MR_SLAY_HELPERS =" `
  -Description "Mr Slay helper content bank"

Write-Step "Adding Mr Slay state"

Replace-RegexOnce `
  -Pattern '(reviewIndex:\s*0,\s*)message:' `
  -Replacement ('$1' + "        mrSlayOpen: false,`r`n        message:") `
  -Marker "mrSlayOpen: false" `
  -Description "state.mrSlayOpen"

Write-Step "Adding helper resolver and modal functions"

$helperFunctions = @'

      function mrSlayTableFromQuestion(active) {
        if (!active || !active.question) return null;

        var text = String(active.question.text || "");
        var tables = active.practiceOptions ? normalizeTables(active.practiceOptions.tables) : [];

        if (active.question.operation === "division") {
          var divisionMatch = text.match(/(-?\d+)\s*\/\s*(-?\d+)/);
          if (divisionMatch) return Number(divisionMatch[2]);
        }

        var multiplicationMatch = text.match(/(-?\d+)\s*x\s*(-?\d+)/i);
        if (multiplicationMatch) {
          var a = Number(multiplicationMatch[1]);
          var b = Number(multiplicationMatch[2]);

          var fromSelected = tables.find(function (table) {
            return table === a || table === b;
          });
          if (fromSelected != null) return fromSelected;

          if (a >= 0 && a <= 12 && b >= 0 && b <= 12) {
            if (a === 0 || b === 0) return 0;
            if (a === 1 || b === 1) return 1;
            return Math.max(a, b);
          }
        }

        var tags = active.sessionTags || [];
        for (var i = 0; i < TIMES_TABLES.length; i += 1) {
          if (tags.indexOf("times" + TIMES_TABLES[i]) >= 0) return TIMES_TABLES[i];
        }

        return null;
      }

      function helperForActiveSession(active) {
        if (!active) return MR_SLAY_HELPERS.general;

        if (active.levelOperation === "division" || (active.question && active.question.operation === "division")) {
          var divisor = mrSlayTableFromQuestion(active);
          return MR_SLAY_HELPERS["times" + divisor] || MR_SLAY_HELPERS.divisionGeneral;
        }

        if (active.levelOperation === "multiplication" || (active.question && active.question.operation === "multiplication")) {
          var table = mrSlayTableFromQuestion(active);
          return MR_SLAY_HELPERS["times" + table] || MR_SLAY_HELPERS.multiplicationGeneral;
        }

        return MR_SLAY_HELPERS.general;
      }

      function mrSlayHelperButton(active) {
        if (!active || active.mode === "sprint") return "";
        return '<button class="btn gold" type="button" data-action="open-mr-slay">Ask Mr Slay</button>';
      }

      function mrSlayPanelHTML(active) {
        if (!state.mrSlayOpen || !active || active.mode === "sprint") return "";

        var helper = helperForActiveSession(active);
        var boardLines = (helper.board || []).map(function (line, index, items) {
          var className = "mr-slay-board-line" + (index === items.length - 1 ? " final" : "");
          return '<div class="' + className + '">' + escapeHTML(line) + '</div>';
        }).join("");

        return [
          '<div class="mr-slay-overlay" role="dialog" aria-modal="true" aria-label="Mr Slay helper">',
          '  <section class="mr-slay-modal section stack">',
          '    <div class="between">',
          '      <div><span class="pill">Summoned helper</span><h2>Mr Slay</h2><p class="muted">A quick strategy and a worked example for this skill.</p></div>',
          '      <button class="btn ghost" type="button" data-action="close-mr-slay">Continue practice</button>',
          '    </div>',
          '    <div class="mr-slay-grid">',
          '      <aside class="mr-slay-card">',
          '        <div class="mr-slay-portrait" aria-hidden="true">MS</div>',
          '        <div><h3>Mr Slay says...</h3><p class="muted tiny">Use the strategy, then try your question again.</p></div>',
          '        <div class="mr-slay-bubble">' + escapeHTML(helper.bubble || "Try a known fact first.") + '</div>',
          '      </aside>',
          '      <section class="mr-slay-whiteboard">',
          '        <h3>' + escapeHTML(helper.title || "Worked example") + '</h3>',
          '        <div class="mr-slay-board-lines">' + boardLines + '</div>',
          helper.prompt ? '        <p class="mr-slay-prompt">' + escapeHTML(helper.prompt) + '</p>' : '',
          '      </section>',
          '    </div>',
          '  </section>',
          '</div>'
        ].join("");
      }
'@

Add-BeforeFirstAnchor `
  -Anchors @("`r`n      function sessionView() {", "`n      function sessionView() {") `
  -Insertion $helperFunctions `
  -Marker "function helperForActiveSession(active)" `
  -Description "Mr Slay helper resolver and modal functions"

Write-Step "Resetting helper on navigation and session changes"

Replace-Once `
  -Search "        state.active = null;`r`n        state.results = null;`r`n        render();" `
  -Replacement "        state.active = null;`r`n        state.results = null;`r`n        state.mrSlayOpen = false;`r`n        render();" `
  -Marker "state.mrSlayOpen = false;`r`n        render();" `
  -Description "reset helper in setView" `
  -Optional

Replace-Once `
  -Search "        state.active = null;`n        state.results = null;`n        render();" `
  -Replacement "        state.active = null;`n        state.results = null;`n        state.mrSlayOpen = false;`n        render();" `
  -Marker "state.mrSlayOpen = false;`n        render();" `
  -Description "reset helper in setView LF" `
  -Optional

Replace-Once `
  -Search "        state.results = null;`r`n        state.view = `"session`";" `
  -Replacement "        state.results = null;`r`n        state.mrSlayOpen = false;`r`n        state.view = `"session`";" `
  -Marker "state.results = null;`r`n        state.mrSlayOpen = false;`r`n        state.view = `"session`";" `
  -Description "reset helper on startSession" `
  -Optional

Replace-Once `
  -Search "        state.results = null;`n        state.view = `"session`";" `
  -Replacement "        state.results = null;`n        state.mrSlayOpen = false;`n        state.view = `"session`";" `
  -Marker "state.results = null;`n        state.mrSlayOpen = false;`n        state.view = `"session`";" `
  -Description "reset helper on startSession LF" `
  -Optional

Replace-Once `
  -Search "        state.results = session;`r`n        state.active = null;`r`n        state.view = `"results`";" `
  -Replacement "        state.results = session;`r`n        state.active = null;`r`n        state.mrSlayOpen = false;`r`n        state.view = `"results`";" `
  -Marker "state.active = null;`r`n        state.mrSlayOpen = false;`r`n        state.view = `"results`";" `
  -Description "reset helper on finishSession" `
  -Optional

Replace-Once `
  -Search "        state.results = session;`n        state.active = null;`n        state.view = `"results`";" `
  -Replacement "        state.results = session;`n        state.active = null;`n        state.mrSlayOpen = false;`n        state.view = `"results`";" `
  -Marker "state.active = null;`n        state.mrSlayOpen = false;`n        state.view = `"results`";" `
  -Description "reset helper on finishSession LF" `
  -Optional

Write-Step "Adding practice-only helper button and modal to session screen"

Replace-Once `
  -Search "          active.mode === `"sprint`" ? '<span class=`"pill`">Time: ' + active.timeLeft + 's</span>' : '<span class=`"pill`">No timer</span>',`r`n          '      <button class=`"btn ghost`" data-action=`"finish-session`">Finish</button>'," `
  -Replacement "          active.mode === `"sprint`" ? '<span class=`"pill`">Time: ' + active.timeLeft + 's</span>' : '<span class=`"pill`">No timer</span>',`r`n          mrSlayHelperButton(active),`r`n          '      <button class=`"btn ghost`" data-action=`"finish-session`">Finish</button>'," `
  -Marker "mrSlayHelperButton(active)" `
  -Description "practice-only Ask Mr Slay button" `
  -Optional

Replace-Once `
  -Search "          active.mode === `"sprint`" ? '<span class=`"pill`">Time: ' + active.timeLeft + 's</span>' : '<span class=`"pill`">No timer</span>',`n          '      <button class=`"btn ghost`" data-action=`"finish-session`">Finish</button>'," `
  -Replacement "          active.mode === `"sprint`" ? '<span class=`"pill`">Time: ' + active.timeLeft + 's</span>' : '<span class=`"pill`">No timer</span>',`n          mrSlayHelperButton(active),`n          '      <button class=`"btn ghost`" data-action=`"finish-session`">Finish</button>'," `
  -Marker "mrSlayHelperButton(active)" `
  -Description "practice-only Ask Mr Slay button LF" `
  -Optional

Replace-Once `
  -Search "          '      <div class=`"notice tiny`">Use the keypad. Physical keyboards work too.</div>',`r`n          '    </aside>',`r`n          '  </section>',`r`n          '</main>'," `
  -Replacement "          '      <div class=`"notice tiny`">Use the keypad. Physical keyboards work too.</div>',`r`n          '    </aside>',`r`n          '  </section>',`r`n          mrSlayPanelHTML(active),`r`n          '</main>'," `
  -Marker "mrSlayPanelHTML(active)" `
  -Description "practice Mr Slay modal output" `
  -Optional

Replace-Once `
  -Search "          '      <div class=`"notice tiny`">Use the keypad. Physical keyboards work too.</div>',`n          '    </aside>',`n          '  </section>',`n          '</main>'," `
  -Replacement "          '      <div class=`"notice tiny`">Use the keypad. Physical keyboards work too.</div>',`n          '    </aside>',`n          '  </section>',`n          mrSlayPanelHTML(active),`n          '</main>'," `
  -Marker "mrSlayPanelHTML(active)" `
  -Description "practice Mr Slay modal output LF" `
  -Optional

Write-Step "Adding guarded action handlers"

$actionHandlers = "        var action = button.getAttribute(`"data-action`");`r`n        if (action === `"open-mr-slay`") {`r`n          if (state.active && state.active.mode === `"sprint`") return;`r`n          state.mrSlayOpen = true;`r`n          render();`r`n          return;`r`n        }`r`n        if (action === `"close-mr-slay`") {`r`n          state.mrSlayOpen = false;`r`n          render();`r`n          return;`r`n        }`r`n"

Replace-Once `
  -Search "        var action = button.getAttribute(`"data-action`");`r`n" `
  -Replacement $actionHandlers `
  -Marker "action === `"open-mr-slay`"" `
  -Description "open/close Mr Slay action handlers" `
  -Optional

$actionHandlersLF = "        var action = button.getAttribute(`"data-action`");`n        if (action === `"open-mr-slay`") {`n          if (state.active && state.active.mode === `"sprint`") return;`n          state.mrSlayOpen = true;`n          render();`n          return;`n        }`n        if (action === `"close-mr-slay`") {`n          state.mrSlayOpen = false;`n          render();`n          return;`n        }`n"

Replace-Once `
  -Search "        var action = button.getAttribute(`"data-action`");`n" `
  -Replacement $actionHandlersLF `
  -Marker "action === `"open-mr-slay`"" `
  -Description "open/close Mr Slay action handlers LF" `
  -Optional

Write-Step "Making Mr Slay the results and feedback guide"

$html = $html.Replace('title: "Guide coach"', 'title: "Mr Slay"')
$html = $html.Replace('Guide coach', 'Mr Slay')
$html = $html.Replace('<div class="coach-avatar" aria-hidden="true">i</div>', '<div class="coach-avatar" aria-hidden="true">MS</div>')
$html = $html.Replace('<section class="panel section coach-panel">', '<section class="panel section coach-panel mr-slay-results-panel">')

Write-Step "Validating patch"

$requiredMarkers = @(
  "var MR_SLAY_HELPERS =",
  "mrSlayOpen: false",
  "function helperForActiveSession(active)",
  "function mrSlayPanelHTML(active)",
  "if (!active || active.mode === `"sprint`") return `"`";",
  "if (state.active && state.active.mode === `"sprint`") return;",
  "mrSlayPanelHTML(active)",
  ".mr-slay-whiteboard",
  "mr-slay-results-panel"
)

foreach ($marker in $requiredMarkers) {
  if (-not $html.Contains($marker)) {
    Fail "Missing required marker after patch: $marker"
  }
}

if ($html -eq $originalHtml) {
  Fail "index.html did not change. The patch was not applied."
}

Write-Step "Writing index.html"
Set-Content -Path $indexPath -Value $html -Encoding UTF8

Write-Host ""
Write-Host "Done. Mr Slay helper patch applied." -ForegroundColor Green
Write-Host "Backup file: $backupPath"
Write-Host ""
Write-Host "Important behaviour:"
Write-Host "- Mr Slay can be summoned in practice mode."
Write-Host "- Mr Slay cannot be summoned in sprint mode."
Write-Host "- Mr Slay appears on results/feedback panels after activities."
Write-Host ""
Write-Host "Next steps:"
Write-Host "1. Open index.html or run the app locally."
Write-Host "2. Test practice mode: Ask Mr Slay should appear."
Write-Host "3. Test sprint mode: no Hint/Ask Mr Slay button should appear."
Write-Host "4. Finish sprint/practice: Mr Slay should deliver feedback on results."
Write-Host "5. Commit index.html if it works."
