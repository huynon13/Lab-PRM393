# LAB 12 Report - Performance Optimization & App Deployment

## Exercise 12.1 - Optimize List Rebuilds

- Refactored inline list item into separate widget: `lib/widgets/task_tile.dart`.
- Used `Selector<TaskProvider, List<Task>>` in `lib/screens/task_list_screen.dart` so only task list subtree rebuilds.
- Added stable key for each row: `ValueKey(task.id)`.
- Added `const` widgets for static UI elements where applicable.

### Before / After (for screenshot evidence)

- Before: full task screen rebuilds when toggling a checkbox.
- After: only list area and the affected list item rebuild.

## Exercise 12.2 - Image & Asset Optimization

- Added optimized image asset: `assets/images/task_icon.png` (128x128).
- Registered asset in `pubspec.yaml`.
- Added image precaching in `TaskListScreen.didChangeDependencies()`:
  - `precacheImage(const AssetImage('assets/images/task_icon.png'), context);`
- No unused assets found in this project template.

## Exercise 12.3 - App Size Analysis

### Commands used

```bash
flutter build apk --analyze-size
```

### What to record from report

- Total APK size.
- Top 3 size contributors.
- Candidate assets/dependencies to optimize or remove.

### Optimization suggestions

1. Remove dependencies that are not used in production.
2. Compress/resize image assets and avoid oversized PNG/JPEG files.
3. Split features and keep only required code paths.

## Exercise 12.4 - Final Optimization & Deployment

### Final checks

- Removed template/debug-only code and redundant rebuild patterns.
- Added `const` where possible.
- Confirmed release-ready structure with provider-based state management.

### Build commands

```bash
flutter clean
flutter pub get
flutter run --profile
flutter build apk --release
flutter build appbundle --release
```

### Why app is ready for deployment

The app uses optimized rebuild patterns (`Selector`, extracted tile widget, stable keys), lightweight assets with precaching, and release build artifacts, which improves responsiveness and reduces runtime overhead for deployment.
