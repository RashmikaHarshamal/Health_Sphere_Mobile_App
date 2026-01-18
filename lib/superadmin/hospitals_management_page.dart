// lib/superadmin/hospitals_management_page.dart
import 'package:flutter/material.dart';
import 'hospital_details_page.dart';
import 'add_hospital_page.dart';

class HospitalsManagementPage extends StatefulWidget {
  const HospitalsManagementPage({Key? key}) : super(key: key);

  @override
  State<HospitalsManagementPage> createState() => _HospitalsManagementPageState();
}

class _HospitalsManagementPageState extends State<HospitalsManagementPage> {
  String _selectedFilter = 'All';
  String _searchQuery = '';

  final List<Map<String, dynamic>> _hospitals = [
    {
      'id': '1',
      'name': 'City General Hospital',
      'address': '123 Main St, New York, NY',
      'phone': '+1 234-567-8900',
      'email': 'info@citygen.com',
      'status': 'Active',
      'doctors': 45,
      'patients': 2340,
      'joinDate': 'Jan 15, 2025',
      'admin': 'Dr. John Smith',
      'adminEmail': 'john.smith@citygen.com',
      'adminPhone': '+1 234-567-8901',
      'beds': 250,
      'departments': ['Cardiology', 'Neurology', 'Pediatrics'],
    },
    {
      'id': '2',
      'name': 'Metro Medical Center',
      'address': '456 Oak Ave, Los Angeles, CA',
      'phone': '+1 234-567-8902',
      'email': 'contact@metromedical.com',
      'status': 'Active',
      'doctors': 38,
      'patients': 1890,
      'joinDate': 'Jan 10, 2025',
      'admin': 'Dr. Sarah Johnson',
      'adminEmail': 'sarah.j@metromedical.com',
      'adminPhone': '+1 234-567-8903',
      'beds': 180,
      'departments': ['Emergency', 'Surgery', 'Orthopedics'],
    },
    {
      'id': '3',
      'name': 'Sunrise Clinic',
      'address': '789 Pine Rd, Chicago, IL',
      'phone': '+1 234-567-8904',
      'email': 'hello@sunriseclinic.com',
      'status': 'Pending',
      'doctors': 12,
      'patients': 450,
      'joinDate': 'Jan 17, 2026',
      'admin': 'Dr. Michael Chen',
      'adminEmail': 'michael.c@sunriseclinic.com',
      'adminPhone': '+1 234-567-8905',
      'beds': 50,
      'departments': ['General Medicine', 'Pediatrics'],
    },
    {
      'id': '4',
      'name': 'St. Mary Hospital',
      'address': '321 Elm St, Boston, MA',
      'phone': '+1 234-567-8906',
      'email': 'info@stmary.org',
      'status': 'Inactive',
      'doctors': 52,
      'patients': 2100,
      'joinDate': 'Dec 20, 2024',
      'admin': 'Dr. Emily Davis',
      'adminEmail': 'emily.d@stmary.org',
      'adminPhone': '+1 234-567-8907',
      'beds': 300,
      'departments': ['Cardiology', 'Oncology', 'Radiology'],
    },
  ];

  List<Map<String, dynamic>> get _filteredHospitals {
    return _hospitals.where((hospital) {
      final matchesFilter = _selectedFilter == 'All' || hospital['status'] == _selectedFilter;
      final matchesSearch = hospital['name'].toLowerCase().contains(_searchQuery.toLowerCase()) ||
          hospital['address'].toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesFilter && matchesSearch;
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
                    hintText: 'Search hospitals...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                  ),
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    _buildFilterChip('All'),
                    const SizedBox(width: 8),
                    _buildFilterChip('Active'),
                    const SizedBox(width: 8),
                    _buildFilterChip('Pending'),
                    const SizedBox(width: 8),
                    _buildFilterChip('Inactive'),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _filteredHospitals.length,
              itemBuilder: (context, index) {
                final hospital = _filteredHospitals[index];
                return _buildHospitalCard(hospital);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddHospitalPage()),
          );
        },
        backgroundColor: const Color(0xFF4FC3F7),
        icon: const Icon(Icons.add),
        label: const Text('Add Hospital'),
      ),
    );
  }

  Widget _buildFilterChip(String label) {
    final isSelected = _selectedFilter == label;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _selectedFilter = label;
        });
      },
      selectedColor: const Color(0xFF4FC3F7),
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : Colors.black87,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }

  Widget _buildHospitalCard(Map<String, dynamic> hospital) {
    Color statusColor;
    switch (hospital['status']) {
      case 'Active':
        statusColor = Colors.green;
        break;
      case 'Pending':
        statusColor = Colors.orange;
        break;
      default:
        statusColor = Colors.red;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
        children: [
          ListTile(
            contentPadding: const EdgeInsets.all(16),
            leading: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF4FC3F7).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.local_hospital, color: Color(0xFF4FC3F7), size: 28),
            ),
            title: Text(
              hospital['name'],
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.location_on, size: 14, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        hospital['address'],
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.phone, size: 14, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Text(
                      hospital['phone'],
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ],
            ),
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                hospital['status'],
                style: TextStyle(
                  color: statusColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                _buildInfoChip(Icons.medical_services, '${hospital['doctors']} Doctors'),
                const SizedBox(width: 8),
                _buildInfoChip(Icons.people, '${hospital['patients']} Patients'),
                const SizedBox(width: 8),
                _buildInfoChip(Icons.hotel, '${hospital['beds']} Beds'),
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HospitalDetailsPage(hospital: hospital),
                        ),
                      );
                    },
                    icon: const Icon(Icons.visibility),
                    label: const Text('View Details'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF4FC3F7),
                      side: const BorderSide(color: Color(0xFF4FC3F7)),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                if (hospital['status'] == 'Pending')
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        _showApprovalDialog(hospital);
                      },
                      icon: const Icon(Icons.check),
                      label: const Text('Approve'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                if (hospital['status'] == 'Active')
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.block),
                      label: const Text('Suspend'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.grey[700]),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(fontSize: 11, color: Colors.grey[700]),
          ),
        ],
      ),
    );
  }

  void _showApprovalDialog(Map<String, dynamic> hospital) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Approve Hospital'),
        content: Text('Are you sure you want to approve ${hospital['name']}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                hospital['status'] = 'Active';
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${hospital['name']} approved successfully!')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            child: const Text('Approve'),
          ),
        ],
      ),
    );
  }
}