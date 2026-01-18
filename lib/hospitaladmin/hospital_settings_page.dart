// lib/hospitaladmin/hospital_settings_page.dart
import 'package:flutter/material.dart';

class HospitalSettingsPage extends StatefulWidget {
  const HospitalSettingsPage({super.key});

  @override
  State<HospitalSettingsPage> createState() => _HospitalSettingsPageState();
}

class _HospitalSettingsPageState extends State<HospitalSettingsPage> {
  bool _emailNotifications = true;
  bool _smsNotifications = true;
  bool _appointmentReminders = true;
  bool _emergencyAlerts = true;
  String _operatingHoursStart = '08:00 AM';
  String _operatingHoursEnd = '08:00 PM';

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          'Hospital Settings',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),

        // Hospital Profile
        _buildSettingsSection(
          'Hospital Profile',
          [
            _buildSettingItem(
              Icons.business,
              'Hospital Information',
              () => _showHospitalInfoDialog(),
            ),
            _buildSettingItem(
              Icons.location_on,
              'Address & Contact',
              () => _showAddressDialog(),
            ),
            _buildSettingItem(
              Icons.image,
              'Upload Hospital Logo',
              () => _showLogoUploadDialog(),
            ),
            _buildSettingItem(
              Icons.description,
              'Hospital Description',
              () => _showDescriptionDialog(),
            ),
          ],
        ),
        const SizedBox(height: 20),

        // Department Management
        _buildSettingsSection(
          'Department Management',
          [
            _buildSettingItem(
              Icons.domain,
              'Manage Departments',
              () => _showDepartmentsDialog(),
            ),
            _buildSettingItem(
              Icons.add_circle,
              'Add New Department',
              () => _showAddDepartmentDialog(),
            ),
            _buildSettingItem(
              Icons.edit,
              'Edit Department Details',
              () => _showEditDepartmentDialog(),
            ),
          ],
        ),
        const SizedBox(height: 20),

        // Operating Hours
        _buildSettingsSection(
          'Operating Hours',
          [
            _buildTimePickerItem(
              Icons.access_time,
              'Opening Time',
              _operatingHoursStart,
              () => _selectTime(true),
            ),
            _buildTimePickerItem(
              Icons.access_time_filled,
              'Closing Time',
              _operatingHoursEnd,
              () => _selectTime(false),
            ),
            _buildSettingItem(
              Icons.calendar_today,
              'Emergency Hours (24/7)',
              () => _showEmergencyHoursDialog(),
            ),
          ],
        ),
        const SizedBox(height: 20),

        // Notification Settings
        _buildSettingsSection(
          'Notification Settings',
          [
            _buildSwitchItem(
              Icons.email,
              'Email Notifications',
              _emailNotifications,
              (value) => setState(() => _emailNotifications = value),
            ),
            _buildSwitchItem(
              Icons.sms,
              'SMS Notifications',
              _smsNotifications,
              (value) => setState(() => _smsNotifications = value),
            ),
            _buildSwitchItem(
              Icons.event_available,
              'Appointment Reminders',
              _appointmentReminders,
              (value) => setState(() => _appointmentReminders = value),
            ),
            _buildSwitchItem(
              Icons.emergency,
              'Emergency Alerts',
              _emergencyAlerts,
              (value) => setState(() => _emergencyAlerts = value),
            ),
          ],
        ),
        const SizedBox(height: 20),

        // Payment Settings
        _buildSettingsSection(
          'Payment Settings',
          [
            _buildSettingItem(
              Icons.payment,
              'Payment Methods',
              () => _showPaymentMethodsDialog(),
            ),
            _buildSettingItem(
              Icons.receipt,
              'Invoice Settings',
              () => _showInvoiceDialog(),
            ),
            _buildSettingItem(
              Icons.account_balance,
              'Insurance Providers',
              () => _showInsuranceDialog(),
            ),
          ],
        ),
        const SizedBox(height: 20),

        // Appointment Settings
        _buildSettingsSection(
          'Appointment Settings',
          [
            _buildSettingItem(
              Icons.timer,
              'Default Appointment Duration',
              () => _showDurationDialog(),
            ),
            _buildSettingItem(
              Icons.schedule,
              'Booking Time Slots',
              () => _showTimeSlotsDialog(),
            ),
            _buildSettingItem(
              Icons.block,
              'Blocked Time Slots',
              () => _showBlockedSlotsDialog(),
            ),
          ],
        ),
        const SizedBox(height: 20),

        // Staff Management
        _buildSettingsSection(
          'Staff Management',
          [
            _buildSettingItem(
              Icons.badge,
              'Manage Staff Roles',
              () => _showStaffRolesDialog(),
            ),
            _buildSettingItem(
              Icons.person_add,
              'Add Staff Member',
              () => _showAddStaffDialog(),
            ),
            _buildSettingItem(
              Icons.schedule,
              'Staff Schedules',
              () => _showStaffScheduleDialog(),
            ),
          ],
        ),
        const SizedBox(height: 20),

        // System Preferences
        _buildSettingsSection(
          'System Preferences',
          [
            _buildSettingItem(
              Icons.language,
              'Language & Region',
              () => _showLanguageDialog(),
            ),
            _buildSettingItem(
              Icons.color_lens,
              'Theme Settings',
              () => _showThemeDialog(),
            ),
            _buildSettingItem(
              Icons.print,
              'Print Settings',
              () => _showPrintDialog(),
            ),
          ],
        ),
        const SizedBox(height: 20),

        // Reports & Analytics
        _buildSettingsSection(
          'Reports & Analytics',
          [
            _buildSettingItem(
              Icons.analytics,
              'Configure Reports',
              () => _showReportsDialog(),
            ),
            _buildSettingItem(
              Icons.download,
              'Export Data',
              () => _showExportDialog(),
            ),
            _buildSettingItem(
              Icons.backup,
              'Backup Settings',
              () => _showBackupDialog(),
            ),
          ],
        ),
        const SizedBox(height: 20),

        // Privacy & Security
        _buildSettingsSection(
          'Privacy & Security',
          [
            _buildSettingItem(
              Icons.lock,
              'Change Admin Password',
              () => _showPasswordDialog(),
            ),
            _buildSettingItem(
              Icons.security,
              'Two-Factor Authentication',
              () => _show2FADialog(),
            ),
            _buildSettingItem(
              Icons.privacy_tip,
              'Data Privacy Settings',
              () => _showPrivacyDialog(),
            ),
            _buildSettingItem(
              Icons.history,
              'Activity Log',
              () => _showActivityLogDialog(),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSettingsSection(String title, List<Widget> items) {
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
          ...items,
        ],
      ),
    );
  }

  Widget _buildSettingItem(IconData icon, String title, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFF4FC3F7)),
            const SizedBox(width: 16),
            Expanded(child: Text(title)),
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchItem(
    IconData icon,
    String title,
    bool value,
    Function(bool) onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF4FC3F7)),
          const SizedBox(width: 16),
          Expanded(child: Text(title)),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: const Color(0xFF4FC3F7),
          ),
        ],
      ),
    );
  }

  Widget _buildTimePickerItem(
    IconData icon,
    String title,
    String time,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFF4FC3F7)),
            const SizedBox(width: 16),
            Expanded(child: Text(title)),
            Text(
              time,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFF4FC3F7),
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  void _selectTime(bool isStart) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        final time = picked.format(context);
        if (isStart) {
          _operatingHoursStart = time;
        } else {
          _operatingHoursEnd = time;
        }
      });
    }
  }

  // Dialog methods
  void _showHospitalInfoDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hospital Information'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: 'Hospital Name',
                hintText: 'City General Hospital',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Registration Number',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: const InputDecoration(
                labelText: 'License Number',
              ),
            ),
          ],
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
                const SnackBar(content: Text('Hospital info updated')),
              );
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showAddressDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Address & Contact'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: const InputDecoration(labelText: 'Street Address'),
              maxLines: 2,
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: const InputDecoration(labelText: 'Phone Number'),
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: const InputDecoration(labelText: 'Email Address'),
            ),
          ],
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
                const SnackBar(content: Text('Contact info updated')),
              );
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showLogoUploadDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Upload Hospital Logo'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 150,
              width: 150,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.local_hospital, size: 80, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.upload),
              label: const Text('Choose Image'),
            ),
          ],
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
                const SnackBar(content: Text('Logo uploaded successfully')),
              );
            },
            child: const Text('Upload'),
          ),
        ],
      ),
    );
  }

  void _showDescriptionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hospital Description'),
        content: TextField(
          maxLines: 5,
          decoration: const InputDecoration(
            hintText: 'Enter a brief description of your hospital...',
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
                const SnackBar(content: Text('Description saved')),
              );
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showDepartmentsDialog() {
    final departments = [
      'Cardiology',
      'Neurology',
      'Pediatrics',
      'Orthopedics',
      'Emergency',
    ];
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Manage Departments'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: departments.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: const Icon(Icons.domain, color: Color(0xFF4FC3F7)),
                title: Text(departments[index]),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, size: 20),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, size: 20, color: Colors.red),
                      onPressed: () {},
                    ),
                  ],
                ),
              );
            },
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

  void _showAddDepartmentDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Department'),
        content: TextField(
          decoration: const InputDecoration(
            labelText: 'Department Name',
            hintText: 'e.g., Cardiology',
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
                const SnackBar(content: Text('Department added')),
              );
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _showEditDepartmentDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Department'),
        content: const Text('Select a department from Manage Departments to edit.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showEmergencyHoursDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Emergency Hours'),
        content: const Text(
          'Emergency services are available 24/7. Configure emergency contact details and on-call staff.',
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

  void _showPaymentMethodsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Payment Methods'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CheckboxListTile(
              title: const Text('Cash'),
              value: true,
              onChanged: (value) {},
            ),
            CheckboxListTile(
              title: const Text('Credit/Debit Card'),
              value: true,
              onChanged: (value) {},
            ),
            CheckboxListTile(
              title: const Text('Insurance'),
              value: true,
              onChanged: (value) {},
            ),
            CheckboxListTile(
              title: const Text('Online Payment'),
              value: false,
              onChanged: (value) {},
            ),
          ],
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

  void _showInvoiceDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Invoice Settings'),
        content: const Text('Configure invoice templates and numbering.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showInsuranceDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Insurance Providers'),
        content: const Text('Manage accepted insurance providers and policies.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showDurationDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Default Appointment Duration'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(title: const Text('15 minutes'), onTap: () => Navigator.pop(context)),
            ListTile(title: const Text('30 minutes'), onTap: () => Navigator.pop(context)),
            ListTile(title: const Text('45 minutes'), onTap: () => Navigator.pop(context)),
            ListTile(title: const Text('60 minutes'), onTap: () => Navigator.pop(context)),
          ],
        ),
      ),
    );
  }

  void _showTimeSlotsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Booking Time Slots'),
        content: const Text('Configure available time slots for appointments.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showBlockedSlotsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Blocked Time Slots'),
        content: const Text('View and manage blocked time slots.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showStaffRolesDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Staff Roles'),
        content: const Text('Manage staff roles and permissions.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showAddStaffDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Staff Member'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(decoration: const InputDecoration(labelText: 'Name')),
            const SizedBox(height: 16),
            TextField(decoration: const InputDecoration(labelText: 'Email')),
            const SizedBox(height: 16),
            TextField(decoration: const InputDecoration(labelText: 'Role')),
          ],
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
                const SnackBar(content: Text('Staff member added')),
              );
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _showStaffScheduleDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Staff Schedules'),
        content: const Text('View and manage staff working schedules.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Language & Region'),
        content: const Text('Configure language and regional settings.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showThemeDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Theme Settings'),
        content: const Text('Choose your preferred theme.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showPrintDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Print Settings'),
        content: const Text('Configure printer and print preferences.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showReportsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Configure Reports'),
        content: const Text('Set up automated reports and schedules.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showExportDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Export Data'),
        content: const Text('Export hospital data in various formats.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showBackupDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Backup Settings'),
        content: const Text('Configure automatic backups.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showPasswordDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Change Password'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Current Password'),
            ),
            const SizedBox(height: 16),
            TextField(
              obscureText: true,
              decoration: const InputDecoration(labelText: 'New Password'),
            ),
            const SizedBox(height: 16),
            TextField(
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Confirm Password'),
            ),
          ],
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
                const SnackBar(content: Text('Password changed successfully')),
              );
            },
            child: const Text('Change'),
          ),
        ],
      ),
    );
  }

  void _show2FADialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Two-Factor Authentication'),
        content: const Text('Enable two-factor authentication for enhanced security.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showPrivacyDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Data Privacy Settings'),
        content: const Text('Configure data privacy and HIPAA compliance.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showActivityLogDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Activity Log'),
        content: const Text('View recent activity and system logs.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}