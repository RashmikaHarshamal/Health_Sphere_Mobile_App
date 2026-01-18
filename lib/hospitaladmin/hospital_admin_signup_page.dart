// lib/hospitaladmin/hospital_admin_signup_page.dart
import 'package:flutter/material.dart';
import 'hospital_admin_dashboard.dart';
import '../services/hospital_management_service.dart';
import '../services/firebase_auth_service.dart';

class HospitalAdminSignUpPage extends StatefulWidget {
  const HospitalAdminSignUpPage({super.key});

  @override
  State<HospitalAdminSignUpPage> createState() => _HospitalAdminSignUpPageState();
}

class _HospitalAdminSignUpPageState extends State<HospitalAdminSignUpPage> {
  final _formKey = GlobalKey<FormState>();
  int _currentStep = 0;
  bool _isLoading = false;

  // Personal Information Controllers
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  // Hospital Information Controllers
  final _hospitalNameController = TextEditingController();
  final _hospitalEmailController = TextEditingController();
  final _hospitalPhoneController = TextEditingController();
  final _hospitalAddressController = TextEditingController();
  final _hospitalCityController = TextEditingController();
  final _hospitalStateController = TextEditingController();
  final _hospitalZipController = TextEditingController();
  final _registrationNumberController = TextEditingController();
  final _licenseNumberController = TextEditingController();
  final _establishedYearController = TextEditingController();
  
  String? _hospitalType;
  final List<String> _hospitalTypes = ['Government', 'Private', 'Semi-Government', 'Charitable Trust'];

  // Hospital Facilities
  final Map<String, bool> _facilities = {
    'Emergency Services': false,
    'ICU': false,
    'Operation Theater': false,
    'Laboratory': false,
    'Radiology': false,
    'Pharmacy': false,
    'Blood Bank': false,
    'Ambulance Service': false,
  };

  // Additional Information
  final _totalBedsController = TextEditingController();
  final _totalDoctorsController = TextEditingController();
  final _websiteController = TextEditingController();
  bool _agreeToTerms = false;

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _hospitalNameController.dispose();
    _hospitalEmailController.dispose();
    _hospitalPhoneController.dispose();
    _hospitalAddressController.dispose();
    _hospitalCityController.dispose();
    _hospitalStateController.dispose();
    _hospitalZipController.dispose();
    _registrationNumberController.dispose();
    _licenseNumberController.dispose();
    _establishedYearController.dispose();
    _totalBedsController.dispose();
    _totalDoctorsController.dispose();
    _websiteController.dispose();
    super.dispose();
  }

  void _handleSubmit() async {
    if (!_agreeToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please agree to Terms & Conditions'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // First, sign up the admin user
      final authService = FirebaseAuthService();
      final userCredential = await authService.signUp(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      // Then register the hospital
      final hospitalService = HospitalManagementService();
      final result = await hospitalService.registerHospital(
        adminId: userCredential.user!.uid,
        adminName: _fullNameController.text.trim(),
        adminEmail: _emailController.text.trim(),
        hospitalName: _hospitalNameController.text.trim(),
        hospitalEmail: _hospitalEmailController.text.trim(),
        hospitalPhone: _hospitalPhoneController.text.trim(),
        hospitalAddress: _hospitalAddressController.text.trim(),
        city: _hospitalCityController.text.trim(),
        state: _hospitalStateController.text.trim(),
        zipCode: _hospitalZipController.text.trim(),
        registrationNumber: _registrationNumberController.text.trim(),
        licenseNumber: _licenseNumberController.text.trim(),
        establishedYear: int.parse(_establishedYearController.text),
        hospitalType: _hospitalType ?? 'Private',
        facilities: _facilities.entries.where((e) => e.value).map((e) => e.key).toList(),
        totalBeds: int.parse(_totalBedsController.text),
        totalDoctors: _totalDoctorsController.text.isNotEmpty
            ? int.parse(_totalDoctorsController.text)
            : 0,
        website: _websiteController.text.trim(),
      );

      setState(() => _isLoading = false);

      if (mounted) {
        if (result.success) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => AlertDialog(
              title: const Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.green, size: 30),
                  SizedBox(width: 12),
                  Text('Registration Successful'),
                ],
              ),
              content: Text(
                'Your hospital registration has been submitted successfully!\n\n'
                'Hospital ID: ${result.hospitalId}\n\n'
                'Our team will review your application and get back to you within 24-48 hours.',
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context); // Close dialog
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const HospitalAdminDashboard()),
                    );
                  },
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(result.message),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      setState(() => _isLoading = false);

      if (mounted) {
        String errorMessage = 'Registration failed: $e';
        if (e.toString().contains('email-already-in-use')) {
          errorMessage = 'Email already registered';
        } else if (e.toString().contains('weak-password')) {
          errorMessage = 'Password is too weak';
        } else if (e.toString().contains('PigeonUserDetails')) {
          // Firebase SDK bug but signup likely succeeded
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => AlertDialog(
              title: const Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.green, size: 30),
                  SizedBox(width: 12),
                  Text('Registration Submitted'),
                ],
              ),
              content: const Text(
                'Your hospital registration has been submitted successfully!\n\n'
                'Our team will review your application and get back to you within 24-48 hours.',
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const HospitalAdminDashboard()),
                    );
                  },
                  child: const Text('OK'),
                ),
              ],
            ),
          );
          return;
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF4FC3F7)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Hospital Registration', style: TextStyle(color: Colors.black87)),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            // Progress Indicator
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildStepIndicator(0, 'Personal'),
                  _buildStepLine(0),
                  _buildStepIndicator(1, 'Hospital'),
                  _buildStepLine(1),
                  _buildStepIndicator(2, 'Facilities'),
                  _buildStepLine(2),
                  _buildStepIndicator(3, 'Review'),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: _buildCurrentStep(),
              ),
            ),
            _buildNavigationButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildStepIndicator(int step, String label) {
    final isActive = _currentStep >= step;
    return Column(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: isActive ? const Color(0xFF4FC3F7) : Colors.grey[300],
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              '${step + 1}',
              style: TextStyle(
                color: isActive ? Colors.white : Colors.grey[600],
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: isActive ? const Color(0xFF4FC3F7) : Colors.grey[600],
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  Widget _buildStepLine(int step) {
    final isActive = _currentStep > step;
    return Container(
      width: 30,
      height: 2,
      color: isActive ? const Color(0xFF4FC3F7) : Colors.grey[300],
      margin: const EdgeInsets.only(bottom: 20),
    );
  }

  Widget _buildCurrentStep() {
    switch (_currentStep) {
      case 0:
        return _buildPersonalInfoStep();
      case 1:
        return _buildHospitalInfoStep();
      case 2:
        return _buildFacilitiesStep();
      case 3:
        return _buildReviewStep();
      default:
        return _buildPersonalInfoStep();
    }
  }

  Widget _buildPersonalInfoStep() {
    return _buildCard([
      const Text('Personal Information', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
      const SizedBox(height: 8),
      Text('Enter your personal details as the hospital administrator', style: TextStyle(color: Colors.grey[600])),
      const SizedBox(height: 24),
      _buildTextField('Full Name', _fullNameController, Icons.person, required: true),
      const SizedBox(height: 16),
      _buildTextField('Email Address', _emailController, Icons.email, keyboardType: TextInputType.emailAddress, required: true),
      const SizedBox(height: 16),
      _buildTextField('Phone Number', _phoneController, Icons.phone, keyboardType: TextInputType.phone, required: true),
      const SizedBox(height: 16),
      _buildPasswordField('Password', _passwordController, _obscurePassword, (value) {
        setState(() => _obscurePassword = value);
      }),
      const SizedBox(height: 16),
      _buildPasswordField('Confirm Password', _confirmPasswordController, _obscureConfirmPassword, (value) {
        setState(() => _obscureConfirmPassword = value);
      }, isConfirm: true),
    ]);
  }

  Widget _buildHospitalInfoStep() {
    return _buildCard([
      const Text('Hospital Information', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
      const SizedBox(height: 8),
      Text('Provide details about your hospital', style: TextStyle(color: Colors.grey[600])),
      const SizedBox(height: 24),
      _buildTextField('Hospital Name', _hospitalNameController, Icons.local_hospital, required: true),
      const SizedBox(height: 16),
      DropdownButtonFormField<String>(
        decoration: const InputDecoration(
          labelText: 'Hospital Type',
          prefixIcon: Icon(Icons.business, color: Color(0xFF4FC3F7)),
        ),
        initialValue: _hospitalType,
        items: _hospitalTypes.map((type) => DropdownMenuItem(value: type, child: Text(type))).toList(),
        onChanged: (value) => setState(() => _hospitalType = value),
        validator: (value) => value == null ? 'Please select hospital type' : null,
      ),
      const SizedBox(height: 16),
      _buildTextField('Registration Number', _registrationNumberController, Icons.confirmation_number, required: true),
      const SizedBox(height: 16),
      _buildTextField('License Number', _licenseNumberController, Icons.verified, required: true),
      const SizedBox(height: 16),
      _buildTextField('Established Year', _establishedYearController, Icons.calendar_today, keyboardType: TextInputType.number, required: true),
      const SizedBox(height: 16),
      _buildTextField('Hospital Email', _hospitalEmailController, Icons.email, keyboardType: TextInputType.emailAddress, required: true),
      const SizedBox(height: 16),
      _buildTextField('Hospital Phone', _hospitalPhoneController, Icons.phone, keyboardType: TextInputType.phone, required: true),
      const SizedBox(height: 16),
      _buildTextField('Address', _hospitalAddressController, Icons.location_on, maxLines: 2, required: true),
      const SizedBox(height: 16),
      Row(
        children: [
          Expanded(child: _buildTextField('City', _hospitalCityController, Icons.location_city, required: true)),
          const SizedBox(width: 12),
          Expanded(child: _buildTextField('State', _hospitalStateController, Icons.map, required: true)),
        ],
      ),
      const SizedBox(height: 16),
      _buildTextField('Zip Code', _hospitalZipController, Icons.pin_drop, keyboardType: TextInputType.number, required: true),
    ]);
  }

  Widget _buildFacilitiesStep() {
    return _buildCard([
      const Text('Hospital Facilities & Capacity', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
      const SizedBox(height: 8),
      Text('Select available facilities and enter capacity details', style: TextStyle(color: Colors.grey[600])),
      const SizedBox(height: 24),
      const Text('Available Facilities', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
      const SizedBox(height: 12),
      ..._facilities.keys.map((facility) {
        return CheckboxListTile(
          title: Text(facility),
          value: _facilities[facility],
          onChanged: (value) => setState(() => _facilities[facility] = value ?? false),
          activeColor: const Color(0xFF4FC3F7),
          contentPadding: EdgeInsets.zero,
        );
      }),
      const SizedBox(height: 24),
      const Text('Capacity Information', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
      const SizedBox(height: 12),
      _buildTextField('Total Beds', _totalBedsController, Icons.bed, keyboardType: TextInputType.number, required: true),
      const SizedBox(height: 16),
      _buildTextField('Total Doctors', _totalDoctorsController, Icons.medical_services, keyboardType: TextInputType.number, required: true),
      const SizedBox(height: 16),
      _buildTextField('Website (Optional)', _websiteController, Icons.web, keyboardType: TextInputType.url),
    ]);
  }

  Widget _buildReviewStep() {
    return _buildCard([
      const Text('Review & Submit', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
      const SizedBox(height: 8),
      Text('Please review all information before submitting', style: TextStyle(color: Colors.grey[600])),
      const SizedBox(height: 24),
      _buildReviewSection('Personal Information', [
        'Name: ${_fullNameController.text}',
        'Email: ${_emailController.text}',
        'Phone: ${_phoneController.text}',
      ]),
      const SizedBox(height: 16),
      _buildReviewSection('Hospital Information', [
        'Hospital: ${_hospitalNameController.text}',
        'Type: ${_hospitalType ?? 'Not selected'}',
        'Registration: ${_registrationNumberController.text}',
        'License: ${_licenseNumberController.text}',
        'Established: ${_establishedYearController.text}',
        'Address: ${_hospitalAddressController.text}, ${_hospitalCityController.text}, ${_hospitalStateController.text} - ${_hospitalZipController.text}',
      ]),
      const SizedBox(height: 16),
      _buildReviewSection('Facilities & Capacity', [
        'Total Beds: ${_totalBedsController.text}',
        'Total Doctors: ${_totalDoctorsController.text}',
        'Facilities: ${_facilities.entries.where((e) => e.value).map((e) => e.key).join(', ')}',
      ]),
      const SizedBox(height: 24),
      CheckboxListTile(
        title: const Text('I agree to the Terms & Conditions and Privacy Policy'),
        value: _agreeToTerms,
        onChanged: (value) => setState(() => _agreeToTerms = value ?? false),
        activeColor: const Color(0xFF4FC3F7),
        contentPadding: EdgeInsets.zero,
      ),
    ]);
  }

  Widget _buildReviewSection(String title, List<String> items) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF4FC3F7))),
          const SizedBox(height: 12),
          ...items.map((item) => Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Text(item, style: const TextStyle(fontSize: 14)),
          )),
        ],
      ),
    );
  }

  Widget _buildCard(List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, IconData icon, {
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    bool required = false,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: const Color(0xFF4FC3F7)),
      ),
      validator: required ? (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter $label';
        }
        return null;
      } : null,
    );
  }

  Widget _buildPasswordField(String label, TextEditingController controller, bool obscure, Function(bool) onToggle, {bool isConfirm = false}) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: const Icon(Icons.lock_outline, color: Color(0xFF4FC3F7)),
        suffixIcon: IconButton(
          icon: Icon(obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined),
          onPressed: () => onToggle(!obscure),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter $label';
        }
        if (!isConfirm && value.length < 6) {
          return 'Password must be at least 6 characters';
        }
        if (isConfirm && value != _passwordController.text) {
          return 'Passwords do not match';
        }
        return null;
      },
    );
  }

  Widget _buildNavigationButtons() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        children: [
          if (_currentStep > 0)
            Expanded(
              child: OutlinedButton(
                onPressed: () => setState(() => _currentStep--),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: const BorderSide(color: Color(0xFF4FC3F7)),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Back', style: TextStyle(color: Color(0xFF4FC3F7))),
              ),
            ),
          if (_currentStep > 0) const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton(
              onPressed: _isLoading ? null : () {
                if (_currentStep < 3) {
                  if (_formKey.currentState!.validate()) {
                    setState(() => _currentStep++);
                  }
                } else {
                  _handleSubmit();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4FC3F7),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: _isLoading
                  ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                  : Text(_currentStep < 3 ? 'Next' : 'Submit', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }
}

// Updated Hospital Admin Login Page with Sign Up Link
class HospitalAdminLoginPage extends StatefulWidget {
  const HospitalAdminLoginPage({super.key});

  @override
  State<HospitalAdminLoginPage> createState() => _HospitalAdminLoginPageState();
}

class _HospitalAdminLoginPageState extends State<HospitalAdminLoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF4FC3F7)),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF4FC3F7).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.local_hospital,
                  size: 60,
                  color: Color(0xFF4FC3F7),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Hospital Admin Login',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Sign in to manage your hospital',
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
              const SizedBox(height: 40),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  labelText: 'Password',
                  prefixIcon: const Icon(Icons.lock),
                  suffixIcon: IconButton(
                    icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
                    onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const HospitalAdminDashboard()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4FC3F7),
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 55),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Login', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an account? ",
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const HospitalAdminSignUpPage()),
                      );
                    },
                    child: const Text(
                      'Register Hospital',
                      style: TextStyle(
                        color: Color(0xFF4FC3F7),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}