import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String id;
  final String username;
  final String email;
  final String photoUrl;
  final String fullName;
  final String bio;

  User({
    this.id,
    this.username,
    this.email,
    this.photoUrl,
    this.fullName,
    this.bio,
  });

  factory User.fromDocument(dynamic doc) {
    return User(
      id: doc['user_uid'],
      username: doc['user_name'],
      email: doc['user_email'],
      photoUrl: doc['user_image'],
      fullName: doc['user_full_name'],
      bio: doc['user_bio'],
    );
  }
}