import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5E1BE), // Beige background
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5E1BE),
        elevation: 0,
        title: Text(
          "App Settings",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.brown[700],
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.brown[700]),
          onPressed: () {
            Navigator.pop(context); // Go back to the ProfileScreen
          },
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildSettingsOption("Account", Icons.person, context),
          _buildSettingsOption("Privacy", Icons.lock, context),
          _buildSettingsOption("Avatar", Icons.image, context),
          _buildSettingsOption("Notifications", Icons.notifications, context),
          _buildSettingsOption("Storage and Data", Icons.storage, context),
          _buildSettingsOption("App Language", Icons.language, context),
          _buildSettingsOption("App Updates", Icons.update, context),
        ],
      ),
    );
  }

  Widget _buildSettingsOption(String title, IconData icon, BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Colors.brown[700]),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.brown[700],
        ),
      ),
      trailing: Icon(Icons.arrow_forward_ios, color: Colors.brown[400], size: 16),
      onTap: () {
        // Handle navigation or action for each setting option
        switch (title) {
          case "Account":
          // Navigate to Account settings
            break;
          case "Privacy":
          // Navigate to Privacy settings
            break;
          case "Avatar":
          // Navigate to Avatar settings
            break;
          case "Notifications":
          // Navigate to Notifications settings
            break;
          case "Storage and Data":
          // Navigate to Storage and Data settings
            break;
          case "App Language":
          // Navigate to App Language settings
            break;
          case "App Updates":
          // Navigate to App Updates settings
            break;
        }
      },
    );;
  }
}