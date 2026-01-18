import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'payment_page.dart';
import '../services/firebase_database_service.dart';

class AppointmentFormPage extends StatefulWidget {
  final Map<String, dynamic> doctor;

  const AppointmentFormPage({super.key, required this.doctor});

  @override
  State<AppointmentFormPage> createState() => _AppointmentFormPageState();
}

class _AppointmentFormPageState extends State<AppointmentFormPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final _dbService = FirebaseDatabaseService();
  final _user = FirebaseAuth.instance.currentUser;
  
  DateTime? _selectedDate;
  String? _selectedTimeSlot;

  final List<String> _timeSlots = [
    '09:00 AM', '10:00 AM', '11:00 AM', '12:00 PM',
    '02:00 PM', '03:00 PM', '04:00 PM', '05:00 PM',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 60)),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _selectedTimeSlot = null;
      });
    }
  }

  void _proceedToPayment() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedDate == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select a date')),
        );
        return;
      }
      if (_selectedTimeSlot == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select a time slot')),
        );
        return;
      }

      if (_user == null) return;

      try {
        String appointmentId = await _dbService.saveAppointment(
          patientId: _user.uid,
          doctorId: widget.doctor['id'] ?? widget.doctor['name'] ?? 'unknown',
          appointmentDate: _selectedDate.toString().split(' ')[0],
          timeSlot: _selectedTimeSlot!,
          notes: 'Appointment requested',
          status: 'scheduled',
        );

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Appointment saved!'), backgroundColor: Colors.green),
          );

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PaymentPage(
                appointmentDetails: {
                  'doctorFee': widget.doctor['fee'] ?? 'Rs. 0',
                  'doctorName': widget.doctor['name'] ?? 'Unknown',
                  'specialty': widget.doctor['specialty'] ?? 'General',
                  'hospital': widget.doctor['hospital'] ?? 'Not Specified',
                  'date': _selectedDate.toString().split(' ')[0],
                  'timeSlot': _selectedTimeSlot!,
                  'appointmentId': appointmentId,
                },
              ),
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Appointment'),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Full Name',
                prefixIcon: Icon(Icons.person),
              ),
              validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _phoneController,
              decoration: const InputDecoration(
                labelText: 'Phone',
                prefixIcon: Icon(Icons.phone),
              ),
              validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                prefixIcon: Icon(Icons.email),
              ),
              validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _selectDate,
              child: Text(_selectedDate == null ? 'Select Date' : _selectedDate.toString().split(' ')[0]),
            ),
            const SizedBox(height: 16),
            const Text('Select Time Slot:'),
            Wrap(
              spacing: 8,
              children: _timeSlots.map((slot) {
                return ChoiceChip(
                  label: Text(slot),
                  selected: _selectedTimeSlot == slot,
                  onSelected: (selected) {
                    setState(() => _selectedTimeSlot = selected ? slot : null);
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _proceedToPayment,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: const Color(0xFF4FC3F7),
              ),
              child: const Text('Proceed to Payment', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
