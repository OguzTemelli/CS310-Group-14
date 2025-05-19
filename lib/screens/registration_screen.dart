import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

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
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade800,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      textStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState!.validate() && _agreeToTerms) {
                        // Validate password match
                        if (_passwordController.text != _confirmPasswordController.text) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Passwords do not match')),
                          );
                          return;
                        }

                        // Show loading indicator
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (context) => const Center(
                            child: CircularProgressIndicator(),
                          ),
                        );

                        try {
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
                            
                            print('Creating database record for user: ${user.uid}');
                            try {
                              // Create a Map with the user data
                              final userData = {
                                'uid': user.uid,
                                'email': user.email,
                                'firstName': _firstNameController.text.trim(),
                                'lastName': _lastNameController.text.trim(),
                                'displayName': fullName, // Store the full name
                                'phone': _phoneController.text.trim(),
                                'createdAt': ServerValue.timestamp,
                                'totalTests': 0,
                                'averageScore': 0.0,
                              };

                              // Set the user data in Realtime Database
                              await FirebaseDatabase.instance
                                  .ref()
                                  .child('users')
                                  .child(user.uid)
                                  .child('profile')
                                  .set(userData);

                              print('Database record created successfully');

                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text(
                                          'Registration successful! Please log in.')),
                                );
                                Navigator.pushReplacementNamed(context, '/login');
                              }
                            } catch (e) {
                              print('Error creating database record: $e');
                              // If database fails, delete the auth user
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
                        } catch (e) {
                          // Handle specific Firebase Auth errors
                          if (e is FirebaseAuthException) {
                            print("Detailed Firebase Auth Error: ${e.code} - ${e.message}");
                            // Show more specific message to the user
                            String errorMessage = "Registration failed";
                            if (e.code == 'weak-password') {
                              errorMessage = "Password is too weak, it must be at least 6 characters";
                            } else if (e.code == 'email-already-in-use') {
                              errorMessage = "This email address is already in use";
                            } else if (e.code == 'invalid-email') {
                              errorMessage = "Invalid email format";
                            } else if (e.code == 'operation-not-allowed') {
                              errorMessage = "Email/password accounts are not enabled";
                            } else {
                              errorMessage = "Error: ${e.message}";
                            }
                            
                            if (context.mounted) {
                              Navigator.of(context).pop(); // Close loading dialog
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(errorMessage)),
                              );
                            }
                          }
                        }
                      } else if (!_agreeToTerms) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content:
                                  Text('Please agree to the terms and conditions')),
                        );
                      }
                    },
                    child: const Text('REGISTER'),
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
