import 'package:flutter/material.dart';

class TestScreen extends StatefulWidget {
  const TestScreen({super.key});

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  bool isEnglish = true; // true for English, false for Turkish
  int currentQuestionIndex = 0;

  // Sorular ve cevaplar
  final List<Map<String, dynamic>> questions = [
    {
      'en': 'Do you sleep late?',
      'tr': 'Geç mi uyursun?',
      'options': ['Yes', 'No'],
      'optionsTr': ['Evet', 'Hayır'],
    },
    {
      'en': 'Do you prefer studying in silence?',
      'tr': 'Sessizlikte çalışmayı mı tercih edersin?',
      'options': ['Yes', 'No'],
      'optionsTr': ['Evet', 'Hayır'],
    },
    {
      'en': 'Are you a social person?',
      'tr': 'Sosyal bir insan mısın?',
      'options': ['Yes', 'No'],
      'optionsTr': ['Evet', 'Hayır'],
    },
    {
      'en': 'Do you like listening to music while studying?',
      'tr': 'Ders çalışırken müzik dinlemeyi sever misin?',
      'options': ['Yes', 'No'],
      'optionsTr': ['Evet', 'Hayır'],
    },
    {
      'en': 'Do you keep your room clean and organized?',
      'tr': 'Odanı temiz ve düzenli tutar mısın?',
      'options': ['Yes', 'No'],
      'optionsTr': ['Evet', 'Hayır'],
    },
  ];

  List<String?> answers = List.filled(5, null);

  void _handleAnswer(String answer) {
    setState(() {
      answers[currentQuestionIndex] = answer;
      if (currentQuestionIndex < questions.length - 1) {
        currentQuestionIndex++;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade800,
        title: const Text(
          'Roommate Test',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Container(
        color: Colors.blue.shade800,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              const SizedBox(height: 40),

              // Title
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
                          Text(
                            'Question ${index + 1}',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            isEnglish
                                ? questions[index]['en']
                                : questions[index]['tr'],
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
                              _buildAnswerButton(
                                index: index,
                                isYes: true,
                                isSelected: answers[index] == 'Yes',
                              ),
                              _buildAnswerButton(
                                index: index,
                                isYes: false,
                                isSelected: answers[index] == 'No',
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

              // Submit button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade600,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    print('Answers: $answers');
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'SUBMIT',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
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
    required bool isYes,
    required bool isSelected,
  }) {
    return GestureDetector(
      onTap: () {
        setState(() {
          answers[index] = isYes ? 'Yes' : 'No';
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          color:
              isSelected ? Colors.blue.shade600 : Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color:
                isSelected
                    ? Colors.blue.shade400
                    : Colors.white.withOpacity(0.3),
            width: 2,
          ),
        ),
        child: Text(
          isYes ? 'Yes' : 'No',
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.white70,
            fontSize: 16,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
