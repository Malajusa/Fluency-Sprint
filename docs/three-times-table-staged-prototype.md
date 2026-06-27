# Staged Prototype: 3 Times Table

## Purpose

This document specifies the first staged skill prototype for Fluency Sprint. The prototype should prove the staged learning architecture before the model is expanded to other times tables, other operations, measurement, fractions, decimals, and percentages.

The prototype skill is the 3 times table because it clearly requires:

- equal groups
- skip counting
- arrays
- number lines
- facts in order
- facts out of order
- automatic recall
- related division and missing-factor transfer

## Prototype principle

The 3 times table should not begin with timed recall. Students should move through staged learning from meaning to representation, guided strategy, structured practice, varied practice, fluency, and transfer.

## Skill identity

```js
{
  id: "M_TABLE_3",
  operation: "multiplication",
  name: "3 times table",
  concept: "multiplication as equal groups of 3",
  representations: ["equalGroups", "array", "numberLine", "skipCounting"],
  relatedSkills: ["divisionBy3", "missingFactors", "mixedMultiplication"]
}
```

## Student-facing pathway

Suggested student navigation label:

```text
3 times table pathway
```

Suggested stages:

1. What does x3 mean?
2. See it: groups, arrays, number lines.
3. Count by 3.
4. Facts in order.
5. Facts shuffled.
6. Sprint when ready.
7. Connect to division.

## Stage 1: Meaning

### Goal

Students understand multiplication by 3 as equal groups.

### Core language

```text
Multiplication means equal groups.
3 x 4 can mean 3 groups of 4.
4 x 3 can mean 4 groups of 3.
Both have the same total.
```

### Example

```text
3 groups of 4
4 + 4 + 4 = 12
3 x 4 = 12
```

### Student action

Students identify:

- number of groups
- number in each group
- total
- matching multiplication sentence

### Practice examples

| Prompt | Expected response |
| --- | --- |
| There are 3 groups of 5. How many altogether? | 15 |
| Which fact matches 3 groups of 4? | 3 x 4 |
| Complete: 3 groups of 6 = 6 + 6 + 6 = __ | 18 |

### Supports

- Equal group diagram visible.
- Repeated addition visible.
- No timer.
- Mr Slay gives meaning-focused advice.

## Stage 2: Representation

### Goal

Students connect multiplication by 3 to arrays, equal groups, and number lines.

### Representations

#### Equal groups

```text
3 groups of 4
●●●●   ●●●●   ●●●●
```

#### Array

```text
3 rows of 4
● ● ● ●
● ● ● ●
● ● ● ●
```

#### Number line

```text
0 -> 3 -> 6 -> 9 -> 12
```

### Practice examples

| Prompt | Expected response |
| --- | --- |
| Match the array to the fact. | 3 x 4 |
| How many jumps of 3 are shown? | 4 jumps |
| What total does the number line reach? | 12 |

### Supports

- Visuals visible.
- Students can reveal the multiplication sentence.
- Students can reveal repeated addition.
- No timer.

## Stage 3: Skip counting

### Goal

Students build the 3s count sequence and understand it as repeated groups of 3.

### Core sequence

```text
3, 6, 9, 12, 15, 18, 21, 24, 27, 30, 33, 36
```

### Practice examples

| Prompt | Expected response |
| --- | --- |
| Continue: 3, 6, 9, __, __ | 12, 15 |
| Fill the missing number: 3, 6, __, 12 | 9 |
| What is the 5th number when counting by 3? | 15 |
| Count four jumps of 3. | 12 |

### Supports

- Sequence visible at first.
- Option to hide sequence later.
- Number line may be shown.
- No timer.

## Stage 4: Structured practice: facts in order

### Goal

Students connect the ordered facts to the skip-counting sequence.

### Ordered fact list

```text
1 x 3 = 3
2 x 3 = 6
3 x 3 = 9
4 x 3 = 12
5 x 3 = 15
6 x 3 = 18
7 x 3 = 21
8 x 3 = 24
9 x 3 = 27
10 x 3 = 30
11 x 3 = 33
12 x 3 = 36
```

### Practice examples

| Prompt | Expected response |
| --- | --- |
| 1 x 3 = __ | 3 |
| 2 x 3 = __ | 6 |
| 3 x 3 = __ | 9 |
| 4 x 3 = __ | 12 |

### Supports

- Previous fact shown where useful.
- Skip-count sequence available.
- Hints before or after attempt.
- No pressure timer.

### Strategy prompts

```text
You know 4 x 3 = 12.
So 5 x 3 is one more group of 3.
12 + 3 = 15.
```

## Stage 5: Varied practice: facts shuffled

### Goal

Students recall 3-times-table facts without relying only on order.

### Practice examples

```text
7 x 3 = __
3 x 11 = __
4 x 3 = __
9 x 3 = __
```

### Supports

- Hints after attempt, not immediately visible.
- Optional strategy reveal.
- Minimal visuals.
- Accuracy tracked.
- Response time tracked quietly but not used as a hard pass/fail yet.

### Strategy examples

| Fact | Suggested strategy |
| --- | --- |
| 6 x 3 | Use 3 x 3, then double. |
| 8 x 3 | Use 4 x 3, then double. |
| 9 x 3 | Use 10 x 3 - 3. |
| 11 x 3 | Use 10 x 3 + 3. |
| 12 x 3 | Use 10 x 3 + 2 x 3. |

## Stage 6: Fluency

### Goal

Students build accurate and efficient automatic recall.

### Entry condition

Students should enter fluency practice after demonstrating reasonable accuracy in varied practice.

Initial recommended placeholder:

```text
90% or higher accuracy in shuffled practice.
```

The exact response-time target should be decided later after classroom testing.

### Practice design

- Shuffled 3-times-table facts.
- Reduced hints.
- Timed or semi-timed mode.
- Review after session.
- Record accuracy and response time.

### Avoid

Do not present fluency as the first stage of learning.

## Stage 7: Transfer

### Goal

Students connect 3-times-table facts to related division, missing factors, and mixed multiplication contexts.

### Practice examples

| Type | Example | Expected response |
| --- | --- | --- |
| Related division | 24 / 3 = __ | 8 |
| Related division | 24 / 8 = __ | 3 |
| Missing factor | 3 x __ = 21 | 7 |
| Missing factor | __ x 3 = 27 | 9 |
| Worded equal groups | 6 bags have 3 counters each. How many counters? | 18 |
| Mixed table contrast | 8 x 3 and 8 x 4 | 24 and 32 |

### Supports

- Fact family triangle or table may be shown.
- Mr Slay prompts inverse reasoning.
- Errors feed teacher observations.

## Mr Slay stage-aware advice

Mr Slay advice should depend on stage.

| Stage | Advice example |
| --- | --- |
| Meaning | Think of equal groups. How many groups? How many in each group? |
| Representation | Show it with groups, an array, or jumps on a number line. |
| Skip counting | Count by 3s until you reach the matching fact. |
| Structured practice | Use the previous fact and add one more group of 3. |
| Varied practice | Build from a known fact instead of guessing. |
| Fluency | If this is slow, return to shuffled practice before sprinting. |
| Transfer | Turn the division or missing-factor problem back into multiplication. |

## Teacher observations

The prototype should eventually generate observations such as:

- Understands multiplication as equal groups of 3.
- Can model 3-times-table facts with arrays or number lines.
- Can skip count by 3 but does not yet recall facts out of order.
- Recalls ordered 3-times-table facts but needs support with shuffled facts.
- Uses known facts to derive harder 3-times-table facts.
- Recalls 3-times-table facts accurately but slowly.
- Connects 3-times-table facts to related division facts.
- Needs further practice with missing-factor problems connected to 3s.

## Tracking requirements

The prototype should eventually track:

| Data | Purpose |
| --- | --- |
| Current stage | Shows where the student is in the pathway. |
| Accuracy by stage | Identifies whether the student is ready to progress. |
| Response time by fact | Identifies which facts are not automatic. |
| Representation errors | Identifies conceptual weakness. |
| Skip-count errors | Identifies sequence weakness. |
| Shuffled fact errors | Identifies recall weakness. |
| Transfer errors | Identifies inverse or application weakness. |

## Progression rules

Initial placeholder progression rules:

| From stage | Suggested progression condition |
| --- | --- |
| Meaning -> Representation | Student correctly identifies groups, group size, and total in supported examples. |
| Representation -> Skip counting | Student matches arrays, groups, and number lines to facts. |
| Skip counting -> Ordered facts | Student completes the 3s sequence with minimal support. |
| Ordered facts -> Shuffled facts | Student answers ordered facts accurately. |
| Shuffled facts -> Fluency | Student reaches high accuracy with shuffled facts. |
| Fluency -> Transfer | Student recalls facts accurately and efficiently enough to apply them. |

These rules are placeholders and should be adjusted after classroom testing.

## Interface implications

The prototype needs a pathway interface, not just a level card.

Possible interface:

```text
3 times table
[1 Meaning] -> [2 See it] -> [3 Count by 3] -> [4 In order] -> [5 Shuffled] -> [6 Sprint] -> [7 Transfer]
```

Each stage should have:

- short explanation
- worked example
- practice task
- support options
- Mr Slay advice
- next-step button

## First implementation slice

The first code implementation should be narrow.

Recommended first slice:

1. Add staged metadata for the 3-times-table pathway.
2. Add a simple staged pathway screen for `M_TABLE_3`.
3. Implement Stage 1 and Stage 2 only:
   - meaning
   - equal groups / array / number line representation
4. Add stage-aware Mr Slay advice for these two stages.
5. Do not yet change sprint mode.

After that works, add:

6. Skip counting.
7. Ordered facts.
8. Shuffled facts.
9. Fluency mode.
10. Transfer tasks.

## Non-goals for the prototype

The first prototype should not:

- replace all multiplication levels
- remove M1-M7
- change existing sprint logic
- alter student data storage broadly
- set final automaticity timing thresholds
- rebuild all operations
- require Supabase schema changes unless unavoidable

## Success criteria

The prototype is successful if:

- a student can enter a 3-times-table pathway
- the pathway begins with meaning and representation, not timed recall
- support is visible for lower proficiency students
- Mr Slay advice changes based on stage
- the model can be duplicated for another times table later
- the existing app remains stable
