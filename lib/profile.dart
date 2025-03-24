// profile.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'settings.dart'; // Import the new SettingsPage

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5E1BE), // Beige background
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5E1BE),
        elevation: 0,
        automaticallyImplyLeading: false, // Remove back button
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.white,
              radius: 18,
              child: Icon(Icons.restaurant, color: Colors.black), // Placeholder for logo
            ),
            const SizedBox(width: 10),
            Text(
              "MealMeter",
              style: GoogleFonts.playfairDisplay(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.brown[600],
              ),
            ),
          ],
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 20),

          // Profile ID Circle
          CircleAvatar(
            radius: 50,
            backgroundColor: Colors.brown[300],
            child: const Text(
              "ID",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
          const SizedBox(height: 20),

          // Profile Information Fields
          ProfileField(text: "Name"),
          ProfileField(text: "Email"),
          ProfileField(text: "Phone Number"),
          const SizedBox(height: 20),

          // Notifications Toggle
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Checkbox(value: true, onChanged: (value) {}), // Default checked
              Text("Notifications", style: TextStyle(fontSize: 16, color: Colors.brown[700])),
            ],
          ),
          const SizedBox(height: 10),

          // Logout Button
          TextButton.icon(
            onPressed: () {
              // Logout function here
            },
            icon: Icon(Icons.logout, color: Colors.brown[700]),
            label: Text("Log Out", style: TextStyle(fontSize: 18, color: Colors.brown[700])),
          ),
          const SizedBox(height: 30),

          // App Settings & Help
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // App Settings Button
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/settings'); // Navigate to SettingsPage
                  },
                  child: Text(
                    "App Settings",
                    style: TextStyle(fontSize: 16, color: Colors.brown[700]),
                  ),
                ),
                // Help & Support Button
                TextButton(
                  onPressed: () {
                    // Navigate to Help & Support page
                  },
                  child: Text(
                    "Help & Support",
                    style: TextStyle(fontSize: 16, color: Colors.brown[700]),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),

      // Bottom Navigation Bar
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFFF5E1BE), // Beige background
        selectedItemColor: Colors.brown[700], // Darker icon color when selected
        unselectedItemColor: Colors.brown[400], // Lighter icon color when unselected
        showSelectedLabels: false,
        showUnselectedLabels: false,
        currentIndex: 4, // Profile is selected by default
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushNamed(context, '/home');
              break;
            case 1:
              Navigator.pushNamed(context, '/search');
              break;
            case 2:
              Navigator.pushNamed(context, '/restaurant');
              break;
            case 3:
              Navigator.pushNamed(context, '/contact');
              break;
            case 4:
            // Already on ProfileScreen, no need to navigate
              break;
          }
        },
        items: [
          BottomNavigationBarItem(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.brown[100], // Lighter circle around the icon
              ),
              child: Icon(Icons.home, color: Colors.brown[700]), // Darker icon
            ),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.brown[100], // Lighter circle around the icon
              ),
              child: Icon(Icons.search, color: Colors.brown[700]), // Darker icon
            ),
            label: "Search",
          ),
          BottomNavigationBarItem(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.brown[100], // Lighter circle around the icon
              ),
              child: Icon(Icons.restaurant_menu, color: Colors.brown[700]), // Darker icon
            ),
            label: "Menu",
          ),
          BottomNavigationBarItem(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.brown[100], // Lighter circle around the icon
              ),
              child: Icon(Icons.phone, color: Colors.brown[700]), // Darker icon
            ),
            label: "Call",
          ),
          BottomNavigationBarItem(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.brown[100], // Lighter circle around the icon
              ),
              child: Icon(Icons.person, color: Colors.brown[700]), // Darker icon
            ),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}

// Profile Field Widget
class ProfileField extends StatelessWidget {
  final String text;

  const ProfileField({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 40),
      padding: const EdgeInsets.all(15),
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFEED9B5),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.brown[800]),
      ),
    );
  }
}