import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/best_match_model.dart';

class MatchesProvider extends ChangeNotifier {
  final FirebaseDatabase _database = FirebaseDatabase.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  List<Map<String, dynamic>> _matches = [];
  List<BestMatch> _bestMatches = [];
  bool _isLoading = false;
  String? _errorMessage;
  
  // Weights for each binary question (can adjust importance here)
  final List<double> _questionWeights = [1, 1, 1, 1, 1];
  
  // Getters
  List<Map<String, dynamic>> get matches => _matches;
  List<BestMatch> get bestMatches => _bestMatches;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  
  // Load roommate matches from Firebase Realtime Database
  Future<void> loadMatches() async {
    final user = _auth.currentUser;
    if (user == null) {
      _errorMessage = 'Please login first';
      _matches = [];
      notifyListeners();
      return;
    }
    
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    
    try {
      // Get the current user's answers first
      final currentUserSnapshot = await _database
          .ref()
          .child('user_answers')
          .child(user.uid)
          .get();
      
      if (!currentUserSnapshot.exists) {
        _isLoading = false;
        _errorMessage = 'NO TEST RESULTS';
        _matches = [];
        notifyListeners();
        return;
      }
      
      final currentUserData = Map<String, dynamic>.from(currentUserSnapshot.value as Map);
      final int currentRoomSize = currentUserData['roomSize'] as int;
      final List<int> vectorA = List<int>.from(currentUserData['answers'] as List);
      
      // Get all users' answers
      final allAnswersSnapshot = await _database
          .ref()
          .child('user_answers')
          .get();
      
      if (!allAnswersSnapshot.exists) {
        _isLoading = false;
        _errorMessage = 'NO DATA TO MATCH';
        _matches = [];
        notifyListeners();
        return;
      }
      
      final allAnswersData = Map<String, dynamic>.from(allAnswersSnapshot.value as Map);
      final List<Map<String, dynamic>> tempMatches = [];
      
      allAnswersData.forEach((userId, userData) {
        // Skip ourselves
        if (userId != user.uid) {
          final userDataMap = Map<String, dynamic>.from(userData as Map);
          final int userRoomSize = userDataMap['roomSize'] as int;
          
          // Only match with those who prefer the same room size
          if (userRoomSize == currentRoomSize) {
            final List<int> vectorB = List<int>.from(userDataMap['answers'] as List);
            
            // Calculate similarity score
            double weightedMatches = 0;
            final totalWeight = _questionWeights.reduce((a, b) => a + b);
            
            for (var i = 0; i < vectorA.length; i++) {
              if (i < vectorB.length && vectorA[i] == vectorB[i]) {
                weightedMatches += _questionWeights[i];
              }
            }
            
            final similarity = weightedMatches / totalWeight;
            
            tempMatches.add({
              'userId': userId,
              'name': userDataMap['displayName'] ?? 'Unnamed',
              'email': userDataMap['email'] ?? '',
              'similarity': similarity,
            });
            
            // Store match in Firestore
            storeMatchSafely(userId, similarity);
          }
        }
      });
      
      // Sort by similarity score (highest to lowest)
      tempMatches.sort((a, b) => b['similarity'].compareTo(a['similarity']));
      
      _matches = tempMatches;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'An error occurred while loading matches: $e';
      print('Error loading matches: $e');
      notifyListeners();
    }
  }
  
  // A safer way to store match data without complex queries
  Future<void> storeMatchSafely(String matchedUserId, double similarity) async {
    final user = _auth.currentUser;
    if (user == null) return;
    
    try {
      // Create a unique ID for the match using both user IDs
      final String matchDocId = '${user.uid}_${matchedUserId}';
      final String reciprocalMatchDocId = '${matchedUserId}_${user.uid}';
      
      // Create or update match document with a known ID
      await _firestore.collection('best_matches').doc(matchDocId).set({
        'id': matchDocId,
        'userId': user.uid,
        'matchedUserId': matchedUserId,
        'matchScore': similarity,
        'matchDate': FieldValue.serverTimestamp(),
        'matchType': 'roommate'
      }, SetOptions(merge: true));
      
      // Create the reciprocal match with the same score
      await _firestore.collection('best_matches').doc(reciprocalMatchDocId).set({
        'id': reciprocalMatchDocId,
        'userId': matchedUserId,
        'matchedUserId': user.uid,
        'matchScore': similarity,
        'matchDate': FieldValue.serverTimestamp(),
        'matchType': 'roommate'
      }, SetOptions(merge: true));
    } catch (e) {
      print('Error storing match: $e');
    }
  }
  
  // Load best matches from Firestore
  Future<void> loadBestMatchesFirestore() async {
    final user = _auth.currentUser;
    if (user == null) {
      _bestMatches = [];
      notifyListeners();
      return;
    }
    
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    
    try {
      // Get all matches where the current user is involved
      final QuerySnapshot matchSnapshot = await _firestore
          .collection('best_matches')
          .where('userId', isEqualTo: user.uid)
          .get();
      
      List<BestMatch> matches = matchSnapshot.docs
          .map((doc) => BestMatch.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
      
      // Sort locally instead of using orderBy in Firestore
      matches.sort((a, b) => b.matchScore.compareTo(a.matchScore));
      
      _bestMatches = matches;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Failed to load best matches: $e';
      print('Firestore error: $e');
      notifyListeners();
    }
  }
  
  // Store a match in Firestore
  Future<void> saveMatch(Map<String, dynamic> matchData) async {
    final user = _auth.currentUser;
    if (user == null) return;
    
    try {
      final matchedUserId = matchData['userId'];
      final double similarity = matchData['similarity'];
      
      // Create a unique ID for the match using both user IDs
      final String matchDocId = '${user.uid}_${matchedUserId}';
      final String reciprocalMatchDocId = '${matchedUserId}_${user.uid}';
      
      // Create or update match document with a known ID
      await _firestore.collection('best_matches').doc(matchDocId).set({
        'id': matchDocId,
        'userId': user.uid,
        'matchedUserId': matchedUserId,
        'matchScore': similarity,
        'matchDate': FieldValue.serverTimestamp(),
        'matchType': 'roommate'
      }, SetOptions(merge: true));
      
      // Create the reciprocal match with the same score
      await _firestore.collection('best_matches').doc(reciprocalMatchDocId).set({
        'id': reciprocalMatchDocId,
        'userId': matchedUserId,
        'matchedUserId': user.uid,
        'matchScore': similarity,
        'matchDate': FieldValue.serverTimestamp(),
        'matchType': 'roommate'
      }, SetOptions(merge: true));
      
    } catch (e) {
      _errorMessage = 'Failed to save match: $e';
      print('Firebase error: $e');
      notifyListeners();
    }
  }
} 