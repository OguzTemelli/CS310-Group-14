import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';

class UserProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  UserModel? _userModel;
  bool _isLoading = false;
  String? _errorMessage;
  
  // Getters
  UserModel? get userModel => _userModel;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  
  // Load user data from Firestore
  Future<void> loadUserData() async {
    final User? currentUser = _auth.currentUser;
    if (currentUser == null) {
      _userModel = null;
      notifyListeners();
      return;
    }
    
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    
    try {
      final DocumentSnapshot userDoc = await _firestore
          .collection('users')
          .doc(currentUser.uid)
          .get();
      
      if (userDoc.exists) {
        _userModel = UserModel.fromJson(userDoc.data() as Map<String, dynamic>);
      } else {
        print('User document not found, creating new one: ${currentUser.uid}');
        // Create a basic user model if not exists in Firestore
        final newUser = UserModel(
          uid: currentUser.uid,
          email: currentUser.email ?? '',
          username: currentUser.displayName ?? 'User',
          createdAt: DateTime.now(),
        );
        
        // Save to Firestore
        await _firestore.collection('users').doc(currentUser.uid).set(newUser.toJson());
        _userModel = newUser;
        
        // Also ensure user status is up to date
        await _firestore.collection('user_status').doc(currentUser.uid).set({
          'isOnline': true,
          'lastSeen': FieldValue.serverTimestamp(),
          'displayName': currentUser.displayName ?? 'User',
          'email': currentUser.email ?? '',
        }, SetOptions(merge: true));
      }
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Failed to load user data: $e';
      print('Error loading user data: $e');
      notifyListeners();
    }
  }
  
  // Update user profile
  Future<bool> updateUserProfile({String? username, String? profilePicture}) async {
    final User? currentUser = _auth.currentUser;
    if (currentUser == null || _userModel == null) {
      _errorMessage = 'No authenticated user found';
      notifyListeners();
      return false;
    }
    
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    
    try {
      // Update display name if provided
      if (username != null && username.isNotEmpty) {
        await currentUser.updateDisplayName(username);
      }
      
      // Create updated user model
      UserModel updatedUser = _userModel!.copyWith(
        username: username ?? _userModel!.username,
        profilePicture: profilePicture ?? _userModel!.profilePicture,
      );
      
      // Update Firestore
      await _firestore.collection('users').doc(currentUser.uid).update({
        if (username != null && username.isNotEmpty) 'username': username,
        if (profilePicture != null) 'profilePicture': profilePicture,
      });
      
      // Update user status collection
      if (username != null && username.isNotEmpty) {
        await _firestore.collection('user_status').doc(currentUser.uid).update({
          'displayName': username,
        });
      }
      
      _userModel = updatedUser;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Failed to update profile: $e';
      notifyListeners();
      return false;
    }
  }
  
  // Update user test stats
  Future<void> updateUserTestStats({required int testScore}) async {
    final User? currentUser = _auth.currentUser;
    if (currentUser == null || _userModel == null) return;
    
    try {
      // Calculate new average
      int newTotalTests = _userModel!.totalTests + 1;
      double currentTotalScore = _userModel!.averageScore * _userModel!.totalTests;
      double newAverage = (currentTotalScore + testScore) / newTotalTests;
      
      // Update Firestore
      await _firestore.collection('users').doc(currentUser.uid).update({
        'totalTests': newTotalTests,
        'averageScore': newAverage,
      });
      
      // Update local model
      _userModel = _userModel!.copyWith(
        totalTests: newTotalTests,
        averageScore: newAverage,
      );
      
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to update test stats: $e';
      notifyListeners();
    }
  }
} 