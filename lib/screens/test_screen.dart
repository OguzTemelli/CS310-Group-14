import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// ----------------------- TestScreen -----------------------
class TestScreen extends StatefulWidget {
  const TestScreen({super.key});

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  bool isEnglish = true;
  int currentQuestionIndex = 0;

  // Questions: first is room size, then binary yes/no
  final List<Map<String, dynamic>> questions = [
    {
      'en': 'How many people do you want in your room?',
      'tr': 'Kaç kişilik odada kalmak istiyorsun?',
      'options': ['2', '4'],
      'optionsTr': ['2', '4'],
      'type': 'choice',
    },
    {
      'en': 'Do you sleep late?',
      'tr': 'Geç mi uyursun?',
      'options': ['Yes', 'No'],
      'optionsTr': ['Evet', 'Hayır'],
      'type': 'binary',
    },
    {
      'en': 'Do you prefer studying in silence?',
      'tr': 'Sessizlikte çalışmayı mı tercih edersin?',
      'options': ['Yes', 'No'],
      'optionsTr': ['Evet', 'Hayır'],
      'type': 'binary',
    },
    {
      'en': 'Are you a social person?',
      'tr': 'Sosyal bir insan mısın?',
      'options': ['Yes', 'No'],
      'optionsTr': ['Evet', 'Hayır'],
      'type': 'binary',
    },
    {
      'en': 'Do you like listening to music while studying?',
      'tr': 'Ders çalışırken müzik dinlemeyi sever misin?',
      'options': ['Yes', 'No'],
      'optionsTr': ['Evet', 'Hayır'],
      'type': 'binary',
    },
    {
      'en': 'Do you keep your room clean and organized?',
      'tr': 'Odanı temiz ve düzenli tutar mısın?',
      'options': ['Yes', 'No'],
      'optionsTr': ['Evet', 'Hayır'],
      'type': 'binary',
    },
  ];

  late List<String?> answers;

  @override
  void initState() {
    super.initState();
    // Initialize answers based on questions length
    answers = List<String?>.filled(questions.length, null);
  }

  Future<void> _submitAnswers() async {
    // (You can leave your existing null‐check in place if you like;
    // but now the button is disabled until all are answered.)
    if (answers.contains(null)) {
      List<int> unansweredIndexes = [];
      for (int i = 0; i < answers.length; i++) {
        if (answers[i] == null) unansweredIndexes.add(i + 1);
      }
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Incomplete Test'),
          content: Text(
            'Please answer all questions before submitting.\n\n'
            'Unanswered questions: ${unansweredIndexes.join(", ")}',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
      return;
    }

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please log in before taking the test.')),
      );
      return;
    }

    final int roomSize = int.parse(answers[0]!);
    final List<int> vector = answers
        .sublist(1)
        .map((a) => a == 'Yes' ? 1 : 0)
        .toList();

    // Save the test result as a new document in a subcollection
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('tests')
        .add({
      'roomSize': roomSize,
      'answers': vector,
      'email': user.email ?? '',
      'displayName': user.displayName ?? '',
      'timestamp': FieldValue.serverTimestamp(), // Use server timestamp for ordering
      'status': 'Completed', // Add a status field
    });

    // Navigate to Best Matches and remove all routes except Home
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/best-matches',
      (route) => route.settings.name == '/home', // Keep Home route
    );
  }

  @override
  Widget build(BuildContext context) {
    // Determine whether all questions have been answered:
    final bool allAnswered = !answers.contains(null);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade800,
        title: const Text('Roommate Test',
            style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: Container(
        color: Colors.blue.shade800,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              const SizedBox(height: 40),
              const Text(
                'Find Your\nPerfect Match!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 60),

              // Questions
              ...List.generate(questions.length, (index) {
                final q = questions[index];
                final opts = isEnglish ? q['options'] : q['optionsTr'];
                return Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Question ${index + 1}',
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                              )),
                          const SizedBox(height: 8),
                          Text(
                            isEnglish ? q['en'] : q['tr'],
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              for (var opt in opts)
                                _buildAnswerButton(
                                  index: index,
                                  answerValue: opt,
                                  isSelected: answers[index] == opt,
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                );
              }),

              const SizedBox(height: 40),

              // Here's the only change: button is disabled if not allAnswered
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,               // light background
                    foregroundColor: Colors.blue.shade800,    
                    disabledForegroundColor: Colors.blue.shade800,  // dark text
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: allAnswered ? _submitAnswers : null,
                  child: const Text('SUBMIT'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAnswerButton({
    required int index,
    required String answerValue,
    required bool isSelected,
  }) {
    return GestureDetector(
      onTap: () {
        setState(() {
          answers[index] = answerValue;
          if (questions[index]['type'] == 'choice') currentQuestionIndex = 1;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.blue.shade600
              : Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected
                ? Colors.blue.shade400
                : Colors.white.withOpacity(0.3),
            width: 2,
          ),
        ),
        child: Text(answerValue,
            style: TextStyle(
                color: isSelected ? Colors.white : Colors.white70,
                fontSize: 16)),
      ),
    );
  }
}
