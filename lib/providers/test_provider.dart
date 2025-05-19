import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/test_result_model.dart';
import '../models/previous_result_model.dart';

class TestProvider extends ChangeNotifier {
  final FirebaseDatabase _database = FirebaseDatabase.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  List<String?> _answers = [];
  List<Map<String, dynamic>> _questions = [];
  List<TestResult> _previousResults = [];
  
  bool _isLoading = false;
  String? _errorMessage;
  
  // Getters
  List<String?> get answers => _answers;
  List<Map<String, dynamic>> get questions => _questions;
  List<TestResult> get previousResults => _previousResults;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  
  // Initialize test questions
  void initializeTest() {
    _questions = [
      {
        'en': 'How many people do you want in your room?',
        'tr': 'How many people do you want in your room?',
        'options': ['2', '4'],
        'optionsTr': ['2', '4'],
        'type': 'choice',
      },
      {
        'en': 'Do you sleep late?',
        'tr': 'Do you sleep late?',
        'options': ['Yes', 'No'],
        'optionsTr': ['Yes', 'No'],
        'type': 'binary',
      },
      {
        'en': 'Do you prefer studying in silence?',
        'tr': 'Do you prefer studying in silence?',
        'options': ['Yes', 'No'],
        'optionsTr': ['Yes', 'No'],
        'type': 'binary',
      },
      {
        'en': 'Are you a social person?',
        'tr': 'Are you a social person?',
        'options': ['Yes', 'No'],
        'optionsTr': ['Yes', 'No'],
        'type': 'binary',
      },
      {
        'en': 'Do you like listening to music while studying?',
        'tr': 'Do you like listening to music while studying?',
        'options': ['Yes', 'No'],
        'optionsTr': ['Yes', 'No'],
        'type': 'binary',
      },
      {
        'en': 'Do you keep your room clean and organized?',
        'tr': 'Do you keep your room clean and organized?',
        'options': ['Yes', 'No'],
        'optionsTr': ['Yes', 'No'],
        'type': 'binary',
      },
    ];
    
    // Initialize answers based on questions length
    _answers = List<String?>.filled(_questions.length, null);
    notifyListeners();
  }
  
  // Set answer for a question
  void setAnswer(int questionIndex, String answer) {
    if (questionIndex >= 0 && questionIndex < _answers.length) {
      _answers[questionIndex] = answer;
      notifyListeners();
    }
  }
  
  // Check if all questions are answered
  bool get areAllQuestionsAnswered => !_answers.contains(null);
  
  // Submit test answers
  Future<bool> submitTestAnswers() async {
    if (!areAllQuestionsAnswered) {
      _errorMessage = 'Please answer all questions before submitting.';
      notifyListeners();
      return false;
    }
    
    final user = _auth.currentUser;
    if (user == null) {
      _errorMessage = 'Please log in before taking the test.';
      notifyListeners();
      return false;
    }
    
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    
    try {
      final int roomSize = int.parse(_answers[0]!);
      final List<int> vector = _answers
          .sublist(1)
          .map((a) => a == 'Yes' ? 1 : 0)
          .toList();
          
      // Create test data
      final testData = {
        'roomSize': roomSize,
        'answers': vector,
        'email': user.email ?? '',
        'displayName': user.displayName ?? '',
        'timestamp': ServerValue.timestamp,
        'status': 'Completed',
      };
      
      // Save to Firebase Realtime Database
      final databaseRef = _database.ref();
      
      // Save the user's test results
      await databaseRef.child('users/${user.uid}/tests').push().set(testData);
      
      // Save all answers separately for matching
      await databaseRef.child('user_answers').child(user.uid).set(testData);
      
      // Build trait scores map based on answers
      Map<String, double> traitScores = {};
      for (int i = 0; i < vector.length; i++) {
        traitScores['trait_${i + 1}'] = vector[i].toDouble();
      }
      
      // Create question-answer map
      Map<String, String> questionAnswers = {};
      for (int i = 1; i < _answers.length; i++) {
        questionAnswers['q${i}'] = _answers[i] ?? '';
      }
      
      // Save to Firestore as TestResult
      DocumentReference testResultRef = await _firestore.collection('test_results').add({
        'userId': user.uid,
        'testDate': FieldValue.serverTimestamp(),
        'testType': 'roommate_compatibility',
        'userAnswers': questionAnswers,
        'traitScores': traitScores,
        'isProcessed': false,
        'roomSize': roomSize,
      });
      
      // Update with the document ID
      await testResultRef.update({'id': testResultRef.id});
      
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Failed to submit test: $e';
      notifyListeners();
      return false;
    }
  }
  
  // Load previous test results
  Future<void> loadPreviousResults() async {
    final user = _auth.currentUser;
    if (user == null) {
      _previousResults = [];
      notifyListeners();
      return;
    }
    
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    
    try {
      final QuerySnapshot resultSnapshot = await _firestore
          .collection('test_results')
          .where('userId', isEqualTo: user.uid)
          .orderBy('testDate', descending: true)
          .get();
      
      List<TestResult> results = resultSnapshot.docs
          .map((doc) => TestResult.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
      
      _previousResults = results;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Failed to load previous results: $e';
      notifyListeners();
    }
  }
  
  // Reset test
  void resetTest() {
    _answers = List<String?>.filled(_questions.length, null);
    _errorMessage = null;
    notifyListeners();
  }
} 