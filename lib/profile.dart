import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'settings.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ImagePicker _picker = ImagePicker();
  final SupabaseClient supabase = Supabase.instance.client;
  XFile? _imageFile;
  String _email = "";
  bool _notificationsEnabled = true;
  int _currentIndex = 4;

  Future<void> _launchWebsite() async {
    final Uri url = Uri.parse('https://www.mealmeter.com');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not launch website')),
        );
      }
    }
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null && mounted) {
        setState(() {
          _imageFile = image;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to pick image: $e')),
        );
      }
    }
  }

  Future<void> _takePhoto() async {
    try {
      final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
      if (photo != null && mounted) {
        setState(() {
          _imageFile = photo;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to take photo: $e')),
        );
      }
    }
  }

  Future<void> _toggleNotifications(bool value) async {
    if (mounted) {
      setState(() {
        _notificationsEnabled = value;
      });
    }
  }

  Future<void> _loadUserData() async {
    try {
      final user = supabase.auth.currentUser;
      if (user != null && mounted) {
        setState(() {
          _email = user.email ?? "No email found";
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load user data: $e')),
        );
      }
    }
  }

  Future<void> _logout() async {
    try {
      await supabase.auth.signOut();
      if (mounted) {
        Navigator.pushNamedAndRemoveUntil(
            context,
            '/login',
                (route) => false
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Logout failed: $e')),
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5E1BE),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5E1BE),
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.white,
              radius: 18,
              child: Icon(Icons.restaurant, color: Colors.black),
            ),
            const SizedBox(width: 10),
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
        actions: [
          IconButton(
            icon: Stack(
              children: [
                Icon(Icons.notifications, color: Colors.brown[700]),
                if (_notificationsEnabled)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 12,
                        minHeight: 12,
                      ),
                    ),
                  ),
              ],
            ),
            onPressed: () {
              _toggleNotifications(!_notificationsEnabled);
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          Stack(
            alignment: Alignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (context) => SafeArea(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ListTile(
                            leading: const Icon(Icons.photo_library),
                            title: const Text('Choose from gallery'),
                            onTap: () {
                              Navigator.pop(context);
                              _pickImage();
                            },
                          ),
                          ListTile(
                            leading: const Icon(Icons.camera_alt),
                            title: const Text('Take a photo'),
                            onTap: () {
                              Navigator.pop(context);
                              _takePhoto();
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.brown[300],
                  backgroundImage: _imageFile != null
                      ? FileImage(File(_imageFile!.path))
                      : null,
                  child: _imageFile == null
                      ? const Text(
                    "ID",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  )
                      : null,
                ),
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.brown[700],
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.edit,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 40),
            padding: const EdgeInsets.all(15),
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFFEED9B5),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Text(
              _email,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.brown[800],
              ),
            ),
          ),
          const SizedBox(height: 30),
          TextButton.icon(
            onPressed: _logout,
            icon: Icon(Icons.logout, color: Colors.brown[700]),
            label: Text(
              "Log Out",
              style: TextStyle(
                  fontSize: 18,
                  color: Colors.brown[700]
              ),
            ),
          ),
          const SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SettingsPage()
                      ),
                    );
                  },
                  child: Text(
                    "App Settings",
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.brown[700]
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: _launchWebsite,
                  child: Text(
                    "Help & Support",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.brown[700],
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFFF5E1BE),
        selectedItemColor: Colors.brown[700],
        unselectedItemColor: Colors.brown[400],
        showSelectedLabels: false,
        showUnselectedLabels: false,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
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
      ),
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
      label: '',
    );
  }
}

class ProfileField extends StatelessWidget {
  final String text;
  final VoidCallback? onTap;

  const ProfileField({super.key, required this.text, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 40),
        padding: const EdgeInsets.all(15),
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color(0xFFEED9B5),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              text,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.brown[800],
              ),
            ),
            if (onTap != null) const Icon(Icons.edit, color: Colors.brown),
          ],
        ),
      ),
    );
  }
}