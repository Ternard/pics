import 'package:flutter/material.dart';
import 'new_meal.dart'; // Import the NewMealScreen
import 'meal_review.dart'; // Import the MealReviewScreen

class MealScreen extends StatefulWidget {
  const MealScreen({super.key});

  @override
  _MealScreenState createState() => _MealScreenState();
}

class _MealScreenState extends State<MealScreen> {
  int _currentIndex = 2; // Track the current index
  final PageController _pageController = PageController(); // PageView controller

  // Function to show the "Add New Meal" pop-up
  void _showAddMealPopup(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Allow the pop-up to be scrollable
      backgroundColor: Colors.transparent, // Make the background transparent
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom, // Adjust for keyboard
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: SingleChildScrollView(
            child: NewMealScreen(
              onSubmit: (bool success) {
                Navigator.pop(context); // Close the pop-up
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(success ? "Meal Added" : "Error"),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  // Function to show the "Add New Review" pop-up
  void _showAddReviewPopup(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Allow the pop-up to be scrollable
      backgroundColor: Colors.transparent, // Make the background transparent
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom, // Adjust for keyboard
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: SingleChildScrollView(
            child: MealReviewScreen(
              onSubmit: (bool success) {
                Navigator.pop(context); // Close the pop-up
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(success ? "Review Added" : "Error"),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: _buildBottomNavigationBar(_currentIndex, context),
      body: SafeArea(
        child: Column(
          children: [
            // PageView for horizontal navigation
            Expanded(
              child: Stack(
                children: [
                  PageView(
                    controller: _pageController,
                    children: [
                      // Page 1
                      _buildMealPage(),
                      // Page 2 (Add more pages as needed)
                      _buildMealPage(),
                      _buildMealPage(),
                    ],
                  ),
                  // Left Arrow
                  Positioned(
                    left: 10,
                    top: MediaQuery.of(context).size.height / 2 - 20,
                    child: IconButton(
                      icon: Icon(Icons.arrow_back_ios, color: Colors.brown),
                      onPressed: () {
                        _pageController.previousPage(
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      },
                    ),
                  ),
                  // Right Arrow
                  Positioned(
                    right: 10,
                    top: MediaQuery.of(context).size.height / 2 - 20,
                    child: IconButton(
                      icon: Icon(Icons.arrow_forward_ios, color: Colors.brown),
                      onPressed: () {
                        _pageController.nextPage(
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      // Add New Meal and Add New Review Buttons
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(left: 30, right: 30, bottom: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            FloatingActionButton(
              onPressed: () {
                _showAddMealPopup(context); // Show the "Add New Meal" pop-up
              },
              backgroundColor: Colors.brown,
              child: const Icon(Icons.add, color: Colors.white),
            ),
            FloatingActionButton(
              onPressed: () {
                _showAddReviewPopup(context); // Show the "Add New Review" pop-up
              },
              backgroundColor: Colors.brown,
              child: const Icon(Icons.edit, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  // Build a single meal page
  Widget _buildMealPage() {
    return SingleChildScrollView(
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
            ],
          ),
          // Add to Plate button below the image
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.brown,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {},
              child: const Text('Add to plate', style: TextStyle(color: Colors.white)),
            ),
          ),
          const SizedBox(height: 20),

          // Meal details
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.location_on, color: Colors.brown),
                        const SizedBox(width: 5),
                        Text('Location', style: TextStyle(color: Colors.brown)),
                      ],
                    ),
                    Text('1500 Ksh', style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 10),
                Text('Steak Plate', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                const SizedBox(height: 5),
                Text('Meal Description', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 5),
                Text(
                  'A perfectly seared steak, cooked to your desired doneness, served with a side of creamy mashed potatoes, sautéed greens, and a rich, velvety sauce.',
                  style: TextStyle(color: Colors.black54),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),

          // Customer reviews with horizontal scroll
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Customer Reviews', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                SizedBox(
                  height: 180, // Fixed height for the reviews section
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildReviewCard('Brandon White', '4.2', 'Best Customer Service I’ve ever had...'),
                        const SizedBox(width: 10),
                        _buildReviewCard('Victoria Malen', '', 'The meals are so flavorful & aesthetic...'),
                        const SizedBox(width: 10),
                        _buildReviewCard('John Doe', '4.8', 'Amazing food and great service!'),
                        const SizedBox(width: 10),
                        _buildReviewCard('Jane Smith', '4.5', 'Highly recommend this place!'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // Review Card Widget
  Widget _buildReviewCard(String name, String rating, String review) {
    return Container(
      padding: const EdgeInsets.all(12),
      width: 160, // Fixed width for each review card
      decoration: BoxDecoration(
        color: const Color(0xFFF5DEB3), // Beige color
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Name
          Text(
            name,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 5),

          // Star Rating (if rating is not empty)
          if (rating.isNotEmpty)
            Row(
              children: [
                Icon(Icons.star, color: Colors.orange, size: 18),
                const SizedBox(width: 5),
                Text(rating, style: TextStyle(fontSize: 16)),
              ],
            ),
          const SizedBox(height: 5),

          // Review Text
          Text(
            review,
            maxLines: 3, // Limit to 3 lines
            overflow: TextOverflow.ellipsis, // Add ellipsis if text overflows
            style: TextStyle(color: Colors.black54, fontSize: 14),
          ),
        ],
      ),
    );
  }

  // Bottom Navigation Bar
  Widget _buildBottomNavigationBar(int currentIndex, BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: const Color(0xFFF5E1BE), // Beige background
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
        padding: const EdgeInsets.all(8),
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