import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5E1BE), // Beige background
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo and App Name
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 20,
                      child: Icon(Icons.restaurant_menu, color: Colors.brown),
                    ),
                    SizedBox(width: 10),
                    Text(
                      "MealMeter",
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.brown[700],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 40),

                // Login Title
                Text(
                  "Log In",
                  style: GoogleFonts.poppins(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.brown[800],
                  ),
                ),
                SizedBox(height: 30),

                // Email Input Field
                _buildTextField("Email"),
                SizedBox(height: 15),

                // Password Input Field
                _buildTextField("Password", obscureText: true),
                SizedBox(height: 20),

                // Sign Up Text
                GestureDetector(
                  onTap: () {
                    // Navigate to the SignUpScreen
                    Navigator.pushNamed(context, '/signup');
                  },
                  child: Text(
                    "Don’t have an account? Sign Up",
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.brown[700],
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
                SizedBox(height: 25),

                // Login Button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.brown[700],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      // Login function
                    },
                    child: Text(
                      "Log In",
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Custom Input Field Widget
  Widget _buildTextField(String hintText, {bool obscureText = false}) {
    return TextField(
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: hintText,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      ),
    );
  }
}