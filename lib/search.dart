import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<String> categories = ["All", "Fast Food", "Drinks", "Desserts", "Meat"];
  int selectedCategoryIndex = 0;

  List<Map<String, String>> meals = [
    {
      "name": "Grilled Meat Platter",
      "price": "1200 Ksh",
      "image": "https://source.unsplash.com/400x300/?meat,grill",
    },
    {
      "name": "Burger & Fries",
      "price": "800 Ksh",
      "image": "https://source.unsplash.com/400x300/?burger,fries",
    },
    {
      "name": "Fresh Fruit Juice",
      "price": "300 Ksh",
      "image": "https://source.unsplash.com/400x300/?juice,fruits",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5E1BE),
      appBar: AppBar(
        backgroundColor: Color(0xFFF5E1BE),
        elevation: 0,
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.white,
              radius: 18,
              child: Icon(Icons.search, color: Colors.black),
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
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10),

            // Search Bar
            TextField(
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search, color: Colors.brown[600]),
                hintText: "Search meals...",
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            SizedBox(height: 15),

            // Category Filters
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(categories.length, (index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedCategoryIndex = index;
                      });
                    },
                    child: Container(
                      margin: EdgeInsets.only(right: 10),
                      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                      decoration: BoxDecoration(
                        color: selectedCategoryIndex == index
                            ? Colors.brown[700]
                            : Colors.brown[300],
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Text(
                        categories[index],
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
            SizedBox(height: 15),

            // Meal List
            Expanded(
              child: ListView.builder(
                itemCount: meals.length,
                itemBuilder: (context, index) {
                  return MealCard(
                    name: meals[index]["name"]!,
                    price: meals[index]["price"]!,
                    imageUrl: meals[index]["image"]!,
                  );
                },
              ),
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

// Meal Card Widget
class MealCard extends StatelessWidget {
  final String name;
  final String price;
  final String imageUrl;

  MealCard({required this.name, required this.price, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      margin: EdgeInsets.only(bottom: 15),
      child: ListTile(
        contentPadding: EdgeInsets.all(10),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.network(imageUrl, width: 60, height: 60, fit: BoxFit.cover),
        ),
        title: Text(
          name,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.brown[800]),
        ),
        subtitle: Text(
          price,
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.brown[600]),
        ),
        trailing: Icon(Icons.arrow_forward_ios, size: 18, color: Colors.brown[600]),
        onTap: () {
          // Navigate to meal details (restaurant.dart)
          Navigator.pushNamed(context, "/restaurant");
        },
      ),
    );
  }
}
