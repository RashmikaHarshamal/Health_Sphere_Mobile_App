# Quick Start Guide - Authentication System

## 🚀 Getting Started

### 1. **First Time User - Sign Up**
1. Open the app → You'll see the LoginPage
2. Click **"Sign Up"** link at the bottom
3. Fill in the registration form:
   - Full Name
   - Email (must be unique)
   - Phone Number
   - Select Gender
   - Select Date of Birth
   - Enter Password (min 6 characters)
   - Confirm Password
   - ✓ Accept Terms & Conditions
4. Click **"Sign Up"** button
5. Success message → Redirected to LoginPage

### 2. **Returning User - Login**
1. On LoginPage, enter:
   - Email: your registered email
   - Password: your password
2. Click **"Login"** button
3. Success → Redirected to HomePage

### 3. **Access Profile**
From HomePage:
1. Look for profile icon/button
2. Click to navigate to User Profile Page
3. View all your information
4. Click "Edit Profile" to update details
5. Click logout icon to exit

---

## 📁 File Structure

```
lib/
├── models/
│   └── user_model.dart ........................ User data model
├── services/
│   ├── authentication_service.dart ........... Authentication logic
│   └── user_profile_service.dart ............ Profile management
└── screens/
    ├── login_page.dart ....................... Updated with auth
    ├── signup_page.dart ...................... Updated with auth
    └── user_profile_page.dart ............... NEW - Profile management
```

---

## 💻 Code Examples

### Example 1: Check if User is Logged In
```dart
import '../services/authentication_service.dart';

if (authService.isLoggedIn()) {
  print('User is logged in');
  User? user = authService.getCurrentUser();
  print('Welcome ${user?.name}');
}
```

### Example 2: Get Current User Details
```dart
User? currentUser = authService.getCurrentUser();
if (currentUser != null) {
  print('Name: ${currentUser.name}');
  print('Email: ${currentUser.email}');
  print('Phone: ${currentUser.phone}');
}
```

### Example 3: Navigate to Profile Page
```dart
Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => const UserProfilePage()),
);
```

### Example 4: Search Users (Admin Feature)
```dart
final userService = userProfileService;
List<User> results = userService.searchUsersByName('John');
```

---

## ✅ Validation Rules

### Sign Up Validation:
- ✓ Name: Required, minimum 3 characters
- ✓ Email: Required, must contain @, unique
- ✓ Phone: Required
- ✓ Gender: Required
- ✓ Date of Birth: Required
- ✓ Password: Required, minimum 6 characters
- ✓ Confirm Password: Must match password
- ✓ Terms & Conditions: Must be accepted

### Login Validation:
- ✓ Email: Required, must be registered
- ✓ Password: Required, must be correct

---

## 🧪 Test Cases

### Test 1: New User Sign Up
```
Email: newuser@test.com
Password: TestPass123
Expected: Account created successfully
```

### Test 2: Duplicate Email Sign Up
```
Email: (existing email)
Expected: "Email already registered" error
```

### Test 3: Wrong Password Login
```
Email: existing@test.com
Password: WrongPassword
Expected: "Invalid email or password" error
```

### Test 4: Successful Login
```
Email: existing@test.com
Password: CorrectPassword
Expected: Redirected to HomePage
```

### Test 5: Profile Update
```
From profile page:
- Change name
- Change phone
- Change gender
- Change date of birth
Expected: Changes saved successfully
```

---

## 📊 Database Structure (Current)

Currently stores in memory as a static List:

```dart
List<User> _registeredUsers = [
  User(
    id: 'USR1234567890',
    name: 'John Doe',
    email: 'john@example.com',
    password: 'test123',
    phone: '+1234567890',
    dateOfBirth: '01/01/1990',
    gender: 'Male',
    createdAt: DateTime.now(),
  ),
];
```

---

## 🔄 How Authentication Flow Works

```
User Opens App
        ↓
    LoginPage
        ↓
    ┌───────────┬───────────┐
    ↓           ↓           ↓
  Login      Sign Up    Forgot Password
    ↓           ↓           ↓
Validate    Register    Reset Flow
    ↓           ↓           ↓
Success    Navigate     Email Link
    ↓        to Login        ↓
    ↓           ↓        Set New Pass
    └─── HomePage ←──────────┘
           ↓
    Access Features
           ↓
    View Profile → Edit → Logout
```

---

## 🔐 Security Notes

**Current Implementation (Demo):**
- Passwords stored as plain text
- No encryption
- No token system
- Data lost on app close

**Production Requirements:**
- Hash passwords with bcrypt
- Implement JWT tokens
- Use Firebase Authentication
- Enable encrypted storage
- Implement session management
- Add rate limiting

---

## 📞 API Reference

### AuthenticationService

```dart
// Sign up
Future<({bool success, String message})> signUp({...})

// Login
Future<({bool success, String message, User? user})> login({...})

// Get current user
User? getCurrentUser()

// Logout
void logout()

// Check login status
bool isLoggedIn()

// Update profile
Future<({bool success, String message})> updateUserProfile({...})

// Check email exists
bool emailExists(String email)

// Get all users
List<User> getAllUsers()
```

### UserProfileService

```dart
// Get current user
User? getCurrentUserProfile()

// Get all users
List<User> getAllUsersProfile()

// Check email exists
bool userExistsByEmail(String email)

// Get user by ID
User? getUserById(String userId)

// Search by name
List<User> searchUsersByName(String searchTerm)

// Get user count
int getTotalUsersCount()
```

---

## 🚨 Common Issues & Solutions

### Issue: "Email already exists"
**Solution:** Use a different email address

### Issue: "Password is too short"
**Solution:** Use at least 6 characters

### Issue: "Passwords do not match"
**Solution:** Make sure confirm password matches password field

### Issue: "User not found"
**Solution:** Check if email is correctly spelled or sign up first

### Issue: "Data lost after app restart"
**Solution:** This is expected with current implementation. Integrate SQLite or Firebase for persistence.

---

## 📚 Documentation Files

- Full Documentation: [AUTHENTICATION_README.md](../AUTHENTICATION_README.md)
- Implementation Summary: [IMPLEMENTATION_SUMMARY.md](../IMPLEMENTATION_SUMMARY.md)
- This Guide: QUICK_START.md

---

**Need Help?** Check the full documentation or review the example screens in the codebase.
