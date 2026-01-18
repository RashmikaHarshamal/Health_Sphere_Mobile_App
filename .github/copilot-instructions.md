# AI Copilot Instructions

## Project Overview
**flutter_application_3** is a healthcare mobile app built with Flutter targeting Android, iOS, web, and desktop platforms. It provides appointment management, doctor discovery (Sri Lanka-focused), health articles, vaccination tracking, and payment integration. The app uses purely local state management—no external packages for networking, state management, or databases. All data is mocked with hardcoded Lists.

## Architecture & Navigation

### Screen-Based Navigation (Stateful Widgets Only)
- **Entry Point**: [lib/main.dart](lib/main.dart) → `LoginPage` via app-wide `MaterialApp`
- **Navigation Flow**: `LoginPage` → `HomePage` (via `pushReplacement`) → other screens (via `push`)
- **All screens** in [lib/screens/](lib/screens/) extend `StatefulWidget` with `_ScreenNameState` classes
- **No route names**: Navigation uses direct `MaterialPageRoute` constructors with screen instances
- **No external state management**: All state lives in individual screen State classes

### Core Screens & Patterns
| Screen | Purpose | Key Pattern |
|--------|---------|------------|
| `LoginPage` | Authentication entry | `GlobalKey<FormState>`, async delay simulation, controller disposal |
| `HomePage` | Main dashboard | `AnimationController`, 8 feature grid, nested navigation bridge |
| `FindDoctorsPage` | Doctor lookup | Triple-filter logic (city→hospital→specialty), large mock doctor dataset (~1000+ records) |
| `AppointmentsPage` | Appointment history | `TabController`, two tabs (Upcoming/Past) |
| `AppointmentFormPage` | Book appointments | Form with DatePicker integration |
| `ArticlesPage` / `ArticleDetailsPage` | Health content | Scrollable article lists; details passed via constructor |
| `VaccinationPage` | Vaccine records | Mock vaccination data |
| `HealthTipsPage` | Tips carousel | List-based UI |

### Data Flow
1. **Mock data**: Hardcoded `List<Map<String, dynamic>>` as class members in each State
2. **Filtering**: Synchronous filtering on mock lists (no queries or server calls)
3. **Form submission**: `Future.delayed()` simulates async work → `setState()` → navigation
4. **No persistence**: Data resets on app restart (no SharedPreferences, SQLite, or Firebase)

## UI/UX Implementation Details

### Global Theme (lib/main.dart)
- **Primary color**: `Color(0xFF4FC3F7)` (cyan/light blue)
- **Input decoration**: Filled grey fields with rounded corners (borderRadius: 12)
- **Focused border**: 2px cyan border on text fields
- **No custom fonts or packages**: Uses Material defaults only

### Common Widget Patterns
- **Form validation**: Always use `GlobalKey<FormState>` + `_formKey.currentState!.validate()`
- **Loading states**: `_isLoading` boolean → `setState()` → show CircularProgressIndicator
- **Controllers**: All `TextEditingController` must call `dispose()` in State's `@override dispose()`
- **List rendering**: Use `ListView.builder()` for performance; avoid `Column` with many children
- **Color coding**: Each feature/category uses distinct color (e.g., appointments: blue, vaccines: red)

### Navigation Pattern (Template)
```dart
// From any screen to another:
Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => const TargetPage()),
);

// For login redirect (replace stack):
Navigator.pushReplacement(
  context,
  MaterialPageRoute(builder: (context) => const HomePage()),
);
```

## Development Workflow

### Build & Run
```bash
flutter pub get              # Install dependencies (minimal set)
flutter run                  # Run on default device/emulator
flutter run -d windows       # Run on Windows desktop
flutter run -d chrome        # Run on web
flutter run -d all           # Build for all platforms (optional)
```

### Build Platform-Specific APK/IPA
```bash
flutter build apk --release  # Android APK
flutter build ios            # iOS (requires macOS + Xcode)
flutter build web            # Web bundle
```

### Testing
```bash
flutter test                 # Run unit/widget tests
flutter test --coverage      # Generate coverage report
```
Existing test file: [test/widget_test.dart](test/widget_test.dart) (basic example)

## Project Conventions

### File Organization
- **Naming**: Snake_case files (e.g., `login_page.dart`, `find_doctors_page.dart`)
- **Classes**: PascalCase (e.g., `LoginPage`, `_LoginPageState`)
- **Methods**: camelCase (e.g., `_handleLogin()`, `_buildDoctorCard()`)
- **Variables**: camelCase (e.g., `_selectedCity`, `_isLoading`)

### Code Style
1. **Imports order**: `package:flutter` → local imports (relative paths)
2. **Const liberally**: Use `const` for widgets, constructors, and collections (enables tree-shaking)
3. **No comments except intent**: Let widget names be self-documenting (e.g., `_buildAppointmentCard()`)
4. **Null safety**: Use non-null assertions (`!`) when value is guaranteed (e.g., `_formKey.currentState!.validate()`)
5. **Error feedback**: Use `ScaffoldMessenger.showSnackBar()` for user messages

### State Management Pattern (Verified in LoginPage)
```dart
class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      await Future.delayed(const Duration(seconds: 2)); // Simulate API
      setState(() => _isLoading = false);
      if (mounted) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomePage()));
      }
    }
  }
}
```

### Mock Data Pattern (Verified in FindDoctorsPage & HomePage)
```dart
final List<Map<String, dynamic>> _allDoctors = [
  {
    'name': 'Dr. Nimali Fernando',
    'specialty': 'Cardiologist',
    'city': 'Colombo',
    'hospital': 'Asiri Central Hospital',
    'rating': 4.9,
    'reviews': 127,
    'experience': '15 years',
    'fee': 'Rs. 3,500',
  },
  // ... 100+ more entries
];

final List<String> _cities = ['Colombo', 'Kandy', 'Galle', ...];

final Map<String, List<String>> _hospitalsByCity = {
  'Colombo': ['Asiri Central', 'Nawaloka', ...],
};
```

## Key Dependencies
- **flutter**: SDK (Material Design)—no Material3 yet
- **cupertino_icons**: iOS-style icon set
- **flutter_lints**: Lint rules for code quality
- **SDK**: Dart 3.9.2+
- **No networking, state management, or database packages**: Everything is local and mocked

## Files to Read First (In Order)
1. [lib/main.dart](lib/main.dart) (50 lines) — App theme & theme configuration
2. [lib/screens/login_page.dart](lib/screens/login_page.dart) (270 lines) — Form & navigation template
3. [lib/screens/home_page.dart](lib/screens/home_page.dart) (1300 lines) — Dashboard with animations and feature grid
4. [lib/screens/find_doctors_page.dart](lib/screens/find_doctors_page.dart) (1180 lines) — Complex filtering logic with large dataset

## Common Modifications Checklist

### Add a New Screen
1. Create `lib/screens/new_feature_page.dart` following `StatefulWidget` pattern
2. Import in `lib/main.dart` (unnecessary if only nested-navigated)
3. Add navigation button in parent screen with `Navigator.push()`
4. Add mock data as class-level `final List<Map>` in State

### Modify Theme/Colors
- Edit `ThemeData` in `lib/main.dart` (primaryColor, inputDecorationTheme, etc.)
- Update color constants inline in feature grids (e.g., `'color': Colors.blue` in mock data)

### Add Mock Data
- Locate screen's State class → add/edit `final List<Map<String, dynamic>> _data = [...]`
- Restructure class members if filtering logic needed (see FindDoctorsPage for city→hospital cascade)

### Handle a Longer Dataset
- Use `ListView.builder()` instead of `Column(children: [...])` for >10 items
- Example: `FindDoctorsPage` uses builder to handle 1000+ doctor records efficiently
