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
import 'screens/membership_features_screen.dart';
import 'utils/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
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
          style: AppTheme.elevatedButtonStyle,
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const WelcomeScreen(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegistrationScreen(),
        '/home': (context) => const HomeScreen(),
        '/contact': (context) => const ContactScreen(),
        '/feedback': (context) => const FeedbackScreen(),
        '/test-confirmation': (context) => const TestConfirmationScreen(),
        '/test': (context) => const TestScreen(),
        '/upgrade-membership': (context) => const UpgradeMembershipScreen(),
        '/payment-success': (context) =>
            const PaymentSuccessScreen(membershipType: 'Premium'),
        '/previous-results': (context) => const PreviousResultsScreen(),
        '/best-matches': (context) => const BestMatchesScreen(),
        '/membership': (context) => const MembershipFeaturesScreen(),
        '/membership-features': (context) => const MembershipFeaturesScreen(),
      },
    );
  }
}
