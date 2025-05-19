// previous_results_screen.dart

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class PreviousResultsScreen extends StatefulWidget {
  const PreviousResultsScreen({super.key});

  @override
  State<PreviousResultsScreen> createState() => _PreviousResultsScreenState();
}

class _PreviousResultsScreenState extends State<PreviousResultsScreen> {
  User? get _user => FirebaseAuth.instance.currentUser;
  final DatabaseReference _database = FirebaseDatabase.instance.ref();
  List<Map<String, dynamic>> _testResults = [];
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadTestResults();
  }

  Future<void> _loadTestResults() async {
    if (_user == null) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Please login first';
      });
      return;
    }

    try {
      final snapshot = await _database.child('users/${_user!.uid}/tests').get();
      if (snapshot.exists) {
        final data = snapshot.value as Map<dynamic, dynamic>;
        List<Map<String, dynamic>> tests = [];
        
        data.forEach((key, value) {
          final test = Map<String, dynamic>.from(value as Map);
          test['id'] = key;
          tests.add(test);
        });
        
        // Sort by date (newest to oldest)
        tests.sort((a, b) {
          final aTimestamp = a['timestamp'] as int;
          final bTimestamp = b['timestamp'] as int;
          return bTimestamp.compareTo(aTimestamp);
        });
        
        setState(() {
          _testResults = tests;
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
          _errorMessage = 'NO TEST RESULTS';
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'ERROR WHILE LOADING DATA: $e';
      });
    }
  }

  // Add delete functionality
  Future<void> _deleteTestResult(String testId) async {
    try {
      // Show confirmation dialog
      final shouldDelete = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Delete Test Result'),
          content: const Text('Are you sure you want to delete this test result? This action cannot be undone.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        ),
      );
      
      if (shouldDelete != true) return;
      
      // Delete from Firebase
      await _database.child('users/${_user!.uid}/tests/$testId').remove();
      
      // Also check if this is the last test result in user_answers and delete if needed
      final userAnswersSnapshot = await _database.child('user_answers/${_user!.uid}').get();
      
      if (userAnswersSnapshot.exists) {
        final userAnswersData = Map<String, dynamic>.from(userAnswersSnapshot.value as Map);
        
        // If this data has the same timestamp as the one we're deleting,
        // we should delete it from user_answers as well
        final deletedTest = _testResults.firstWhere((test) => test['id'] == testId);
        final deletedTimestamp = deletedTest['timestamp'] as int;
        
        if (userAnswersData.containsKey('timestamp') && 
            userAnswersData['timestamp'] == deletedTimestamp) {
          await _database.child('user_answers/${_user!.uid}').remove();
        }
      }
      
      // Reload the list
      _loadTestResults();
      
      // Show success message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Test result deleted successfully')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_user == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Previous Results'),
          backgroundColor: Colors.blue.shade800,
          foregroundColor: Colors.white,
        ),
        body: const Center(
          child: Text('Please login to see your results'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('PREVIOUS RESULTS'),
        backgroundColor: Colors.blue.shade800,
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage.isNotEmpty
              ? Center(child: Text(_errorMessage))
              : _testResults.isEmpty
                  ? const Center(child: Text('NO RESULTS YET'))
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: _testResults.length,
                      itemBuilder: (context, index) {
                        final test = _testResults[index];
                        final timestamp = test['timestamp'] as int;
                        final date = DateTime.fromMillisecondsSinceEpoch(timestamp);
                        final formattedDate = '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute}';
                        final testId = test['id'] as String;
                        
                        final answers = List<int>.from(test['answers'] as List);
                        final roomSize = test['roomSize'] as int;
                        
                        return Card(
                          margin: const EdgeInsets.only(bottom: 16),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Test Result #${index + 1}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          formattedDate,
                                          style: TextStyle(
                                            color: Colors.grey[600],
                                            fontSize: 14,
                                          ),
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.delete, color: Colors.red),
                                          onPressed: () => _deleteTestResult(testId),
                                          tooltip: 'Delete this result',
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                Text('Room Preference: $roomSize person',
                                    style: const TextStyle(fontSize: 16)),
                                const SizedBox(height: 8),
                                Text(
                                  'Sleep Late: ${answers[0] == 1 ? 'Yes' : 'No'}',
                                  style: const TextStyle(fontSize: 16),
                                ),
                                Text(
                                  'Study in Silence: ${answers[1] == 1 ? 'Yes' : 'No'}',
                                  style: const TextStyle(fontSize: 16),
                                ),
                                Text(
                                  'Social Person: ${answers[2] == 1 ? 'Yes' : 'No'}',
                                  style: const TextStyle(fontSize: 16),
                                ),
                                Text(
                                  'Study with Music: ${answers[3] == 1 ? 'Yes' : 'No'}',
                                  style: const TextStyle(fontSize: 16),
                                ),
                                Text(
                                  'Clean and Organized: ${answers[4] == 1 ? 'Yes' : 'No'}',
                                  style: const TextStyle(fontSize: 16),
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  children: [
                                    Expanded(
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.blue.shade800,
                                          foregroundColor: Colors.white,
                                        ),
                                        onPressed: () {
                                          Navigator.pushNamed(context, '/best-matches');
                                        },
                                        child: const Text('View Matches'),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
    );
  }
}
