import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'new_meal.dart';
import 'meal_review.dart';

class MealScreen extends StatefulWidget {
  const MealScreen({super.key});

  @override
  _MealScreenState createState() => _MealScreenState();
}

class _MealScreenState extends State<MealScreen> {
  int _currentIndex = 2;
  final PageController _pageController = PageController();
  final SupabaseClient supabase = Supabase.instance.client;
  List<String> mealImageUrls = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchMealImages();
  }

  Future<void> _fetchMealImages() async {
    try {
      // First verify bucket exists and is accessible
      final bucketResponse = await supabase.storage.from('restaurant').list();

      // Then list files in the images folder
      final response = await supabase.storage
          .from('restaurant')
          .list(path: 'images');

      if (response != null && response.isNotEmpty) {
        final List<String> urls = [];
        for (var file in response) {
          if (file.name != '.emptyFolderPlaceholder') {
            final url = supabase.storage
                .from('restaurant')
                .getPublicUrl('images/${file.name}');
            urls.add(url);
          }
        }

        setState(() {
          mealImageUrls = urls;
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'No images found in storage';
          isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Error fetching images: $e');
      setState(() {
        errorMessage = 'Failed to load images';
        isLoading = false;
      });
    }
  }

  void _showAddMealPopup(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: SingleChildScrollView(
            child: NewMealScreen(
              onSubmit: (bool success) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(success ? "Meal Added" : "Error"),
                  ),
                );
                if (success) _fetchMealImages(); // Refresh images after adding
              },
            ),
          ),
        );
      },
    );
  }

  void _showAddReviewPopup(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: SingleChildScrollView(
            child: MealReviewScreen(
              onSubmit: (bool success) {
                Navigator.pop(context);
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
            Expanded(
              child: Stack(
                children: [
                  _buildMealPage(),
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
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(left: 30, right: 30, bottom: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            FloatingActionButton(
              onPressed: () => _showAddMealPopup(context),
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

  Widget _buildMealPage() {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 50, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              errorMessage!,
              style: const TextStyle(fontSize: 16, color: Colors.red),
            ),
            TextButton(
              onPressed: _fetchMealImages,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    return PageView.builder(
      controller: _pageController,
      itemCount: mealImageUrls.isEmpty ? 1 : mealImageUrls.length,
      itemBuilder: (context, index) {
        final imageUrl = mealImageUrls.isEmpty
            ? 'https://via.placeholder.com/400x200?text=No+Images+Found'
            : mealImageUrls[index % mealImageUrls.length];

        return SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                children: [
                  ClipPath(
                    clipper: CurvedClipper(),
                    child: Image.network(
                      imageUrl,
                      width: double.infinity,
                      height: 200,
                      fit: BoxFit.cover,
                      loadingBuilder: (BuildContext context, Widget child,
                          ImageChunkEvent? loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                                : null,
                          ),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: Colors.grey[200],
                        height: 200,
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.broken_image, size: 50),
                            Text('Failed to load image'),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
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
                  child: const Text(
                    'Add to plate',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 20),
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
                    Text(
                      'Steak Plate',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'Meal Description',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'A perfectly seared steak, cooked to your desired doneness, served with a side of creamy mashed potatoes, sautéed greens, and a rich, velvety sauce.',
                      style: TextStyle(color: Colors.black54),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
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
                      height: 180,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            _buildReviewCard(
                                'Brandon White', '4.2', 'Best Customer Service I\'ve ever had...'),
                            const SizedBox(width: 10),
                            _buildReviewCard('Victoria Malen', '',
                                'The meals are so flavorful & aesthetic...'),
                            const SizedBox(width: 10),
                            _buildReviewCard(
                                'John Doe', '4.8', 'Amazing food and great service!'),
                            const SizedBox(width: 10),
                            _buildReviewCard(
                                'Jane Smith', '4.5', 'Highly recommend this place!'),
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
      },
    );
  }

  Widget _buildReviewCard(String name, String rating, String review) {
    return Container(
      padding: const EdgeInsets.all(12),
      width: 160,
      decoration: BoxDecoration(
        color: const Color(0xFFF5DEB3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 5),
          if (rating.isNotEmpty)
            Row(
              children: [
                Icon(Icons.star, color: Colors.orange, size: 18),
                const SizedBox(width: 5),
                Text(rating, style: TextStyle(fontSize: 16)),
              ],
            ),
          const SizedBox(height: 5),
          Text(
            review,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: Colors.black54, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigationBar(int currentIndex, BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: const Color(0xFFF5E1BE),
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

  BottomNavigationBarItem _buildBottomNavigationBarItem(
      IconData icon, int index, int currentIndex) {
    return BottomNavigationBarItem(
      icon: Container(
        padding: const EdgeInsets.all(8),
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

class CurvedClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 50);
    path.quadraticBezierTo(
        size.width / 2, size.height, size.width, size.height - 50);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}