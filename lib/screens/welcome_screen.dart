import 'package:flutter/material.dart';
import 'registration_screen.dart'; // Import RegistrationScreen
import 'login_screen.dart'; // Import LoginScreen (make sure you create this file)
import 'package:cloud_firestore/cloud_firestore.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Define colors based on wireframe for easier reuse
    const Color primaryButtonColor = Color(0xFF1A237E); // Dark Blue example
    const Color secondaryButtonColor = Color(0xFFEC407A); // Pink example
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      // Use SafeArea to avoid overlaps with system UI (notch, status bar)
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const Spacer(flex: 2),
              // Display the illustration from assets
              Image.asset(
                'assets/images/welcome_illustration.png',
                height: screenHeight *
                    0.35, // Adjust height relative to screen size
                errorBuilder: (context, error, stackTrace) {
                  // Display placeholder if image fails to load
                  print("Error loading image: $error");
                  return Icon(Icons.broken_image,
                      size: screenHeight * 0.3, color: Colors.grey);
                },
              ),
              const Spacer(flex: 1),
              // MatchMate Title
              const Text(
                'MatchMate',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87, // Adjust color as needed
                ),
              ),
              const SizedBox(height: 16),
              // Subtitle Text
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  'It is now easier to find your best roommate match even before you meet them!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                  ),
                ),
              ),
              const Spacer(flex: 3),
              // Login and Sign Up Buttons
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryButtonColor,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(30), // Rounded corners
                        ),
                      ),
                      onPressed: () {
                        // Navigate to Login Screen
                        Navigator.pushNamed(context, '/login');
                        print("Login button pressed");
                      },
                      child: const Text(
                        'Login',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: secondaryButtonColor,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(30), // Rounded corners
                        ),
                      ),
                      onPressed: () {
                        // Navigate to Registration Screen
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const RegistrationScreen(),
                          ),
                        );
                        print("Sign Up button pressed");
                      },
                      child: const Text(
                        'Sign Up',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Contact and Feedback Buttons
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade700,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, '/contact');
                      },
                      child: const Text(
                        'Contact Us',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade500,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, '/feedback');
                      },
                      child: const Text(
                        'Feedback',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Spacer(flex: 1),
              // Optional: Add bottom navigation elements (arrows, dots) if needed.
              // For now, just adding some bottom padding.
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
