import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'contact_us.dart'; // Import the ContactUsScreen
import 'home.dart'; // Import the HomeScreen
import 'login.dart'; // Import the LoginPage
import 'meals.dart'; // Import the MealScreen
import 'profile.dart'; // Import the ProfileScreen
import 'restaurants.dart'; // Import the RestaurantScreen
import 'search.dart'; // Import the SearchScreen
import 'sign_up.dart'; // Import the SignUpScreen

void main() {
  runApp(MealMeterApp());
}

class MealMeterApp extends StatelessWidget {
  const MealMeterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/', // Set the initial route to the splash screen
      routes: {
        '/': (context) => SplashScreen(), // SplashScreen
        '/meals': (context) => MealScreen(), // MealScreen
        '/signup': (context) => SignUpScreen(), // SignUpScreen
        '/login': (context) => LoginPage(), // LoginPage
        '/home': (context) => HomeScreen(), // HomeScreen
        '/profile': (context) => ProfileScreen(), // ProfileScreen
        '/restaurant': (context) => RestaurantScreen(), // RestaurantScreen
        '/search': (context) => SearchScreen(), // SearchScreen
        '/contact': (context) => ContactUsScreen(), // ContactUsScreen
      },
    );
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5E1BE), // Beige background
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo Image
            Image.asset(
              'assets/logo.png', // Replace with your logo asset
              width: 120,
              height: 120,
            ),
            SizedBox(height: 20),

            // Get Started Button
            ElevatedButton(
              onPressed: () {
                // Navigate to the SignUpScreen
                Navigator.pushNamed(context, '/signup');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.brown[700],
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                "Get Started",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}