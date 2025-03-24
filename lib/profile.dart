import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:image_picker/image_picker.dart';
import 'auth_service.dart';
import 'settings.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final AuthService authService = AuthService();
  final ImagePicker _picker = ImagePicker();
  XFile? _imageFile;
  String _email = "user@example.com"; // This will be loaded from auth service
  String _phoneNumber = "+254 708 756 456";
  bool _notificationsEnabled = true;

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

  Future<void> _updatePhoneNumber() async {
    final TextEditingController phoneController = TextEditingController(text: _phoneNumber);
    final newPhone = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Update Phone Number'),
        content: TextField(
          controller: phoneController,
          decoration: const InputDecoration(labelText: 'Phone Number'),
          keyboardType: TextInputType.phone,
          onChanged: (value) => _phoneNumber = value,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, phoneController.text),
            child: const Text('Save'),
          ),
        ],
      ),
    );

    if (newPhone != null && newPhone.isNotEmpty && mounted) {
      setState(() {
        _phoneNumber = newPhone;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Phone number updated')),
      );
    }
  }

  Future<void> _toggleNotifications(bool value) async {
    if (!mounted) return;

    setState(() {
      _notificationsEnabled = value;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    // Load actual user data from your auth service
    // final user = await authService.getCurrentUser();
    // if (mounted) {
    //   setState(() {
    //     _email = user.email;
    //     _phoneNumber = user.phoneNumber ?? '+254 708 756 456';
    //   });
    // }
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
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
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
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
              )
                  : null,
            ),
          ),
          const SizedBox(height: 20),
          // Changed ProfileField for email to be non-editable
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
          ProfileField(
            text: _phoneNumber,
            onTap: _updatePhoneNumber,
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Checkbox(
                value: _notificationsEnabled,
                onChanged: (value) {
                  if (value != null) {
                    _toggleNotifications(value);
                  }
                },
              ),
              Text("Notifications", style: TextStyle(fontSize: 16, color: Colors.brown[700])),
            ],
          ),
          const SizedBox(height: 10),
          TextButton.icon(
            onPressed: () async {
              try {
                await authService.logout();
                if (mounted) {
                  Navigator.pushReplacementNamed(context, '/');
                }
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Logout failed: $e')),
                  );
                }
              }
            },
            icon: Icon(Icons.logout, color: Colors.brown[700]),
            label: Text("Log Out", style: TextStyle(fontSize: 18, color: Colors.brown[700])),
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
                      MaterialPageRoute(builder: (context) => const SettingsPage()),
                    );
                  },
                  child: Text(
                      "App Settings",
                      style: TextStyle(fontSize: 16, color: Colors.brown[700])
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
        currentIndex: 4,
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
              break;
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: _BottomNavIcon(icon: Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: _BottomNavIcon(icon: Icons.search),
            label: "Search",
          ),
          BottomNavigationBarItem(
            icon: _BottomNavIcon(icon: Icons.restaurant_menu),
            label: "Menu",
          ),
          BottomNavigationBarItem(
            icon: _BottomNavIcon(icon: Icons.phone),
            label: "Call",
          ),
          BottomNavigationBarItem(
            icon: _BottomNavIcon(icon: Icons.person),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}

class _BottomNavIcon extends StatelessWidget {
  final IconData icon;

  const _BottomNavIcon({required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.brown[100],
      ),
      child: Icon(icon, color: Colors.brown[700]),
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