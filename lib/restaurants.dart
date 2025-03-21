import 'package:flutter/material.dart';
import 'new_restaurant.dart'; // Import the NewRestaurantScreen
import 'restaurant_review.dart'; // Import the RestaurantReviewScreen

class RestaurantScreen extends StatefulWidget {
  const RestaurantScreen({super.key});

  @override
  _RestaurantScreenState createState() => _RestaurantScreenState();
}

class _RestaurantScreenState extends State<RestaurantScreen> {
  int _currentIndex = 2; // Track the current index

  // Function to show the "Add New Restaurant" pop-up
  void _showAddRestaurantPopup(BuildContext context) {
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
            child: NewRestaurantScreen(
              onSubmit: (bool success) {
                Navigator.pop(context); // Close the pop-up
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(success ? "Submission Added" : "Error"),
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
            child: RestaurantReviewScreen(
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
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(16.0),
                color: const Color(0xFFF5DEB3), // Beige color
                child: Row(
                  children: [
                    Icon(Icons.restaurant, color: Colors.brown),
                    const SizedBox(width: 8.0),
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
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(30)),
                child: Image.network(
                  'https://source.unsplash.com/400x300/?restaurant',
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Shawarma Street',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.brown,
                ),
              ),
              const SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.location_on, color: Colors.brown),
                  const SizedBox(width: 5),
                  Text(
                    'Restaurant Location',
                    style: TextStyle(color: Colors.brown),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.brown,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                ),
                onPressed: () {},
                child: const Text('Menu', style: TextStyle(color: Colors.white)),
              ),
              const SizedBox(height: 20),

              // Reviews Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Customer Reviews',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 180, // Fixed height for the reviews section
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            _buildReviewCard('Brandon White', '4.2', 'Best Customer Services I’ve ever had...'),
                            const SizedBox(width: 10),
                            _buildReviewCard('Victoria Malen', '4.5', 'The meals are so aesthetic...Just Wow!'),
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
        ),
      ),

      // Add New Restaurant and Add New Review Buttons
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(left: 30, right: 30, bottom: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            FloatingActionButton(
              onPressed: () {
                _showAddRestaurantPopup(context); // Show the "Add New Restaurant" pop-up
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