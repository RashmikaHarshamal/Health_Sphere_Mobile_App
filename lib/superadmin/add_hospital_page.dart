// lib/superadmin/add_hospital_page.dart
import 'package:flutter/material.dart';

class AddHospitalPage extends StatefulWidget {
  const AddHospitalPage({Key? key}) : super(key: key);

  @override
  State<AddHospitalPage> createState() => _AddHospitalPageState();
}

class _AddHospitalPageState extends State<AddHospitalPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _bedsController = TextEditingController();
  final _adminNameController = TextEditingController();
  final _adminEmailController = TextEditingController();
  final _adminPhoneController = TextEditingController();
  
  final List<String> _selectedDepartments = [];
  final List<String> _availableDepartments = [
    'Cardiology',
    'Neurology',
    'Pediatrics',
    'Orthopedics',
    'Emergency',
    'Surgery',
    'Radiology',
    'Oncology',
    'General Medicine',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: const Text('Add New Hospital', style: TextStyle(color: Colors.black87)),
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildSection('Hospital Information', [
              _buildTextField('Hospital Name', _nameController, Icons.local_hospital),
              const SizedBox(height: 16),
              _buildTextField('Address', _addressController, Icons.location_on, maxLines: 2),
              const SizedBox(height: 16),
              _buildTextField('Phone', _phoneController, Icons.phone),
              const SizedBox(height: 16),
              _buildTextField('Email', _emailController, Icons.email),
              const SizedBox(height: 16),
              _buildTextField('Number of Beds', _bedsController, Icons.hotel, isNumber: true),
            ]),
            const SizedBox(height: 24),
            _buildSection('Administrator Information', [
              _buildTextField('Admin Name', _adminNameController, Icons.person),
              const SizedBox(height: 16),
              _buildTextField('Admin Email', _adminEmailController, Icons.email),
              const SizedBox(height: 16),
              _buildTextField('Admin Phone', _adminPhoneController, Icons.phone),
            ]),
            const SizedBox(height: 24),
            _buildSection('Departments', [
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _availableDepartments.map((dept) {
                  final isSelected = _selectedDepartments.contains(dept);
                  return FilterChip(
                    label: Text(dept),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          _selectedDepartments.add(dept);
                        } else {
                          _selectedDepartments.remove(dept);
                        }
                      });
                    },
                    selectedColor: const Color(0xFF4FC3F7),
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : Colors.black87,
                    ),
                  );
                }).toList(),
              ),
            ]),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _submitForm,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4FC3F7),
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 55),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Add Hospital', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(20),
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
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller,
    IconData icon, {
    int maxLines = 1,
    bool isNumber = false,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: const Color(0xFF4FC3F7)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF4FC3F7), width: 2),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter $label';
        }
        return null;
      },
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      if (_selectedDepartments.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select at least one department')),
        );
        return;
      }

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Success'),
          content: Text('Hospital "${_nameController.text}" has been added successfully!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _bedsController.dispose();
    _adminNameController.dispose();
    _adminEmailController.dispose();
    _adminPhoneController.dispose();
    super.dispose();
  }
}