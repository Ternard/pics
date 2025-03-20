import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5E7C5), // Beige background
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.restaurant_menu, color: Colors.brown),
            ),
            SizedBox(width: 8),
            Text(
              'MealMeter',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.brown,
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Find the perfect meal within your Budget',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.brown,
              ),
            ),
            SizedBox(height: 10),
            TextField(
              decoration: InputDecoration(
                hintText: 'Search Meals',
                filled: true,
                fillColor: Colors.brown[300], // Darker search bar background
                prefixIcon: Icon(Icons.search, color: Colors.brown[700]), // Darker search icon
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Restaurants near you...',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                children: [
                  buildRestaurantCard('CJ’s', 'Kenyan', '4.5(100+ Reviews)', '2km Away', 'assets/cjs.jpg'),
                  buildRestaurantCard('Shawarma Street', 'Kenyan', '3.9(600+ Reviews)', '2km Away', 'assets/shawarma.jpg'),
                ],
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Your History...',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                children: [
                  buildRestaurantCard('Chicken Wings', 'Kenyan', '4.5(100+ Reviews)', '', 'assets/chicken_wings.jpg'),
                  buildRestaurantCard('Shawarma', 'Indian', '3.9(600+ Reviews)', '', 'assets/shawarma_food.jpg'),
                ],
              ),
            ),
          ],
        ),
      ),

      // Bottom Navigation Bar
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color(0xFFF5E1BE), // Beige background
        selectedItemColor: Colors.brown[700], // Darker icon color when selected
        unselectedItemColor: Colors.brown[400], // Lighter icon color when unselected
        showSelectedLabels: false,
        showUnselectedLabels: false,
        currentIndex: 0, // Home is selected by default
        onTap: (index) {
          switch (index) {
            case 0:
            // Already on HomeScreen, no need to navigate
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
              Navigator.pushNamed(context, '/profile');
              break;
          }
        },
        items: [
          BottomNavigationBarItem(
            icon: Container(
              padding: EdgeInsets.all(8),
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
              padding: EdgeInsets.all(8),
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
              padding: EdgeInsets.all(8),
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
              padding: EdgeInsets.all(8),
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
              padding: EdgeInsets.all(8),
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

  Widget buildRestaurantCard(String name, String type, String rating, String distance, String imagePath) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
              child: Image.asset(imagePath, fit: BoxFit.cover, width: double.infinity),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: TextStyle(fontWeight: FontWeight.bold)),
                Text(type, style: TextStyle(color: Colors.grey)),
                Text(rating, style: TextStyle(color: Colors.orange)),
                if (distance.isNotEmpty) Text(distance, style: TextStyle(color: Colors.grey)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}