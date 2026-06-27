# Staged Skill Architecture

## Purpose

Fluency Sprint should not treat a mathematical concept as a single flat skill. Each concept should move students through a staged pathway from meaning and representation to supported practice, fluency, and transfer.

This document defines the long-term architecture that should guide lesson pages, practice modes, diagnostics, Mr Slay advice, progress tracking, and teacher observations.

## Core principle

Every skill should follow a progression:

```text
Conceptual meaning
-> visual or concrete representation
-> guided strategy
-> structured practice
-> varied practice
-> fluency or automaticity
-> mixed application and transfer
```

Timed fluency should not be the first experience. It should be the later check that follows conceptual understanding, scaffolded practice, and accuracy.

## Universal stage model

| Stage | Name | Purpose | Typical support |
| --- | --- | --- | --- |
| 1 | Meaning | Establish what the concept means. | Concrete examples, teacher language, simple models. |
| 2 | Representation | Show what the concept looks like. | Ten-frames, arrays, number lines, place-value charts, part-part-whole diagrams, bar models. |
| 3 | Guided strategy | Teach an efficient method. | Worked examples, partially completed steps, prompts, hints. |
| 4 | Structured practice | Practise when the pattern is clear. | Ordered facts, repeated strategy use, low cognitive load, optional reveal. |
| 5 | Varied practice | Practise when examples are shuffled or less predictable. | Out-of-order facts, mixed examples, hints after attempt, reduced scaffolding. |
| 6 | Fluency | Build accurate and efficient recall or strategy use. | Timed or semi-timed practice, response-time tracking, accuracy threshold. |
| 7 | Transfer | Apply the skill in connected contexts. | Mixed operations, missing-number forms, worded problems, related inverse facts. |

## Proficiency levels

Practice should adapt to the student's proficiency rather than offering only one mode.

| Proficiency | Description | Practice design |
| --- | --- | --- |
| Building | Student is still developing the concept. | Visuals visible, no timer, guided prompts, multiple representations. |
| Developing | Student understands the idea but still needs support. | Optional hints, ordered examples, strategy reminders, no pressure timer. |
| Consolidating | Student is moving toward independence. | Shuffled practice, hints after attempt, limited visuals, accuracy tracked. |
| Fluent | Student is ready to build automaticity. | Timed recall, reduced hints, response-time tracking, review after session. |
| Flexible | Student can transfer the skill. | Mixed contexts, related inverse facts, missing-number tasks, explanation prompts. |

## Skill data model implication

The current `LEVELS` model can remain as the visible navigation layer, but the deeper learning model should eventually include staged skill metadata.

Possible long-term structure:

```js
{
  id: "M3_TABLE",
  operation: "multiplication",
  name: "3 times table",
  concept: "equal groups and repeated addition",
  representations: ["equalGroups", "array", "numberLine", "skipCount"],
  stages: [
    "meaning",
    "representation",
    "guidedStrategy",
    "structuredPractice",
    "variedPractice",
    "fluency",
    "transfer"
  ],
  relatedSkills: ["divisionBy3", "missingFactors", "mixedMultiplication"]
}
```

## Lesson page structure

Each skill lesson page should eventually use a consistent structure:

1. What this skill means.
2. What it looks like.
3. How to solve it efficiently.
4. Worked examples.
5. Common trap.
6. Try with support.
7. Move to practice.

## Practice mode structure

Each skill should provide practice options aligned to proficiency.

| Mode | Purpose |
| --- | --- |
| Learn | Conceptual and representational introduction. |
| Guided practice | Worked or partially worked questions. |
| Structured practice | Ordered or predictable examples. |
| Varied practice | Shuffled examples with reduced scaffolding. |
| Sprint | Timed or semi-timed fluency check. |
| Review | Error analysis, strategy reminders, and next-step recommendation. |

## Mr Slay architecture

Mr Slay should respond to the student's stage, not only the operation or level.

For the same question, advice should change depending on where the student is in the pathway.

Example: `3 x 8`

| Stage | Mr Slay advice |
| --- | --- |
| Meaning | Think of 8 equal groups of 3. |
| Representation | Use an array or number line to show eight jumps of 3. |
| Guided strategy | Use 4 x 3 = 12, then double it. |
| Structured practice | You are in the 3s pattern. Count by 3 if needed. |
| Fluency | This should become automatic. If it is slow, return to practice. |
| Transfer | Connect it to 24 / 3 and 24 / 8. |

This means future helper selection should consider:

- operation
- skill
- stage
- representation
- proficiency level
- current error pattern
- current response time

## Diagnostic implication

The diagnostic should identify not just whether a student got an answer correct, but what stage they may need.

Examples:

| Observation | Likely need |
| --- | --- |
| Student cannot model the fact. | Meaning or representation stage. |
| Student can solve with visuals but not mentally. | Guided or structured practice. |
| Student answers correctly but slowly. | Varied practice or fluency stage. |
| Student is accurate in isolation but weak in mixed tasks. | Transfer stage. |
| Student uses inefficient counting for known facts. | Strategy selection and fluency stage. |

## Teacher observation bank implication

Teacher observations should be tied to staged needs.

Examples:

- Needs representation support for multiplication as equal groups.
- Can skip count by 3 but has not memorised facts out of order.
- Knows 5-times-table facts in order but does not recall them automatically in mixed practice.
- Uses related addition facts effectively for subtraction from 10.
- Can convert mL to L in structured examples but struggles when units are mixed.

## Concept examples

### Friends of 10

| Stage | Example |
| --- | --- |
| Meaning | 10 can be partitioned into two parts. |
| Representation | Ten-frame, counters, part-part-whole diagram. |
| Guided strategy | Ask: what does 6 need to make 10? |
| Structured practice | 1 + 9, 2 + 8, 3 + 7 in order. |
| Varied practice | Shuffled friends of 10. |
| Fluency | Automatic recall of pairs to 10. |
| Transfer | Missing-number facts, subtraction from 10, bridge to 10. |

### Bridge through 10 subtraction

| Stage | Example |
| --- | --- |
| Meaning | Subtraction can be take-away or finding the gap. |
| Representation | Number line moving back through 10. |
| Guided strategy | Split the number being subtracted. |
| Structured practice | 13 - 5, 14 - 6, 15 - 7. |
| Varied practice | Mixed teen subtraction. |
| Fluency | Efficient mental strategy use. |
| Transfer | Larger mental subtraction and multi-digit subtraction. |

### Times tables

| Stage | Example |
| --- | --- |
| Meaning | Multiplication represents equal groups. |
| Representation | Arrays, groups, number lines. |
| Guided strategy | Skip count and connect to known facts. |
| Structured practice | Facts in order. |
| Varied practice | Facts shuffled. |
| Fluency | Accurate recall within a target response time. |
| Transfer | Division facts, missing factors, mixed tables, worded problems. |

### Division facts

| Stage | Example |
| --- | --- |
| Meaning | Division can mean sharing or grouping. |
| Representation | Arrays, equal groups, number lines. |
| Guided strategy | Connect division to multiplication. |
| Structured practice | One divisor or one fact family. |
| Varied practice | Shuffled division facts. |
| Fluency | Automatic inverse recall. |
| Transfer | Missing factors, remainders, worded problems. |

### Metric conversions

| Stage | Example |
| --- | --- |
| Meaning | Units measure the same attribute at different scales. |
| Representation | Place-value chart, unit ladder, real-world examples. |
| Guided strategy | Identify the unit relationship. |
| Structured practice | m to cm, L to mL, kg to g. |
| Varied practice | Mixed metric conversions. |
| Fluency | Efficient conversion recall. |
| Transfer | Measurement problems and decimal links. |

## First implementation target

Do not immediately rebuild the whole site.

Recommended first implementation target:

```text
Prototype one staged pathway for the 3 times table.
```

Suggested prototype pathway:

1. Meaning: equal groups of 3.
2. Representation: groups, arrays, number line jumps.
3. Guided strategy: skip counting and build from known facts.
4. Structured practice: 3-times-table facts in order.
5. Varied practice: 3-times-table facts shuffled.
6. Fluency: timed recall once accurate.
7. Transfer: related division facts and missing factors.

Once this pathway works, duplicate the structure for other tables and then apply the same model across addition, subtraction, division, measurement, fractions, decimals, and percentages.

## Implementation notes

Short-term implementation should avoid large rewrites.

Safer sequence:

1. Add staged skill metadata separately from current `LEVELS`.
2. Create one prototype staged lesson page.
3. Add one staged practice mode for the prototype skill.
4. Connect Mr Slay to stage-aware advice for the prototype.
5. Add progress tracking by stage.
6. Expand only after the prototype works.

## Non-goals for the first implementation

The first staged architecture update should not attempt to:

- replace all current levels
- remove current sprint mode
- rewrite the full app
- change Supabase storage broadly
- redesign every operation at once
- set final automaticity timing thresholds before testing

## Decision record

Fluency Sprint's long-term direction is now:

> Every mathematical concept should be taught and practised through staged progression from conceptual meaning to representation, guided strategy, structured practice, varied practice, fluency, and transfer.

This principle should drive future code changes and content design.
