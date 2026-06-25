# Combined Mr Slay and four-operation diagnostic update

This document records the next local patch package to apply before the next app push.

## Included updates

1. Mr Slay visual upgrade v3
   - repair missing Ask Mr Slay wiring
   - keep helper practice-only
   - prevent summon during sprint
   - add visual Mr Slay asset

2. Four-operation diagnostic foundation
   - student menu panel across addition, subtraction, multiplication, division
   - student strongest/focus operation recommendation
   - teacher dashboard class summary
   - teacher results summary
   - no Supabase schema change

## Local commit checklist

After applying the combined package locally, commit only:

- `index.html`
- `assets/mr-slay-npc.jpg`

Do not commit:

- PowerShell scripts
- backup files
- patch README files

## Test checklist

- Practice mode shows `Ask Mr Slay` on the live question screen.
- Sprint mode has no `Ask Mr Slay` and no `Hint`.
- Mr Slay helper opens with a speech bubble and whiteboard example.
- Student menu shows the 4 operations diagnostic panel.
- `Start next diagnostic` begins a sprint for the suggested operation.
- Teacher dashboard shows 4-operation diagnostic status.
- Teacher results class/student views show diagnostic evidence.
