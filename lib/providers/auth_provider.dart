import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  User? _user;
  bool _isLoading = false;
  String? _errorMessage;
  
  // Getters
  User? get user => _user;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _user != null;
  String? get errorMessage => _errorMessage;
  
  // Constructor - initialize current user state
  AuthProvider() {
    _init();
  }
  
  void _init() {
    _user = _auth.currentUser;
    _auth.authStateChanges().listen((User? user) {
      _user = user;
      notifyListeners();
    });
  }
  
  // Sign up with email and password
  Future<bool> signUp({
    required String email, 
    required String password, 
    required String username
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    
    try {
      // Create user with email and password
      final UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      // Update user profile
      await userCredential.user?.updateDisplayName(username);
      
      // Add user data to Firestore
      await _firestore.collection('users').doc(userCredential.user?.uid).set({
        'uid': userCredential.user?.uid,
        'email': email,
        'username': username,
        'createdAt': FieldValue.serverTimestamp(),
        'totalTests': 0,
        'averageScore': 0.0,
      });
      
      // Set initial online status
      await _firestore.collection('user_status').doc(userCredential.user?.uid).set({
        'isOnline': true,
        'lastSeen': FieldValue.serverTimestamp(),
        'displayName': username,
        'email': email,
      });
      
      _user = userCredential.user;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = _getAuthErrorMessage(e);
      notifyListeners();
      return false;
    }
  }
  
  // Sign in with email and password
  Future<bool> signIn({required String email, required String password}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    
    try {
      final UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      // Update online status
      await _firestore.collection('user_status').doc(userCredential.user?.uid).set({
        'isOnline': true,
        'lastSeen': FieldValue.serverTimestamp(),
        'displayName': userCredential.user?.displayName,
        'email': email,
      });
      
      // Check if user document exists in Firestore
      final userDoc = await _firestore.collection('users').doc(userCredential.user?.uid).get();
      
      if (userDoc.exists) {
        // Update existing user document
        await _firestore.collection('users').doc(userCredential.user?.uid).update({
          'lastLoginAt': FieldValue.serverTimestamp(),
        });
      } else {
        // Create new user document if it doesn't exist (for users created before Provider implementation)
        await _firestore.collection('users').doc(userCredential.user?.uid).set({
          'uid': userCredential.user?.uid,
          'email': email,
          'username': userCredential.user?.displayName ?? 'User',
          'createdAt': FieldValue.serverTimestamp(),
          'lastLoginAt': FieldValue.serverTimestamp(),
          'totalTests': 0,
          'averageScore': 0.0,
        });
        
        print('Created new user document for existing auth user: ${userCredential.user?.uid}');
      }
      
      _user = userCredential.user;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = _getAuthErrorMessage(e);
      notifyListeners();
      return false;
    }
  }
  
  // Sign out
  Future<void> signOut() async {
    _isLoading = true;
    notifyListeners();
    
    try {
      // Update online status before signing out
      if (_user != null) {
        await _firestore.collection('user_status').doc(_user!.uid).set({
          'isOnline': false,
          'lastSeen': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
      }
      
      await _auth.signOut();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = _getAuthErrorMessage(e);
      notifyListeners();
    }
  }
  
  // Helper method to get readable error messages
  String _getAuthErrorMessage(dynamic e) {
    if (e is FirebaseAuthException) {
      switch (e.code) {
        case 'user-not-found':
          return 'No user found with this email.';
        case 'wrong-password':
          return 'Wrong password provided.';
        case 'email-already-in-use':
          return 'The email address is already in use.';
        case 'weak-password':
          return 'The password provided is too weak.';
        case 'invalid-email':
          return 'The email address is invalid.';
        case 'operation-not-allowed':
          return 'This operation is not allowed.';
        case 'user-disabled':
          return 'This user account has been disabled.';
        case 'too-many-requests':
          return 'Too many requests. Try again later.';
        case 'network-request-failed':
          return 'Network error. Check your connection.';
        default:
          return 'An unknown error occurred: ${e.code}';
      }
    }
    return 'An error occurred: $e';
  }
} 