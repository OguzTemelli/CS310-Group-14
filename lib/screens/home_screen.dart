import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'package:firebase_database/firebase_database.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String userName = 'User';
  String userEmail = 'user@example.com';
  List<Map<String, dynamic>> onlineUsers = [];
  StreamSubscription<QuerySnapshot>? _onlineUsersSubscription;
  
  @override
  void initState() {
    super.initState();
    _loadUserData();
    _setupOnlineStatus();
    _listenToOnlineUsers();
  }
  
  @override
  void dispose() {
    _onlineUsersSubscription?.cancel();
    super.dispose();
  }
  
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Reload user data whenever the screen rebuilds
    _loadUserData();
  }

  // Set current user online status
  void _setupOnlineStatus() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final databaseRef = FirebaseDatabase.instance.ref().child('status/${user.uid}');

      // Set up onDisconnect to update status when connection is lost
      databaseRef.onDisconnect().update({'status': 'offline'});

      // Set current status to online
      databaseRef.update({'status': 'online'});

      // Listen to connection state
      FirebaseDatabase.instance.ref('.info/connected').onValue.listen((event) {
        if (event.snapshot.value == false) {
          return;
        }
        
        // If we're connected, set up the onDisconnect handler
        databaseRef.onDisconnect().update({'status': 'offline'});
        databaseRef.update({'status': 'online'});
      });
    }
  }
  
  // Listen for online users
  void _listenToOnlineUsers() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // Get timestamp for 2 minutes ago
      final twoMinutesAgo = DateTime.now().subtract(const Duration(minutes: 2));
      final timestamp = Timestamp.fromDate(twoMinutesAgo);
      
      _onlineUsersSubscription = FirebaseFirestore.instance
        .collection('user_status')
        .where('isOnline', isEqualTo: true)
        // Consider users who have been seen in the last 2 minutes
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
          
          setState(() {
            onlineUsers = users;
            print('Online users updated: ${users.length}');
          });
        }, onError: (error) {
          print('Error listening to online users: $error');
        });
    }
  }
  
  String _getShortName(String fullName) {
    if (fullName.length <= 8) return fullName;
    return '${fullName.substring(0, 7)}...';
  }
  
  void _loadUserData() {
    final User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      // Force a refresh of the user info from Firebase
      currentUser.reload().then((_) {
        // Get the latest user data
        final refreshedUser = FirebaseAuth.instance.currentUser;
        if (refreshedUser != null) {
          setState(() {
            // Use display name if available, otherwise extract name from email
            userName = refreshedUser.displayName ?? 
                      refreshedUser.email?.split('@')[0] ?? 'User';
            userEmail = refreshedUser.email ?? 'user@example.com';
            
            print('User data loaded: $userName, $userEmail');
          });
        }
      }).catchError((error) {
        print('Error reloading user data: $error');
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1a237e),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              // Profile Card
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.white.withOpacity(0.1),
                      Colors.white.withOpacity(0.05),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.1),
                    width: 1,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    children: [
                      // Profile Picture
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white.withOpacity(0.2),
                            width: 2,
                          ),
                        ),
                        child: CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.white.withOpacity(0.1),
                          child: const Icon(
                            Icons.person,
                            size: 35,
                            color: Colors.white70,
                          ),
                        ),
                      ),
                      const SizedBox(width: 15),
                      // User Information
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Welcome $userName',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              userEmail,
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.7),
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Upgrade Button
                      Container(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(25),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.pushNamed(context, '/upgrade-membership');
                          },
                          icon: const Icon(Icons.star, color: Colors.white),
                          label: const Text('Upgrade'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              
              // Add Online Users Bar
              if (onlineUsers.isNotEmpty) ...[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.people, color: Colors.white.withOpacity(0.7), size: 16),
                        const SizedBox(width: 6),
                        Text(
                          'Online Users',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.7),
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            '${onlineUsers.length}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 60,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: onlineUsers.length,
                        itemBuilder: (context, index) {
                          final user = onlineUsers[index];
                          final displayName = user['displayName']?.toString() ?? 'User';
                          final firstLetter = displayName.isNotEmpty ? displayName.substring(0, 1).toUpperCase() : 'U';
                          
                          return Padding(
                            padding: const EdgeInsets.only(right: 12),
                            child: Column(
                              children: [
                                Stack(
                                  children: [
                                    CircleAvatar(
                                      radius: 20,
                                      backgroundColor: Colors.white.withOpacity(0.2),
                                      child: Text(
                                        firstLetter,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      right: 0,
                                      bottom: 0,
                                      child: Container(
                                        width: 12,
                                        height: 12,
                                        decoration: BoxDecoration(
                                          color: Colors.green,
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: const Color(0xFF1a237e),
                                            width: 2,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  _getShortName(displayName),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
              
              // Menu Grid
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 20,
                  crossAxisSpacing: 20,
                  children: [
                    _buildMenuButton(
                      icon: Icons.quiz,
                      label: 'Take The\nTest',
                      onTap: () {
                        Navigator.pushNamed(context, '/test-confirmation');
                      },
                    ),
                    _buildMenuButton(
                      icon: Icons.history,
                      label: 'Previous\nResults',
                      onTap: () {
                        Navigator.pushNamed(context, '/previous-results');
                      },
                    ),
                    _buildMenuButton(
                      icon: Icons.school,
                      label: 'Dorm\nRules',
                      onTap: () {
                        Navigator.pushNamed(context, '/rules');
                      },
                    ),
                    _buildMenuButton(
                      icon: Icons.home,
                      label: 'SuDorms',
                      onTap: () {
                        Navigator.pushNamed(context, '/dorms');
                      },
                    ),
                    _buildMenuButton(
                      icon: Icons.contact_phone,
                      label: 'Contact',
                      onTap: () {
                        Navigator.pushNamed(context, '/contact');
                      },
                    ),
                    _buildMenuButton(
                      icon: Icons.feedback,
                      label: 'Feedback',
                      onTap: () {
                        Navigator.pushNamed(context, '/feedback');
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              // Logoff Button
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.1),
                    width: 1,
                  ),
                ),
                child: ElevatedButton.icon(
                  onPressed: () {
                    // Update status to offline before signing out
                    _setupOnlineStatusOffline();
                    
                    // Sign out the user
                    FirebaseAuth.instance.signOut();
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      '/welcome',
                      (route) => false,
                    );
                  },
                  icon: Icon(
                    Icons.logout,
                    color: Colors.white.withOpacity(0.9),
                    size: 20,
                  ),
                  label: Text(
                    'Log Out',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  // Set user status to offline when logging out
  void _setupOnlineStatusOffline() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      FirebaseFirestore.instance.collection('user_status').doc(user.uid).set({
        'isOnline': false,
        'lastSeen': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    }
  }

  Widget _buildMenuButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: Colors.white),
            const SizedBox(height: 10),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}