import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _currentIndex = 4; // Track the current index

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
        backgroundColor: Color(0xFFF5E1BE), // Beige background
        selectedItemColor: Colors.brown[700], // Darker icon color when selected
        unselectedItemColor: Colors.brown[400], // Lighter icon color when unselected
        showSelectedLabels: false,
        showUnselectedLabels: false,
        currentIndex: _currentIndex, // Track the current index
        onTap: (index) {
          setState(() {
            _currentIndex = index; // Update the current index
          });
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
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _currentIndex == 0 ? Colors.brown[700] : Colors.brown[100], // Darker circle when selected
              ),
              child: Icon(
                Icons.home,
                color: _currentIndex == 0 ? Colors.white : Colors.brown[700], // Lighter icon when selected
              ),
            ),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _currentIndex == 1 ? Colors.brown[700] : Colors.brown[100], // Darker circle when selected
              ),
              child: Icon(
                Icons.search,
                color: _currentIndex == 1 ? Colors.white : Colors.brown[700], // Lighter icon when selected
              ),
            ),
            label: "Search",
          ),
          BottomNavigationBarItem(
            icon: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _currentIndex == 2 ? Colors.brown[700] : Colors.brown[100], // Darker circle when selected
              ),
              child: Icon(
                Icons.restaurant_menu,
                color: _currentIndex == 2 ? Colors.white : Colors.brown[700], // Lighter icon when selected
              ),
            ),
            label: "Menu",
          ),
          BottomNavigationBarItem(
            icon: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _currentIndex == 3 ? Colors.brown[700] : Colors.brown[100], // Darker circle when selected
              ),
              child: Icon(
                Icons.phone,
                color: _currentIndex == 3 ? Colors.white : Colors.brown[700], // Lighter icon when selected
              ),
            ),
            label: "Call",
          ),
          BottomNavigationBarItem(
            icon: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _currentIndex == 4 ? Colors.brown[700] : Colors.brown[100], // Darker circle when selected
              ),
              child: Icon(
                Icons.person,
                color: _currentIndex == 4 ? Colors.white : Colors.brown[700], // Lighter icon when selected
              ),
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