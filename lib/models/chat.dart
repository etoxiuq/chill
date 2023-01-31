import 'package:cloud_firestore/cloud_firestore.dart';

class Chat {
  String name;
  String photoUrl;
  String? lastMessagePhoto;
  String? lastMessage;
  Timestamp timestamp;

  Chat({
    required this.name,
    required this.photoUrl,
    this.lastMessagePhoto,
    this.lastMessage,
    required this.timestamp,
  });

  static fromSnapshot(DocumentSnapshot snapshot) {
    String name = snapshot['name'];
    String photoUrl = snapshot['photoUrl'];
    String? lastMessagePhoto = snapshot['lastMessagePhoto'];
    String? lastMessage = snapshot['lastMessage'];
    Timestamp timestamp = snapshot['timestamp'];
    return Chat(
      name: name,
      photoUrl: photoUrl,
      timestamp: timestamp,
      lastMessagePhoto: lastMessagePhoto,
      lastMessage: lastMessage,
    );
  }
}
