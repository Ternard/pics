import 'package:flutter/material.dart';
import '../auth_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _privateAccount = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Privacy & Security Section
          _buildSectionTitle('Privacy & Security'),
          _buildSettingsTile(
            icon: Icons.lock,
            title: 'Privacy & Security',
            onTap: () {},
          ),
          _buildSettingsTile(
            icon: Icons.group,
            title: 'Manage Close Friends',
            onTap: () {
              Navigator.pushNamed(context, '/close_friends');
            },
          ),
          _buildSettingsTile(
            icon: Icons.notifications,
            title: 'Notification Preferences',
            trailing: Switch(
              value: _notificationsEnabled,
              onChanged: (value) {
                setState(() {
                  _notificationsEnabled = value;
                });
              },
              activeColor: const Color(0xFF64B5F6),
            ),
          ),
          _buildSettingsTile(
            icon: Icons.lock_outline,
            title: 'Private Account',
            trailing: Switch(
              value: _privateAccount,
              onChanged: (value) {
                setState(() {
                  _privateAccount = value;
                });
              },
              activeColor: const Color(0xFF64B5F6),
            ),
          ),

          const SizedBox(height: 24),

          // Account Settings
          _buildSectionTitle('Account Settings'),
          _buildSettingsTile(
            icon: Icons.person,
            title: 'Account Information',
            onTap: () {},
          ),
          _buildSettingsTile(
            icon: Icons.email,
            title: 'Email Preferences',
            onTap: () {},
          ),
          _buildSettingsTile(
            icon: Icons.password,
            title: 'Change Password',
            onTap: () {
              _showChangePasswordDialog();
            },
          ),

          const SizedBox(height: 24),

          // Help & Support
          _buildSectionTitle('Help & Support'),
          _buildSettingsTile(
            icon: Icons.help,
            title: 'Help & Support',
            onTap: () {},
          ),
          _buildSettingsTile(
            icon: Icons.info,
            title: 'About Pics',
            onTap: () {},
          ),
          _buildSettingsTile(
            icon: Icons.description,
            title: 'Terms of Service',
            onTap: () {},
          ),
          _buildSettingsTile(
            icon: Icons.privacy_tip,
            title: 'Privacy Policy',
            onTap: () {},
          ),

          const SizedBox(height: 24),

          // Logout Button
          Container(
            margin: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.red.withOpacity(0.5), width: 1.5),
              borderRadius: BorderRadius.circular(30),
            ),
            child: TextButton(
              onPressed: () async {
                final authService = AuthService();
                await authService.logout(context);
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.red,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text(
                'Log Out',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, bottom: 8, top: 16),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Colors.grey[600],
        ),
      ),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    VoidCallback? onTap,
    Widget? trailing,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFF64B5F6).withOpacity(0.3),
          width: 1,
        ),
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFF64B5F6).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: const Color(0xFF64B5F6), size: 20),
        ),
        title: Text(title),
        trailing: trailing ?? (onTap != null ? const Icon(Icons.arrow_forward_ios, size: 16) : null),
        onTap: onTap,
      ),
    );
  }

  void _showChangePasswordDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Change Password'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Current Password',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'New Password',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Confirm New Password',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
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
                const SnackBar(
                  content: Text('Password updated successfully'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }
}