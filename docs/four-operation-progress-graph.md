# Four-operation progress graph

Planned update 03 after the combined Mr Slay + four-operation diagnostic package.

## Purpose

Add a teacher-facing progress graph so a selected student's growth across core operations is visible at a glance.

## Placement

Teacher Results → Student view.

Place it near the four-operation diagnostic evidence panel.

## Data source

Use existing saved session data only:

- `studentId`
- `operation`
- `levelId`
- `accuracy`
- `score`
- `createdAt`

No Supabase schema change.

## Graph specification

- X-axis: Stage 1, Stage 2, Stage 3, Stage 4
- Lines: Addition, Subtraction, Multiplication, Division
- Y-axis: Best accuracy percentage
- Exclude mixed operations
- Exclude measurement

## Behaviour

For each operation, map the first four pathway levels to Stage 1–4. For each stage, show the student's best saved accuracy for that level.

If the student has no data, show a fallback message instead of an empty graph.

## Validation checklist

- Teacher Results → Student view shows `4 operations progress graph`.
- The graph has Stage 1 to Stage 4 on the x-axis.
- Lines show Addition, Subtraction, Multiplication and Division.
- Mixed operations and measurement are excluded.
- The evidence table below the graph shows level IDs and best accuracy.
- Existing teacher results, sprint and practice flows still work.
