import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  int _currentIndex = 1; // Track the current index
  String? _selectedPeopleRange; // For No. of People dropdown
  String? _selectedFoodType; // For Food Type dropdown

  // Dropdown options for No. of People
  final List<String> _peopleRanges = [
    'Below 5',
    '6-10',
    '11-15',
    '16-20',
    'Above 20',
  ];

  // Dropdown options for Food Type
  final List<String> _foodTypes = [
    'Drinks',
    'Meals',
    'Snacks',
    'Combined Meals',
  ];

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
                    Image.asset(
                      'assets/logo.png', // Replace with your logo asset
                      width: 40,
                      height: 40,
                    ),
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
              const SizedBox(height: 30),

              // Location Input Field
              _buildInputField(Icons.location_on, 'Location', isDropdown: false),
              const SizedBox(height: 10),

              // Budget Input Field
              _buildInputField(Icons.attach_money, 'Budget (Ksh)', isDropdown: false),
              const SizedBox(height: 10),

              // No. of People Dropdown
              _buildInputField(Icons.people, 'No. of People', isDropdown: true, dropdownItems: _peopleRanges, selectedValue: _selectedPeopleRange, onChanged: (value) {
                setState(() {
                  _selectedPeopleRange = value; // Update selected value
                });
              }),
              const SizedBox(height: 10),

              // Food Type Dropdown
              _buildInputField(Icons.fastfood, 'Food Type', isDropdown: true, dropdownItems: _foodTypes, selectedValue: _selectedFoodType, onChanged: (value) {
                setState(() {
                  _selectedFoodType = value; // Update selected value
                });
              }),
              const SizedBox(height: 20),

              // Search Meals Button
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.brown,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  // Navigate to the MealScreen
                  Navigator.pushNamed(context, '/meals');
                },
                child: const Text('Search Meals', style: TextStyle(color: Colors.white)),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // Custom Input Field Widget
  Widget _buildInputField(
      IconData icon,
      String hintText, {
        bool isDropdown = false,
        List<String>? dropdownItems,
        String? selectedValue,
        Function(String?)? onChanged,
      }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(
          color: const Color(0xFFF5DEB3), // Beige color
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
            children: [
            Icon(icon, color: Colors.brown),
        const SizedBox(width: 10),
        Expanded(
          child: isDropdown
              ? DropdownButton<String>(
            value: selectedValue,
            hint: Text(hintText, style: TextStyle(color: Colors.brown)),
            items: dropdownItems?.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value, style: TextStyle(color: Colors.brown)),
              );
            }).toList(),
            onChanged: onChanged,
            underline: const SizedBox(), // Remove the default underline
            isExpanded: true, // Allow the dropdown to expand
          )
              : TextField(
            decoration: InputDecoration(
                hintText: hintText,
                border: InputBorder.none,
                hintStyle: TextStyle(color: Colors.brown)),
          ),
        ),

      ],
    ),
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
        setState(() {
          _currentIndex = index; // Update the current index
        });
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