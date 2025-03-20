import 'package:flutter/material.dart';

class RestaurantScreen extends StatefulWidget {
  const RestaurantScreen({super.key});

  @override
  _RestaurantScreenState createState() => _RestaurantScreenState();
}

class _RestaurantScreenState extends State<RestaurantScreen> {
  int _currentIndex = 2; // Track the current index

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: _buildBottomNavigationBar(_currentIndex, context),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(16.0),
                color: Color(0xFFF5DEB3), // Beige color
                child: Row(
                  children: [
                    Icon(Icons.restaurant, color: Colors.brown),
                    SizedBox(width: 8.0),
                    Text(
                      'MealMeter',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.brown,
                      ),
                    ),
                  ],
                ),
              ),
              ClipRRect(
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
                child: Image.network(
                  'https://source.unsplash.com/400x300/?restaurant',
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Shawarma Street',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.brown,
                ),
              ),
              SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.location_on, color: Colors.brown),
                  SizedBox(width: 5),
                  Text(
                    'Restaurant Location',
                    style: TextStyle(color: Colors.brown),
                  ),
                ],
              ),
              SizedBox(height: 10),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.brown,
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                ),
                onPressed: () {},
                child: Text('Menu', style: TextStyle(color: Colors.white)),
              ),
              SizedBox(height: 20),
              _buildReviewCard('Brandon White', 4.2, 'Best Customer Services I’ve ever had...'),
              _buildReviewCard('Victoria Malen', 4.5, 'The meals are so aesthetic...Just Wow!'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReviewCard(String name, double rating, String review) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Color(0xFFF5DEB3),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(name, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.brown)),
                Row(
                  children: [
                    Icon(Icons.star, color: Colors.amber, size: 18),
                    Text(rating.toString(), style: TextStyle(color: Colors.brown)),
                  ],
                ),
              ],
            ),
            SizedBox(height: 5),
            Text(review, style: TextStyle(color: Colors.brown)),
          ],
        ),
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
        setState(() {
          _currentIndex = index;
        });
        switch (index) {
          case 0:
            Navigator.pushNamed(context, '/home');
            break;
          case 1:
            Navigator.pushNamed(context, '/search');
            break;
          case 2:
          // Already on RestaurantScreen, no need to navigate
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