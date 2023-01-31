import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  String senderId;
  String senderName;
  String selectedUserId;
  String text;
  String photoUrl;
  File? photo;
  Timestamp timestamp;

  Message({
    required this.senderId,
    required this.senderName,
    required this.selectedUserId,
    required this.text,
    required this.photoUrl,
    required this.timestamp,
  });

  static fromSnapshot(DocumentSnapshot snapshot) {
    String text = snapshot['text'];
    String senderId = snapshot['senderId'];
    String selectedUserId = snapshot['selectedUserId'];
    String senderName = snapshot['senderName'];
    String photoUrl = snapshot['photoUrl'];
    Timestamp timestamp = snapshot['timestamp'];
    return Message(
      senderId: senderId,
      senderName: senderName,
      selectedUserId: selectedUserId,
      text: text,
      photoUrl: photoUrl,
      timestamp: timestamp,
    );
  }
}
