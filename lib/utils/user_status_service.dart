import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Service that manages user online status in Firestore
class UserStatusService {
  static final UserStatusService _instance = UserStatusService._internal();
  factory UserStatusService() => _instance;
  UserStatusService._internal();
  
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  StreamSubscription<QuerySnapshot>? _onlineUsersSubscription;
  final StreamController<List<Map<String, dynamic>>> _onlineUsersController = 
      StreamController<List<Map<String, dynamic>>>.broadcast();
  
  // Stream of online users that UI components can listen to
  Stream<List<Map<String, dynamic>>> get onlineUsers => _onlineUsersController.stream;
  
  // Initialize the service and set up listeners
  void initialize() {
    final user = _auth.currentUser;
    if (user != null) {
      // Set current user as online
      _setUserOnlineStatus(user.uid, true);
      
      // Set up listener for online users
      _setupOnlineUsersListener();
    }
    
    // Listen for auth state changes
    _auth.authStateChanges().listen((User? user) {
      if (user != null) {
        // User signed in
        _setUserOnlineStatus(user.uid, true);
        _setupOnlineUsersListener();
      } else {
        // User signed out
        final currentUser = _auth.currentUser;
        if (currentUser != null) {
          _setUserOnlineStatus(currentUser.uid, false);
        }
        _onlineUsersSubscription?.cancel();
      }
    });
  }
  
  // Set up a real-time listener for online users
  void _setupOnlineUsersListener() {
    _onlineUsersSubscription?.cancel(); // Cancel existing subscription if any
    
    _onlineUsersSubscription = _firestore
        .collection('user_status')
        .where('isOnline', isEqualTo: true)
        .snapshots()
        .listen((snapshot) {
      final List<Map<String, dynamic>> users = [];
      for (var doc in snapshot.docs) {
        final data = doc.data();
        users.add({
          'uid': doc.id,
          'displayName': data['displayName'] ?? 'Unknown User',
          'email': data['email'] ?? '',
          'lastSeen': data['lastSeen'],
          'photoURL': data['photoURL'],
        });
      }
      _onlineUsersController.add(users);
    }, onError: (error) {
      print('Error listening to online users: $error');
    });
  }
  
  // Set user online status in Firestore
  Future<void> _setUserOnlineStatus(String uid, bool isOnline) async {
    final user = _auth.currentUser;
    if (user != null) {
      try {
        await _firestore.collection('user_status').doc(uid).set({
          'isOnline': isOnline,
          'lastSeen': FieldValue.serverTimestamp(),
          'displayName': user.displayName ?? user.email?.split('@')[0] ?? 'User',
          'email': user.email ?? '',
          'photoURL': user.photoURL,
        }, SetOptions(merge: true));
      } catch (e) {
        print('Error updating user status: $e');
      }
    }
  }
  
  // Update user's online status manually
  Future<void> updateUserStatus(bool isOnline) async {
    final user = _auth.currentUser;
    if (user != null) {
      await _setUserOnlineStatus(user.uid, isOnline);
    }
  }
  
  // Clean up resources
  void dispose() {
    _onlineUsersSubscription?.cancel();
  }
}