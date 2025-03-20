import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

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
        automaticallyImplyLeading: false, // Remove back button
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

            // Search Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Navigate to the MealScreen when the search button is clicked
                  Navigator.pushNamed(context, '/meals');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.brown[700],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 12),
                ),
                child: Text(
                  "Search",
                  style: TextStyle(fontSize: 18, color: Colors.white),
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
        backgroundColor: Color(0xFFF5E1BE), // Beige background
        selectedItemColor: Colors.brown[700], // Darker icon color when selected
        unselectedItemColor: Colors.brown[400], // Lighter icon color when unselected
        showSelectedLabels: false,
        showUnselectedLabels: false,
        currentIndex: 1, // Search is selected by default
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushNamed(context, '/home');
              break;
            case 1:
            // Already on SearchScreen, no need to navigate
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
          BottomNavigationBarItem(
            icon: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.brown[100], // Lighter circle around the icon
              ),
              child: Icon(Icons.home, color: Colors.brown[700]), // Darker icon
            ),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.brown[100], // Lighter circle around the icon
              ),
              child: Icon(Icons.search, color: Colors.brown[700]), // Darker icon
            ),
            label: "Search",
          ),
          BottomNavigationBarItem(
            icon: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.brown[100], // Lighter circle around the icon
              ),
              child: Icon(Icons.restaurant_menu, color: Colors.brown[700]), // Darker icon
            ),
            label: "Menu",
          ),
          BottomNavigationBarItem(
            icon: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.brown[100], // Lighter circle around the icon
              ),
              child: Icon(Icons.phone, color: Colors.brown[700]), // Darker icon
            ),
            label: "Call",
          ),
          BottomNavigationBarItem(
            icon: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.brown[100], // Lighter circle around the icon
              ),
              child: Icon(Icons.person, color: Colors.brown[700]), // Darker icon
            ),
            label: "Profile",
          ),
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

  const MealCard({super.key, required this.name, required this.price, required this.imageUrl});

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