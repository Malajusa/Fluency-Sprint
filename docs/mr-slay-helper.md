# Mr Slay Helper NPC

Mr Slay is the contextual helper NPC for Fluency Sprint.

He should not be treated as a static poster or decorative mascot. He should appear at useful learning moments and provide targeted support linked to the skill the student is currently practising.

## Intended role

Mr Slay can appear in two main ways:

1. **After an activity**
   - gives brief feedback;
   - reinforces effort and accuracy;
   - suggests a next step;
   - points students toward a related skill or prerequisite.

2. **During practice**
   - can be summoned by the student;
   - gives skill-specific advice;
   - uses a whiteboard to model a worked example;
   - keeps the student in the practice flow rather than moving them to a separate lesson page.

## Visual model

Use the uploaded teacher-like illustrated character as the likeness reference for Mr Slay.

Core visual identity:

- friendly adult classroom guide;
- glasses;
- short dark hair;
- trimmed beard;
- warm smile;
- green/olive polo style;
- calm classroom-teacher presence;
- appears beside a whiteboard when giving worked help.

Do not regenerate unrelated mascots. The image is a likeness/style reference for a consistent helper character.

## Interaction model

During practice, students should be able to press a helper button such as:

```text
Ask Mr Slay
Need a hint?
Show me how
```

When opened, the helper panel should show:

- Mr Slay character/portrait;
- a speech bubble with the key strategy;
- a whiteboard area with a worked example;
- a short prompt encouraging the student to try the next one;
- a close/continue button.

The helper should not give away the answer to the current live question by default. Prefer showing a similar worked example using the same strategy.

## Whiteboard model

The whiteboard is for the worked example.

The speech bubble is for the strategy summary.

Example structure:

```text
Speech bubble:
Try the 5 + 2 trick for 7s.

Whiteboard:
7 × 4
= (5 × 4) + (2 × 4)
= 20 + 8
= 28

Prompt:
Now try your question using the same steps.
```

## Times-table strategy bank

Use the uploaded *Mastering Your Times Tables!* presentation as inspiration for the language and strategy set. Do not copy the deck wholesale. Convert strategies into short, child-friendly helper advice.

### 0 times table

Speech bubble:

```text
Zero groups means zero altogether.
```

Whiteboard:

```text
0 × 8 = 0
8 groups of nothing is still 0.
```

### 1 times table

Speech bubble:

```text
The 1s keep the number the same.
```

Whiteboard:

```text
1 × 9 = 9
One group of 9 is 9.
```

### 2 times table

Speech bubble:

```text
For 2s, just double it.
```

Whiteboard:

```text
2 × 8
= 8 + 8
= 16
```

### 3 times table

Speech bubble:

```text
For 3s, check the digit sum.
```

Whiteboard:

```text
3 × 8 = 24
2 + 4 = 6
6 is a 3s pattern.
```

### 4 times table

Speech bubble:

```text
For 4s, double it, then double it again.
```

Whiteboard:

```text
4 × 6
6 → 12 → 24
```

### 5 times table

Speech bubble:

```text
5s end in 0 or 5.
```

Whiteboard:

```text
5 × 7 = 35
Odd × 5 ends in 5.

5 × 8 = 40
Even × 5 ends in 0.
```

### 6 times table

Speech bubble:

```text
For 6s, double the 3s fact.
```

Whiteboard:

```text
6 × 4
= 2 × (3 × 4)
= 2 × 12
= 24
```

### 7 times table

Speech bubble:

```text
For 7s, use 5 groups and 2 groups.
```

Whiteboard:

```text
7 × 4
= (5 × 4) + (2 × 4)
= 20 + 8
= 28
```

### 8 times table

Speech bubble:

```text
For 8s, double three times.
```

Whiteboard:

```text
8 × 3
3 → 6 → 12 → 24
```

### 9 times table

Speech bubble:

```text
For 9s, do 10 groups then take one group away.
```

Whiteboard:

```text
9 × 7
= (10 × 7) - 7
= 70 - 7
= 63
```

### 10 times table

Speech bubble:

```text
For 10s, shift one place and add a zero.
```

Whiteboard:

```text
10 × 6 = 60
6 ones becomes 6 tens.
```

### 11 times table

Speech bubble:

```text
For 11s up to 9, repeat the digit.
```

Whiteboard:

```text
11 × 8 = 88

For 11 × 12:
(11 × 10) + (11 × 2)
= 110 + 22
= 132
```

### 12 times table

Speech bubble:

```text
For 12s, use 10 groups and 2 groups.
```

Whiteboard:

```text
12 × 7
= (10 × 7) + (2 × 7)
= 70 + 14
= 84
```

## General times-table advice

Use these when the selected practice is mixed multiplication or custom times tables.

### Commutativity

Speech bubble:

```text
Swap the order if it helps.
```

Whiteboard:

```text
7 × 3 = 3 × 7
Both equal 21.
```

### Square numbers

Speech bubble:

```text
Same number twice? That's a square number.
```

Whiteboard:

```text
6 × 6 = 36
8 × 8 = 64
```

### Accuracy before speed

Speech bubble:

```text
Be accurate first. Speed comes next.
```

Whiteboard:

```text
Step 1: Choose a strategy.
Step 2: Check the answer.
Step 3: Try to get faster.
```

## Recommended front-end implementation

Add a central helper-content registry such as:

```js
var MR_SLAY_HELPERS = {
  times7: {
    title: "7 times table",
    bubble: "For 7s, use 5 groups and 2 groups.",
    board: [
      "7 × 4",
      "= (5 × 4) + (2 × 4)",
      "= 20 + 8",
      "= 28"
    ],
    prompt: "Now try your question using the same 5 + 2 idea."
  }
};
```

Then add a resolver function that chooses the best helper based on the current session:

```js
function helperForActiveSession(active) {
  if (!active) return MR_SLAY_HELPERS.general;
  if ((active.tags || []).indexOf("times7") >= 0) return MR_SLAY_HELPERS.times7;
  if ((active.tags || []).indexOf("times8") >= 0) return MR_SLAY_HELPERS.times8;
  if ((active.tags || []).indexOf("times9") >= 0) return MR_SLAY_HELPERS.times9;
  if (active.operation === "multiplication") return MR_SLAY_HELPERS.multiplicationGeneral;
  return MR_SLAY_HELPERS.general;
}
```

## UX requirements

- Keep it optional. Students should not be forced to open the helper.
- Do not interrupt timed sprint flow unless the student taps the helper button.
- In practice mode, the helper can be more prominent.
- In sprint mode, the helper button should be available but unobtrusive.
- The helper should support the strategy, not replace student thinking.
- Mr Slay should never shame the student or imply failure.

## Future extension

Once times tables work well, add skill-specific helper panels for:

- friends of 10;
- bridging through 10;
- friends of 100/1000/150/1500;
- reverse division facts;
- metric conversions;
- fractions of quantities;
- percentage discounts;
- related denominator fractions.
