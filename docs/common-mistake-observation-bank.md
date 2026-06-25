# Common mistake observation bank

Planned update 04 after:

1. Mr Slay visual/helper upgrade
2. Four-operation diagnostic foundation
3. Four-operation progress graph

## Purpose

Turn saved student mistakes into teacher-facing observation prompts.

This should support small-group planning, mini-lessons and individual feedback without overclaiming why a student made a mistake.

## Data source

Use existing saved session mistakes only.

No Supabase schema change.

## Teacher dashboard

Add an `Observation watchlist` showing the highest-frequency current error pattern for students with saved mistakes.

## Teacher Results → Class view

Add a `Class common mistake bank` showing top error patterns across the class.

Each card should include:

- pattern name
- number of errors
- evidence example
- teaching cue
- suggested student strategy

## Teacher Results → Student view

Add `Common mistake observations` for the selected student.

Each observation should include:

- pattern name
- evidence example
- teaching cue
- suggested student strategy

## Categories

Classify mistakes cautiously into broad teaching patterns:

- metric place-value conversion
- place-value complements
- bridging through 10
- unknown part / missing number
- division fact family recall
- times-table recall
- addition known facts
- subtraction known facts
- accuracy and checking

## Constraint

The app should phrase observations as teacher prompts, not as fixed diagnoses.

## Validation checklist

- Teacher dashboard shows `Observation watchlist` when saved mistakes exist.
- Teacher Results → Class view shows `Class common mistake bank`.
- Teacher Results → Student view shows `Common mistake observations`.
- Observations include an evidence example, teaching cue and student strategy.
- Practice and sprint still work.
