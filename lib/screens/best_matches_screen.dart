// screens/best_matches_screen.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BestMatchesScreen extends StatefulWidget {
  const BestMatchesScreen({super.key});

  @override
  State<BestMatchesScreen> createState() => _BestMatchesScreenState();
}

class _BestMatchesScreenState extends State<BestMatchesScreen> {
  List<Map<String, dynamic>> _matches = [];

  // Weights for each binary question (can adjust importance here)
  final List<double> questionWeights = [1, 1, 1, 1, 1];

  @override
  void initState() {
    super.initState();
    _loadMatches();
  }

  Future<void> _loadMatches() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final currentDoc = await FirebaseFirestore.instance
        .collection('user_answers')
        .doc(user.uid)
        .get();
    if (!currentDoc.exists) return;

    final int currentRoomSize = currentDoc['roomSize'];
    final List<int> vectorA = currentDoc['answers'].cast<int>();

    final snapshot = await FirebaseFirestore.instance
        .collection('user_answers')
        .where('roomSize', isEqualTo: currentRoomSize)
        .get();

    final List<Map<String, dynamic>> temp = [];
    for (final doc in snapshot.docs) {
      if (doc.id == user.uid) continue;
      final List<int> vectorB = doc['answers'].cast<int>();

      double weightedMatches = 0;
      final totalWeight = questionWeights.reduce((a, b) => a + b);
      for (var i = 0; i < vectorA.length; i++) {
        if (vectorA[i] == vectorB[i]) {
          weightedMatches += questionWeights[i];
        }
      }
      final similarity = weightedMatches / totalWeight;

      temp.add({
        'name': doc['displayName'] ?? 'Unknown',
        'email': doc['email'] ?? '',
        'similarity': similarity,
      });
    }

    temp.sort((a, b) => b['similarity'].compareTo(a['similarity']));

    setState(() {
      _matches = temp;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1a237e),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 20),
                  const Text(
                    'Best Matches',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(20),
                itemCount: _matches.length,
                itemBuilder: (context, index) {
                  final match = _matches[index];
                  final percent = (match['similarity'] * 100).toStringAsFixed(0);
                  return Container(
                    margin: const EdgeInsets.only(bottom: 15),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.white.withOpacity(0.1),
                          Colors.white.withOpacity(0.05),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.1),
                        width: 1,
                      ),
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.white.withOpacity(0.1),
                        child: Image.asset(
                          'assets/images/profile_icon.png',
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) =>
                          const Icon(Icons.person, color: Colors.white70),
                        ),
                      ),
                      title: Text(match['name'],
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold)),
                      subtitle: Text(match['email'],
                          style: TextStyle(
                              color: Colors.white.withOpacity(0.7),
                              fontSize: 14)),
                      trailing: Text('$percent%',
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold)),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}