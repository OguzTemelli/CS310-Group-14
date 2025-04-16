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
      backgroundColor: const Color(0xFF1a237e),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              // Header with logo
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.person, color: Colors.white),
                      SizedBox(width: 8),
                      Text(
                        'MatchMate',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  // Dil seçimi
                  TextButton.icon(
                    onPressed: () {
                      setState(() {
                        isEnglish = !isEnglish;
                      });
                    },
                    icon: Icon(Icons.language, color: Colors.white),
                    label: Text(
                      isEnglish ? 'EN' : 'TR',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              // İlerleme göstergesi
              LinearProgressIndicator(
                value: (currentQuestionIndex + 1) / questions.length,
                backgroundColor: Colors.white.withOpacity(0.2),
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
              const SizedBox(height: 20),
              // Soru numarası
              Text(
                'Question ${currentQuestionIndex + 1}/${questions.length}',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 40),
              // Soru
              Text(
                isEnglish
                    ? questions[currentQuestionIndex]['en']
                    : questions[currentQuestionIndex]['tr'],
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              // Cevap butonları
              ...List.generate(
                2,
                (index) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed:
                          () => _handleAnswer(
                            isEnglish
                                ? questions[currentQuestionIndex]['options'][index]
                                : questions[currentQuestionIndex]['optionsTr'][index],
                          ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        isEnglish
                            ? questions[currentQuestionIndex]['options'][index]
                            : questions[currentQuestionIndex]['optionsTr'][index],
                        style: TextStyle(
                          color: Color(0xFF1a237e),
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const Spacer(),
              // Submit butonu (son soruda göster)
              if (currentQuestionIndex == questions.length - 1)
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // TODO: Submit answers
                      print('Answers: $answers');
                      Navigator.pushReplacementNamed(context, '/home');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepOrange,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      isEnglish ? 'Submit' : 'Gönder',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
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
}
