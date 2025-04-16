import 'package:flutter/material.dart';
import 'screens/welcome_screen.dart'; // Import the WelcomeScreen
import 'screens/registration_screen.dart'; // Import RegistrationScreen
import 'screens/contact_screen.dart'; // Import ContactScreen
import 'screens/feedback_screen.dart'; // Import FeedbackScreen

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DormMate', // Changed title
      theme: ThemeData(
        // Use a blue color scheme
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue.shade800),
        useMaterial3: true, // Recommended for new apps
         // Define button themes based on wireframe if needed
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white, // Text color for ElevatedButton
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8), // Adjust radius as needed
            ),
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
          ),
        ),
        // Define Text Field Themes if needed
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide.none, // Hide default border if filled
          ),
          filled: true,
          fillColor: Colors.grey[200], // Example fill color
        ),
      ),
      // Set WelcomeScreen as the home screen
      home: const WelcomeScreen(),
      // Define routes for navigation
      routes: {
        '/welcome': (context) => const WelcomeScreen(),
        '/register': (context) => const RegistrationScreen(),
        '/contact': (context) => const ContactScreen(),
        '/feedback': (context) => const FeedbackScreen(),
      },
    );
  }
}
