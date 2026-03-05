import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'event_provider.dart';

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
    final plateProvider = Provider.of<PlateProvider>(context);

    return Scaffold(
      backgroundColor: Color(0xFFF5E7C5),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false, // This removes the back arrow
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
              'Pics',
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
                'Your Plate...',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.brown,
                ),
              ),
              SizedBox(height: 10),
              if (plateProvider.plateItems.isEmpty)
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      'No items in your plate yet. Search and add meals!',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                )
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: plateProvider.plateItems.length,
                  itemBuilder: (context, index) {
                    final item = plateProvider.plateItems[index];
                    return _buildPlateItem(item, index, plateProvider);
                  },
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

  Widget _buildPlateItem(Map<String, dynamic> item, int index, PlateProvider plateProvider) {
    return Card(
      margin: EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                item['image_url'] ?? 'https://via.placeholder.com/100?text=No+Image',
                width: 60,
                height: 60,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 60,
                  height: 60,
                  color: Colors.grey[200],
                  child: Center(child: Icon(Icons.fastfood)),
                ),
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item['name'] ?? 'No name',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    item['category'] ?? 'No category',
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),
                  Text(
                    'Ksh ${item['price']?.toString() ?? '0'}',
                    style: TextStyle(color: Colors.brown[700]),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: () => plateProvider.removeFromPlate(index),
            ),
          ],
        ),
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