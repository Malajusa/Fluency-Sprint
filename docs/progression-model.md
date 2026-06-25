# Fluency Sprint Progression Model

This document defines the intended access, progression, and unlocking model for Fluency Sprint.

The aim is to move beyond a flat menu of skills. Students should be able to choose freely during practice, but sprint challenges should guide progression based on diagnostic placement and demonstrated prerequisite proficiency.

## Core model

Each student has an assigned year level.

That year level controls default access:

```text
Practice access = student choice across visible skills
Sprint access = diagnostic start point + unlocked ladder steps
```

Progression within and beyond those skills is controlled by prerequisites and proficiency evidence.

```text
Year-level placement determines where diagnostics begin.
Prerequisites determine the next sprint ladder step.
Proficiency determines what unlocks.
Teacher override preserves professional judgement.
```

## Student year levels

Use teacher-assigned year levels rather than student self-selection.

Initial year-level values:

- Pre-primary
- Year 1
- Year 2
- Year 3
- Year 4
- Year 5
- Year 6

A student assigned to Year 5 should not see the year-level label, but the diagnostic should usually begin around the Year 4 pathway for each operation or skill. If the student is secure, the app can expose the next sprint stage. If not, the diagnostic pathway should move down to find the right starting point.

Pre-primary and Year 1 students should begin at the earliest pathway stages.

## Student-facing language

Students should not see curriculum codes unless the teacher intentionally enables that later.

Use simple labels:

- Ready to practise
- Keep building
- Nearly there
- Secure
- Next skill
- Challenge unlocked
- Locked for now
- Start diagnostic
- Sprint climb

Avoid language such as:

- deficient
- failed
- below standard
- remedial
- intervention

## Teacher-facing language

Teachers can see more precise information:

- assigned year level;
- skill year-level range;
- curriculum reference/code where available;
- strand/sub-strand;
- prerequisite skills;
- proficiency status;
- unlock reason;
- recommended next skill;
- blocking gaps.

## Skill metadata requirements

Each skill should eventually be represented by a structured object.

Suggested shape:

```js
{
  id: "friends100",
  name: "Friends of 100",
  operation: "addition",
  category: "number",
  yearLevels: [3, 4],
  accessYear: 3,
  curriculum: {
    system: "WA Curriculum",
    strand: "Number and algebra",
    subStrand: "Understanding number",
    codes: []
  },
  tags: ["friends100", "placeValue", "addition"],
  prerequisites: ["friends10", "placeValueTens"],
  unlocks: ["friends1000"],
  studentVisible: true,
  teacherVisible: true,
  diagnosticVisible: true,
  extensionEligible: true,
  generator: "friendsOfTarget",
  generatorOptions: {
    target: 100,
    operations: ["addition", "missingAddend"]
  },
  strategy: {
    title: "Make 100",
    explanation: "Use tens and ones to find the partner number that makes 100.",
    examples: ["40 + 60 = 100", "75 + 25 = 100", "40 + ? = 100"]
  }
}
```

This does not need to be fully implemented at once. The immediate need is to avoid adding future skills as disconnected hard-coded labels.

## Access calculation

A skill is available to a student if any of the following is true:

1. The skill's access year is less than or equal to the student's assigned year level.
2. The teacher has manually unlocked the skill for that student.
3. The app has unlocked the skill because prerequisite skills are secure.
4. The diagnostic has recommended the skill and the teacher or app settings allow diagnostic assignment.

Suggested function shape:

```js
function skillAccessForStudent(student, skill, progress, overrides) {
  if (teacherUnlocked(student.id, skill.id, overrides)) return "teacherUnlocked";
  if (skill.accessYear <= student.yearLevel) return "yearLevel";
  if (prerequisitesSecure(student.id, skill, progress)) return "prerequisitesSecure";
  return "locked";
}
```

## Unlock reasons

Track why a skill is visible.

Possible unlock reasons:

- yearLevel
- teacherOverride
- prerequisitesSecure
- diagnosticRecommendation
- previewMode
- diagnosticStart
- supportStep

This helps the teacher understand why a student can access a skill.

## Proficiency statuses

Use derived proficiency states from session evidence.

Initial statuses:

- notStarted
- building
- nearlySecure
- secure
- extensionReady

Student labels can simplify these, but the internal state should remain precise.

## Initial proficiency rule

Avoid unlocking a skill from one lucky sprint.

Suggested starting rule for `secure`:

```text
A skill is secure when the student has:
- completed at least 3 sessions for the skill;
- attempted at least 30 total questions for the skill;
- achieved at least 85% average accuracy across recent sessions;
- achieved at least 80% accuracy in at least one timed sprint or equivalent challenge;
- shown no major repeated error pattern in recent attempts.
```

Suggested starting rule for `nearlySecure`:

```text
A skill is nearly secure when the student has:
- attempted at least 20 total questions;
- achieved at least 75% average recent accuracy;
- shown improvement across recent sessions.
```

Suggested starting rule for `extensionReady`:

```text
A student is extension-ready when:
- the skill is secure;
- prerequisite skills for the next pathway are also secure;
- recent performance is consistent rather than isolated.
```

These thresholds should be adjustable.

## Derived progress object

Progress does not need to be stored separately at first. It can be derived from existing session data.

Possible derived shape:

```js
{
  studentId: "student-id",
  skillId: "friends10",
  status: "secure",
  sessions: 4,
  attempts: 54,
  recentAccuracy: 89,
  bestSprintAccuracy: 92,
  lastEvidenceAt: "2026-06-24T00:00:00Z",
  repeatedErrors: [],
  unlocks: ["friends100"]
}
```

If performance becomes expensive to calculate, this can later be cached or stored in Supabase.

## Teacher override model

Teachers must be able to use professional judgement.

Teacher override options:

- unlock skill for a student;
- lock/hide skill for a student;
- assign skill as focus;
- mark prerequisite as secure manually;
- reset a skill's recommendation status;
- hide future-year extension content.

Override records should include:

```js
{
  studentId,
  skillId,
  action: "unlock" | "lock" | "assignFocus" | "markSecure",
  reason,
  createdAt,
  teacherId
}
```

This may require a future Supabase table if overrides need to persist across devices.

## Student practice and sprint behaviour

Practice should remain open-choice and low pressure. Students can choose a skill to rehearse even if they have not unlocked the sprint for that skill.

Sprint mode is the game/progression layer:

- each operation or skill pathway is shown vertically as a climb;
- diagnostics choose the initial sprint point without showing year-level labels to students;
- a strong diagnostic sprint can expose the next stage;
- repeated secure evidence confirms proficiency for teacher reporting;
- an insecure sprint can reveal an earlier support stage;
- teachers can later override locked or unlocked stages.

Rewards should attach mainly to sprint completion so the fun loop supports fluency rather than blocking exploration.

The long-term reward identity should be a customisable cartoon human avatar, not uploaded photos or realistic student images. Sprint coins and trophy achievements should unlock avatar options such as facial features, skin colour, hair styles, outfits, accessories, and celebration poses. Printable trophy certificates should be able to feature the student's avatar in an earned celebration pose.

The progression model should also support a helpful guide NPC. The NPC should explain the next recommended focus, offer strategy tips, and point students to the right practice guide or sprint step. It should use concise, encouraging language and avoid ranking or diagnostic labels.

The initial guide NPC can ship as a text-first coach panel using existing session evidence. Future releases can pair the same advice model with the custom cartoon avatar and certificate visuals.

## Teacher dashboard behaviour

The dashboard should eventually show:

- assigned year level;
- available skills;
- secure prior knowledge;
- current focus skills;
- blocked skills and missing prerequisites;
- recommended next skills;
- extension-ready skills;
- uneven profiles, for example strong multiplication but weak subtraction bridging.

The first version can start with simple badges.

Example:

```text
Student: Ava
Year level: Year 5
Current focus: Friends of 1000
Secure: Friends of 10, Friends of 100, 2s/5s/10s
Building: 6s and 7s
Blocked: Reverse division for 6s/7s until multiplication facts are secure
Recommended next: Friends of 150
```

## Curriculum source direction

Use the Western Australian Mathematics Scope and Sequence as the primary teacher-facing year-level guide.

Use Australian Curriculum F-6 content as supporting alignment where useful.

Do not reproduce curriculum content unnecessarily in the student app. Store only concise metadata needed for filtering, teacher understanding, and pathway decisions.

## Initial 2026 WA alignment notes

The first year-level guide in the app is aligned to the Western Australian Curriculum Mathematics Scope and sequence for implementation in 2026 at a high level:

- Pre-primary: small collections, partitions, adding, removing, grouping and sharing.
- Year 1: numbers to 100/120, add and subtract to 20 using strategies, groups of 10, skip counting by 2s, 5s and 10s.
- Year 2: numbers to at least 1000, recall addition and subtraction facts to 10, add and subtract one- and two-digit numbers, represent multiplication and division.
- Year 3: addition and subtraction facts to 20, place-value partitioning to four digits, multiplication facts of 2, 3, 4, 5 and 10, related division representations.
- Year 4: efficient addition and subtraction to four digits, multiplication facts up to 10 x 10 and related division facts, whole-number division without remainders, litres/millilitres and grams/kilograms.
- Year 5: larger whole-number operations, factors and multiples, division with remainders, metric-unit choice, decimal measurement links and flexible mixed-operation fluency.
- Year 6: consolidation and extension across mixed operations, metric conversions and secondary-readiness fluency.

This is a guide for Fluency Sprint pathways, not a replacement for teacher judgement or the full curriculum text.

## Initial implementation slices

### Slice 1: student year level

- Add a yearLevel field to local student records and remote student records where possible.
- Add teacher UI to assign/edit year level.
- Default imported students to the class year level if available.
- Do not yet hide skills if this risks breaking student flow.

### Slice 2: skill metadata registry

- Create a central skill metadata registry.
- Map existing LEVELS to skill metadata without changing visible behaviour.
- Add accessYear and yearLevels fields.
- Add prerequisite arrays for a small number of skills.

### Slice 3: access filtering

- Filter student-visible skills by year level.
- Keep teacher override unavailable/locked skills visible only in teacher view.
- Avoid showing future-year locked content to students unless specifically wanted.

### Slice 4: proficiency calculation

- Derive skill status from existing sessions.
- Show simple status badges.
- Do not write new Supabase tables unless needed.

### Slice 5: unlocking and recommendations

- Recommend next skills based on prerequisites.
- Unlock extension skills when prerequisite evidence is secure.
- Add teacher overrides once the base model works.

## Constraints

- Do not break existing teacher login.
- Do not break class/student management.
- Do not require student emails.
- Preserve class code + alias + PIN student access.
- Preserve Supabase-backed session saving.
- Preserve GitHub Pages deployment.
- Keep student pages iPad-friendly.
- Make implementation incremental.
