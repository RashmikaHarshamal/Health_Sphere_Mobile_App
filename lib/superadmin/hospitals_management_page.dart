// lib/superadmin/hospitals_management_page.dart
import 'package:flutter/material.dart';
import '../services/hospital_management_service.dart';

class HospitalsManagementPage extends StatefulWidget {
  const HospitalsManagementPage({super.key});

  @override
  State<HospitalsManagementPage> createState() => _HospitalsManagementPageState();
}

class _HospitalsManagementPageState extends State<HospitalsManagementPage> {
  final _hospitalService = HospitalManagementService();
  String _selectedFilter = 'all';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Column(
        children: [
          _buildFilterBar(),
          Expanded(
            child: _buildHospitalsList(),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterBar() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _buildFilterChip('All', 'all'),
            const SizedBox(width: 8),
            _buildFilterChip('Pending', 'pending'),
            const SizedBox(width: 8),
            _buildFilterChip('Approved', 'approved'),
            const SizedBox(width: 8),
            _buildFilterChip('Rejected', 'rejected'),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, String value) {
    final isSelected = _selectedFilter == value;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _selectedFilter = value;
        });
      },
      backgroundColor: Colors.grey[100],
      selectedColor: const Color(0xFF4FC3F7),
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : Colors.black87,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }

  Widget _buildHospitalsList() {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: _hospitalService.getHospitalsStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.local_hospital_outlined, size: 80, color: Colors.grey[300]),
                const SizedBox(height: 16),
                Text(
                  'No hospitals registered yet',
                  style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                ),
              ],
            ),
          );
        }

        List<Map<String, dynamic>> hospitals = snapshot.data!;
        
        // Apply filter
        if (_selectedFilter != 'all') {
          hospitals = hospitals.where((h) => h['status'] == _selectedFilter).toList();
        }

        if (hospitals.isEmpty) {
          return Center(
            child: Text(
              'No hospitals with "$_selectedFilter" status',
              style: TextStyle(color: Colors.grey[600]),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: hospitals.length,
          itemBuilder: (context, index) {
            return _buildHospitalCard(hospitals[index]);
          },
        );
      },
    );
  }

  Widget _buildHospitalCard(Map<String, dynamic> hospital) {
    final status = hospital['status'] ?? 'unknown';
    final statusColor = _getStatusColor(status);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: () {
          _showHospitalDetails(context, hospital);
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: const Color(0xFF4FC3F7).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.local_hospital, color: Color(0xFF4FC3F7), size: 32),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          hospital['hospitalName'] ?? 'Unknown Hospital',
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          hospital['city'] ?? 'Unknown City',
                          style: TextStyle(color: Colors.grey[600], fontSize: 13),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: statusColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            status.toUpperCase(),
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: statusColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.info_outline, color: Color(0xFF4FC3F7)),
                    onPressed: () => _showHospitalDetails(context, hospital),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Divider(color: Colors.grey[200]),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildInfoChip(
                    icon: Icons.bed,
                    label: '${hospital['totalBeds'] ?? 0} Beds',
                  ),
                  _buildInfoChip(
                    icon: Icons.people,
                    label: '${hospital['totalDoctors'] ?? 0} Doctors',
                  ),
                  _buildInfoChip(
                    icon: Icons.local_hospital,
                    label: hospital['hospitalType'] ?? 'N/A',
                  ),
                ],
              ),
              const SizedBox(height: 12),
              if (status == 'pending') ...[
                Divider(color: Colors.grey[200]),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => _approveHospital(hospital['hospitalId']),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        child: const Text('Approve', style: TextStyle(color: Colors.white)),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => _rejectHospital(hospital['hospitalId']),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        child: const Text('Reject', style: TextStyle(color: Colors.white)),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip({required IconData icon, required String label}) {
    return Chip(
      avatar: Icon(icon, size: 16, color: const Color(0xFF4FC3F7)),
      label: Text(label, style: const TextStyle(fontSize: 12)),
      backgroundColor: const Color(0xFF4FC3F7).withOpacity(0.1),
      labelStyle: const TextStyle(color: Color(0xFF4FC3F7)),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'rejected':
        return Colors.red;
      case 'suspended':
        return Colors.redAccent;
      default:
        return Colors.grey;
    }
  }

  void _showHospitalDetails(BuildContext context, Map<String, dynamic> hospital) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(hospital['hospitalName'] ?? 'Hospital Details'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailRow('Email', hospital['hospitalEmail'] ?? 'N/A'),
              _buildDetailRow('Phone', hospital['hospitalPhone'] ?? 'N/A'),
              _buildDetailRow('Address', hospital['hospitalAddress'] ?? 'N/A'),
              _buildDetailRow('City', hospital['city'] ?? 'N/A'),
              _buildDetailRow('State', hospital['state'] ?? 'N/A'),
              _buildDetailRow('Type', hospital['hospitalType'] ?? 'N/A'),
              _buildDetailRow('Registration', hospital['registrationNumber'] ?? 'N/A'),
              _buildDetailRow('License', hospital['licenseNumber'] ?? 'N/A'),
              _buildDetailRow('Total Beds', '${hospital['totalBeds'] ?? 0}'),
              _buildDetailRow('Total Doctors', '${hospital['totalDoctors'] ?? 0}'),
              _buildDetailRow('Status', hospital['status'] ?? 'N/A'),
              _buildDetailRow('Admin', hospital['adminName'] ?? 'N/A'),
              if (hospital['facilities'] != null)
                _buildDetailRow(
                  'Facilities',
                  (hospital['facilities'] as List).join(', '),
                ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  void _approveHospital(String hospitalId) async {
    try {
      await _hospitalService.approveHospital(hospitalId, 'super_admin');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Hospital approved'), backgroundColor: Colors.green),
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

  void _rejectHospital(String hospitalId) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reject Hospital'),
        content: const Text('Are you sure you want to reject this hospital registration?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              try {
                await _hospitalService.rejectHospital(hospitalId, 'Rejected by super admin');
                if (mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Hospital rejected'), backgroundColor: Colors.red),
                  );
                }
              } catch (e) {
                if (mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
                  );
                }
              }
            },
            child: const Text('Reject', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}