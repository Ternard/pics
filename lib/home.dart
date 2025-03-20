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
      body: SingleChildScrollView(
        child: Padding(
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
              GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                children: [
                  buildRestaurantCard('CJ’s', 'Kenyan', '4.5(100+ Reviews)', '2km Away', 'assets/cjs.jpg'),
                  buildRestaurantCard('Shawarma Street', 'Kenyan', '3.9(600+ Reviews)', '2km Away', 'assets/shawarma.jpg'),
                ],
              ),
              SizedBox(height: 10),
              Text(
                'Your History...',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                children: [
                  buildRestaurantCard('Chicken Wings', 'Kenyan', '4.5(100+ Reviews)', '', 'assets/chicken_wings.jpg'),
                  buildRestaurantCard('Shawarma', 'Indian', '3.9(600+ Reviews)', '', 'assets/shawarma_food.jpg'),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(0, context),
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
            Navigator.pushNamed(context, '/profile');
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