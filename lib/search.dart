import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'new_event.dart';
import 'event_provider.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final SupabaseClient supabase = Supabase.instance.client;
  final TextEditingController _searchController = TextEditingController();
  String? _selectedCategory;
  final List<String> _categories = [
    "All",
    "Drinks",
    "Meals",
    "Snacks",
    "Combo Meals"
  ];
  List<Map<String, dynamic>> _searchResults = [];
  bool _isSearching = false;
  int _currentIndex = 1;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      if (args != null && args['preselectedCategory'] != null) {
        setState(() {
          _selectedCategory = args['preselectedCategory'];
        });
      }
    });
  }

  void _showAddMealDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: SingleChildScrollView(
            child: NewMealScreen(
              onSubmit: (bool success) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(success ? "Meal Added Successfully" : "Error Adding Meal"),
                    backgroundColor: success ? Colors.green : Colors.red,
                  ),
                );
                if (success) {
                  _searchMeals();
                }
              },
            ),
          ),
        );
      },
    );
  }

  Future<void> _searchMeals() async {
    if (_searchController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a price to search')),
      );
      return;
    }

    setState(() {
      _isSearching = true;
      _searchResults = [];
    });

    try {
      final price = double.tryParse(_searchController.text);
      if (price == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter a valid price')),
        );
        return;
      }

      List<Map<String, dynamic>> results = [];

      if (_selectedCategory == null || _selectedCategory == "All") {
        // Search all tables
        final drinks = await supabase
            .from('drinks')
            .select()
            .lte('drinks_price', price);
        final meals = await supabase
            .from('food')
            .select()
            .lte('food_price', price);
        final snacks = await supabase
            .from('snacks')
            .select()
            .lte('snacks_price', price);
        final combos = await supabase
            .from('combo')
            .select()
            .lte('combo_price', price);

        results = [
          ...drinks.map((e) => {
            ...e,
            'category': 'Drinks',
            'name': e['drinks_name'],
            'price': e['drinks_price'],
            'desc': e['drinks_desc'],
            'image_url': e['image.url'],
            'location.url': e['location.url'],
          }),
          ...meals.map((e) => {
            ...e,
            'category': 'Meals',
            'name': e['food_name'],
            'price': e['food_price'],
            'desc': e['food_desc'],
            'image_url': e['image.url'],
            'location.url': e['location.url'],
          }),
          ...snacks.map((e) => {
            ...e,
            'category': 'Snacks',
            'name': e['snacks_name'],
            'price': e['snacks_price'],
            'desc': e['snacks_desc'],
            'image_url': e['image.url'],
            'location.url': e['location.url'],
          }),
          ...combos.map((e) => {
            ...e,
            'category': 'Combo Meals',
            'name': e['combo_name'],
            'price': e['combo_price'],
            'desc': e['combo_desc'],
            'image_url': e['image.url'],
            'location.url': e['location.url'],
          }),
        ];
      } else {
        // Search specific table based on category
        switch (_selectedCategory) {
          case "Drinks":
            results = (await supabase
                .from('drinks')
                .select()
                .lte('drinks_price', price))
                .map((e) => {
              ...e,
              'category': 'Drinks',
              'name': e['drinks_name'],
              'price': e['drinks_price'],
              'desc': e['drinks_desc'],
              'image_url': e['image.url'],
              'location.url': e['location.url'],
            })
                .toList();
            break;
          case "Meals":
            results = (await supabase
                .from('food')
                .select()
                .lte('food_price', price))
                .map((e) => {
              ...e,
              'category': 'Meals',
              'name': e['food_name'],
              'price': e['food_price'],
              'desc': e['food_desc'],
              'image_url': e['image.url'],
              'location.url': e['location.url'],
            })
                .toList();
            break;
          case "Snacks":
            results = (await supabase
                .from('snacks')
                .select()
                .lte('snacks_price', price))
                .map((e) => {
              ...e,
              'category': 'Snacks',
              'name': e['snacks_name'],
              'price': e['snacks_price'],
              'desc': e['snacks_desc'],
              'image_url': e['image.url'],
              'location.url': e['location.url'],
            })
                .toList();
            break;
          case "Combo Meals":
            results = (await supabase
                .from('combo')
                .select()
                .lte('combo_price', price))
                .map((e) => {
              ...e,
              'category': 'Combo Meals',
              'name': e['combo_name'],
              'price': e['combo_price'],
              'desc': e['combo_desc'],
              'image_url': e['image.url'],
              'location.url': e['location.url'],
            })
                .toList();
            break;
        }
      }

      setState(() {
        _searchResults = results;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Search failed: $e')),
      );
    } finally {
      setState(() {
        _isSearching = false;
      });
    }
  }

  Future<void> _launchMapsUrl(String url) async {
    try {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(
          uri,
          mode: LaunchMode.externalApplication,
        );
      } else {
        throw 'Could not launch $url';
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to open map: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final plateProvider = Provider.of<PlateProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF5E7C5),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'Search',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.brown,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddMealDialog,
        backgroundColor: Colors.brown[700],
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Column(
                children: [
                  Image.asset(
                    'assets/logo.png',
                    width: 80,
                    height: 80,
                    errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.restaurant, size: 80, color: Colors.brown),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Pics',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.brown,
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),

              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        labelText: 'Search by maximum price (Ksh)',
                        border: OutlineInputBorder(),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: _searchMeals,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.brown[700],
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Search'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: InputDecoration(
                  labelText: 'Filter by category',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white,
                ),
                items: _categories.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _selectedCategory = newValue;
                  });
                },
              ),
              const SizedBox(height: 20),
              if (_isSearching)
                const Center(child: CircularProgressIndicator())
              else if (_searchResults.isEmpty && _searchController.text.isNotEmpty)
                const Column(
                  children: [
                    Icon(Icons.search_off, size: 50, color: Colors.brown),
                    SizedBox(height: 10),
                    Text(
                      'No meals found matching your criteria',
                      style: TextStyle(color: Colors.brown),
                    ),
                  ],
                )
              else
                ..._searchResults.map((meal) {
                  return Card(
                    margin: const EdgeInsets.only(bottom: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(15)),
                          child: Image.network(
                            meal['image_url'] ??
                                'https://via.placeholder.com/400x300?text=No+Image',
                            width: double.infinity,
                            height: 200,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Container(
                                  height: 200,
                                  color: Colors.grey[200],
                                  child: const Center(
                                      child: Icon(Icons.fastfood, size: 50)),
                                ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                meal['name'] ?? 'No name',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  const Icon(Icons.category,
                                      size: 16, color: Colors.brown),
                                  const SizedBox(width: 5),
                                  Text(
                                    meal['category'] ?? 'No category',
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              InkWell(
                                onTap: () {
                                  if (meal['location.url'] != null) {
                                    _launchMapsUrl(meal['location.url']);
                                  }
                                },
                                child: Row(
                                  children: [
                                    const Icon(Icons.location_on,
                                        size: 16, color: Colors.brown),
                                    const SizedBox(width: 5),
                                    Text(
                                      meal['location.url'] != null
                                          ? 'View on Map'
                                          : 'Location not available',
                                      style: TextStyle(
                                        color: meal['location.url'] != null
                                            ? Colors.blue
                                            : Colors.grey,
                                        decoration: meal['location.url'] != null
                                            ? TextDecoration.underline
                                            : null,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  const Icon(Icons.attach_money,
                                      size: 16, color: Colors.brown),
                                  const SizedBox(width: 5),
                                  Text(
                                    'Ksh ${meal['price']?.toString() ?? '0'} ',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                meal['desc'] ?? 'No description available',
                                style: const TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 10),
                              ElevatedButton(
                                onPressed: () {
                                  plateProvider.addToPlate(meal);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('${meal['name']} added to your plate!'),
                                      backgroundColor: Colors.green,
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.brown[700],
                                  foregroundColor: Colors.white,
                                  minimumSize: const Size(double.infinity, 40),
                                ),
                                child: const Text('Add to Plate'),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  BottomNavigationBar _buildBottomNavigationBar() {
    return BottomNavigationBar(
      backgroundColor: const Color(0xFFF5E1BE),
      selectedItemColor: Colors.brown[700],
      unselectedItemColor: Colors.brown[400],
      showSelectedLabels: false,
      showUnselectedLabels: false,
      currentIndex: _currentIndex,
      onTap: (index) {
        setState(() => _currentIndex = index);
        switch (index) {
          case 0:
            Navigator.pushNamed(context, '/home');
            break;
          case 1:
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
        _buildBottomNavigationBarItem(Icons.home, 0),
        _buildBottomNavigationBarItem(Icons.search, 1),
        _buildBottomNavigationBarItem(Icons.restaurant_menu, 2),
        _buildBottomNavigationBarItem(Icons.phone, 3),
        _buildBottomNavigationBarItem(Icons.person, 4),
      ],
    );
  }

  BottomNavigationBarItem _buildBottomNavigationBarItem(IconData icon, int index) {
    final isSelected = _currentIndex == index;
    return BottomNavigationBarItem(
      icon: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isSelected ? Colors.brown[700] : Colors.transparent,
        ),
        child: Icon(
          icon,
          color: isSelected ? Colors.white : Colors.brown[700],
        ),
      ),
      label: "",
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}