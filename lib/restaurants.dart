import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'new_restaurant.dart';
import 'restaurant_review.dart';
import 'menu.dart';

class RestaurantScreen extends StatefulWidget {
  const RestaurantScreen({super.key});

  @override
  State<RestaurantScreen> createState() => _RestaurantScreenState();
}

class _RestaurantScreenState extends State<RestaurantScreen> {
  final SupabaseClient supabase = Supabase.instance.client;
  final PageController _pageController = PageController();
  List<Map<String, dynamic>> _restaurants = [];
  bool _isLoading = true;
  String? _errorMessage;
  int _currentIndex = 2;

  @override
  void initState() {
    super.initState();
    _fetchRestaurants();
  }

  Future<void> _fetchRestaurants() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final response = await supabase
          .from('restaurants')
          .select('*')
          .order('created_at', ascending: false);

      setState(() {
        _restaurants = List<Map<String, dynamic>>.from(response);
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = "Failed to load restaurants: ${e.toString()}";
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
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to open map: ${e.toString()}')),
        );
      }
    }
  }

  void _showMenuPopup(BuildContext context, Map<String, dynamic> restaurant) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: MenuScreen(restaurant: restaurant),
      ),
    );
  }

  void _showAddRestaurantPopup(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SingleChildScrollView(
          child: NewRestaurantScreen(
            onSubmit: (success, message) {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(message ?? (success ? "Restaurant Added" : "Error")),
                  backgroundColor: success ? Colors.green : Colors.red,
                ),
              );
              if (success) _fetchRestaurants();
            },
          ),
        ),
      ),
    );
  }

  void _showAddReviewPopup(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SingleChildScrollView(
          child: RestaurantReviewScreen(
            onSubmit: (success, message) {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(message ?? (success ? "Review Added" : "Error")),
                  backgroundColor: success ? Colors.green : Colors.red,
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: _buildBottomNavigationBar(),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  if (_isLoading)
                    const Center(child: CircularProgressIndicator())
                  else if (_errorMessage != null)
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.error, size: 50, color: Colors.red),
                          const SizedBox(height: 20),
                          Text(
                            "Error loading restaurants",
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            _errorMessage!,
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.red),
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: _fetchRestaurants,
                            child: const Text("Retry"),
                          ),
                        ],
                      ),
                    )
                  else if (_restaurants.isEmpty)
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.restaurant, size: 50, color: Colors.brown),
                            const SizedBox(height: 20),
                            Text(
                              "No restaurants found",
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              "Add a new restaurant to get started",
                              style: TextStyle(color: Colors.brown),
                            ),
                          ],
                        ),
                      )
                    else
                      PageView.builder(
                        controller: _pageController,
                        itemCount: _restaurants.length,
                        itemBuilder: (context, index) {
                          return _buildRestaurantPage(_restaurants[index]);
                        },
                      ),
                  if (_restaurants.isNotEmpty && _restaurants.length > 1)
                    Positioned(
                      left: 10,
                      top: MediaQuery.of(context).size.height / 2 - 20,
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back_ios, color: Colors.brown),
                        onPressed: () => _pageController.previousPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        ),
                      ),
                    ),
                  if (_restaurants.isNotEmpty && _restaurants.length > 1)
                    Positioned(
                      right: 10,
                      top: MediaQuery.of(context).size.height / 2 - 20,
                      child: IconButton(
                        icon: const Icon(Icons.arrow_forward_ios, color: Colors.brown),
                        onPressed: () => _pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(left: 30, right: 30, bottom: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            FloatingActionButton(
              onPressed: () => _showAddRestaurantPopup(context),
              backgroundColor: Colors.brown,
              child: const Icon(Icons.add, color: Colors.white),
            ),
            FloatingActionButton(
              onPressed: () => _showAddReviewPopup(context),
              backgroundColor: Colors.brown,
              child: const Icon(Icons.edit, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRestaurantPage(Map<String, dynamic> restaurant) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: const Color(0xFFF5DEB3),
            child: Row(
              children: [
                const Icon(Icons.restaurant, color: Colors.brown),
                const SizedBox(width: 8),
                Text(
                  'MealMeter',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.brown[700],
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          ClipRRect(
            borderRadius: const BorderRadius.vertical(bottom: Radius.circular(30)),
            child: Image.network(
              restaurant['image.url'] ?? 'https://source.unsplash.com/400x300/?restaurant',
              width: double.infinity,
              height: 200,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Image.network(
                'https://source.unsplash.com/400x300/?restaurant',
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            restaurant['res.name'] ?? 'Restaurant Name',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: Colors.brown[700],
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          InkWell(
            onTap: () {
              final locationUrl = restaurant['location.url'];
              if (locationUrl != null && locationUrl.isNotEmpty) {
                _launchMapsUrl(locationUrl);
              }
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.location_on, color: Colors.brown),
                const SizedBox(width: 5),
                Text(
                  restaurant['location.url'] != null ? "View on Map" : "Location not available",
                  style: TextStyle(
                    color: Colors.brown[700],
                    decoration: restaurant['location.url'] != null
                        ? TextDecoration.underline
                        : TextDecoration.none,
                  ),
                ),
                if (restaurant['location.url'] != null)
                  const Icon(Icons.open_in_new, size: 16, color: Colors.brown),
              ],
            ),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.brown,
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
            ),
            onPressed: () => _showMenuPopup(context, restaurant),
            child: const Text('Menu', style: TextStyle(color: Colors.white)),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Customer Reviews',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.brown[700],
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 180,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildReviewCard('Brandon White', '4.2', 'Best service ever!'),
                        const SizedBox(width: 10),
                        _buildReviewCard('Victoria Malen', '4.5', 'Amazing food!'),
                        const SizedBox(width: 10),
                        _buildReviewCard('John Doe', '4.8', 'Highly recommended!'),
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

  Widget _buildReviewCard(String name, String rating, String review) {
    return Container(
      width: 160,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF5DEB3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 5),
          Row(
            children: [
              const Icon(Icons.star, color: Colors.orange, size: 18),
              const SizedBox(width: 5),
              Text(rating, style: const TextStyle(fontSize: 16)),
            ],
          ),
          const SizedBox(height: 5),
          Text(
            review,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: Colors.black54, fontSize: 14),
          ),
        ],
      ),
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
            Navigator.pushNamed(context, '/search');
            break;
          case 2:
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
        _buildNavItem(Icons.home, 0),
        _buildNavItem(Icons.search, 1),
        _buildNavItem(Icons.restaurant_menu, 2),
        _buildNavItem(Icons.phone, 3),
        _buildNavItem(Icons.person, 4),
      ],
    );
  }

  BottomNavigationBarItem _buildNavItem(IconData icon, int index) {
    final isSelected = _currentIndex == index;
    return BottomNavigationBarItem(
      icon: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isSelected ? Colors.brown[700] : Colors.brown[100],
        ),
        child: Icon(
          icon,
          color: isSelected ? Colors.white : Colors.brown[700],
        ),
      ),
      label: "",
    );
  }
}