# Four-operation diagnostic foundation

Planned next update after the Mr Slay visual upgrade.

## Purpose

Move Fluency Sprint from a practice-only tool toward a teaching tool by giving students and teachers a clear first signal across the four core operations.

## Scope

Use existing sprint sessions as diagnostic evidence rather than adding a new database mode. This avoids Supabase schema changes at this stage.

## Student-facing behaviour

Add a 4 operations diagnostic panel to the student menu. It should show:

- Addition
- Subtraction
- Multiplication
- Division

For each operation, show a simple status:

- Not started
- Building
- Nearly secure
- Secure

The panel should also show:

- strongest operation
- focus operation
- a `Start next diagnostic` button

The button should use the existing `start-diagnostic` action and pass the next needed operation through `data-operation`.

## Teacher-facing behaviour

Add a 4 operations diagnostic panel to the teacher dashboard and results view. It should show, per student:

- number of secure operations out of 4
- strongest operation
- focus operation
- diagnostic recommendation

## Constraints

- Do not add a Supabase schema change in this update.
- Do not create a new `mode` value. Keep using existing `practice` and `sprint` modes.
- Do not interfere with current sprint climb unlocking.
- Do not interfere with Mr Slay: practice summon only, no summon during sprint.

## Validation checklist

- Student menu shows the four-operation diagnostic panel.
- `Start next diagnostic` begins a sprint for the suggested operation.
- Teacher dashboard shows a class diagnostic summary.
- Teacher results class view shows diagnostic status.
- Student results view shows that student’s four-operation diagnostic evidence.
- Existing sprint climb still works.
- Existing practice mode still works.
