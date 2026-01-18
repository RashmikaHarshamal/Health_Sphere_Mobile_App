// lib/hospitaladmin/appointments_management_page.dart
import 'package:flutter/material.dart';

class AppointmentsManagementPage extends StatefulWidget {
  const AppointmentsManagementPage({super.key});

  @override
  State<AppointmentsManagementPage> createState() => _AppointmentsManagementPageState();
}

class _AppointmentsManagementPageState extends State<AppointmentsManagementPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedFilter = 'All';
  String _searchQuery = '';
  DateTime _selectedDate = DateTime.now();

  final List<Map<String, dynamic>> _appointments = [
    {
      'id': 'APT001',
      'patient': 'John Doe',
      'patientId': 'P12345',
      'age': 45,
      'gender': 'Male',
      'doctor': 'Dr. Sarah Johnson',
      'department': 'Cardiology',
      'date': 'Jan 18, 2026',
      'time': '10:00 AM',
      'status': 'Confirmed',
      'type': 'Consultation',
      'phone': '+1 234-567-8900',
      'email': 'john.doe@email.com',
      'reason': 'Regular checkup and blood pressure monitoring',
    },
    {
      'id': 'APT002',
      'patient': 'Jane Smith',
      'patientId': 'P12346',
      'age': 32,
      'gender': 'Female',
      'doctor': 'Dr. Michael Chen',
      'department': 'Neurology',
      'date': 'Jan 18, 2026',
      'time': '11:30 AM',
      'status': 'Pending',
      'type': 'Follow-up',
      'phone': '+1 234-567-8901',
      'email': 'jane.smith@email.com',
      'reason': 'Follow-up after MRI scan',
    },
    {
      'id': 'APT003',
      'patient': 'Bob Wilson',
      'patientId': 'P12347',
      'age': 28,
      'gender': 'Male',
      'doctor': 'Dr. Emily Davis',
      'department': 'Pediatrics',
      'date': 'Jan 18, 2026',
      'time': '2:00 PM',
      'status': 'Completed',
      'type': 'Consultation',
      'phone': '+1 234-567-8902',
      'email': 'bob.wilson@email.com',
      'reason': 'Child vaccination',
    },
    {
      'id': 'APT004',
      'patient': 'Alice Brown',
      'patientId': 'P12348',
      'age': 55,
      'gender': 'Female',
      'doctor': 'Dr. Robert Wilson',
      'department': 'Orthopedics',
      'date': 'Jan 19, 2026',
      'time': '9:00 AM',
      'status': 'Confirmed',
      'type': 'Surgery',
      'phone': '+1 234-567-8903',
      'email': 'alice.brown@email.com',
      'reason': 'Knee replacement surgery',
    },
    {
      'id': 'APT005',
      'patient': 'Charlie Davis',
      'patientId': 'P12349',
      'age': 40,
      'gender': 'Male',
      'doctor': 'Dr. Sarah Johnson',
      'department': 'Cardiology',
      'date': 'Jan 19, 2026',
      'time': '3:30 PM',
      'status': 'Cancelled',
      'type': 'Emergency',
      'phone': '+1 234-567-8904',
      'email': 'charlie.davis@email.com',
      'reason': 'Chest pain evaluation',
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get _filteredAppointments {
    return _appointments.where((apt) {
      final matchesFilter = _selectedFilter == 'All' || apt['status'] == _selectedFilter;
      final matchesSearch = apt['patient'].toLowerCase().contains(_searchQuery.toLowerCase()) ||
          apt['patientId'].toLowerCase().contains(_searchQuery.toLowerCase()) ||
          apt['doctor'].toLowerCase().contains(_searchQuery.toLowerCase());
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
            color: Colors.white,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      // Search bar
                      TextField(
                        decoration: InputDecoration(
                          hintText: 'Search by patient name, ID, or doctor...',
                          prefixIcon: const Icon(Icons.search),
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.calendar_today),
                            onPressed: () => _selectDate(context),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.grey[100],
                        ),
                        onChanged: (value) => setState(() => _searchQuery = value),
                      ),
                      const SizedBox(height: 16),
                      // Filter chips
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            _buildFilterChip('All'),
                            const SizedBox(width: 8),
                            _buildFilterChip('Pending'),
                            const SizedBox(width: 8),
                            _buildFilterChip('Confirmed'),
                            const SizedBox(width: 8),
                            _buildFilterChip('Completed'),
                            const SizedBox(width: 8),
                            _buildFilterChip('Cancelled'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // Tabs
                TabBar(
                  controller: _tabController,
                  labelColor: const Color(0xFF4FC3F7),
                  unselectedLabelColor: Colors.grey,
                  indicatorColor: const Color(0xFF4FC3F7),
                  tabs: const [
                    Tab(text: 'List View'),
                    Tab(text: 'Calendar View'),
                    Tab(text: 'Statistics'),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildListView(),
                _buildCalendarView(),
                _buildStatisticsView(),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddAppointmentDialog(),
        backgroundColor: const Color(0xFF4FC3F7),
        icon: const Icon(Icons.add),
        label: const Text('New Appointment'),
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
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : Colors.black87,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }

  Widget _buildListView() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _filteredAppointments.length,
      itemBuilder: (context, index) => _buildAppointmentCard(_filteredAppointments[index]),
    );
  }

  Widget _buildAppointmentCard(Map<String, dynamic> appointment) {
    Color statusColor = _getStatusColor(appointment['status']);
    Color typeColor = _getTypeColor(appointment['type']);

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
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: typeColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    appointment['type'],
                    style: TextStyle(
                      color: typeColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 11,
                    ),
                  ),
                ),
                const Spacer(),
                Text(
                  appointment['id'],
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: const Color(0xFF4FC3F7).withOpacity(0.2),
                      child: Text(
                        appointment['patient'].split(' ')[0][0] + 
                        appointment['patient'].split(' ')[1][0],
                        style: const TextStyle(
                          color: Color(0xFF4FC3F7),
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            appointment['patient'],
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            '${appointment['patientId']} • ${appointment['age']}y, ${appointment['gender']}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        appointment['status'],
                        style: TextStyle(
                          color: statusColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildInfoRow(Icons.medical_services, 'Doctor', appointment['doctor']),
                const SizedBox(height: 8),
                _buildInfoRow(Icons.domain, 'Department', appointment['department']),
                const SizedBox(height: 8),
                _buildInfoRow(Icons.calendar_today, 'Date & Time', '${appointment['date']} at ${appointment['time']}'),
                const SizedBox(height: 8),
                _buildInfoRow(Icons.phone, 'Phone', appointment['phone']),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.notes, size: 16, color: Colors.grey[700]),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Reason',
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              appointment['reason'],
                              style: const TextStyle(fontSize: 13),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _showAppointmentDetails(appointment),
                        icon: const Icon(Icons.visibility),
                        label: const Text('View'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFF4FC3F7),
                          side: const BorderSide(color: Color(0xFF4FC3F7)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    if (appointment['status'] == 'Pending')
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => _confirmAppointment(appointment),
                          icon: const Icon(Icons.check),
                          label: const Text('Confirm'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ),
                    if (appointment['status'] == 'Confirmed')
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => _completeAppointment(appointment),
                          icon: const Icon(Icons.check_circle),
                          label: const Text('Complete'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF4FC3F7),
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ),
                    const SizedBox(width: 8),
                    IconButton(
                      onPressed: () => _showMoreOptions(appointment),
                      icon: const Icon(Icons.more_vert),
                      color: Colors.grey[600],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey[600]),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: TextStyle(
            fontSize: 13,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 13),
          ),
        ),
      ],
    );
  }

  Widget _buildCalendarView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.calendar_today, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text(
            'Calendar View',
            style: TextStyle(fontSize: 18, color: Colors.grey[600]),
          ),
          const SizedBox(height: 8),
          Text(
            'Coming Soon',
            style: TextStyle(fontSize: 14, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  Widget _buildStatisticsView() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Row(
          children: [
            Expanded(
              child: _buildStatCard('Total', '${_appointments.length}', Icons.calendar_today, Colors.blue),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard('Today', '3', Icons.event, Colors.green),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildStatCard('Pending', '1', Icons.pending, Colors.orange),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard('Completed', '1', Icons.check_circle, Colors.purple),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Container(
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
              const Text(
                'By Department',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              _buildDepartmentRow('Cardiology', 2, Colors.red),
              _buildDepartmentRow('Neurology', 1, Colors.purple),
              _buildDepartmentRow('Pediatrics', 1, Colors.pink),
              _buildDepartmentRow('Orthopedics', 1, Colors.orange),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
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
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
          ),
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
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Icons.medical_services, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              name,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Text(
            '$count',
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Confirmed':
        return Colors.green;
      case 'Pending':
        return Colors.orange;
      case 'Completed':
        return Colors.blue;
      case 'Cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Color _getTypeColor(String type) {
    switch (type) {
      case 'Consultation':
        return Colors.blue;
      case 'Follow-up':
        return Colors.purple;
      case 'Surgery':
        return Colors.red;
      case 'Emergency':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _confirmAppointment(Map<String, dynamic> appointment) {
    setState(() {
      appointment['status'] = 'Confirmed';
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Appointment ${appointment['id']} confirmed'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _completeAppointment(Map<String, dynamic> appointment) {
    setState(() {
      appointment['status'] = 'Completed';
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Appointment ${appointment['id']} completed'),
        backgroundColor: Colors.blue,
      ),
    );
  }

  void _showAppointmentDetails(Map<String, dynamic> appointment) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Appointment ${appointment['id']}'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Patient: ${appointment['patient']}'),
              Text('Doctor: ${appointment['doctor']}'),
              Text('Department: ${appointment['department']}'),
              Text('Date: ${appointment['date']}'),
              Text('Time: ${appointment['time']}'),
              Text('Status: ${appointment['status']}'),
              const SizedBox(height: 8),
              Text('Reason: ${appointment['reason']}'),
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

  void _showMoreOptions(Map<String, dynamic> appointment) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit, color: Color(0xFF4FC3F7)),
              title: const Text('Edit Appointment'),
              onTap: () {
                Navigator.pop(context);
                _showEditAppointmentDialog(appointment);
              },
            ),
            ListTile(
              leading: const Icon(Icons.phone, color: Colors.green),
              title: const Text('Call Patient'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.email, color: Colors.blue),
              title: const Text('Email Patient'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.cancel, color: Colors.orange),
              title: const Text('Cancel Appointment'),
              onTap: () {
                Navigator.pop(context);
                _cancelAppointment(appointment);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text('Delete Appointment'),
              onTap: () {
                Navigator.pop(context);
                _deleteAppointment(appointment);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showAddAppointmentDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('New Appointment'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(decoration: const InputDecoration(labelText: 'Patient Name')),
              const SizedBox(height: 16),
              TextField(decoration: const InputDecoration(labelText: 'Patient ID')),
              const SizedBox(height: 16),
              TextField(decoration: const InputDecoration(labelText: 'Select Doctor')),
              const SizedBox(height: 16),
              TextField(decoration: const InputDecoration(labelText: 'Department')),
              const SizedBox(height: 16),
              TextField(decoration: const InputDecoration(labelText: 'Date')),
              const SizedBox(height: 16),
              TextField(decoration: const InputDecoration(labelText: 'Time')),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Appointment created successfully')),
              );
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  void _showEditAppointmentDialog(Map<String, dynamic> appointment) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Appointment'),
        content: const Text('Edit appointment functionality'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Appointment updated')),
              );
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _cancelAppointment(Map<String, dynamic> appointment) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel Appointment'),
        content: const Text('Are you sure you want to cancel this appointment?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('No'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                appointment['status'] = 'Cancelled';
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Appointment cancelled'),
                  backgroundColor: Colors.orange,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
            child: const Text('Yes, Cancel'),
          ),
        ],
      ),
    );
  }

  void _deleteAppointment(Map<String, dynamic> appointment) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Appointment'),
        content: const Text('This action cannot be undone. Delete this appointment?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('No'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _appointments.remove(appointment);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Appointment deleted'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Yes, Delete'),
          ),
        ],
      ),
    );
  }
}