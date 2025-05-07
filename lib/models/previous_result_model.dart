import 'package:cloud_firestore/cloud_firestore.dart';

class PreviousResult {
  final String id;
  final String userId;
  final String testId;
  final DateTime date;
  final String testType;
  final Map<String, String> userAnswers;
  final Map<String, double> traitScores;
  final Map<String, double> traitDifferences; // Önceki test ile karşılaştırma
  final List<String> matchedUserIds; // Bu test sonucuyla eşleşen kullanıcılar

  PreviousResult({
    required this.id,
    required this.userId,
    required this.testId,
    required this.date,
    required this.testType,
    required this.userAnswers,
    required this.traitScores,
    required this.traitDifferences,
    required this.matchedUserIds,
  });

  // Firestore'dan veri okumak için
  factory PreviousResult.fromJson(Map<String, dynamic> json) {
    return PreviousResult(
      id: json['id'] as String,
      userId: json['userId'] as String,
      testId: json['testId'] as String,
      date: (json['date'] as Timestamp).toDate(),
      testType: json['testType'] as String,
      userAnswers: Map<String, String>.from(json['userAnswers'] as Map),
      traitScores: Map<String, double>.from(
        (json['traitScores'] as Map).map(
            (key, value) => MapEntry(key as String, (value as num).toDouble())),
      ),
      traitDifferences: Map<String, double>.from(
        (json['traitDifferences'] as Map).map(
            (key, value) => MapEntry(key as String, (value as num).toDouble())),
      ),
      matchedUserIds: List<String>.from(json['matchedUserIds'] as List),
    );
  }

  // Firestore'a veri yazmak için
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'testId': testId,
      'date': Timestamp.fromDate(date),
      'testType': testType,
      'userAnswers': userAnswers,
      'traitScores': traitScores,
      'traitDifferences': traitDifferences,
      'matchedUserIds': matchedUserIds,
    };
  }

  // Önceki sonucu güncellemek için
  PreviousResult copyWith({
    String? id,
    String? userId,
    String? testId,
    DateTime? date,
    String? testType,
    Map<String, String>? userAnswers,
    Map<String, double>? traitScores,
    Map<String, double>? traitDifferences,
    List<String>? matchedUserIds,
  }) {
    return PreviousResult(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      testId: testId ?? this.testId,
      date: date ?? this.date,
      testType: testType ?? this.testType,
      userAnswers: userAnswers ?? this.userAnswers,
      traitScores: traitScores ?? this.traitScores,
      traitDifferences: traitDifferences ?? this.traitDifferences,
      matchedUserIds: matchedUserIds ?? this.matchedUserIds,
    );
  }
}
