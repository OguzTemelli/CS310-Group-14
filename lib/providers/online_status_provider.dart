import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';

class OnlineStatusProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseDatabase _database = FirebaseDatabase.instance;
  
  List<Map<String, dynamic>> _onlineUsers = [];
  StreamSubscription<QuerySnapshot>? _onlineUsersSubscription;
  StreamSubscription<DatabaseEvent>? _connectedSubscription;
  
  bool _isSetup = false;
  
  // Getters
  List<Map<String, dynamic>> get onlineUsers => _onlineUsers;
  
  // Constructor
  OnlineStatusProvider() {
    // Listen for auth state changes
    _auth.authStateChanges().listen((User? user) {
      if (user != null && !_isSetup) {
        _setupOnlineStatus();
        _listenToOnlineUsers();
        _isSetup = true;
      } else if (user == null) {
        _cleanupSubscriptions();
        _isSetup = false;
      }
    });
  }
  
  // Cleanup when provider is no longer needed
  @override
  void dispose() {
    _cleanupSubscriptions();
    super.dispose();
  }
  
  // Clean up subscriptions
  void _cleanupSubscriptions() {
    _onlineUsersSubscription?.cancel();
    _connectedSubscription?.cancel();
    _onlineUsers = [];
    notifyListeners();
  }
  
  // Set current user online status
  void _setupOnlineStatus() {
    final user = _auth.currentUser;
    if (user != null) {
      final databaseRef = _database.ref().child('status/${user.uid}');
      
      // Set up onDisconnect to update status when connection is lost
      databaseRef.onDisconnect().update({'status': 'offline'});
      
      // Set current status to online
      databaseRef.update({'status': 'online'});
      
      // Listen to connection state
      _connectedSubscription = _database.ref('.info/connected').onValue.listen((event) {
        if (event.snapshot.value == false) {
          return;
        }
        
        // If we're connected, set up the onDisconnect handler
        databaseRef.onDisconnect().update({'status': 'offline'});
        databaseRef.update({'status': 'online'});
      });
      
      // Also update Firestore status
      _firestore.collection('user_status').doc(user.uid).set({
        'isOnline': true,
        'lastSeen': FieldValue.serverTimestamp(),
        'displayName': user.displayName,
        'email': user.email,
      }, SetOptions(merge: true));
    }
  }
  
  // Listen for online users
  void _listenToOnlineUsers() {
    final user = _auth.currentUser;
    if (user != null) {
      // Get timestamp for 2 minutes ago
      final twoMinutesAgo = DateTime.now().subtract(const Duration(minutes: 2));
      final timestamp = Timestamp.fromDate(twoMinutesAgo);
      
      _onlineUsersSubscription = _firestore
        .collection('user_status')
        .where('isOnline', isEqualTo: true)
        .snapshots()
        .listen((snapshot) {
          final List<Map<String, dynamic>> users = [];
          for (var doc in snapshot.docs) {
            // Skip current user
            if (doc.id != user.uid) {
              final data = doc.data();
              
              // Additional check for recent activity
              bool isRecentlyActive = true;
              if (data['lastSeen'] != null) {
                final lastSeen = data['lastSeen'] as Timestamp;
                // Only consider the user online if they were seen in the last 2 minutes
                isRecentlyActive = lastSeen.compareTo(timestamp) >= 0;
              }
              
              if (isRecentlyActive) {
                users.add({
                  'uid': doc.id,
                  'displayName': data['displayName'] ?? 'Unknown User',
                  'email': data['email'] ?? '',
                  'lastSeen': data['lastSeen'],
                });
              }
            }
          }
          
          _onlineUsers = users;
          notifyListeners();
        }, onError: (error) {
          print('Error listening to online users: $error');
        });
    }
  }
  
  // Force update user status to online/offline
  Future<void> updateUserStatus(bool isOnline) async {
    final user = _auth.currentUser;
    if (user != null) {
      // Update Realtime Database status
      await _database.ref().child('status/${user.uid}').update({
        'status': isOnline ? 'online' : 'offline',
      });
      
      // Update Firestore status
      await _firestore.collection('user_status').doc(user.uid).set({
        'isOnline': isOnline,
        'lastSeen': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    }
  }
  
  // Get a specific user's online status
  Future<bool> getUserOnlineStatus(String userId) async {
    try {
      final doc = await _firestore.collection('user_status').doc(userId).get();
      if (doc.exists) {
        final data = doc.data();
        if (data != null && data['isOnline'] == true) {
          // Check if lastSeen is recent (within 2 minutes)
          if (data['lastSeen'] != null) {
            final lastSeen = data['lastSeen'] as Timestamp;
            final twoMinutesAgo = DateTime.now().subtract(const Duration(seconds: 5));
            return lastSeen.toDate().isAfter(twoMinutesAgo);
          }
          return true;
        }
      }
      return false;
    } catch (e) {
      print('Error checking user status: $e');
      return false;
    }
  }
} 