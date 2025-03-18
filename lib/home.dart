import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatelessWidget {
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
        children: [
          // Restaurant Image with Curve
          ClipRRect(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(40)),
            child: Image.asset(
              'assets/images/restaurant.jpg', // Replace with actual image asset
              width: double.infinity,
              height: 200,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(height: 20),

          // Restaurant Info
          Text(
            "CJ’s",
            style: GoogleFonts.playfairDisplay(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Colors.brown[700],
            ),
          ),
          SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.location_on, color: Colors.brown[600], size: 18),
              SizedBox(width: 5),
              Text(
                "Restaurant Location",
                style: TextStyle(color: Colors.brown[600], fontSize: 16),
              ),
            ],
          ),
          SizedBox(height: 15),

          // Menu Button
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.brown[700],
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
              // Navigate to menu page (implement later)
            },
            child: Text("Menu", style: TextStyle(color: Colors.white, fontSize: 18)),
          ),
          SizedBox(height: 20),

          // User Reviews Section
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ReviewCard(name: "Brandon White", rating: 4.2, review: "Best Customer Services I've ever had..."),
              ReviewCard(name: "Victoria Malen", rating: 4.0, review: "The meals are so aesthetic...Just wow!"),
            ],
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

// Review Card Widget
class ReviewCard extends StatelessWidget {
  final String name;
  final double rating;
  final String review;

  ReviewCard({required this.name, required this.rating, required this.review});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Color(0xFFEED9B5),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$name  ★ $rating",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.brown[800]),
          ),
          SizedBox(height: 5),
          Text(
            review,
            style: TextStyle(color: Colors.brown[600]),
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
          ),
        ],
      ),
    );
  }
}
