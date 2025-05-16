import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _agreeToTerms = false;

  // Controllers for text fields
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    // Dispose controllers when the widget is removed from the widget tree
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // Basic email validation regex (adjust as needed for stricter validation)
  bool _isEmailValid(String email) {
    return RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
    ).hasMatch(email);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Use AppBar for back navigation and branding consistency
      appBar: AppBar(
        backgroundColor: Colors.blue.shade800, // Consistent with wireframe
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'MatchMate',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ), // Optional: Add MatchMate logo/title
        centerTitle: true,
      ),
      body: Container(
        color: Colors.blue.shade800, // Background color from wireframe
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            autovalidateMode:
                AutovalidateMode.onUserInteraction, // Add autovalidation
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const SizedBox(height: 20),
                const Text(
                  "Don't have an Account?\nCreate your Account",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),

                // First Name & Last Name Row
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _firstNameController, // Assign controller
                        decoration: const InputDecoration(
                          hintText: 'First Name',
                          // Using theme's input decoration
                        ),
                        validator: (value) {
                          // Add validator
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter your first name';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        controller: _lastNameController, // Assign controller
                        decoration: const InputDecoration(
                          hintText: 'Last Name',
                        ),
                        validator: (value) {
                          // Add validator
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter your last name';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Email Address
                TextFormField(
                  controller: _emailController, // Assign controller
                  decoration: const InputDecoration(hintText: 'E-mail Address'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    // Add validator
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your email address';
                    }
                    if (!_isEmailValid(value.trim())) {
                      return 'Please enter a valid email address';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Phone Number (Simple for now)
                TextFormField(
                  controller: _phoneController, // Assign controller
                  decoration: const InputDecoration(
                    hintText: 'Phone Number',
                    // TODO: Add prefix icon or use a dedicated phone field package
                    prefixIcon: Padding(
                      padding: EdgeInsets.all(15.0),
                      // Placeholder for flag/country code selector
                      child: Text(
                        'tr +90',
                        style: TextStyle(color: Colors.black54),
                      ),
                    ),
                  ),
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    // Add validator
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your phone number';
                    }
                    // TODO: Add more specific phone number validation if needed
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Create Password
                TextFormField(
                  controller: _passwordController, // Assign controller
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    hintText: 'Create Your Password',
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                  ),
                  validator: (value) {
                    // Add validator
                    if (value == null || value.isEmpty) {
                      return 'Please create a password';
                    }
                    if (value.length < 6) {
                      // Example: Minimum length
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Confirm Password
                TextFormField(
                  controller: _confirmPasswordController, // Assign controller
                  obscureText: _obscureConfirmPassword,
                  decoration: InputDecoration(
                    hintText: 'Confirm Password',
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureConfirmPassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureConfirmPassword = !_obscureConfirmPassword;
                        });
                      },
                    ),
                  ),
                  validator: (value) {
                    // Add validator
                    if (value == null || value.isEmpty) {
                      return 'Please confirm your password';
                    }
                    if (value != _passwordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Terms and Conditions Checkbox
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Checkbox(
                      value: _agreeToTerms,
                      onChanged: (bool? value) {
                        setState(() {
                          _agreeToTerms = value ?? false;
                        });
                      },
                      checkColor:
                          Colors.blue.shade800, // Color of the check mark
                      activeColor:
                          Colors.white, // Color of the box when checked
                      side: const BorderSide(
                        color: Colors.white,
                      ), // Border color
                    ),
                    // Using GestureDetector to make text tappable later
                    GestureDetector(
                      onTap: () {
                        // TODO: Show Terms and Conditions
                        print("Terms tapped");
                      },
                      child: const Text(
                        'I agree to the Terms and Conditions',
                        style: TextStyle(
                          color: Colors.white70,
                          decoration: TextDecoration.underline,
                          decorationColor: Colors.white70,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),

                // Sign Up Button
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Colors.white, // White background for contrast
                    foregroundColor: Colors.blue.shade900, // Dark blue text
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        30,
                      ), // Rounded corners
                    ),
                  ),
                  onPressed: () async {
                    final isValid = _formKey.currentState!.validate();
                    if (!isValid || !_agreeToTerms) {
                      showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text('Invalid Submission'),
                          content: const Text(
                            'Please fix the errors and agree to the terms before submitting.',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(ctx).pop(),
                              child: const Text('OK'),
                            ),
                          ],
                        ),
                      );
                      return;
                    }
                    // Firebase Auth ve Firestore entegrasyonu
                    try {
                      print('Starting registration process...');
                      print('Email: ${_emailController.text.trim()}');
                      print(
                          'Password length: ${_passwordController.text.trim().length}');

                      // Check if Firebase Auth is initialized
                      if (FirebaseAuth.instance == null) {
                        throw Exception('Firebase Auth is not initialized');
                      }

                      final credential = await FirebaseAuth.instance
                          .createUserWithEmailAndPassword(
                        email: _emailController.text.trim(),
                        password: _passwordController.text.trim(),
                      );

                      print('Firebase Auth user created successfully');
                      final user = credential.user;

                      if (user != null) {
                        // Set the user's display name
                        String fullName = "${_firstNameController.text.trim()} ${_lastNameController.text.trim()}";
                        await user.updateDisplayName(fullName);
                        
                        print(
                            'Creating Firestore document for user: ${user.uid}');
                        try {
                          // Create a Map with the user data
                          final userData = {
                            'uid': user.uid,
                            'email': user.email,
                            'firstName': _firstNameController.text.trim(),
                            'lastName': _lastNameController.text.trim(),
                            'displayName': fullName, // Store the full name
                            'phone': _phoneController.text.trim(),
                            'createdAt': FieldValue.serverTimestamp(),
                            'totalTests': 0,
                            'averageScore': 0.0,
                          };

                          // Set the document with the Map
                          await FirebaseFirestore.instance
                              .collection('users')
                              .doc(user.uid)
                              .set(userData);

                          print('Firestore document created successfully');

                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text(
                                      'Registration successful! Please log in.')),
                            );
                            Navigator.pushReplacementNamed(context, '/login');
                          }
                        } catch (e) {
                          print('Error creating Firestore document: $e');
                          // If Firestore fails, delete the auth user
                          await user.delete();
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text(
                                      'Error creating user profile. Please try again.')),
                            );
                          }
                        }
                      }
                    } on FirebaseAuthException catch (e) {
                      print('FirebaseAuthException: ${e.code} - ${e.message}');
                      String message = 'Registration failed.';
                      if (e.code == 'email-already-in-use') {
                        message = 'This email is already in use.';
                      } else if (e.code == 'weak-password') {
                        message = 'Password is too weak.';
                      } else if (e.code == 'invalid-email') {
                        message = 'Invalid email address.';
                      } else if (e.code == 'operation-not-allowed') {
                        message =
                            'Email/password accounts are not enabled. Please contact support.';
                      } else if (e.code == 'network-request-failed') {
                        message =
                            'Network error. Please check your internet connection.';
                      }
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(message)),
                        );
                      }
                    } catch (e) {
                      print('General error during registration: $e');
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content:
                                  Text('An error occurred: ' + e.toString())),
                        );
                      }
                    }
                  },
                  child: const Text(
                    'SIGN UP',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 20),

                // Back to Sign In Button
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/login');
                  },
                  child: const Text(
                    'BACK TO SIGN IN',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
