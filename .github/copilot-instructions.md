# AI Agent Coding Instructions - Mess Managing System

## Project Overview
Flutter-based **Mess Managing System** (shared dining expense manager for multiple members). Uses Provider pattern for state management and Material Design for UI. Two core entities: **Members** (track meal counts) and **Expenses** (shared costs split by meal count).

## Architecture & Data Flow

### Core Structure
- **Provider Pattern**: `MessProvider` (single ChangeNotifier) manages all state
  - Located: [lib/providers/mess_provider.dart](lib/providers/mess_provider.dart)
  - One source of truth for members, expenses, and UI theme
  - All screens consume via `context.watch<MessProvider>()` for reactive updates

### Entity Models
- **Member**: ID, name, meal count (integer) - represents a mess participant
- **Expense**: ID, title, amount (double), date, optional memberId - represents shared costs
- Key calculation: `Per Meal = totalExpense / totalMeal` → used to settle accounts

### Data Flow Pattern
1. User action in screen → call `MessProvider` method
2. Provider mutates internal lists and calls `notifyListeners()`
3. Widgets consuming provider rebuild automatically
4. No network/database layer (in-memory only, data lost on app close)

## Key Files & Patterns

### Navigation & Routing
- [lib/main.dart](lib/main.dart): Root `RootPage` uses bottom navigation with indexed `_pages` list
  - Center-docked FAB for add expense (fixed navigation pattern)
  - Dynamic AppBar visibility based on `_index`
- Navigation: Use `Navigator.of(context).push(MaterialPageRoute(...))` for screens

### Screen Conventions
- Located: [lib/screens/](lib/screens/)
- Naming: `*_screen.dart` or `*Screen` class suffix (inconsistent - normalize to `ScreenName`)
- Form screens use `StatefulWidget` with `TextEditingController` (e.g., [add_expense.dart](lib/screens/add_expense.dart))
- Always include input validation and user feedback (SnackBar)
- Example: Add expense checks `if (title.isEmpty || amt <= 0) return`

### Widget Reuse
- Shared UI components in [lib/widgets/](lib/widgets/)
- `CartWidget`: Summary stats card displayed on HomeScreen - shows members, meals, total expense, per-meal cost
- Keep widgets focused and composable

## Provider Pattern Details

### State Access
- **Read-only**: `context.read<MessProvider>()` for one-time access
- **Reactive**: `context.watch<MessProvider>()` for rebuild on changes
- All getter methods return `List.unmodifiable()` (immutable access)

### Core Methods
- `addMember(String name)`: Uses `DateTime.now().microsecondsSinceEpoch` for unique IDs
- `addExpense(String title, double amount, {String? memberId})`: Optional member association
- `addMeal(String memberId, int mealCount)`: Directly mutates member's meal count
- `deleteMember(id)`: Cascading delete - removes associated expenses
- `toggleDark()`: Theme switching (dark/light) - observed by MaterialApp theme property

## Critical Conventions & Patterns

### State Management Rules
- **Always call `notifyListeners()`** after any list/object mutation
- Use `_members` and `_expenses` as private with public getters for immutability
- Never expose mutable references; use `List.unmodifiable()` for lists
- Theme state (`_isDark`) managed alongside data (minor but established pattern)

### String Formatting
- Monetary amounts: `toStringAsFixed(2)` (e.g., in CartWidget)
- Null-safe defaults: `DateTime? date` → `date ?? DateTime.now()`

### UI/UX Patterns
- Forms use `TextField` with `TextEditingController` and `trim()` validation
- ListTiles for item display with trailing icons for delete/actions
- Cards for visual grouping (member cards in HomeScreen)
- SnackBar for brief success feedback

### Naming Inconsistencies (Normalize)
- Controllers: `_titleCtrl`, `_amtCtrl` (abbreviated) → standardize to `_titleController`
- Screen classes: Mix of snake_case filenames with PascalCase classes → keep snake_case files, PascalCase classes
- Methods: Generally clear (addMember, deleteMember, memberExpense) → maintain consistency

## Development Workflow

### Running & Testing
```bash
flutter pub get          # Install dependencies
flutter run             # Run on connected device/emulator
flutter analyze         # Check for lint issues
```

### Build Commands
- Debug: `flutter run` (default)
- Release: `flutter build apk` (Android) / `flutter build ios` (iOS)
- Web: `flutter build web`

### Code Standards
- Enable lints: Configured in [analysis_options.yaml](analysis_options.yaml)
- No explicit lint rules overrides found - follow Dart conventions
- Imports: Absolute imports from `package:mess_meneging_system/`

## Common Tasks & Implementation Examples

### Adding a New Feature
1. **Extend Model** (e.g., add `description` to Expense) → update [expense.dart](lib/models/expense.dart)
2. **Update Provider** → add getter/method in [mess_provider.dart](lib/providers/mess_provider.dart)
3. **Create/Update Screen** → in [lib/screens/](lib/screens/), consume with `context.watch<MessProvider>()`
4. **Update Navigation** → add route to [main.dart](lib/main.dart) `_pages` list if needed

### Adding a Calculation
- Add getter to `MessProvider` (e.g., `double memberBalance(Member m)`)
- Use immutable getters that depend on current state (totalExpense, totalMeal, perMeal)
- Example: `memberExpense(Member m) => m.meal * perMeal` (shows calculation pattern)

### Form Validation
- Always trim inputs: `.text.trim()`
- Always check for empty/invalid before processing
- Always clear controllers after successful action
- Provide SnackBar feedback on success/failure

## Known Gaps & Future Considerations
- **Persistence**: No database/local storage - data is lost on app restart
- **Authentication**: Login/Signup screens exist but not integrated with actual auth backend
- **Testing**: No unit/widget tests present (`test/widget_test.dart` is default Flutter boilerplate)
- **Error Handling**: Minimal error handling in forms - add try-catch for real data operations

---

**Last Updated**: January 2, 2026  
**Dart SDK**: ^3.9.2 | **Flutter**: Latest | **Provider**: ^6.0.5
