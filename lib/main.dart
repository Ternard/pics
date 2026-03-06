import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'auth_service.dart';
import 'screens/home_screen.dart';
import 'screens/close_friends_screen.dart';
import 'screens/direct_share_screen.dart';
import 'screens/activity_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/photo_viewer_screen.dart';
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/landing_screen.dart';
import 'providers/friend_provider.dart';
import 'providers/widget_provider.dart';

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
        ChangeNotifierProvider(create: (context) => FriendProvider()),
        ChangeNotifierProvider(create: (context) => WidgetProvider()),
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
      title: 'Pics - Close Friends Sharing',
      theme: ThemeData(
        primaryColor: const Color(0xFF64B5F6),
        colorScheme: ColorScheme.light(
          primary: const Color(0xFF64B5F6),
          secondary: const Color(0xFF42A5F5),
          surface: Colors.white,
          background: const Color(0xFFF5F5F5),
          error: Colors.red,
        ),
        textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
        visualDensity: VisualDensity.adaptivePlatformDensity,
        appBarTheme: const AppBarTheme(
          elevation: 0,
          backgroundColor: Colors.white,
          foregroundColor: Color(0xFF2C3E50),
          titleTextStyle: TextStyle(
            color: Color(0xFF2C3E50),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF64B5F6),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFFFAFAFA),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(color: const Color(0xFF64B5F6).withOpacity(0.5), width: 1.5),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(color: const Color(0xFF64B5F6).withOpacity(0.3), width: 1.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(color: Color(0xFF64B5F6), width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(color: Colors.red, width: 1.5),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        ),
        cardTheme: const CardThemeData(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
          margin: EdgeInsets.all(0),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => FutureBuilder<bool>(
          future: AuthService().isLoggedIn(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF64B5F6)),
                  ),
                ),
              );
            }
            if (snapshot.hasError) {
              return Scaffold(
                body: Center(
                  child: Text('Error: ${snapshot.error}'),
                ),
              );
            }
            return snapshot.data == true
                ? const HomeScreen()
                : const LandingScreen();
          },
        ),
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignupScreen(),
        '/home': (context) => const HomeScreen(),
        '/close_friends': (context) => const CloseFriendsScreen(),
        '/direct_share': (context) => DirectShareScreen(),
        '/activity': (context) => const ActivityScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/settings': (context) => const SettingsScreen(),
        '/photo_viewer': (context) {
          final args = ModalRoute.of(context)!.settings.arguments;
          if (args == null || args is! Map<String, dynamic> || !args.containsKey('photoUrl')) {
            return const Scaffold(
              body: Center(
                child: Text(
                  'No photo URL provided',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            );
          }
          return PhotoViewerScreen(
            photoUrl: args['photoUrl'],
            uploadedBy: args['uploadedBy'] ?? 'Unknown',
            timestamp: args['timestamp'] ?? DateTime.now().toIso8601String(),
          );
        },
      },
      onGenerateRoute: (settings) {
        // Handle any undefined routes
        return MaterialPageRoute(
          builder: (context) => Scaffold(
            appBar: AppBar(
              title: const Text('Page Not Found'),
              backgroundColor: Colors.white,
              foregroundColor: const Color(0xFF64B5F6),
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
                      backgroundColor: const Color(0xFF64B5F6),
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                    child: const Text(
                      'Return Home',
                      style: TextStyle(color: Colors.white),
                    ),
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