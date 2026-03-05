import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'auth_service.dart';
import 'contact_us.dart';
import 'home.dart';
import 'login.dart';
import 'events.dart';
import 'event_provider.dart';
import 'profile.dart';
import 'event_gallery.dart';
import 'search.dart';
import 'sign_up.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://bscypeqozgsrcgmhqjns.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImJzY3lwZXFvemdzcmNnbWhxam5zIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzIyMTMyNTEsImV4cCI6MjA4Nzc4OTI1MX0.H2UfLTkjRyOu5YmDMr9Hzjfz-djVQgAPzeNX0fMyThY',
    debug: true,
  );

  usePathUrlStrategy();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => PlateProvider()),
      ],
      child: const PicsApp(),
    ),
  );
}

class PicsApp extends StatelessWidget {
  const PicsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.brown,
        textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
        visualDensity: VisualDensity.adaptivePlatformDensity,
        appBarTheme: AppBarTheme(
          elevation: 0,
          backgroundColor: Colors.transparent,
          iconTheme: const IconThemeData(color: Colors.brown),
          titleTextStyle: GoogleFonts.poppins(
            color: Colors.brown,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        cardTheme: CardTheme(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: const EdgeInsets.symmetric(vertical: 8),
        ),
      ),
      home: FutureBuilder<bool>(
        future: AuthService().isLoggedIn(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.brown),
                ),
              ),
            );
          }
          if (snapshot.hasError) {
            return Scaffold(
                body: Center(
                  child: Text(
                      'Error checking login status: ${snapshot.error}',
                      style: const TextStyle(color: Colors.red)),
                ));
          }
          return snapshot.data == true ? HomeScreen() : const SplashScreen();
        },
      ),
      routes: {
        '/meals': (context) => const MealScreen(),
        '/signup': (context) => const SignUpScreen(),
        '/login': (context) => const LoginPage(),
        '/home': (context) =>  HomeScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/restaurant': (context) => const RestaurantScreen(),
        '/search': (context) => const SearchScreen(),
        '/contact': (context) =>  ContactUsScreen(),
      },
      onGenerateRoute: (settings) {
        return MaterialPageRoute(
          builder: (context) => Scaffold(
            appBar: AppBar(
              title: const Text('Page Not Found'),
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    '404 - Page not found',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => Navigator.pushNamed(context, '/home'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.brown,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                    ),
                    child: const Text('Return Home'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNextScreen();
  }

  Future<void> _navigateToNextScreen() async {
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;

    final isLoggedIn = await AuthService().isLoggedIn();
    Navigator.pushReplacementNamed(
      context,
      isLoggedIn ? '/home' : '/signup',
    );
  }

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
              width: 150,
              height: 150,
              errorBuilder: (context, error, stackTrace) => const Icon(
                Icons.restaurant,
                size: 100,
                color: Colors.brown,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Pics',
              style: GoogleFonts.poppins(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.brown,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Find meals within your budget',
              style: TextStyle(
                fontSize: 16,
                color: Colors.brown,
              ),
            ),
            const SizedBox(height: 40),
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.brown),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final isLoggedIn = await AuthService().isLoggedIn();
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
                elevation: 5,
              ),
              child: const Text(
                "Get Started",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}