import 'package:flutter/material.dart';
import 'screens/welcome_screen.dart';
import 'screens/registration_screen.dart';
import 'screens/contact_screen.dart';
import 'screens/feedback_screen.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/test_confirmation_screen.dart';
import 'screens/test_screen.dart';
import 'screens/upgrade_membership_screen.dart';
import 'screens/payment_success_screen.dart';
import 'screens/previous_results_screen.dart';
import 'screens/best_matches_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fitness App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: AppTheme.primaryColor,
        scaffoldBackgroundColor: AppTheme.backgroundColor,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppTheme.primaryColor,
          secondary: AppTheme.secondaryColor,
        ),
        textTheme: TextTheme(
          headlineLarge: AppTheme.headingStyle,
          bodyLarge: AppTheme.subheadingStyle,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.grey[200],
        ),
      ),
      home: const WelcomeScreen(),
      routes: {
        '/welcome': (context) => const WelcomeScreen(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegistrationScreen(),
        '/home': (context) => const HomeScreen(),
        '/contact': (context) => const ContactScreen(),
        '/feedback': (context) => const FeedbackScreen(),
        '/test-confirmation': (context) => const TestConfirmationScreen(),
        '/test': (context) => const TestScreen(),
        '/upgrade-membership': (context) => const UpgradeMembershipScreen(),
        '/payment-success':
            (context) => const PaymentSuccessScreen(membershipType: 'Premium'),
        '/previous-results': (context) => const PreviousResultsScreen(),
        '/best-matches': (context) => const BestMatchesScreen(),
      },
    );
  }
}
