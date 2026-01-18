// lib/superadmin/settings_page.dart
import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _emailNotifications = true;
  bool _pushNotifications = true;
  bool _smsNotifications = false;
  bool _autoApproval = false;
  bool _twoFactorAuth = true;
  String _selectedLanguage = 'English';
  String _selectedTheme = 'Light';

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          'Settings',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        
        // Account Settings
        _buildSettingsSection(
          'Account Settings',
          [
            _buildSettingItem(
              Icons.person,
              'Profile Information',
              () => _showProfileDialog(),
            ),
            _buildSettingItem(
              Icons.lock,
              'Change Password',
              () => _showPasswordDialog(),
            ),
            _buildSwitchItem(
              Icons.security,
              'Two-Factor Authentication',
              _twoFactorAuth,
              (value) => setState(() => _twoFactorAuth = value),
            ),
          ],
        ),
        const SizedBox(height: 20),

        // Notification Settings
        _buildSettingsSection(
          'Notification Preferences',
          [
            _buildSwitchItem(
              Icons.email,
              'Email Notifications',
              _emailNotifications,
              (value) => setState(() => _emailNotifications = value),
            ),
            _buildSwitchItem(
              Icons.notifications,
              'Push Notifications',
              _pushNotifications,
              (value) => setState(() => _pushNotifications = value),
            ),
            _buildSwitchItem(
              Icons.sms,
              'SMS Notifications',
              _smsNotifications,
              (value) => setState(() => _smsNotifications = value),
            ),
          ],
        ),
        const SizedBox(height: 20),

        // System Settings
        _buildSettingsSection(
          'System Settings',
          [
            _buildDropdownItem(
              Icons.language,
              'Language',
              _selectedLanguage,
              ['English', 'Spanish', 'French', 'German', 'Chinese'],
              (value) => setState(() => _selectedLanguage = value!),
            ),
            _buildDropdownItem(
              Icons.color_lens,
              'Theme',
              _selectedTheme,
              ['Light', 'Dark', 'System'],
              (value) => setState(() => _selectedTheme = value!),
            ),
            _buildSettingItem(
              Icons.schedule,
              'Time Zone',
              () => _showTimeZoneDialog(),
            ),
          ],
        ),
        const SizedBox(height: 20),

        // Platform Settings
        _buildSettingsSection(
          'Platform Settings',
          [
            _buildSwitchItem(
              Icons.verified,
              'Auto-Approve Hospitals',
              _autoApproval,
              (value) => setState(() => _autoApproval = value),
            ),
            _buildSettingItem(
              Icons.payment,
              'Payment Gateway Settings',
              () => _showPaymentDialog(),
            ),
            _buildSettingItem(
              Icons.policy,
              'Terms & Policies',
              () => _showTermsDialog(),
            ),
            _buildSettingItem(
              Icons.privacy_tip,
              'Privacy Settings',
              () => _showPrivacyDialog(),
            ),
          ],
        ),
        const SizedBox(height: 20),

        // Data Management
        _buildSettingsSection(
          'Data Management',
          [
            _buildSettingItem(
              Icons.backup,
              'Backup Data',
              () => _showBackupDialog(),
            ),
            _buildSettingItem(
              Icons.download,
              'Export Reports',
              () => _showExportDialog(),
            ),
            _buildSettingItem(
              Icons.cleaning_services,
              'Clear Cache',
              () => _showClearCacheDialog(),
            ),
          ],
        ),
        const SizedBox(height: 20),

        // Support & Help
        _buildSettingsSection(
          'Support & Help',
          [
            _buildSettingItem(
              Icons.help_outline,
              'Help Center',
              () {},
            ),
            _buildSettingItem(
              Icons.contact_support,
              'Contact Support',
              () => _showContactSupportDialog(),
            ),
            _buildSettingItem(
              Icons.info_outline,
              'About',
              () => _showAboutDialog(),
            ),
          ],
        ),
        const SizedBox(height: 20),

        // Danger Zone
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.red[50],
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.red[200]!),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Danger Zone',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
              const SizedBox(height: 16),
              _buildDangerItem(
                Icons.delete_forever,
                'Delete All Inactive Hospitals',
                () => _showDeleteInactiveDialog(),
              ),
              _buildDangerItem(
                Icons.restore,
                'Reset System Settings',
                () => _showResetDialog(),
              ),
            ],
          ),
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
            Expanded(
              child: Text(
                title,
                style: const TextStyle(fontSize: 15),
              ),
            ),
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
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontSize: 15),
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: const Color(0xFF4FC3F7),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownItem(
    IconData icon,
    String title,
    String value,
    List<String> items,
    Function(String?) onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF4FC3F7)),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontSize: 15),
            ),
          ),
          DropdownButton<String>(
            value: value,
            items: items.map((item) {
              return DropdownMenuItem(
                value: item,
                child: Text(item),
              );
            }).toList(),
            onChanged: onChanged,
            underline: Container(),
          ),
        ],
      ),
    );
  }

  Widget _buildDangerItem(IconData icon, String title, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Icon(icon, color: Colors.red),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(fontSize: 15, color: Colors.red),
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.red),
          ],
        ),
      ),
    );
  }

  // Dialog methods
  void _showProfileDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Profile'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: const InputDecoration(labelText: 'Email'),
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
                const SnackBar(content: Text('Profile updated successfully')),
              );
            },
            child: const Text('Save'),
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

  void _showTimeZoneDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Time Zone'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView(
            shrinkWrap: true,
            children: [
              'UTC-8 (PST)',
              'UTC-5 (EST)',
              'UTC+0 (GMT)',
              'UTC+1 (CET)',
              'UTC+8 (CST)',
            ].map((tz) {
              return ListTile(
                title: Text(tz),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Time zone set to $tz')),
                  );
                },
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  void _showPaymentDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Payment Gateway Settings'),
        content: const Text(
          'Configure payment gateways for hospital subscriptions and transactions.',
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

  void _showTermsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Terms & Policies'),
        content: const Text(
          'Manage platform terms of service and privacy policies.',
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

  void _showPrivacyDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Privacy Settings'),
        content: const Text(
          'Configure data privacy and HIPAA compliance settings.',
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

  void _showBackupDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Backup Data'),
        content: const Text(
          'Create a backup of all system data?',
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
                const SnackBar(content: Text('Backup started...')),
              );
            },
            child: const Text('Backup'),
          ),
        ],
      ),
    );
  }

  void _showExportDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Export Reports'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('Export as PDF'),
              leading: const Icon(Icons.picture_as_pdf),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Exporting as PDF...')),
                );
              },
            ),
            ListTile(
              title: const Text('Export as Excel'),
              leading: const Icon(Icons.table_chart),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Exporting as Excel...')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showClearCacheDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Cache'),
        content: const Text(
          'This will clear all cached data. Continue?',
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
                const SnackBar(content: Text('Cache cleared successfully')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }

  void _showContactSupportDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Contact Support'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Email: support@healthcare.com'),
            const SizedBox(height: 8),
            const Text('Phone: +1 (800) 123-4567'),
            const SizedBox(height: 8),
            const Text('Available: 24/7'),
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

  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('About HealthCare+'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Version: 1.0.0'),
            SizedBox(height: 8),
            Text('Build: 2026.01.18'),
            SizedBox(height: 16),
            Text('© 2026 HealthCare+ Inc.'),
            Text('All rights reserved.'),
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

  void _showDeleteInactiveDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Inactive Hospitals'),
        content: const Text(
          'This will permanently delete all inactive hospitals. This action cannot be undone!',
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
                const SnackBar(
                  content: Text('Inactive hospitals deleted'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showResetDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset System Settings'),
        content: const Text(
          'This will reset all system settings to default. Continue?',
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
                const SnackBar(content: Text('Settings reset to default')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }
}