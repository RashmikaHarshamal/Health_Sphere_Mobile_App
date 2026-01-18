# User Authentication System Documentation

## Overview
This document describes the user authentication system for the HealthSphere mobile app. The system allows users to sign up, log in, and manage their profiles using local data storage.

## Folder Structure

```
lib/
├── models/
│   └── user_model.dart          # User data model
├── services/
│   ├── authentication_service.dart    # Core authentication logic
│   └── user_profile_service.dart      # User profile management
└── screens/
    ├── login_page.dart           # Login screen
    ├── signup_page.dart          # Sign up screen
    └── user_profile_page.dart    # User profile & edit profile screens
```

## Features

### 1. User Registration (Sign Up)
- Users can create an account with the following information:
  - Full Name
  - Email Address
  - Phone Number
  - Gender (Male, Female, Other)
  - Date of Birth
  - Password (minimum 6 characters)
  - Terms & Conditions acceptance

**Validation:**
- All fields are required
- Email must be unique (not already registered)
- Password must be at least 6 characters
- Password confirmation must match password field
- User must agree to Terms & Conditions

**Result:**
- On successful registration, user is assigned a unique User ID (format: USR + 10 random characters)
- User account is stored locally
- Success message displayed and user is redirected to login page

### 2. User Login
- Users can log in with their registered email and password
- System validates credentials against registered users

**Validation:**
- Email must be in the database (registered)
- Password must match the registered password
- Both fields are required

**Result:**
- On successful login, user is set as current user and redirected to HomePage
- On failed login, appropriate error message is displayed (user not found or incorrect password)

### 3. User Profile Management
- **View Profile**: Users can view their complete profile information including:
  - User ID
  - Name
  - Email
  - Phone
  - Gender
  - Date of Birth
  - Member Since (account creation date)

- **Edit Profile**: Users can update their:
  - Name
  - Phone Number
  - Gender
  - Date of Birth

- **Logout**: Users can logout from their profile page

### 4. Authentication Service (Core)

**File:** `lib/services/authentication_service.dart`

**Key Methods:**

```dart
// Sign up a new user
Future<({bool success, String message})> signUp({
  required String name,
  required String email,
  required String password,
  required String phone,
  required String dateOfBirth,
  required String gender,
})

// Log in a user
Future<({bool success, String message, User? user})> login({
  required String email,
  required String password,
})

// Get current logged-in user
User? getCurrentUser()

// Log out user
void logout()

// Check if user is logged in
bool isLoggedIn()

// Update user profile
Future<({bool success, String message})> updateUserProfile({
  required String name,
  required String phone,
  required String dateOfBirth,
  required String gender,
})
```

### 5. User Profile Service

**File:** `lib/services/user_profile_service.dart`

**Key Methods:**

```dart
// Get current user profile
User? getCurrentUserProfile()

// Get all registered users
List<User> getAllUsersProfile()

// Check if user exists by email
bool userExistsByEmail(String email)

// Get user by ID
User? getUserById(String userId)

// Search users by name
List<User> searchUsersByName(String searchTerm)

// Get total users count
int getTotalUsersCount()
```

## Data Model

### User Model

**File:** `lib/models/user_model.dart`

```dart
class User {
  final String id;                // Unique user identifier
  final String name;              // Full name
  final String email;             // Email address (unique)
  final String password;          // Password (plain text in local storage)
  final String phone;             // Phone number
  final String dateOfBirth;       // Format: DD/MM/YYYY
  final String gender;            // Male, Female, or Other
  final DateTime createdAt;       // Account creation timestamp
}
```

## User Flow

### Registration Flow
1. User opens app → LoginPage
2. User clicks "Sign Up" → SignUpPage
3. User fills form with required information
4. User agrees to Terms & Conditions
5. User clicks "Sign Up" button
6. System validates input
7. If valid: User account created, success message shown, navigate back to LoginPage
8. If invalid: Error message shown, user remains on SignUpPage

### Login Flow
1. User enters email and password
2. User clicks "Login" button
3. System validates credentials
4. If valid: User logged in, redirected to HomePage
5. If invalid: Error message shown

### Profile Management Flow
1. User navigates to profile (from HomePage)
2. User can view their profile information
3. User can click "Edit Profile" to update information
4. User can click logout to exit the app

## Storage

Currently, the authentication system uses **in-memory storage** (static List in AuthenticationService). This means:
- User data persists during the app session
- Data is lost when the app is closed
- No persistent database

**Future Enhancement:** To persist data across app sessions, integrate:
- SQLite (local database)
- SharedPreferences (key-value storage)
- Firebase Firestore (cloud database)
- Firebase Authentication (professional auth solution)

## Security Considerations

⚠️ **Important:** This is a demonstration implementation. For production:
- Hash passwords using bcrypt or similar
- Implement JWT tokens for session management
- Use HTTPS for all communications
- Implement refresh token mechanism
- Add rate limiting for login attempts
- Use Firebase Authentication for production-grade security

## Integration with Existing Screens

To integrate the authentication system with other screens:

1. **In HomePage:**
   ```dart
   // Add profile button to navigate to UserProfilePage
   Navigator.push(
     context,
     MaterialPageRoute(builder: (context) => const UserProfilePage()),
   );
   ```

2. **Check if user is logged in:**
   ```dart
   if (authService.isLoggedIn()) {
     // User is authenticated
   }
   ```

3. **Get current user details:**
   ```dart
   User? currentUser = authService.getCurrentUser();
   ```

## Testing

To test the authentication system:

1. **Create a test account:**
   - Name: John Doe
   - Email: john@example.com
   - Phone: +1234567890
   - Password: test123
   - Gender: Male
   - DOB: 01/01/1990

2. **Test login with valid credentials**
3. **Test login with invalid credentials**
4. **Test duplicate email registration**
5. **Test profile update**
6. **Test logout**

## Future Enhancements

1. **Firebase Integration**: Replace local storage with Firebase
2. **Email Verification**: Send verification emails to new users
3. **Password Reset**: Implement "Forgot Password" functionality
4. **Social Login**: Add Google, Facebook, and Apple sign-in
5. **Two-Factor Authentication**: Add SMS/Email OTP verification
6. **User Roles**: Implement different user types (patient, doctor, admin)
7. **Profile Picture**: Allow users to upload profile photos
8. **Encrypted Storage**: Secure password storage with encryption
