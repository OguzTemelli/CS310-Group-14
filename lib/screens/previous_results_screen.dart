// previous_results_screen.dart

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PreviousResultsScreen extends StatefulWidget {
  const PreviousResultsScreen({super.key});

  @override
  State<PreviousResultsScreen> createState() => _PreviousResultsScreenState();
}

class _PreviousResultsScreenState extends State<PreviousResultsScreen> {
  User? get _user => FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    if (_user == null) {
      // Not signed in
      return Scaffold(
        body: Center(child: Text('Please log in to see your results')),
      );
    }

    // Stream from the 'tests' subcollection
    final testsStream = FirebaseFirestore.instance
        .collection('users')
        .doc(_user!.uid)
        .collection('tests')
        .orderBy('timestamp', descending: true) // Order by timestamp
        .snapshots();

    return Scaffold(
      backgroundColor: const Color(0xFF1A237E),
      body: SafeArea(
        child: Column(
          children: [
            // — Header with back button + title —
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.1),
                        width: 1,
                      ),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  const SizedBox(width: 20),
                  const Text(
                    'Previous Results',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            // — Stream of test documents —
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: testsStream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(
                      child: Text(
                        'No previous tests found.',
                        style: TextStyle(color: Colors.white70),
                      ),
                    );
                  }

                  final docs = snapshot.data!.docs;
                  return ListView.builder(
                    padding: const EdgeInsets.all(20),
                    itemCount: docs.length,
                    itemBuilder: (context, index) {
                      final doc = docs[index];
                      final data = doc.data()! as Map<String, dynamic>;
                      final roomSize = data['roomSize'] as int? ?? 0; // Get roomSize
                      final answers = List<int>.from(data['answers'] ?? []); // Get answers
                      final savedStatus = data['status'] as String? ?? ''; // Get saved status
                      final testNumber = docs.length - index; // Calculate test number (newest is 1)

                      // Determine display status based on index (newest is Valid)
                      final displayStatus = index == 0 ? 'Valid' : 'Invalid';

                      return _buildTestResultItem(
                        testNumber: testNumber,
                        roomSize: roomSize,
                        status: displayStatus, // Use the determined display status
                        answers: answers, // Pass answers to the new widget
                        onRemove: savedStatus == 'Completed' // Show soft delete for Completed tests
                            ? () {
                                FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(_user!.uid)
                                    .collection('tests')
                                    .doc(doc.id)
                                    .update({'status': 'Deleted'}); // Change status to Deleted
                              }
                            : null,
                        onHardDelete: savedStatus == 'Deleted' // Show hard delete for Deleted tests
                            ? () {
                                FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(_user!.uid)
                                    .collection('tests')
                                    .doc(doc.id)
                                    .delete(); // Completely delete the document
                              }
                            : null,
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // New widget to build each test result item with expandable details
  Widget _buildTestResultItem({
    required int testNumber,
    required int roomSize,
    required String status,
    required List<int> answers,
    VoidCallback? onRemove,
    VoidCallback? onHardDelete,
  }) {
    final questions = [
      'Sleep late',
      'Prefer studying in silence',
      'Social person',
      'Listen to music while studying',
      'Keep room clean and organized',
    ];

    // Determine the background color based on the status
    final backgroundColor = status == 'Valid'
        ? Colors.green.withOpacity(0.2) // Greenish tone for Valid
        : status == 'Deleted'
            ? Colors.red.withOpacity(0.2) // Reddish tone for Deleted
            : Colors.white.withOpacity(0.1); // Existing color for others

    return Card(
      margin: const EdgeInsets.only(bottom: 15),
      color: backgroundColor, // Use the determined background color
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              testNumber.toString(),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        title: Text(
          'Test #$testNumber - Room Size: $roomSize',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          'Status: $status',
          style: TextStyle(
            color: Colors.white.withOpacity(0.7),
            fontSize: 14,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (onRemove != null) // Show soft delete for Valid/Completed tests
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.white70), // Soft delete icon
                onPressed: onRemove,
              ),
            if (onHardDelete != null) // Show hard delete for Deleted tests
              IconButton(
                icon: const Icon(Icons.delete_forever, color: Colors.redAccent), // Hard delete icon (red)
                onPressed: onHardDelete,
              ),
            // Add Best Matches button here
            IconButton(
              icon: const Icon(Icons.arrow_forward_ios, color: Colors.white70),
              onPressed: () {
                // TODO: Pass the test ID or relevant data to the best matches screen
                Navigator.pushNamed(context, '/best-matches');
              },
            ),
          ],
        ),
        children: status == 'Deleted' ? [] : [ // Hide children if status is Deleted
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Your Answers:',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                ...List.generate(answers.length, (index) {
                  // Ensure the index is within the bounds of questions list
                  if (index < questions.length) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        children: [
                          Text(
                            questions[index],
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.7),
                              fontSize: 14,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            answers[index] == 1 ? 'Yes' : 'No',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    );
                  } else {
                    // Handle unexpected index if necessary (e.g., log a warning)
                    return Container(); // Return an empty container for invalid indices
                  }
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
