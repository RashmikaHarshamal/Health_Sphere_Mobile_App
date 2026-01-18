# Integration Guide - Adding Authentication to Your App

## 🎯 Step-by-Step Integration

### Step 1: Run and Test the Authentication System

```bash
# Navigate to project directory
cd d:\HealthSphere\Health_Sphere_Mobile_App

# Get dependencies
flutter pub get

# Run on your device/emulator
flutter run
```

Expected flow:
1. App opens → LoginPage
2. See "Sign Up" link at bottom
3. Click to go to SignUpPage
4. Register an account
5. Login with same credentials
6. Access HomePage

---

### Step 2: Add Profile Navigation to HomePage

In `lib/screens/home_page.dart`, find the AppBar and add a profile button:

```dart
AppBar(
  title: const Text('HealthSphere'),
  backgroundColor: const Color(0xFF4FC3F7),
  elevation: 0,
  actions: [
    // Add this profile icon button
    IconButton(
      icon: const Icon(Icons.person),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const UserProfilePage()),
        );
      },
      tooltip: 'My Profile',
    ),
  ],
)
```

Don't forget to import:
```dart
import 'user_profile_page.dart';
```

---

### Step 3: Add User Name Display in HomePage

To display the logged-in user's name:

```dart
import '../services/authentication_service.dart';

// In HomePage build method
final currentUser = authService.getCurrentUser();

// Display in header or anywhere in the UI
Text(
  'Welcome, ${currentUser?.name ?? "User"}!',
  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
)
```

---

### Step 4: Protect Restricted Pages

For pages that require authentication:

```dart
class RestrictedPage extends StatefulWidget {
  const RestrictedPage({Key? key}) : super(key: key);

  @override
  State<RestrictedPage> createState() => _RestrictedPageState();
}

class _RestrictedPageState extends State<RestrictedPage> {
  @override
  void initState() {
    super.initState();
    _checkAuthentication();
  }

  void _checkAuthentication() {
    if (!authService.isLoggedIn()) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!authService.isLoggedIn()) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    // Build page content
    return Scaffold(
      // Your page content here
    );
  }
}
```

---

### Step 5: Add User Info to Appointment Features

Example: Display doctor appointments for current user

```dart
import '../services/authentication_service.dart';

void _bookAppointment() {
  final currentUser = authService.getCurrentUser();
  
  if (currentUser == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Please login to book appointments')),
    );
    return;
  }

  // Proceed with booking
  // You can now use currentUser.id, currentUser.email, etc.
  print('Booking appointment for: ${currentUser.name}');
}
```

---

### Step 6: Add User Filter for Admin Features

Example: Show users in admin panel

```dart
import '../services/user_profile_service.dart';

List<User> getAllUsers() {
  return userProfileService.getAllUsersProfile();
}

List<User> searchUsers(String query) {
  return userProfileService.searchUsersByName(query);
}

void _displayUserCount() {
  int count = userProfileService.getTotalUsersCount();
  print('Total registered users: $count');
}
```

---

### Step 7: Add Logout from Any Screen

Add a logout function that can be called from any screen:

```dart
void _handleLogout(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              authService.logout();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
              );
            },
            child: const Text('Logout', style: TextStyle(color: Colors.red)),
          ),
        ],
      );
    },
  );
}
```

---

### Step 8: Update Appointment Data Structure

Enhance appointments to include user information:

```dart
class Appointment {
  final String id;
  final String userId;        // Add this
  final String userName;      // Add this
  final String userEmail;     // Add this
  final String doctorName;
  final String specialty;
  final DateTime dateTime;
  final String status;

  Appointment({
    required this.id,
    required this.userId,
    required this.userName,
    required this.userEmail,
    required this.doctorName,
    required this.specialty,
    required this.dateTime,
    required this.status,
  });
}

// When creating appointment:
final currentUser = authService.getCurrentUser();
final appointment = Appointment(
  id: generateId(),
  userId: currentUser!.id,
  userName: currentUser.name,
  userEmail: currentUser.email,
  doctorName: selectedDoctor,
  specialty: selectedSpecialty,
  dateTime: selectedDateTime,
  status: 'Confirmed',
);
```

---

### Step 9: Add User Validation to Payment

Ensure only authenticated users can make payments:

```dart
import '../services/authentication_service.dart';

void _processPayment(double amount) {
  final currentUser = authService.getCurrentUser();
  
  if (currentUser == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Please login to make payment')),
    );
    return;
  }

  // Process payment for currentUser
  print('Processing payment of Rs. $amount for ${currentUser.email}');
  
  // Add payment record with user info
  final paymentRecord = {
    'userId': currentUser.id,
    'userEmail': currentUser.email,
    'amount': amount,
    'timestamp': DateTime.now(),
    'status': 'Completed',
  };
}
```

---

### Step 10: Display User Information in Articles/Tips

Show who bookmarked or viewed content:

```dart
// Track user activities
void _trackUserActivity(String userId, String action, String contentId) {
  final currentUser = authService.getCurrentUser();
  
  if (currentUser != null) {
    print('User: ${currentUser.name}');
    print('Action: $action');
    print('Content: $contentId');
    print('Time: ${DateTime.now()}');
    
    // Save to activity log
    // Can be used for personalized recommendations
  }
}

// Example usage
_trackUserActivity(
  currentUser.id,
  'viewed_article',
  articleId,
);
```

---

## 🔗 Common Integration Patterns

### Pattern 1: Check User Before Action
```dart
bool _canPerformAction() {
  if (!authService.isLoggedIn()) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Please login first')),
    );
    return false;
  }
  return true;
}

// Usage
if (_canPerformAction()) {
  // Perform action
}
```

### Pattern 2: Get User Info Safely
```dart
User? _getUserOrNull() => authService.getCurrentUser();

User _getUserOrDefault() => authService.getCurrentUser() ?? User(
  id: 'guest',
  name: 'Guest User',
  email: 'guest@example.com',
  password: '',
  phone: '',
  dateOfBirth: '',
  gender: '',
  createdAt: DateTime.now(),
);
```

### Pattern 3: Handle Auth State Changes
```dart
@override
void initState() {
  super.initState();
  _checkAuthState();
}

void _checkAuthState() {
  if (authService.isLoggedIn()) {
    // User is logged in
    _currentUser = authService.getCurrentUser();
    setState(() {});
  } else {
    // User is not logged in
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }
}
```

### Pattern 4: Safe Navigation with Auth Check
```dart
void _navigateToProtectedPage() {
  if (!authService.isLoggedIn()) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Please login to access this feature')),
    );
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
    return;
  }

  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const ProtectedPage()),
  );
}
```

---

## 📋 Integration Checklist

- [ ] Run app and test sign up/login
- [ ] Add profile icon button to HomePage
- [ ] Display user name in HomePage header
- [ ] Protect restricted pages with auth check
- [ ] Add user info to appointment booking
- [ ] Add user filter to admin panel
- [ ] Add logout option to navigation
- [ ] Update appointment model with user ID
- [ ] Add user validation to payment page
- [ ] Track user activities in analytics
- [ ] Test all auth flows end-to-end
- [ ] Handle edge cases and errors

---

## 🧪 Testing Scenarios

### Scenario 1: New User Flow
1. Open app → LoginPage
2. Click "Sign Up"
3. Fill form with: `test_new@test.com`, `NewPass123`
4. Sign up successfully
5. Login with same credentials
6. Verify redirected to HomePage
7. Click profile icon
8. Verify all details displayed

### Scenario 2: Existing User Flow
1. Open app (already have account)
2. Click "Don't have account? Sign Up"
3. Try signing up with existing email
4. See error: "Email already registered"
5. Go back to login
6. Enter credentials
7. Login successfully

### Scenario 3: Protected Page Access
1. Logout from app
2. Try accessing profile page directly
3. Should be redirected to LoginPage
4. Login successfully
5. Can now access profile page

### Scenario 4: Profile Update
1. Login to app
2. Navigate to profile
3. Click "Edit Profile"
4. Change name and phone
5. Save changes
6. Go back and verify changes saved

---

## 🐛 Troubleshooting

### Issue: Can't login after signup
**Solution:** Make sure email matches exactly (case-sensitive in some cases)

### Issue: Data lost after closing app
**Solution:** This is expected. Integrate SQLite or Firebase for persistence

### Issue: Import errors in IDE
**Solution:** Run `flutter pub get` and reload IDE

### Issue: User not found after signup
**Solution:** Check that AuthenticationService singleton is being used consistently

---

## 📞 Support Files

- **Full Documentation**: [AUTHENTICATION_README.md](AUTHENTICATION_README.md)
- **Quick Start**: [QUICK_START.md](QUICK_START.md)
- **Architecture**: [ARCHITECTURE.md](ARCHITECTURE.md)
- **Implementation Summary**: [IMPLEMENTATION_SUMMARY.md](IMPLEMENTATION_SUMMARY.md)

---

## ✅ You're All Set!

Your authentication system is now:
- ✓ Implemented and working
- ✓ Ready to integrate with other features
- ✓ Documented and maintainable
- ✓ Extensible for future enhancements

Start by running the app and testing the authentication flow!
