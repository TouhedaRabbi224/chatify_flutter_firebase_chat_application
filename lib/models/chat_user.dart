//packages
import 'package:flutter/material.dart';

class ChatUser {
  final String uid;
  final String name;
  final String email;
  final String image;
  final DateTime lastActive;

  ChatUser({
    required this.uid,
    required this.name,
    required this.email,
    required this.image,
    required this.lastActive,
  });

  factory ChatUser.fromJSON(Map<String, dynamic> _json) {
    return ChatUser(
      uid: _json['uid'],
      name: _json['name'],
      email: _json['email'],
      image: _json['image'],
      lastActive: _json['lastActive'].toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'image': image,
      'lastActive': lastActive,
    };
  }

  String lastDayActive() {
    return "${lastActive.month}/${lastActive.day}/${lastActive.year}";
  }

  bool recentActive() {
    return DateTime.now().difference(lastActive).inHours < 2;
  }
}
