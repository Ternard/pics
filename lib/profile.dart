import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart'; // For image picking
import 'dart:io'; // For handling file paths

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  File? _image; // To store the selected image
  bool _notificationsEnabled = true; // To track notifications state

  // Function to pick an image from the device
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path); // Set the selected image
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5E1BE), // Beige background
      appBar: AppBar(
        backgroundColor: Color(0xFFF5E1BE),
        elevation: 0,
        automaticallyImplyLeading: false, // Remove back button
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.white,
              radius: 18,
              child: Icon(Icons.restaurant, color: Colors.black), // Placeholder for logo
            ),
            SizedBox(width: 10),
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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20),

            // Profile ID Circle with Image Picker
            GestureDetector(
              onTap: _pickImage, // Allow user to pick an image
              child: CircleAvatar(
                radius: 50,
                backgroundColor: Colors.brown[300],
                backgroundImage: _image != null ? FileImage(_image!) : null, // Display selected image
                child: _image == null
                    ? Text(
                  "ID",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                )
                    : null, // Hide text if image is selected
              ),
            ),
            SizedBox(height: 20),

            // Profile Information Fields
            ProfileField(text: "Name"),
            ProfileField(text: "Email"),
            ProfileField(text: "Phone Number"),
            SizedBox(height: 20),

            // Notifications Toggle
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Checkbox(
                  value: _notificationsEnabled,
                  onChanged: (value) {
                    setState(() {
                      _notificationsEnabled = value ?? false; // Update notifications state
                    });
                  },
                ),
                Text(
                  _notificationsEnabled ? "Notifications On" : "Notifications Off",
                  style: TextStyle(fontSize: 16, color: Colors.brown[700]),
                ),
              ],
            ),
            SizedBox(height: 10),

            // Logout Button
            TextButton.icon(
              onPressed: () {
                // Logout function: Navigate to the login page
                Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
              },
              icon: Icon(Icons.logout, color: Colors.brown[700]),
              label: Text("Log Out", style: TextStyle(fontSize: 18, color: Colors.brown[700])),
            ),
            SizedBox(height: 30),

            // App Settings & Help
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("App Settings", style: TextStyle(fontSize: 16, color: Colors.brown[700])),
                  Text("Help & Support", style: TextStyle(fontSize: 16, color: Colors.brown[700])),
                ],
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),

      // Bottom Navigation Bar
      bottomNavigationBar: _buildBottomNavigationBar(4, context),
    );
  }

  // Bottom Navigation Bar
  Widget _buildBottomNavigationBar(int currentIndex, BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: Color(0xFFF5E1BE), // Beige background
      selectedItemColor: Colors.brown[700], // Darker icon color when selected
      unselectedItemColor: Colors.brown[400], // Lighter icon color when unselected
      showSelectedLabels: false,
      showUnselectedLabels: false,
      currentIndex: currentIndex,
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
        _buildBottomNavigationBarItem(Icons.home, 0, currentIndex),
        _buildBottomNavigationBarItem(Icons.search, 1, currentIndex),
        _buildBottomNavigationBarItem(Icons.restaurant_menu, 2, currentIndex),
        _buildBottomNavigationBarItem(Icons.phone, 3, currentIndex),
        _buildBottomNavigationBarItem(Icons.person, 4, currentIndex),
      ],
    );
  }

  // Bottom Navigation Bar Item
  BottomNavigationBarItem _buildBottomNavigationBarItem(IconData icon, int index, int currentIndex) {
    return BottomNavigationBarItem(
      icon: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: currentIndex == index ? Colors.brown[700] : Colors.transparent, // Dark circle when selected
        ),
        child: Icon(
          icon,
          color: currentIndex == index ? Colors.white : Colors.brown[700], // Lighter icon when selected
        ),
      ),
      label: "",
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
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 40),
      padding: EdgeInsets.all(15),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Color(0xFFEED9B5),
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