// lib/hospitaladmin/hospital_admin_dashboard.dart
import 'package:flutter/material.dart';
import 'doctors_management_page.dart';
import 'appointments_management_page.dart';
import 'hospital_settings_page.dart';

class HospitalAdminDashboard extends StatefulWidget {
  const HospitalAdminDashboard({super.key});

  @override
  State<HospitalAdminDashboard> createState() => _HospitalAdminDashboardState();
}

class _HospitalAdminDashboardState extends State<HospitalAdminDashboard> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const HospitalDashboardHome(),
    const DoctorsManagementPage(),
    const AppointmentsManagementPage(),
    const HospitalSettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 2,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF4FC3F7).withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.local_hospital, color: Color(0xFF4FC3F7), size: 24),
            ),
            const SizedBox(width: 12),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('City General Hospital', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 16)),
                Text('Admin Panel', style: TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: Colors.black87),
            onPressed: () {},
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: CircleAvatar(
              backgroundColor: const Color(0xFF4FC3F7),
              child: const Text('JS', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                gradient: LinearGradient(colors: [Color(0xFF4FC3F7), Color(0xFF2196F3)]),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const CircleAvatar(
                    radius: 35,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.local_hospital, size: 40, color: Color(0xFF4FC3F7)),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'City General Hospital',
                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Dr. John Smith - Admin',
                    style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 14),
                  ),
                ],
              ),
            ),
            _buildDrawerItem(Icons.dashboard, 'Dashboard', 0),
            _buildDrawerItem(Icons.medical_services, 'Doctors', 1),
            _buildDrawerItem(Icons.calendar_today, 'Appointments', 2),
            _buildDrawerItem(Icons.settings, 'Settings', 3),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text('Logout', style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: _pages[_selectedIndex],
    );
  }

  Widget _buildDrawerItem(IconData icon, String title, int index) {
    final isSelected = _selectedIndex == index;
    return ListTile(
      leading: Icon(icon, color: isSelected ? const Color(0xFF4FC3F7) : Colors.grey),
      title: Text(
        title,
        style: TextStyle(
          color: isSelected ? const Color(0xFF4FC3F7) : Colors.black87,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      selected: isSelected,
      selectedTileColor: const Color(0xFF4FC3F7).withOpacity(0.1),
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
        Navigator.pop(context);
      },
    );
  }
}

class HospitalDashboardHome extends StatelessWidget {
  const HospitalDashboardHome({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text('Dashboard Overview', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        const SizedBox(height: 20),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: [
            _buildStatCard('Total Doctors', '45', Icons.medical_services, Colors.blue),
            _buildStatCard('Active Patients', '2,340', Icons.people, Colors.green),
            _buildStatCard('Today Appointments', '78', Icons.calendar_today, Colors.orange),
            _buildStatCard('Available Beds', '120/250', Icons.hotel, Colors.purple),
          ],
        ),
        const SizedBox(height: 24),
        _buildTodayAppointments(),
        const SizedBox(height: 24),
        _buildDoctorsOverview(),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: color, size: 28),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(value, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(title, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTodayAppointments() {
    final appointments = [
      {'patient': 'John Doe', 'doctor': 'Dr. Sarah Johnson', 'time': '10:00 AM', 'status': 'Pending'},
      {'patient': 'Jane Smith', 'doctor': 'Dr. Michael Chen', 'time': '11:30 AM', 'status': 'Confirmed'},
      {'patient': 'Bob Wilson', 'doctor': 'Dr. Emily Davis', 'time': '2:00 PM', 'status': 'Completed'},
    ];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Today\'s Appointments', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              TextButton(onPressed: () {}, child: const Text('View All')),
            ],
          ),
          const SizedBox(height: 16),
          ...appointments.map((apt) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
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
                      Text(apt['patient']!, style: const TextStyle(fontWeight: FontWeight.w600)),
                      Text('${apt['doctor']} • ${apt['time']}', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getStatusColor(apt['status']!).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(apt['status']!, style: TextStyle(fontSize: 11, color: _getStatusColor(apt['status']!), fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildDoctorsOverview() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Department Overview', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          _buildDepartmentRow('Cardiology', 12, Colors.red),
          _buildDepartmentRow('Neurology', 8, Colors.purple),
          _buildDepartmentRow('Pediatrics', 10, Colors.pink),
          _buildDepartmentRow('Orthopedics', 15, Colors.orange),
        ],
      ),
    );
  }

  Widget _buildDepartmentRow(String name, int count, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
            child: Icon(Icons.medical_services, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(child: Text(name, style: const TextStyle(fontWeight: FontWeight.w600))),
          Text('$count Doctors', style: TextStyle(color: Colors.grey[600], fontSize: 13)),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Confirmed': return Colors.green;
      case 'Pending': return Colors.orange;
      case 'Completed': return Colors.blue;
      default: return Colors.grey;
    }
  }
}