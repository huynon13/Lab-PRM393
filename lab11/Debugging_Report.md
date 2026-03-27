# Lab 11.4 DevTools Debugging Report (Taskly App)

## Potential layout issue
- On narrow screens, the input row (`TextField + Add button`) can feel tight and may compress the text field.
- Suggested fix: make the Add action an icon button or move it below the input on very small widths.

## Potential performance issue
- Entire `TaskListScreen` rebuilds after each add/delete/update because `setState` wraps full-screen state changes.
- Suggested fix: use finer-grained state updates (e.g., `ValueNotifier`, `ChangeNotifier` + `AnimatedBuilder`, or `ListView` item-level state split).

## How testing and DevTools help
- Widget and integration tests catch behavior regressions (add/edit/navigation/empty state) quickly after refactors.
- Widget Inspector helps identify layout constraints and overflow risks on different screen sizes.
- Performance Timeline helps observe frame build/raster workload during repeated add/edit operations.

## Required manual artifacts
- Add 2 screenshots from your environment:
  - Widget Inspector tree
  - Performance Timeline trace
