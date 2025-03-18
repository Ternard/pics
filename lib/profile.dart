import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5E1BE), // Beige background
      appBar: AppBar(
        backgroundColor: Color(0xFFF5E1BE),
        elevation: 0,
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 20),

          // Profile ID Circle
          CircleAvatar(
            radius: 50,
            backgroundColor: Colors.brown[300],
            child: Text(
              "ID",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
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
              Checkbox(value: true, onChanged: (value) {}), // Default checked
              Text("Notifications", style: TextStyle(fontSize: 16, color: Colors.brown[700])),
            ],
          ),
          SizedBox(height: 10),

          // Logout Button
          TextButton.icon(
            onPressed: () {
              // Logout function here
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
        ],
      ),

      // Bottom Navigation Bar
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.brown[700],
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: "Search"),
          BottomNavigationBarItem(icon: Icon(Icons.restaurant_menu, size: 30), label: "Menu"),
          BottomNavigationBarItem(icon: Icon(Icons.phone), label: "Call"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}

// Profile Field Widget
class ProfileField extends StatelessWidget {
  final String text;

  ProfileField({required this.text});

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
