# Subtraction Mr Slay Advice Plan

This file records the intended small PR scope before editing the single-file app.

## Branch

`feature/subtraction-mr-slay-advice`

## Scope

Add targeted Mr Slay advice for subtraction practice and subtraction guide pages only.

Do not alter:

- `main` directly
- addition advice
- multiplication advice
- division advice
- diagnostics
- graphs
- lesson content
- old broken branches
- old Update 06 or Update 07A scripts

## Intended helper entries

Add these beside the existing `additionGeneral`, `additionFriends10`, `additionEnding5`, and `additionBridge10` helpers:

- `subtractionGeneral`
- `subtractionFriends10`
- `subtractionEnding5`
- `subtractionBridge10`
- `subtractionPlaceValue`

## Routing

Update `mrSlayHelperForLevel(level)` so subtraction levels route by tag:

- `ending5` -> `subtractionEnding5`
- `bridge` -> `subtractionBridge10`
- `friends10` -> `subtractionFriends10`
- `friends100`, `friends1000`, `friends150`, `friends1500` -> `subtractionPlaceValue`
- otherwise -> `subtractionGeneral`

Update `helperForActiveSession(active)` so subtraction practice calls:

`mrSlayHelperForLevel(levelById(active.levelId))`

This should mirror the current addition practice behaviour.

## Manual test list

Before merge, manually check:

- S2 Subtract from 10
- S5 Answers ending in 5
- S6 Bridge through 10
- S8 Subtract from 100
- S7 Mixed subtraction fluency

For each check:

1. Open the guide page.
2. Confirm the Mr Slay guide panel gives subtraction-specific advice.
3. Start practice.
4. Use Ask Mr Slay.
5. Confirm advice remains subtraction-specific and targeted to the level.
