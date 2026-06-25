# Year-level multiplication/division sprint diagnostics

Planned update 05.

## Purpose

Align multiplication and division sprints to student year level, then use sprint mistakes to advise students which tables to practise next.

## Sprint table scope

### Year 3 and below

- 0s
- 1s
- 2s
- 3s
- 5s
- 10s

### Year 4

- 0s through 10s

### Year 5+

- 0s through 12s, including 11s and 12s

## Division rule

Division sprints use the same year-level table scope, but 0 is excluded as a divisor.

## Mr Slay behaviour

After a multiplication or division sprint, Mr Slay should inspect table-specific sprint errors and recommend which tables to practise next.

Example:

`This sprint showed the most friction with 7s and 8s. Use free practice for 7s and 8s, then repeat the year-level sprint.`

## Data behaviour

Custom sprint questions should be tagged by the specific table involved in the question, such as:

- `times7`
- `times8`
- `yearLevelSprint`

This improves the common mistake observation bank and makes Mr Slay feedback more precise.

## Constraints

- Do not change Supabase schema.
- Do not remove free table selection for practice.
- Keep sprint/diagnostic pathways controlled.
- Do not use 0 as a division divisor.

## Validation checklist

- Year 3 multiplication sprint uses only 0, 1, 2, 3, 5 and 10 tables.
- Year 4 multiplication sprint uses 0 through 10 tables.
- Year 5+ multiplication sprint includes 11s and 12s.
- Division sprints exclude 0 as a divisor.
- Mistakes are tagged by specific table.
- Mr Slay recommends which tables to practise after multiplication/division sprint errors.
