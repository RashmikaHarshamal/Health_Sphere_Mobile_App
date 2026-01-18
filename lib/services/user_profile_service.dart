import '../models/user_model.dart';
import 'authentication_service.dart';

class UserProfileService {
  // Get current user profile
  User? getCurrentUserProfile() {
    return authService.getCurrentUser();
  }

  // Get all users (admin feature)
  List<User> getAllUsersProfile() {
    return authService.getAllUsers();
  }

  // Check if user exists by email
  bool userExistsByEmail(String email) {
    return authService.emailExists(email);
  }

  // Get user by ID (for admin/profile lookup)
  User? getUserById(String userId) {
    try {
      final users = authService.getAllUsers();
      return users.firstWhere((user) => user.id == userId);
    } catch (e) {
      return null;
    }
  }

  // Search users by name (admin feature)
  List<User> searchUsersByName(String searchTerm) {
    final users = authService.getAllUsers();
    return users
        .where((user) => user.name.toLowerCase().contains(searchTerm.toLowerCase()))
        .toList();
  }

  // Get user registration count
  int getTotalUsersCount() {
    return authService.getAllUsers().length;
  }
}

// Singleton instance
final userProfileService = UserProfileService();
