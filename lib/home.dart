import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final supabase = Supabase.instance.client;
  Position? _currentPosition;
  bool _isLoading = true;
  String _locationError = '';
  List<Map<String, dynamic>> _restaurants = [];

  @override
  void initState() {
    super.initState();
    _getLocationAndRestaurants();
  }

  Future<void> _getLocationAndRestaurants() async {
    await _getUserLocation();
    await _fetchRestaurants();
  }

  Future<void> _getUserLocation() async {
    setState(() {
      _isLoading = true;
      _locationError = '';
    });

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() {
          _locationError = 'Please enable location services';
          _isLoading = false;
        });
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() {
            _locationError = 'Location permissions are denied';
            _isLoading = false;
          });
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        setState(() {
          _locationError = 'Location permissions are permanently denied';
          _isLoading = false;
        });
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
      );

      setState(() {
        _currentPosition = position;
      });
    } catch (e) {
      setState(() {
        _locationError = 'Error getting location: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  Future<void> _fetchRestaurants() async {
    try {
      final response = await supabase
          .from('restaurants')
          .select('res.name, location.url, image.url, latitude, longitude');

      if (_currentPosition != null) {
        List<Map<String, dynamic>> restaurantsWithDistance = response.map((restaurant) {
          double distance = Geolocator.distanceBetween(
            _currentPosition!.latitude,
            _currentPosition!.longitude,
            restaurant['latitude'] ?? 0,
            restaurant['longitude'] ?? 0,
          ) / 1000;

          return {
            ...restaurant,
            'distance': distance,
            'distanceText': distance < 1
                ? '${(distance * 1000).toStringAsFixed(0)} m Away'
                : '${distance.toStringAsFixed(1)} km Away',
          };
        }).toList();

        restaurantsWithDistance.sort((a, b) => a['distance'].compareTo(b['distance']));

        setState(() {
          _restaurants = restaurantsWithDistance;
        });
      } else {
        setState(() {
          _restaurants = List<Map<String, dynamic>>.from(response);
        });
      }
    } catch (e) {
      setState(() {
        _locationError = 'Error loading restaurants: ${e.toString()}';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Widget _buildRestaurantCard(Map<String, dynamic> restaurant) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          '/restaurant',
          arguments: restaurant,
        );
      },
      child: Container(
        width: 180,
        margin: EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 6,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
              child: Image.network(
                restaurant['image.url'] ?? 'https://via.placeholder.com/180',
                height: 120,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 120,
                  color: Colors.grey[200],
                  child: Icon(Icons.restaurant, size: 40),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    restaurant['res.name'] ?? 'Restaurant',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4),
                  if (restaurant['distanceText'] != null)
                    Text(
                      restaurant['distanceText'],
                      style: TextStyle(
                        color: Colors.brown[700],
                        fontSize: 14,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryItem(String name, String type, String rating, String imagePath) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
              child: Image.asset(
                imagePath,
                fit: BoxFit.cover,
                width: double.infinity,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: Colors.grey[200],
                  child: Center(child: Icon(Icons.restaurant, size: 40)),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: TextStyle(fontWeight: FontWeight.bold)),
                Text(type, style: TextStyle(color: Colors.grey[600])),
                Text(rating, style: TextStyle(color: Colors.orange)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5E7C5),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Row(
          children: [
            Image.asset(
              'assets/logo.png',
              width: 40,
              height: 40,
              errorBuilder: (context, error, stackTrace) => Icon(Icons.restaurant),
            ),
            SizedBox(width: 8),
            Text(
              'MealMeter',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.brown,
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Find the perfect meal within your Budget',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.brown,
                ),
              ),
              SizedBox(height: 10),
              InkWell(
                onTap: () => Navigator.pushNamed(context, '/search'),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.brown[300],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.search, color: Colors.brown[700]),
                      SizedBox(width: 8),
                      Text(
                        'Search Meals',
                        style: TextStyle(
                          color: Colors.brown[700],
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Restaurants near you...',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              if (_isLoading)
                Center(child: CircularProgressIndicator())
              else if (_locationError.isNotEmpty)
                Column(
                  children: [
                    Icon(Icons.location_off, size: 40, color: Colors.brown[700]),
                    SizedBox(height: 8),
                    Text(
                      _locationError,
                      style: TextStyle(color: Colors.brown[700]),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: _getLocationAndRestaurants,
                      child: Text('Enable Location'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.brown[700],
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                )
              else
                SizedBox(
                  height: 220,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _restaurants.length,
                    itemBuilder: (context, index) => _buildRestaurantCard(_restaurants[index]),
                  ),
                ),
              SizedBox(height: 20),
              Text(
                'Your History...',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                children: [
                  _buildHistoryItem('CJ\'s', 'Kenyan', '4.5(100+ Reviews)', 'assets/cjs.jpg'),
                  _buildHistoryItem('Shawarma Street', 'Kenyan', '3.9(600+ Reviews)', 'assets/shawarma.jpg'),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(0, context),
    );
  }

  BottomNavigationBar _buildBottomNavigationBar(int currentIndex, BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: Color(0xFFF5E1BE),
      selectedItemColor: Colors.brown[700],
      unselectedItemColor: Colors.brown[400],
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

  BottomNavigationBarItem _buildBottomNavigationBarItem(IconData icon, int index, int currentIndex) {
    return BottomNavigationBarItem(
      icon: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: currentIndex == index ? Colors.brown[700] : Colors.transparent,
        ),
        child: Icon(
          icon,
          color: currentIndex == index ? Colors.white : Colors.brown[700],
        ),
      ),
      label: "",
    );
  }
}