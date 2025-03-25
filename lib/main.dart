import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'auth_service.dart';
import 'contact_us.dart';
import 'home.dart';
import 'login.dart';
import 'meals.dart';
import 'profile.dart';
import 'restaurants.dart';
import 'search.dart';
import 'sign_up.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://pokfgifldgnorifrmetp.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InBva2ZnaWZsZGdub3JpZnJtZXRwIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDIzNzA1NTYsImV4cCI6MjA1Nzk0NjU1Nn0.DcQuWYaEw9DqjCer7PENJG9hMEYTMr-KOui4ia23WQQ',
  );

  runApp(const MealMeterApp());
}

class MealMeterApp extends StatelessWidget {
  const MealMeterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FutureBuilder<bool>(
        future: AuthService().isLoggedIn(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          if (snapshot.hasError) {
            return const Scaffold(
              body: Center(child: Text('Error checking login status')),
            );
          }
          return snapshot.data == true ? HomeScreen() : const SplashScreen();
        },
      ),
      routes: {
        '/meals': (context) => const MealScreen(),
        '/signup': (context) => const SignUpScreen(),
        '/login': (context) => const LoginPage(),
        '/home': (context) => HomeScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/restaurant': (context) => const RestaurantScreen(),
        '/search': (context) => const SearchScreen(),
        '/contact': (context) => ContactUsScreen(),
      },
    );
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5E1BE),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/logo.png',
              width: 120,
              height: 120,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final isLoggedIn = await AuthService().isLoggedIn();;
                Navigator.pushReplacementNamed(
                  context,
                  isLoggedIn ? '/home' : '/signup',
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.brown[700],
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
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