import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String email;
  final String username;
  final DateTime createdAt;
  final DateTime? lastLoginAt;
  final String? profilePicture;
  final int totalTests;
  final double averageScore;

  UserModel({
    required this.uid,
    required this.email,
    required this.username,
    required this.createdAt,
    this.lastLoginAt,
    this.profilePicture,
    this.totalTests = 0,
    this.averageScore = 0.0,
  });

  // Firestore'dan veri okumak için
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'] as String,
      email: json['email'] as String,
      username: json['username'] as String,
      createdAt: (json['createdAt'] as Timestamp).toDate(),
      lastLoginAt: json['lastLoginAt'] != null
          ? (json['lastLoginAt'] as Timestamp).toDate()
          : null,
      profilePicture: json['profilePicture'] as String?,
      totalTests: json['totalTests'] as int? ?? 0,
      averageScore: (json['averageScore'] as num?)?.toDouble() ?? 0.0,
    );
  }

  // Firestore'a veri yazmak için
  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'username': username,
      'createdAt': Timestamp.fromDate(createdAt),
      'lastLoginAt':
          lastLoginAt != null ? Timestamp.fromDate(lastLoginAt!) : null,
      'profilePicture': profilePicture,
      'totalTests': totalTests,
      'averageScore': averageScore,
    };
  }

  // Kullanıcı bilgilerini güncellemek için
  UserModel copyWith({
    String? uid,
    String? email,
    String? username,
    DateTime? createdAt,
    DateTime? lastLoginAt,
    String? profilePicture,
    int? totalTests,
    double? averageScore,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      username: username ?? this.username,
      createdAt: createdAt ?? this.createdAt,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
      profilePicture: profilePicture ?? this.profilePicture,
      totalTests: totalTests ?? this.totalTests,
      averageScore: averageScore ?? this.averageScore,
    );
  }
}
