import 'package:flutter/material.dart';

class MealScreen extends StatefulWidget {
  const MealScreen({super.key});

  @override
  _MealScreenState createState() => _MealScreenState();
}

class _MealScreenState extends State<MealScreen> {
  int _currentIndex = 2; // Track the current index

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            // Already on MealScreen, no need to navigate
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
      body: SafeArea(
        child: Column(
          children: [
            // Header with image
            Stack(
              children: [
                ClipPath(
                  clipper: CurvedClipper(),
                  child: Image.asset(
                    'assets/steak_plate.jpg', // Replace with your image asset
                    width: double.infinity,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  bottom: 15,
                  left: MediaQuery.of(context).size.width / 2 - 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.brown,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {},
                    child: Text('Add to plate', style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),

            // Meal details
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.location_on, color: Colors.brown),
                          SizedBox(width: 5),
                          Text('Location', style: TextStyle(color: Colors.brown)),
                        ],
                      ),
                      Text('1500 Ksh', style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                  SizedBox(height: 10),
                  Text('Steak Plate', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  SizedBox(height: 5),
                  Text('Meal Description', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 5),
                  Text(
                    'A perfectly seared steak, cooked to your desired doneness, served with a side of creamy mashed potatoes, sautéed greens, and a rich, velvety sauce.',
                    style: TextStyle(color: Colors.black54),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),

            // Customer reviews
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildReviewCard('Brandon White', '4.2', 'Best Customer Service I’ve ever had...'),
                  _buildReviewCard('Victoria Malen', '', 'The meals are so flavorful & aesthetic...'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReviewCard(String name, String rating, String review) {
    return Container(
      padding: EdgeInsets.all(10),
      width: 150,
      decoration: BoxDecoration(
        color: Color(0xFFF5DEB3), // Beige color
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.account_circle, color: Colors.brown),
              SizedBox(width: 5),
              Text(name, style: TextStyle(fontWeight: FontWeight.bold)),
              if (rating.isNotEmpty) ...[
                SizedBox(width: 5),
                Icon(Icons.star, color: Colors.orange, size: 16),
                Text(rating),
              ]
            ],
          ),
          SizedBox(height: 5),
          Text(
            review,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: Colors.black54),
          ),
        ],
      ),
    );
  }
}

// Custom clipper for curved image
class CurvedClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 50);
    path.quadraticBezierTo(size.width / 2, size.height, size.width, size.height - 50);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

void main() => runApp(MaterialApp(
  debugShowCheckedModeBanner: false,
  home: MealScreen(),
));