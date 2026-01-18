import 'package:flutter/material.dart';
import '../services/authentication_service.dart';
import '../models/user_model.dart';
import 'login_page.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key});

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  late User? _currentUser;
  final bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  void _loadUserProfile() {
    _currentUser = authService.getCurrentUser();
    if (_currentUser == null) {
      // If no user is logged in, navigate back to login
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    }
  }

  void _handleLogout() {
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

  void _handleUpdateProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditUserProfilePage(user: _currentUser!),
      ),
    ).then((updatedUser) {
      if (updatedUser != null) {
        setState(() {
          _currentUser = updatedUser;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_currentUser == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        backgroundColor: const Color(0xFF4FC3F7),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _handleLogout,
            tooltip: 'Logout',
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile Header
            Container(
              color: const Color(0xFF4FC3F7),
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.person,
                      size: 60,
                      color: Colors.grey[400],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _currentUser!.name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _currentUser!.email,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Profile Information
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  // User ID
                  _buildProfileCard(
                    icon: Icons.badge,
                    label: 'User ID',
                    value: _currentUser!.id,
                  ),
                  const SizedBox(height: 12),

                  // Email
                  _buildProfileCard(
                    icon: Icons.email,
                    label: 'Email',
                    value: _currentUser!.email,
                  ),
                  const SizedBox(height: 12),

                  // Phone
                  _buildProfileCard(
                    icon: Icons.phone,
                    label: 'Phone',
                    value: _currentUser!.phone,
                  ),
                  const SizedBox(height: 12),

                  // Date of Birth
                  _buildProfileCard(
                    icon: Icons.cake,
                    label: 'Date of Birth',
                    value: _currentUser!.dateOfBirth,
                  ),
                  const SizedBox(height: 12),

                  // Gender
                  _buildProfileCard(
                    icon: Icons.wc,
                    label: 'Gender',
                    value: _currentUser!.gender,
                  ),
                  const SizedBox(height: 12),

                  // Member Since
                  _buildProfileCard(
                    icon: Icons.calendar_today,
                    label: 'Member Since',
                    value: _currentUser!.createdAt.toString().split(' ')[0],
                  ),
                  const SizedBox(height: 32),

                  // Edit Profile Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _handleUpdateProfile,
                      icon: const Icon(Icons.edit),
                      label: const Text('Edit Profile'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4FC3F7),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileCard({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF4FC3F7), size: 24),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Edit Profile Page
class EditUserProfilePage extends StatefulWidget {
  final User user;

  const EditUserProfilePage({super.key, required this.user});

  @override
  State<EditUserProfilePage> createState() => _EditUserProfilePageState();
}

class _EditUserProfilePageState extends State<EditUserProfilePage> {
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  String? _selectedGender;
  String? _selectedDateOfBirth;
  bool _isLoading = false;

  final List<String> _genderOptions = ['Male', 'Female', 'Other'];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user.name);
    _phoneController = TextEditingController(text: widget.user.phone);
    _selectedGender = widget.user.gender;
    _selectedDateOfBirth = widget.user.dateOfBirth;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _selectedDateOfBirth = '${picked.day}/${picked.month}/${picked.year}';
      });
    }
  }

  void _handleUpdateProfile() async {
    setState(() => _isLoading = true);

    final result = await authService.updateUserProfile(
      name: _nameController.text,
      phone: _phoneController.text,
      dateOfBirth: _selectedDateOfBirth!,
      gender: _selectedGender!,
    );

    setState(() => _isLoading = false);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result.message),
          backgroundColor: result.success ? Colors.green : Colors.red,
        ),
      );

      if (result.success) {
        Navigator.pop(context, authService.getCurrentUser());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        backgroundColor: const Color(0xFF4FC3F7),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Name Field
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Full Name',
                hintText: 'Enter your full name',
                prefixIcon: Icon(Icons.person_outline, color: Color(0xFF4FC3F7)),
              ),
            ),
            const SizedBox(height: 20),

            // Phone Field
            TextFormField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: 'Phone Number',
                hintText: 'Enter your phone number',
                prefixIcon: Icon(Icons.phone_outlined, color: Color(0xFF4FC3F7)),
              ),
            ),
            const SizedBox(height: 20),

            // Gender Dropdown
            DropdownButtonFormField<String>(
              initialValue: _selectedGender,
              decoration: const InputDecoration(
                labelText: 'Gender',
                hintText: 'Select your gender',
                prefixIcon: Icon(Icons.wc, color: Color(0xFF4FC3F7)),
              ),
              items: _genderOptions.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() => _selectedGender = newValue);
              },
            ),
            const SizedBox(height: 20),

            // Date of Birth Field
            TextFormField(
              controller: TextEditingController(text: _selectedDateOfBirth),
              readOnly: true,
              decoration: InputDecoration(
                labelText: 'Date of Birth',
                hintText: 'Select your date of birth',
                prefixIcon: const Icon(Icons.calendar_today, color: Color(0xFF4FC3F7)),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.calendar_today, color: Color(0xFF4FC3F7)),
                  onPressed: () => _selectDate(context),
                ),
              ),
              onTap: () => _selectDate(context),
            ),
            const SizedBox(height: 32),

            // Save Button
            ElevatedButton(
              onPressed: _isLoading ? null : _handleUpdateProfile,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4FC3F7),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: _isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : const Text(
                      'Save Changes',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
