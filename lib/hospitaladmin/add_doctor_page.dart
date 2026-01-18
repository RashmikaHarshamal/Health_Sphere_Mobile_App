// lib/hospitaladmin/add_doctor_page.dart
import 'package:flutter/material.dart';

class AddDoctorPage extends StatefulWidget {
  const AddDoctorPage({super.key});

  @override
  State<AddDoctorPage> createState() => _AddDoctorPageState();
}

class _AddDoctorPageState extends State<AddDoctorPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _specialtyController = TextEditingController();
  final _qualificationsController = TextEditingController();
  final _experienceController = TextEditingController();
  
  String? _selectedDepartment;
  final List<String> _selectedSchedule = [];

  final List<String> _departments = ['Cardiology', 'Neurology', 'Pediatrics', 'Orthopedics', 'Emergency', 'Surgery'];
  final List<String> _days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: const Text('Add New Doctor', style: TextStyle(color: Colors.black87)),
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildSection('Personal Information', [
              _buildTextField('Full Name', _nameController, Icons.person),
              const SizedBox(height: 16),
              _buildTextField('Email', _emailController, Icons.email),
              const SizedBox(height: 16),
              _buildTextField('Phone', _phoneController, Icons.phone),
            ]),
            const SizedBox(height: 20),
            _buildSection('Professional Information', [
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Department', prefixIcon: Icon(Icons.domain)),
                initialValue: _selectedDepartment,
                items: _departments.map((dept) => DropdownMenuItem(value: dept, child: Text(dept))).toList(),
                onChanged: (value) => setState(() => _selectedDepartment = value),
                validator: (value) => value == null ? 'Please select a department' : null,
              ),
              const SizedBox(height: 16),
              _buildTextField('Specialty', _specialtyController, Icons.medical_services),
              const SizedBox(height: 16),
              _buildTextField('Qualifications', _qualificationsController, Icons.school),
              const SizedBox(height: 16),
              _buildTextField('Years of Experience', _experienceController, Icons.work, isNumber: true),
            ]),
            const SizedBox(height: 20),
            _buildSection('Working Schedule', [
              const Text('Select working days:', style: TextStyle(fontWeight: FontWeight.w500)),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _days.map((day) {
                  final isSelected = _selectedSchedule.contains(day);
                  return FilterChip(
                    label: Text(day),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          _selectedSchedule.add(day);
                        } else {
                          _selectedSchedule.remove(day);
                        }
                      });
                    },
                    selectedColor: const Color(0xFF4FC3F7),
                    labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.black87),
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
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Add Doctor', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        ...children,
      ]),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, IconData icon, {bool isNumber = false}) {
    return TextFormField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: const Color(0xFF4FC3F7)),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF4FC3F7), width: 2)),
      ),
      validator: (value) => value == null || value.isEmpty ? 'Please enter $label' : null,
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate() && _selectedSchedule.isNotEmpty) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Success'),
          content: Text('Dr. ${_nameController.text} has been added successfully!'),
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
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please complete all fields')));
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _specialtyController.dispose();
    _qualificationsController.dispose();
    _experienceController.dispose();
    super.dispose();
  }
}

// lib/hospitaladmin/appointments_management_page.dart
class AppointmentsManagementPage extends StatefulWidget {
  const AppointmentsManagementPage({super.key});

  @override
  State<AppointmentsManagementPage> createState() => _AppointmentsManagementPageState();
}

class _AppointmentsManagementPageState extends State<AppointmentsManagementPage> {
  String _selectedFilter = 'All';

  final List<Map<String, dynamic>> _appointments = [
    {'patient': 'John Doe', 'doctor': 'Dr. Sarah Johnson', 'department': 'Cardiology', 'date': 'Jan 18, 2026', 'time': '10:00 AM', 'status': 'Confirmed'},
    {'patient': 'Jane Smith', 'doctor': 'Dr. Michael Chen', 'department': 'Neurology', 'date': 'Jan 18, 2026', 'time': '11:30 AM', 'status': 'Pending'},
    {'patient': 'Bob Wilson', 'doctor': 'Dr. Emily Davis', 'department': 'Pediatrics', 'date': 'Jan 18, 2026', 'time': '2:00 PM', 'status': 'Completed'},
    {'patient': 'Alice Brown', 'doctor': 'Dr. Robert Wilson', 'department': 'Orthopedics', 'date': 'Jan 19, 2026', 'time': '9:00 AM', 'status': 'Confirmed'},
  ];

  List<Map<String, dynamic>> get _filteredAppointments {
    return _appointments.where((apt) => _selectedFilter == 'All' || apt['status'] == _selectedFilter).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: Row(
              children: [
                _buildFilterChip('All'),
                const SizedBox(width: 8),
                _buildFilterChip('Pending'),
                const SizedBox(width: 8),
                _buildFilterChip('Confirmed'),
                const SizedBox(width: 8),
                _buildFilterChip('Completed'),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _filteredAppointments.length,
              itemBuilder: (context, index) => _buildAppointmentCard(_filteredAppointments[index]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label) {
    final isSelected = _selectedFilter == label;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) => setState(() => _selectedFilter = label),
      selectedColor: const Color(0xFF4FC3F7),
      labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.black87, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal),
    );
  }

  Widget _buildAppointmentCard(Map<String, dynamic> appointment) {
    Color statusColor = appointment['status'] == 'Confirmed' ? Colors.green : appointment['status'] == 'Pending' ? Colors.orange : Colors.blue;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: const Color(0xFF4FC3F7).withOpacity(0.2),
                child: const Icon(Icons.person, color: Color(0xFF4FC3F7)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(appointment['patient'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    Text('${appointment['doctor']} • ${appointment['department']}', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(color: statusColor.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
                child: Text(appointment['status'], style: TextStyle(color: statusColor, fontWeight: FontWeight.bold, fontSize: 11)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.calendar_today, size: 14, color: Colors.grey[600]),
              const SizedBox(width: 4),
              Text(appointment['date'], style: TextStyle(fontSize: 13, color: Colors.grey[600])),
              const SizedBox(width: 16),
              Icon(Icons.access_time, size: 14, color: Colors.grey[600]),
              const SizedBox(width: 4),
              Text(appointment['time'], style: TextStyle(fontSize: 13, color: Colors.grey[600])),
            ],
          ),
        ],
      ),
    );
  }
}