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
      // First, check if we have stored matches in Firestore
      final QuerySnapshot storedMatches = await _firestore
          .collection('best_matches')
          .where('userId', isEqualTo: user.uid)
          .orderBy('matchScore', descending: true)
          .get();
      
      // If we have stored matches, use those instead of recalculating
      if (storedMatches.docs.isNotEmpty) {
        final List<Map<String, dynamic>> tempMatches = [];
        
        for (var doc in storedMatches.docs) {
          final matchData = doc.data() as Map<String, dynamic>;
          
          // Get matched user info from Firestore or database
          final matchedUserId = matchData['matchedUserId'] as String;
          final matchedUserSnapshot = await _database
              .ref()
              .child('user_answers')
              .child(matchedUserId)
              .get();
          
          if (matchedUserSnapshot.exists) {
            final userDataMap = Map<String, dynamic>.from(matchedUserSnapshot.value as Map);
            
            tempMatches.add({
              'userId': matchedUserId,
              'name': userDataMap['displayName'] ?? 'Unnamed',
              'email': userDataMap['email'] ?? '',
              'similarity': matchData['matchScore'] as double,
            });
          }
        }
        
        _matches = tempMatches;
        _isLoading = false;
        notifyListeners();
        return;
      }
      
      // If no stored matches, proceed with calculating new matches
      // Get the current user's answers
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
            
            // Store this match in Firestore (for both users)
            saveMatch({
              'userId': userId,
              'similarity': similarity,
            });
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
      notifyListeners();
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
      final QuerySnapshot matchSnapshot = await _firestore
          .collection('best_matches')
          .where('userId', isEqualTo: user.uid)
          .orderBy('matchScore', descending: true)
          .get();
      
      List<BestMatch> matches = matchSnapshot.docs
          .map((doc) => BestMatch.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
      
      _bestMatches = matches;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Failed to load best matches: $e';
      notifyListeners();
    }
  }
  
  // Store a match in Firestore
  Future<void> saveMatch(Map<String, dynamic> matchData) async {
    final user = _auth.currentUser;
    if (user == null) return;
    
    try {
      // First get the user's latest test result
      final QuerySnapshot testResults = await _firestore
          .collection('test_results')
          .where('userId', isEqualTo: user.uid)
          .orderBy('testDate', descending: true)
          .limit(1)
          .get();
      
      if (testResults.docs.isEmpty) return;
      
      final String testResultId = testResults.docs.first.id;
      final matchedUser = matchData['userId'];
      final double similarity = matchData['similarity'];
      
      // Check if there's already a match between these users
      final QuerySnapshot existingMatches = await _firestore
          .collection('best_matches')
          .where('userId', isEqualTo: user.uid)
          .where('matchedUserId', isEqualTo: matchedUser)
          .get();
      
      if (existingMatches.docs.isNotEmpty) {
        // Update existing match
        await _firestore.collection('best_matches').doc(existingMatches.docs.first.id).update({
          'matchScore': similarity,
          'matchDate': FieldValue.serverTimestamp(),
          'testResultId': testResultId,
        });
      } else {
        // Create new match record
        DocumentReference matchRef = await _firestore.collection('best_matches').add({
          'userId': user.uid,
          'matchedUserId': matchedUser,
          'matchScore': similarity,
          'matchDate': FieldValue.serverTimestamp(),
          'matchType': 'roommate',
          'traitComparisons': {}, // Would need actual trait data
          'commonAnswers': {}, // Would need actual answer data
          'commonTraits': [], // Would need actual trait data
          'testResultId': testResultId,
          'previousResultId': '', // No previous result in this context
        });
        
        // Update with the document ID
        await matchRef.update({'id': matchRef.id});
      }
      
      // Create or update the reciprocal match (from matched user's perspective)
      final QuerySnapshot existingReciprocalMatches = await _firestore
          .collection('best_matches')
          .where('userId', isEqualTo: matchedUser)
          .where('matchedUserId', isEqualTo: user.uid)
          .get();
          
      if (existingReciprocalMatches.docs.isNotEmpty) {
        // Update existing reciprocal match with the same score
        await _firestore.collection('best_matches').doc(existingReciprocalMatches.docs.first.id).update({
          'matchScore': similarity, // Use the same similarity score
          'matchDate': FieldValue.serverTimestamp(),
        });
      } else {
        // Create new reciprocal match record with the same score
        DocumentReference reciprocalMatchRef = await _firestore.collection('best_matches').add({
          'userId': matchedUser,
          'matchedUserId': user.uid,
          'matchScore': similarity, // Use the same similarity score
          'matchDate': FieldValue.serverTimestamp(),
          'matchType': 'roommate',
          'traitComparisons': {}, // Would need actual trait data
          'commonAnswers': {}, // Would need actual answer data
          'commonTraits': [], // Would need actual trait data
          'testResultId': '', // We don't know the other user's test result ID
          'previousResultId': '', // No previous result in this context
        });
        
        // Update with the document ID
        await reciprocalMatchRef.update({'id': reciprocalMatchRef.id});
      }
    } catch (e) {
      _errorMessage = 'Failed to save match: $e';
      notifyListeners();
    }
  }
} 