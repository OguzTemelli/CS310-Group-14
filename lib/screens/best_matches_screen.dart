// screens/best_matches_screen.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class BestMatchesScreen extends StatefulWidget {
  const BestMatchesScreen({super.key});

  @override
  State<BestMatchesScreen> createState() => _BestMatchesScreenState();
}

class _BestMatchesScreenState extends State<BestMatchesScreen> {
  List<Map<String, dynamic>> _matches = [];
  bool _isLoading = true;
  String _errorMessage = '';

  // Weights for each binary question (can adjust importance here)
  final List<double> questionWeights = [1, 1, 1, 1, 1];

  @override
  void initState() {
    super.initState();
    _loadMatches();
  }

  Future<void> _loadMatches() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Lütfen önce giriş yapın';
      });
      return;
    }

    try {
      // Kullanıcının kendi cevaplarını al
      final currentUserSnapshot = await FirebaseDatabase.instance
          .ref()
          .child('user_answers')
          .child(user.uid)
          .get();
      
      if (!currentUserSnapshot.exists) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Henüz test sonucunuz bulunmamaktadır';
        });
        return;
      }
      
      final currentUserData = Map<String, dynamic>.from(currentUserSnapshot.value as Map);
      final int currentRoomSize = currentUserData['roomSize'] as int;
      final List<int> vectorA = List<int>.from(currentUserData['answers'] as List);
      
      // Tüm kullanıcıların cevaplarını al
      final allAnswersSnapshot = await FirebaseDatabase.instance
          .ref()
          .child('user_answers')
          .get();
      
      if (!allAnswersSnapshot.exists) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Henüz eşleşme için veri bulunmamaktadır';
        });
        return;
      }
      
      final allAnswersData = Map<String, dynamic>.from(allAnswersSnapshot.value as Map);
      final List<Map<String, dynamic>> tempMatches = [];
      
      allAnswersData.forEach((userId, userData) {
        // Kendimizi hariç tut
        if (userId != user.uid) {
          final userDataMap = Map<String, dynamic>.from(userData as Map);
          final int userRoomSize = userDataMap['roomSize'] as int;
          
          // Sadece aynı oda boyutunu tercih edenlerle eşleş
          if (userRoomSize == currentRoomSize) {
            final List<int> vectorB = List<int>.from(userDataMap['answers'] as List);
            
            // Benzerlik skorunu hesapla
            double weightedMatches = 0;
            final totalWeight = questionWeights.reduce((a, b) => a + b);
            
            for (var i = 0; i < vectorA.length; i++) {
              if (i < vectorB.length && vectorA[i] == vectorB[i]) {
                weightedMatches += questionWeights[i];
              }
            }
            
            final similarity = weightedMatches / totalWeight;
            
            tempMatches.add({
              'userId': userId,
              'name': userDataMap['displayName'] ?? 'İsimsiz',
              'email': userDataMap['email'] ?? '',
              'similarity': similarity,
            });
          }
        }
      });
      
      // Benzerlik skoruna göre sırala (en yüksekten en düşüğe)
      tempMatches.sort((a, b) => b['similarity'].compareTo(a['similarity']));
      
      setState(() {
        _matches = tempMatches;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Eşleşmeler yüklenirken bir hata oluştu: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('En İyi Eşleşmeler'),
        backgroundColor: Colors.blue.shade800,
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage.isNotEmpty
              ? Center(child: Text(_errorMessage))
              : _matches.isEmpty
                  ? const Center(child: Text('Herhangi bir eşleşme bulunamadı'))
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: _matches.length,
                      itemBuilder: (context, index) {
                        final match = _matches[index];
                        final similarity = match['similarity'] as double;
                        final percentage = (similarity * 100).toStringAsFixed(0);
                        
                        return Card(
                          margin: const EdgeInsets.only(bottom: 16),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    CircleAvatar(
                                      backgroundColor: Colors.blue.shade100,
                                      child: Text(
                                        match['name'].toString().substring(0, 1).toUpperCase(),
                                        style: TextStyle(
                                          color: Colors.blue.shade800,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            match['name'],
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                            ),
                                          ),
                                          Text(
                                            match['email'],
                                            style: TextStyle(
                                              color: Colors.grey[600],
                                              fontSize: 14,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.green,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        '$percentage% Uyum',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
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