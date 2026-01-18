import '../models/user_model.dart';
import 'dart:math';

class AuthenticationService {
  // Simulated database - in real app, this would be persistent storage
  static final List<User> _registeredUsers = [];
  static User? _currentUser;

  // Get all registered users
  List<User> getAllUsers() => _registeredUsers;

  // Check if email already exists
  bool emailExists(String email) {
    return _registeredUsers.any((user) => user.email.toLowerCase() == email.toLowerCase());
  }

  // Generate unique ID
  String _generateUserId() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    Random random = Random();
    return 'USR${String.fromCharCodes(Iterable<int>.generate(10, (_) => chars.codeUnitAt(random.nextInt(chars.length))))}';
  }

  // Register new user
  Future<({bool success, String message})> signUp({
    required String name,
    required String email,
    required String password,
    required String phone,
    required String dateOfBirth,
    required String gender,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));

    // Validate input
    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      return (success: false, message: 'Please fill all required fields');
    }

    if (emailExists(email)) {
      return (success: false, message: 'Email already registered. Please login or use a different email.');
    }

    if (password.length < 6) {
      return (success: false, message: 'Password must be at least 6 characters');
    }

    try {
      // Create new user
      User newUser = User(
        id: _generateUserId(),
        name: name,
        email: email,
        password: password,
        phone: phone,
        dateOfBirth: dateOfBirth,
        gender: gender,
        createdAt: DateTime.now(),
      );

      // Add to registered users
      _registeredUsers.add(newUser);

      return (success: true, message: 'Account created successfully!');
    } catch (e) {
      return (success: false, message: 'Error creating account: $e');
    }
  }

  // Login user
  Future<({bool success, String message, User? user})> login({
    required String email,
    required String password,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));

    if (email.isEmpty || password.isEmpty) {
      return (success: false, message: 'Please enter email and password', user: null);
    }

    try {
      // Find user by email
      User? user = _registeredUsers.firstWhere(
        (u) => u.email.toLowerCase() == email.toLowerCase(),
        orElse: () => throw Exception('User not found'),
      );

      // Verify password
      if (user.password != password) {
        return (success: false, message: 'Incorrect password', user: null);
      }

      // Set current user
      _currentUser = user;

      return (success: true, message: 'Login successful!', user: user);
    } catch (e) {
      return (success: false, message: 'Invalid email or password', user: null);
    }
  }

  // Get current logged-in user
  User? getCurrentUser() => _currentUser;

  // Logout user
  void logout() {
    _currentUser = null;
  }

  // Check if user is logged in
  bool isLoggedIn() => _currentUser != null;

  // Update user profile
  Future<({bool success, String message})> updateUserProfile({
    required String name,
    required String phone,
    required String dateOfBirth,
    required String gender,
  }) async {
    if (_currentUser == null) {
      return (success: false, message: 'No user logged in');
    }

    await Future.delayed(const Duration(seconds: 1));

    try {
      int index = _registeredUsers.indexWhere((u) => u.id == _currentUser!.id);
      if (index != -1) {
        _registeredUsers[index] = User(
          id: _currentUser!.id,
          name: name,
          email: _currentUser!.email,
          password: _currentUser!.password,
          phone: phone,
          dateOfBirth: dateOfBirth,
          gender: gender,
          createdAt: _currentUser!.createdAt,
        );
        _currentUser = _registeredUsers[index];
      }
      return (success: true, message: 'Profile updated successfully!');
    } catch (e) {
      return (success: false, message: 'Error updating profile: $e');
    }
  }
}

// Singleton instance
final authService = AuthenticationService();
