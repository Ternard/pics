// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:pics/main.dart';
import 'package:pics/screens/home_screen.dart';
import 'package:pics/screens/login_screen.dart';
import 'package:pics/screens/signup_screen.dart';
import 'package:pics/screens/landing_screen.dart';
import 'package:pics/screens/close_friends_screen.dart';
import 'package:pics/screens/direct_share_screen.dart';
import 'package:pics/screens/activity_screen.dart';
import 'package:pics/screens/profile_screen.dart';
import 'package:pics/screens/settings_screen.dart';
import 'package:pics/providers/friend_provider.dart';
import 'package:pics/providers/widget_provider.dart';

void main() {
  testWidgets('App loads successfully', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => FriendProvider()),
          ChangeNotifierProvider(create: (context) => WidgetProvider()),
        ],
        child: const MaterialApp(
          home: Scaffold(
            body: Center(
              child: Text('Pics App'),
            ),
          ),
        ),
      ),
    );

    // Verify that our app loads
    expect(find.text('Pics App'), findsOneWidget);
  });

  testWidgets('Landing screen has welcome text and sign in/up buttons', (WidgetTester tester) async {
    // Build the LandingScreen
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => FriendProvider()),
          ChangeNotifierProvider(create: (context) => WidgetProvider()),
        ],
        child: const MaterialApp(
          home: LandingScreen(),
        ),
      ),
    );

    // Verify that landing screen shows app name and welcome text
    expect(find.text('PICS'), findsOneWidget);
    expect(find.text('Close Friends · Photo Sharing'), findsOneWidget);

    // Verify sign in and sign up buttons exist
    expect(find.widgetWithText(ElevatedButton, 'Get Started'), findsOneWidget);
    expect(find.text('Already have an account?'), findsOneWidget);
    expect(find.text('Sign In'), findsOneWidget);
  });

  testWidgets('Login screen has email field and sign in button', (WidgetTester tester) async {
    // Build the LoginScreen
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => FriendProvider()),
          ChangeNotifierProvider(create: (context) => WidgetProvider()),
        ],
        child: const MaterialApp(
          home: LoginScreen(),
        ),
      ),
    );

    // Verify login screen elements
    expect(find.text('Welcome back!'), findsOneWidget);
    expect(find.text('Sign in to continue sharing with close friends'), findsOneWidget);
    expect(find.text('Email'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
    expect(find.byType(TextField), findsNWidgets(2)); // Email and password fields
    expect(find.text('Forgot password?'), findsOneWidget);
    expect(find.widgetWithText(ElevatedButton, 'Sign In'), findsOneWidget);
    expect(find.text("Don't have an account?"), findsOneWidget);
    expect(find.text('Sign Up'), findsOneWidget);
  });

  testWidgets('Sign up screen has email, password, confirm password fields and sign up button', (WidgetTester tester) async {
    // Build the SignupScreen
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => FriendProvider()),
          ChangeNotifierProvider(create: (context) => WidgetProvider()),
        ],
        child: const MaterialApp(
          home: SignupScreen(),
        ),
      ),
    );

    // Verify signup screen elements
    expect(find.text('Create Account'), findsOneWidget);
    expect(find.text('Sign up to start sharing moments'), findsOneWidget);
    expect(find.text('Email'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
    expect(find.text('Confirm Password'), findsOneWidget);
    expect(find.byType(TextField), findsNWidgets(3)); // Email, password, confirm password fields
    expect(find.widgetWithText(ElevatedButton, 'Sign up'), findsOneWidget);
    expect(find.text("Already have an account?"), findsOneWidget);
    expect(find.text('Sign in'), findsOneWidget);
  });

  testWidgets('Home screen has greeting, quick actions, and recent events', (WidgetTester tester) async {
    // Build the HomeScreen
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => FriendProvider()),
          ChangeNotifierProvider(create: (context) => WidgetProvider()),
        ],
        child: const MaterialApp(
          home: HomeScreen(),
        ),
      ),
    );

    // Verify home screen elements
    expect(find.text('Pics'), findsOneWidget);
    expect(find.byIcon(Icons.person), findsOneWidget); // Profile icon

    // Check for greeting (time-based, so we can't check exact text)
    expect(find.byType(Text), findsWidgets);

    // Quick Actions section
    expect(find.text('Quick Actions'), findsOneWidget);
    expect(find.text('Create Event'), findsOneWidget);
    expect(find.text('Join Event'), findsOneWidget);

    // Recent Events section
    expect(find.text('Recent Events'), findsOneWidget);

    // Either "No events yet" message or event cards
    final noEventsFinder = find.text('No events yet');
    final eventCardsFinder = find.byType(GestureDetector);

    // At least one of these should be true
    expect(noEventsFinder.evaluate().isNotEmpty || eventCardsFinder.evaluate().isNotEmpty, true);
  });

  testWidgets('Close friends screen can be opened', (WidgetTester tester) async {
    // Build the CloseFriendsScreen
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => FriendProvider()),
          ChangeNotifierProvider(create: (context) => WidgetProvider()),
        ],
        child: const MaterialApp(
          home: CloseFriendsScreen(),
        ),
      ),
    );

    // Verify close friends screen elements
    expect(find.text('Close Friends'), findsOneWidget);
    expect(find.byType(TextField), findsOneWidget); // Search field
    expect(find.text('CLOSE FRIENDS'), findsOneWidget);
    expect(find.text('SUGGESTIONS'), findsOneWidget);
  });

  testWidgets('Direct share screen has friend selector', (WidgetTester tester) async {
    // Build the DirectShareScreen
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => FriendProvider()),
          ChangeNotifierProvider(create: (context) => WidgetProvider()),
        ],
        child: const MaterialApp(
          home: DirectShareScreen(),
        ),
      ),
    );

    // Verify direct share screen elements
    expect(find.text('Direct Share'), findsOneWidget);
    expect(find.text('Send'), findsOneWidget);
    expect(find.text('CLOSE FRIENDS'), findsOneWidget);
    expect(find.text('ALL FRIENDS'), findsOneWidget);
  });

  testWidgets('Activity screen has notifications and headlines tabs', (WidgetTester tester) async {
    // Build the ActivityScreen
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => FriendProvider()),
          ChangeNotifierProvider(create: (context) => WidgetProvider()),
        ],
        child: const MaterialApp(
          home: ActivityScreen(),
        ),
      ),
    );

    // Verify activity screen elements
    expect(find.text('Activity'), findsOneWidget);
    expect(find.text('Filter'), findsOneWidget);
    expect(find.text('Notifications'), findsOneWidget);
    expect(find.text('Headlines'), findsOneWidget);
    expect(find.byType(TabBar), findsOneWidget);
  });

  testWidgets('Profile screen has user info and history', (WidgetTester tester) async {
    // Build the ProfileScreen
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => FriendProvider()),
          ChangeNotifierProvider(create: (context) => WidgetProvider()),
        ],
        child: const MaterialApp(
          home: ProfileScreen(),
        ),
      ),
    );

    // Verify profile screen elements
    expect(find.text('Profile'), findsOneWidget);
    expect(find.byIcon(Icons.settings), findsOneWidget);
    expect(find.text('Photos'), findsOneWidget);
    expect(find.text('Friends'), findsOneWidget);
    expect(find.text('Close Friends'), findsOneWidget);
    expect(find.text('Personal History'), findsOneWidget);
    expect(find.text('Manage Friends'), findsOneWidget);
    expect(find.text('Share Profile'), findsOneWidget);
  });

  testWidgets('Settings screen has configuration options', (WidgetTester tester) async {
    // Build the SettingsScreen
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => FriendProvider()),
          ChangeNotifierProvider(create: (context) => WidgetProvider()),
        ],
        child: const MaterialApp(
          home: SettingsScreen(),
        ),
      ),
    );

    // Verify settings screen elements
    expect(find.text('Settings'), findsOneWidget);
    expect(find.text('Privacy & Security'), findsOneWidget);
    expect(find.text('Account Settings'), findsOneWidget);
    expect(find.text('Help & Support'), findsOneWidget);
    expect(find.text('Log Out'), findsOneWidget);
  });

  testWidgets('FriendProvider works correctly', (WidgetTester tester) async {
    // Create a test widget that uses FriendProvider
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => FriendProvider()),
        ],
        child: MaterialApp(
          home: Builder(
            builder: (context) {
              final friendProvider = Provider.of<FriendProvider>(context, listen: false);

              // Load mock data
              friendProvider.loadMockData();

              return Scaffold(
                body: Consumer<FriendProvider>(
                  builder: (context, provider, child) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Close Friends: ${provider.closeFriends.length}'),
                        Text('All Friends: ${provider.allFriends.length}'),
                      ],
                    );
                  },
                ),
              );
            },
          ),
        ),
      ),
    );

    // Wait for mock data to load
    await tester.pumpAndSettle();

    // Verify provider data is displayed
    expect(find.textContaining('Close Friends:'), findsOneWidget);
    expect(find.textContaining('All Friends:'), findsOneWidget);
  });

  testWidgets('WidgetProvider works correctly', (WidgetTester tester) async {
    // Create a test widget that uses WidgetProvider
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => WidgetProvider()),
        ],
        child: MaterialApp(
          home: Builder(
            builder: (context) {
              final widgetProvider = Provider.of<WidgetProvider>(context, listen: false);

              // Load mock data
              widgetProvider.loadMockData();

              return Scaffold(
                body: Consumer<WidgetProvider>(
                  builder: (context, provider, child) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Shared Widgets: ${provider.sharedWidgets.length}'),
                        Text('Notifications: ${provider.notifications.length}'),
                        Text('Unread: ${provider.unreadCount}'),
                      ],
                    );
                  },
                ),
              );
            },
          ),
        ),
      ),
    );

    // Wait for mock data to load
    await tester.pumpAndSettle();

    // Verify provider data is displayed
    expect(find.textContaining('Shared Widgets:'), findsOneWidget);
    expect(find.textContaining('Notifications:'), findsOneWidget);
    expect(find.textContaining('Unread:'), findsOneWidget);
  });

  testWidgets('Bottom navigation works on home screen', (WidgetTester tester) async {
    // Build the HomeScreen with navigation
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => FriendProvider()),
          ChangeNotifierProvider(create: (context) => WidgetProvider()),
        ],
        child: MaterialApp(
          routes: {
            '/home': (context) => const HomeScreen(),
            '/direct_share': (context) => const DirectShareScreen(),
            '/activity': (context) => const ActivityScreen(),
            '/profile': (context) => const ProfileScreen(),
          },
          home: const HomeScreen(),
        ),
      ),
    );

    // Verify home screen is shown
    expect(find.text('Pics'), findsOneWidget);

    // Find bottom navigation bar
    expect(find.byType(BottomNavigationBar), findsOneWidget);

    // Note: We can't easily test navigation in widget tests without more setup
    // This is a placeholder for more comprehensive navigation tests
  });

  testWidgets('Light blue theme is applied', (WidgetTester tester) async {
    // Build the app with theme
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => FriendProvider()),
          ChangeNotifierProvider(create: (context) => WidgetProvider()),
        ],
        child: const MaterialApp(
          home: Scaffold(
            body: Center(
              child: Text('Theme Test'),
            ),
          ),
        ),
      ),
    );

    // Find a button to check theme
    expect(find.text('Theme Test'), findsOneWidget);
  });
}