# Lovable Strategic Progress Review

_Date added: 2026-06-27_

## Purpose

This file captures the state of the large Lovable update against the previously agreed Fluency Sprint strategic plan.

It is intentionally a review document, not a merge instruction. The Lovable update appears to contain substantial strategic progress, but it should be tested and integrated through controlled workflow rather than treated as a cosmetic patch.

## Direct links

Main app:

```text
https://malajusa.github.io/Fluency-Sprint/
```

3 times table staged prototype:

```text
https://malajusa.github.io/Fluency-Sprint/prototypes/three-times-table-pathway.html
```

## Executive judgement

The Lovable update appears to be a major strategic leap.

Before this update, the project state was approximately:

```text
static app
+ staged 3s prototype
+ Mr Slay helper
+ targeted addition advice
+ diagnostic/observation foundations
```

The Lovable output moves toward:

```text
animated Mr Slay
+ parameterised lesson engine
+ table strategies
+ stage gating
+ warm-up/check mode
+ lesson progress
+ teacher visibility hooks
```

Estimated progress:

```text
Mr Slay / times-table strategic arc: about 65–75% structurally built
Full long-term Fluency Sprint vision: about 35–45% built
Classroom-ready stability: not yet confirmed
```

## Major progress detected

### 1. Mr Slay is no longer a static mascot

The uploaded Lovable plan targets replacement of the static `assets/mr-slay-npc.jpg` portrait with a dynamic six-pose sprite system.

Planned pose set:

```text
idle
wave
thinking
pointing
encouraging
celebrating
```

This directly supports the agreed design principle that Mr Slay should point, gesture, and visually direct attention to the mathematical idea being taught.

### 2. Learn with Mr Slay mode appears to have been advanced

The earlier strategic plan treated animated lesson mode as a later stage. The Lovable output appears to go beyond a visual patch and begins implementing the broader lesson system.

Target learning flow:

```text
Mr Slay teaches
→ students watch/think
→ students interact
→ Mr Slay gives feedback
→ students practise
```

This should be treated as a significant feature, not a small visual change.

### 3. Times-table pedagogy has been strengthened as a source of truth

The uploaded `pedagogy.md` preserves the core principle:

```text
Rote recall is the end point, not the starting method.
```

Core sequence:

```text
meaning
→ visual structure
→ skip-counting
→ derived facts
→ ordered recall
→ random recall
→ mixed recall
→ related division
→ maintenance
```

This strongly protects against memory drift and future feature drift.

### 4. Lesson generation appears to be parameterised

The Lovable output appears to move beyond a single hard-coded 3s prototype by defining reusable lesson/strategy structures for tables.

This is important because the long-term pathway needs to cover:

```text
2s, 3s, 4s, 5s, 6s, 7s, 8s, 9s, 10s, 11s, 12s
```

### 5. Stage gating appears to have started

The strategic requirement is that students should not move into random, mixed, or timed recall before earlier stages are secure.

Desired gating rule:

```text
Stages 6+ should not unlock until stages 1–5 are passed.
Timed work belongs at maintenance, not first exposure.
```

Lovable appears to have started implementing this idea.

### 6. Teacher visibility hooks appear to have started

The Lovable output appears to include teacher-facing progress hooks and Supabase RPC expectations.

This is strategically aligned but not yet verified.

## Key risks

### 1. Scope creep

The original safe step was to animate or replace the Mr Slay portrait. The Lovable update appears to add significantly more than that.

Potential added scope:

```text
lesson engine
stage gating
warm-up/check mode
teacher lesson progress
cloud sync hooks
new RPC dependencies
```

This is likely good product progress, but it increases regression risk.

### 2. Supabase RPC mismatch

If the app now calls new RPC functions, the database must contain matching functions and permissions.

Check for RPCs such as:

```text
student_lesson_complete
teacher_class_slay_progress
```

If these are missing, the student-side lesson may still appear to work, but teacher progress visibility may fail.

### 3. Existing app flows may conflict

The app may now contain multiple overlapping student pathways:

```text
sprint climb diagnostic
Learn with Mr Slay diagnostic
free practice
daily warm-up
stage gates
sprint unlocks
```

These need to feel coherent to a student.

### 4. iPad usability is unknown

The student interface must be checked on iPad in both portrait and landscape.

Important checks:

```text
large tap targets
readable Mr Slay pose area
no blocked feedback
no cramped lesson cards
keypad still usable
stage controls visible
```

### 5. Lovable workflow needs protection

The uploaded `AGENTS.md` warns that the project is connected to Lovable. Avoid force-pushing, rebasing, amending, or squashing pushed commits, because doing so can disrupt Lovable project history.

## Controlled review checklist

### Build and syntax

- [ ] App builds successfully.
- [ ] No TypeScript/JavaScript syntax errors.
- [ ] No missing asset errors for Mr Slay pose images.
- [ ] No console errors on initial load.
- [ ] No console errors when opening a lesson.

### Student entry flow

- [ ] Student login still works.
- [ ] Student menu still loads.
- [ ] Existing operation tabs still work.
- [ ] Existing levels still appear.
- [ ] Existing sprint/practice flow still works.
- [ ] Existing 3s staged prototype link still works if retained.

### Mr Slay visual system

- [ ] Mr Slay appears in the strategy coach panel.
- [ ] Mr Slay appears in the Ask Mr Slay modal.
- [ ] Idle pose loads.
- [ ] Thinking pose loads.
- [ ] Pointing pose loads.
- [ ] Encouraging pose loads.
- [ ] Celebrating pose loads.
- [ ] Pose changes are not jarring or broken.
- [ ] Broken `assets/mr-slay-npc.jpg` reference is removed or safely replaced.

### Learn with Mr Slay

- [ ] Student can open Learn with Mr Slay.
- [ ] Student can select a table.
- [ ] The 9 stages are visible.
- [ ] Stage 1 begins with meaning/representation.
- [ ] Stages 6+ are gated appropriately.
- [ ] Timed work appears only as maintenance/fluency, not introduction.
- [ ] Bad advice is clearly correctable and not confusing.
- [ ] Feedback explains the mistake, not just the answer.

### Teacher dashboard

- [ ] Teacher dashboard still loads.
- [ ] Existing class/student data still loads.
- [ ] Mr Slay lesson progress panel loads without breaking the dashboard.
- [ ] Missing lesson-progress data is handled gracefully.
- [ ] Missing RPCs do not crash the UI.

### Supabase

- [ ] Check whether `student_lesson_complete` exists.
- [ ] Check whether `teacher_class_slay_progress` exists.
- [ ] Check Row Level Security / permissions for student writes.
- [ ] Check teacher reads are limited to the correct class.
- [ ] Verify no old Supabase project credentials have been accidentally mixed with new credentials.

### iPad classroom test

- [ ] Student flow works on iPad portrait.
- [ ] Student flow works on iPad landscape.
- [ ] Tap targets are large enough.
- [ ] Mr Slay does not cover the maths content.
- [ ] Feedback is visible after answering.
- [ ] Lesson can be completed without keyboard issues.

## Recommended next steps

### Step 1 — Freeze feature additions

Do not add more new features until this Lovable update is tested.

### Step 2 — Run a controlled branch review

Use a branch such as:

```text
review/lovable-mr-slay-engine
```

Do not merge directly into `main` until checks pass.

### Step 3 — Verify database compatibility

Confirm the required Supabase RPCs, tables, and permissions exist.

### Step 4 — Test student flow first

Priority order:

```text
student login
student menu
Learn with Mr Slay
existing practice
existing sprint
```

### Step 5 — Test teacher dashboard second

Priority order:

```text
teacher login/dashboard
class view
student detail
lesson progress panel
observation data
```

### Step 6 — Update backlog after review

Once confirmed, move relevant items from Planned/Partially implemented to Implemented.

## Merge decision

Do not merge/replace the live app until:

```text
student flows pass
teacher dashboard passes
Supabase RPCs are confirmed
Mr Slay assets load
no critical console errors
```

