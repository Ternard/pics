import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final supabase = Supabase.instance.client;
  final List<Map<String, dynamic>> _categories = [
    {'name': 'Drinks', 'icon': Icons.local_drink, 'color': Colors.blue},
    {'name': 'Meals', 'icon': Icons.lunch_dining, 'color': Colors.green},
    {'name': 'Combo', 'icon': Icons.set_meal, 'color': Colors.orange},
    {'name': 'Snacks', 'icon': Icons.fastfood, 'color': Colors.red},
    {'name': 'All', 'icon': Icons.all_inclusive, 'color': Colors.purple},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5E7C5),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Row(
          children: [
            Image.asset(
              'assets/logo.png',
              width: 40,
              height: 40,
              errorBuilder: (context, error, stackTrace) => Icon(Icons.restaurant),
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
              InkWell(
                onTap: () => Navigator.pushNamed(context, '/search'),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.brown[300],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.search, color: Colors.brown[700]),
                      SizedBox(width: 8),
                      Text(
                        'Search Meals',
                        style: TextStyle(
                          color: Colors.brown[700],
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              // Category Tiles Row
              Container(
                height: 110,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _categories.length,
                  itemBuilder: (context, index) {
                    return _buildCategoryTile(_categories[index]);
                  },
                ),
              ),
              SizedBox(height: 20),
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
                  _buildHistoryItem('CJ\'s', 'Kenyan', '4.5(100+ Reviews)', 'assets/cjs.jpg'),
                  _buildHistoryItem('Shawarma Street', 'Kenyan', '3.9(600+ Reviews)', 'assets/shawarma.jpg'),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(0, context),
    );
  }

  Widget _buildCategoryTile(Map<String, dynamic> category) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          '/search',
          arguments: {'preselectedCategory': category['name']},
        );
      },
      child: Container(
        width: 80,
        margin: EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                color: category['color'].withOpacity(0.2),
                shape: BoxShape.circle,
                border: Border.all(
                  color: category['color'].withOpacity(0.5),
                  width: 2,
                ),
              ),
              child: Center(
                child: Icon(
                  category['icon'],
                  size: 30,
                  color: category['color'],
                ),
              ),
            ),
            SizedBox(height: 8),
            Text(
              category['name'],
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.brown[800],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryItem(String name, String type, String rating, String imagePath) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
              child: Image.asset(
                imagePath,
                fit: BoxFit.cover,
                width: double.infinity,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: Colors.grey[200],
                  child: Center(child: Icon(Icons.restaurant, size: 40)),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: TextStyle(fontWeight: FontWeight.bold)),
                Text(type, style: TextStyle(color: Colors.grey[600])),
                Text(rating, style: TextStyle(color: Colors.orange)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  BottomNavigationBar _buildBottomNavigationBar(int currentIndex, BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: Color(0xFFF5E1BE),
      selectedItemColor: Colors.brown[700],
      unselectedItemColor: Colors.brown[400],
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
          color: currentIndex == index ? Colors.brown[700] : Colors.transparent,
        ),
        child: Icon(
          icon,
          color: currentIndex == index ? Colors.white : Colors.brown[700],
        ),
      ),
      label: "",
    );
  }
}