// lib/hospitaladmin/doctors_management_page.dart
import 'package:flutter/material.dart';
import 'add_doctor_page.dart';
import 'doctor_details_page.dart';

class DoctorsManagementPage extends StatefulWidget {
  const DoctorsManagementPage({super.key});

  @override
  State<DoctorsManagementPage> createState() => _DoctorsManagementPageState();
}

class _DoctorsManagementPageState extends State<DoctorsManagementPage> {
  String _selectedDepartment = 'All';
  String _searchQuery = '';

  final List<Map<String, dynamic>> _doctors = [
    {
      'id': '1',
      'name': 'Dr. Sarah Johnson',
      'specialty': 'Cardiology',
      'department': 'Cardiology',
      'phone': '+1 234-567-8900',
      'email': 'sarah.j@hospital.com',
      'experience': '15 years',
      'patients': 234,
      'rating': 4.8,
      'status': 'Available',
      'schedule': ['Mon', 'Tue', 'Wed', 'Fri'],
      'qualifications': 'MD, FACC',
      'joinDate': 'Jan 2020',
    },
    {
      'id': '2',
      'name': 'Dr. Michael Chen',
      'specialty': 'Neurology',
      'department': 'Neurology',
      'phone': '+1 234-567-8901',
      'email': 'michael.c@hospital.com',
      'experience': '12 years',
      'patients': 189,
      'rating': 4.9,
      'status': 'Busy',
      'schedule': ['Mon', 'Wed', 'Thu', 'Fri'],
      'qualifications': 'MD, PhD',
      'joinDate': 'Mar 2021',
    },
    {
      'id': '3',
      'name': 'Dr. Emily Davis',
      'specialty': 'Pediatrics',
      'department': 'Pediatrics',
      'phone': '+1 234-567-8902',
      'email': 'emily.d@hospital.com',
      'experience': '10 years',
      'patients': 312,
      'rating': 4.7,
      'status': 'Available',
      'schedule': ['Tue', 'Wed', 'Thu', 'Sat'],
      'qualifications': 'MD, FAAP',
      'joinDate': 'Jun 2022',
    },
    {
      'id': '4',
      'name': 'Dr. Robert Wilson',
      'specialty': 'Orthopedics',
      'department': 'Orthopedics',
      'phone': '+1 234-567-8903',
      'email': 'robert.w@hospital.com',
      'experience': '18 years',
      'patients': 267,
      'rating': 4.6,
      'status': 'On Leave',
      'schedule': ['Mon', 'Tue', 'Thu', 'Fri'],
      'qualifications': 'MD, FAAOS',
      'joinDate': 'Aug 2019',
    },
  ];

  List<Map<String, dynamic>> get _filteredDoctors {
    return _doctors.where((doctor) {
      final matchesDept = _selectedDepartment == 'All' || doctor['department'] == _selectedDepartment;
      final matchesSearch = doctor['name'].toLowerCase().contains(_searchQuery.toLowerCase()) ||
          doctor['specialty'].toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesDept && matchesSearch;
    }).toList();
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
            child: Column(
              children: [
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Search doctors...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                    filled: true,
                    fillColor: Colors.grey[100],
                  ),
                  onChanged: (value) => setState(() => _searchQuery = value),
                ),
                const SizedBox(height: 16),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildFilterChip('All'),
                      const SizedBox(width: 8),
                      _buildFilterChip('Cardiology'),
                      const SizedBox(width: 8),
                      _buildFilterChip('Neurology'),
                      const SizedBox(width: 8),
                      _buildFilterChip('Pediatrics'),
                      const SizedBox(width: 8),
                      _buildFilterChip('Orthopedics'),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _filteredDoctors.length,
              itemBuilder: (context, index) => _buildDoctorCard(_filteredDoctors[index]),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const AddDoctorPage()));
        },
        backgroundColor: const Color(0xFF4FC3F7),
        icon: const Icon(Icons.add),
        label: const Text('Add Doctor'),
      ),
    );
  }

  Widget _buildFilterChip(String label) {
    final isSelected = _selectedDepartment == label;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) => setState(() => _selectedDepartment = label),
      selectedColor: const Color(0xFF4FC3F7),
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : Colors.black87,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }

  Widget _buildDoctorCard(Map<String, dynamic> doctor) {
    Color statusColor;
    switch (doctor['status']) {
      case 'Available': statusColor = Colors.green; break;
      case 'Busy': statusColor = Colors.orange; break;
      default: statusColor = Colors.red;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        children: [
          ListTile(
            contentPadding: const EdgeInsets.all(16),
            leading: CircleAvatar(
              radius: 30,
              backgroundColor: const Color(0xFF4FC3F7),
              child: Text(
                doctor['name'].split(' ')[1][0],
                style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            title: Text(doctor['name'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.medical_services, size: 14, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Text(doctor['specialty'], style: TextStyle(fontSize: 13, color: Colors.grey[600])),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.star, size: 14, color: Colors.amber),
                    const SizedBox(width: 4),
                    Text('${doctor['rating']} • ${doctor['patients']} patients', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                  ],
                ),
              ],
            ),
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(color: statusColor.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
              child: Text(doctor['status'], style: TextStyle(color: statusColor, fontWeight: FontWeight.bold, fontSize: 11)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Icon(Icons.phone, size: 14, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text(doctor['phone'], style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                const Spacer(),
                Icon(Icons.email, size: 14, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Expanded(child: Text(doctor['email'], style: TextStyle(fontSize: 12, color: Colors.grey[600]), overflow: TextOverflow.ellipsis)),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => DoctorDetailsPage(doctor: doctor)));
                    },
                    icon: const Icon(Icons.visibility),
                    label: const Text('View Details'),
                    style: OutlinedButton.styleFrom(foregroundColor: const Color(0xFF4FC3F7), side: const BorderSide(color: Color(0xFF4FC3F7))),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.edit),
                    label: const Text('Edit'),
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF4FC3F7), foregroundColor: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}