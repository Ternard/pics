import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ContactUsScreen extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5E1BE),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 80),

            // Logo and App Name
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 18,
                  child: Icon(Icons.restaurant_menu, color: Colors.brown),
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
            SizedBox(height: 30),

            // Contact Us Title
            Text(
              "Contact Us",
              style: GoogleFonts.playfairDisplay(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.brown[700],
              ),
            ),
            SizedBox(height: 20),

            // Input Fields
            buildTextField("Your Name", nameController),
            SizedBox(height: 10),
            buildTextField("Your Email", emailController),
            SizedBox(height: 10),
            buildTextField("What can we help you with?", messageController, maxLines: 4),
            SizedBox(height: 20),

            // Submit Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Handle submit logic
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.brown[700],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 12),
                ),
                child: Text(
                  "Submit",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
            SizedBox(height: 20),

            // Contact Information
            Text(
              "mealmeter@gmail.com",
              style: TextStyle(fontSize: 14, color: Colors.brown[700]),
            ),
            SizedBox(height: 5),
            Text(
              "+254 708 756 456",
              style: TextStyle(fontSize: 14, color: Colors.brown[700]),
            ),

            // Social Media Icons
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Icon(Icons.cancel, color: Colors.brown[700]),
                Icon(Icons.tiktok, color: Colors.brown[700]),
                Icon(Icons.camera_alt, color: Colors.brown[700]),

              ],
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // Custom TextField Widget
  Widget buildTextField(String hintText, TextEditingController controller, {int maxLines = 1}) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hintText,
        filled: true,
        fillColor: Color(0xFFD7B77B),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
