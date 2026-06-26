import fs from "node:fs";

const INDEX_PATH = "index.html";

function replaceOnce(source, target, replacement, label) {
  const count = source.split(target).length - 1;
  if (count !== 1) {
    throw new Error(`${label}: expected 1 match, found ${count}`);
  }
  return source.replace(target, replacement);
}

let html = fs.readFileSync(INDEX_PATH, "utf8");

const helpersTarget = `        additionGeneral: { title: "Addition strategy", bubble: "Name the strategy before you calculate.", board: ["Look for a friendly pair, near double, bridge, or compensation.", "Choose the quickest pathway.", "Then calculate and check."], prompt: "Do not just count if a known structure is hiding in the fact." },
        additionFriends10: { title: "Friends of 10", bubble: "A friend of 10 is the missing part that finishes 10.", board: ["4 + ? = 10", "4 needs 6 to make 10", "4 + 6 = 10"], prompt: "Say the number you can see, then name its friend." },
        additionEnding5: { title: "Facts ending in 5", bubble: "Use ones-digit pairs that make 5 or 15.", board: ["1 + 4 = 5", "2 + 3 = 5", "6 + 9 = 15", "7 + 8 = 15", "27 + 8: 7 + 8 = 15, so 20 + 15 = 35"], prompt: "Look at the ones digits first. Do they pair to 5 or 15?" },
        additionBridge10: { title: "Bridge to 10", bubble: "Make 10 first, then add what is left.", board: ["8 + 6", "8 needs 2 to make 10", "6 = 2 + 4", "10 + 4 = 14"], prompt: "How many to make 10? What is left over?" },`;

const helpersReplacement = `        additionGeneral: { title: "Addition strategy", bubble: "Name the strategy before you calculate.", board: ["Look for a friendly pair, near double, bridge, or compensation.", "Choose the quickest pathway.", "Then calculate and check."], prompt: "Do not just count if a known structure is hiding in the fact." },
        additionFriends10: { title: "Friends of 10", bubble: "A friend of 10 is the missing part that finishes 10.", board: ["4 + ? = 10", "4 needs 6 to make 10", "4 + 6 = 10"], prompt: "Say the number you can see, then name its friend." },
        additionEnding5: { title: "Facts ending in 5", bubble: "Use ones-digit pairs that make 5 or 15.", board: ["1 + 4 = 5", "2 + 3 = 5", "6 + 9 = 15", "7 + 8 = 15", "27 + 8: 7 + 8 = 15, so 20 + 15 = 35"], prompt: "Look at the ones digits first. Do they pair to 5 or 15?" },
        additionBridge10: { title: "Bridge to 10", bubble: "Make 10 first, then add what is left.", board: ["8 + 6", "8 needs 2 to make 10", "6 = 2 + 4", "10 + 4 = 14"], prompt: "How many to make 10? What is left over?" },

        subtractionGeneral: { title: "Subtraction strategy", bubble: "Subtraction can mean take away, find the gap, or use a connected addition fact.", board: ["Read the subtraction sign.", "Decide: take away, count up, or use an inverse fact.", "Check that the answer is smaller unless it is a missing-number equation."], prompt: "Do not just count backwards. Ask what the subtraction fact is really asking." },
        subtractionFriends10: { title: "Subtract from 10", bubble: "Use the related addition fact to find the missing part from 10.", board: ["10 - 6 = ?", "6 + ? = 10", "6 needs 4", "So 10 - 6 = 4"], prompt: "Think of the friend of 10 before you answer." },
        subtractionEnding5: { title: "Answers ending in 5", bubble: "Use known fact families where the answer ends in 5.", board: ["15 - 8 = 7", "7 + 8 = 15", "25 - 10 = 15", "Check with addition."], prompt: "Look for the related addition fact that rebuilds the starting number." },
        subtractionBridge10: { title: "Bridge through 10", bubble: "Get back to 10 first, then subtract what is left.", board: ["13 - 5", "Take 3 to reach 10", "5 = 3 + 2", "10 - 2 = 8"], prompt: "How many back to 10? What still needs to be subtracted?" },
        subtractionPlaceValue: { title: "Place-value subtraction", bubble: "Use the target number and find the missing part by place value.", board: ["100 - 36", "36 + ? = 100", "36 needs 64", "So 100 - 36 = 64"], prompt: "Partition the target, then find the missing part exactly." },`;

html = replaceOnce(html, helpersTarget, helpersReplacement, "helper block");

const lessonTarget = `        if (level && level.operation === "addition") {
          if (tags.indexOf("ending5") >= 0) return MR_SLAY_HELPERS.additionEnding5;
          if (tags.indexOf("bridge") >= 0) return MR_SLAY_HELPERS.additionBridge10;
          if (tags.indexOf("friends10") >= 0) return MR_SLAY_HELPERS.additionFriends10;
          return MR_SLAY_HELPERS.additionGeneral;
        }
        if (level && level.operation === "multiplication") return MR_SLAY_HELPERS.multiplicationGeneral;`;

const lessonReplacement = `        if (level && level.operation === "addition") {
          if (tags.indexOf("ending5") >= 0) return MR_SLAY_HELPERS.additionEnding5;
          if (tags.indexOf("bridge") >= 0) return MR_SLAY_HELPERS.additionBridge10;
          if (tags.indexOf("friends10") >= 0) return MR_SLAY_HELPERS.additionFriends10;
          return MR_SLAY_HELPERS.additionGeneral;
        }
        if (level && level.operation === "subtraction") {
          if (tags.indexOf("ending5") >= 0) return MR_SLAY_HELPERS.subtractionEnding5;
          if (tags.indexOf("bridge") >= 0) return MR_SLAY_HELPERS.subtractionBridge10;
          if (tags.indexOf("friends10") >= 0) return MR_SLAY_HELPERS.subtractionFriends10;
          if (tags.indexOf("friends100") >= 0 || tags.indexOf("friends1000") >= 0 || tags.indexOf("friends150") >= 0 || tags.indexOf("friends1500") >= 0) return MR_SLAY_HELPERS.subtractionPlaceValue;
          return MR_SLAY_HELPERS.subtractionGeneral;
        }
        if (level && level.operation === "multiplication") return MR_SLAY_HELPERS.multiplicationGeneral;`;

html = replaceOnce(html, lessonTarget, lessonReplacement, "lesson routing block");

const practiceTarget = `        if (active.levelOperation === "addition" || (active.question && active.question.operation === "addition")) {
          return mrSlayHelperForLevel(levelById(active.levelId));
        }

        return MR_SLAY_HELPERS.general;`;

const practiceReplacement = `        if (active.levelOperation === "addition" || (active.question && active.question.operation === "addition")) {
          return mrSlayHelperForLevel(levelById(active.levelId));
        }

        if (active.levelOperation === "subtraction" || (active.question && active.question.operation === "subtraction")) {
          return mrSlayHelperForLevel(levelById(active.levelId));
        }

        return MR_SLAY_HELPERS.general;`;

html = replaceOnce(html, practiceTarget, practiceReplacement, "practice routing block");

fs.writeFileSync(INDEX_PATH, html, "utf8");

console.log("Patched subtraction Mr Slay advice in index.html");
