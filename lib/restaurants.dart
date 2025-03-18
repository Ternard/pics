import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RestaurantScreen extends StatelessWidget {
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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 10),

            // Food Image
            ClipRRect(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(50),
                bottomRight: Radius.circular(50),
              ),
              child: Image.network(
                "https://source.unsplash.com/400x300/?food,meat", // Replace with actual image URL
                height: 250,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),

            // Add to Plate Button
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.brown[700],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Text("Add to plate", style: TextStyle(fontSize: 18, color: Colors.white)),
              ),
            ),
            SizedBox(height: 20),

            // Location & Price
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.location_on, color: Colors.brown[700]),
                      SizedBox(width: 5),
                      Text("Location", style: TextStyle(fontSize: 16, color: Colors.brown[800])),
                    ],
                  ),
                  Text("1200 Ksh", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.brown[800])),
                ],
              ),
            ),
            SizedBox(height: 15),

            // Meal Title
            Text(
              "Meat Platter",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.brown[800]),
            ),
            SizedBox(height: 10),

            // Meal Description
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Text(
                "An assortment of grilled meats, including succulent lamb, chicken kebabs, and beef skewers, accompanied by a side of flatbread and flavorful dipping sauces.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.brown[700]),
              ),
            ),
            SizedBox(height: 20),

            // Customer Reviews
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ReviewCard(
                  name: "Brandon White",
                  rating: "4.2",
                  review: "Best Customer Services I've ever had...",
                ),
                SizedBox(width: 10),
                ReviewCard(
                  name: "Victoria Malen",
                  rating: "4.5",
                  review: "The meals are so aesthetic... Just wow!",
                ),
              ],
            ),
          ],
        ),
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
  final String rating;
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
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.brown[800]),
          ),
          SizedBox(height: 5),
          Text(
            review,
            style: TextStyle(fontSize: 12, color: Colors.brown[700]),
          ),
        ],
      ),
    );
  }
}
