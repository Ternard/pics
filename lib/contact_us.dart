import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ContactUsScreen extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController messageController = TextEditingController();
  final SupabaseClient supabase = Supabase.instance.client;

  ContactUsScreen({super.key});

  Future<void> _launchURL(String url, BuildContext context) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not launch $url')),
      );
    }
  }

  Future<void> _submitForm(BuildContext context) async {
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final message = messageController.text.trim();

    if (name.isEmpty || email.isEmpty || message.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }

    try {
      await supabase.from('contact_us').insert({
        'name': name,
        'email': email,
        'help': message,
        'created_at': DateTime.now().toIso8601String(),
      });

      // Clear the form after successful submission
      nameController.clear();
      emailController.clear();
      messageController.clear();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Thank you for contacting us!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error submitting form: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5E1BE),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 80),
              Image.asset(
                'assets/logo.png',
                width: 100,
                height: 100,
              ),
              const SizedBox(height: 20),
              Text(
                "Contact Us",
                style: GoogleFonts.playfairDisplay(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.brown[700],
                ),
              ),
              const SizedBox(height: 20),
              buildTextField("Your Name", nameController),
              const SizedBox(height: 10),
              buildTextField("Your Email", emailController),
              const SizedBox(height: 10),
              buildTextField("What can we help you with?", messageController, maxLines: 4),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => _submitForm(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.brown[700],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text(
                    "Submit",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                "mealmeter@gmail.com",
                style: TextStyle(fontSize: 14, color: Colors.brown[700]),
              ),
              const SizedBox(height: 5),
              Text(
                "+254 791 192 168",
                style: TextStyle(fontSize: 14, color: Colors.brown[700]),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    onPressed: () {
                      _launchURL("https://x.com/?lang=en", context);
                    },
                    icon: Image.asset(
                      'assets/twitter.png',
                      width: 24,
                      height: 24,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      _launchURL("https://www.tiktok.com/foryou?lang=en", context);
                    },
                    icon: Image.asset(
                      'assets/tiktok.png',
                      width: 24,
                      height: 24,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      _launchURL("https://www.instagram.com/", context);
                    },
                    icon: Image.asset(
                      'assets/instagram.png',
                      width: 24,
                      height: 24,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(3, context),
    );
  }

  Widget buildTextField(String hintText, TextEditingController controller, {int maxLines = 1}) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hintText,
        filled: true,
        fillColor: const Color(0xFFD7B77B),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
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
            Navigator.pushNamed(context, '/restaurant');
            break;
          case 3:
            break;
          case 4:
            Navigator.pushNamed(context, '/profile');
            break;
        }
      },
      items: [
        _buildNavItem(Icons.home, 0, currentIndex),
        _buildNavItem(Icons.search, 1, currentIndex),
        _buildNavItem(Icons.restaurant_menu, 2, currentIndex),
        _buildNavItem(Icons.phone, 3, currentIndex),
        _buildNavItem(Icons.person, 4, currentIndex),
      ],
    );
  }

  BottomNavigationBarItem _buildNavItem(IconData icon, int index, int currentIndex) {
    final isSelected = currentIndex == index;;
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