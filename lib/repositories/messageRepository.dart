import 'package:chill/models/message.dart';
import 'package:chill/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MessageRepository {
  final FirebaseFirestore _firestore;

  MessageRepository({required FirebaseFirestore firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  Stream<QuerySnapshot> getChats({userId}) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('chats')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  Future deleteChat({currentUserId, selectedUserId}) async {
    await _firestore
        .collection('users')
        .doc(currentUserId)
        .collection('chats')
        .doc(selectedUserId)
        .delete();
  }

  Future<User> getUserDetail({userId}) async {
    return User.fromSnapshot(
        await _firestore.collection('users').doc(userId).get());
  }

  Future<Message> getLastMessage({currentUserId, selectedUserId}) async {
    QuerySnapshot first = await _firestore
        .collection('users')
        .doc(currentUserId)
        .collection('chats')
        .doc(selectedUserId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .get();
    DocumentSnapshot snapshot =
        await _firestore.collection('messages').doc(first.docs.first.id).get();
    return Message.fromSnapshot(snapshot);
  }
}
