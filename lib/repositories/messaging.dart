import 'package:chill/models/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

class MessagingRepository {
  final FirebaseFirestore _firestore;
  final FirebaseStorage _firebaseStorage;
  String uuid = Uuid().v4();

  MessagingRepository(
      {required FirebaseStorage firebaseStorage,
      required FirebaseFirestore firestore})
      : _firebaseStorage = firebaseStorage ?? FirebaseStorage.instance,
        _firestore = firestore ?? FirebaseFirestore.instance;

  Future sendMessage({required Message message}) async {
    DocumentReference messageRef = _firestore.collection('messages').doc();
    CollectionReference senderRef = _firestore
        .collection('users')
        .doc(message.senderId)
        .collection('chats')
        .doc(message.selectedUserId)
        .collection('messages');

    CollectionReference sendUserRef = _firestore
        .collection('users')
        .doc(message.selectedUserId)
        .collection('chats')
        .doc(message.senderId)
        .collection('messages');

    if (message.photo != null) {
      Reference photoRef = _firebaseStorage
          .ref()
          .child('messages')
          .child(messageRef.id)
          .child(uuid);

      UploadTask uploadTask =
          (await photoRef.putFile(message.photo)) as UploadTask;
      await uploadTask.then((photo) async {
        await photo.ref.getDownloadURL().then((photoUrl) async {
          await messageRef.set({
            'senderName': message.senderName,
            'senderId': message.senderId,
            'text': null,
            'photoUrl': photoUrl,
            'timestamp': DateTime.now(),
          });
        });
      });

      senderRef.doc(messageRef.id).set({'timestamp': DateTime.now()});

      sendUserRef.doc(messageRef.id).set({'timestamp': DateTime.now()});

      await _firestore
          .collection('users')
          .doc(message.senderId)
          .collection('chats')
          .doc(message.selectedUserId)
          .update({'timestamp': DateTime.now()});

      await _firestore
          .collection('users')
          .doc(message.selectedUserId)
          .collection('chats')
          .doc(message.senderId)
          .update({'timestamp': DateTime.now()});
    }
    if (message.text != null) {
      await messageRef.set({
        'senderName': message.senderName,
        'senderId': message.senderId,
        'text': message.text,
        'photoUrl': null,
        'timestamp': DateTime.now(),
      });

      senderRef.doc(messageRef.id).set({'timestamp': DateTime.now()});

      sendUserRef.doc(messageRef.id).set({'timestamp': DateTime.now()});

      await _firestore
          .collection('users')
          .doc(message.senderId)
          .collection('chats')
          .doc(message.selectedUserId)
          .update({'timestamp': DateTime.now()});

      await _firestore
          .collection('users')
          .doc(message.selectedUserId)
          .collection('chats')
          .doc(message.senderId)
          .update({'timestamp': DateTime.now()});
    }
  }

  Stream<QuerySnapshot> getMessages({currentUserId, selectedUserId}) {
    return _firestore
        .collection('users')
        .doc(currentUserId)
        .collection('chats')
        .doc(selectedUserId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots();
  }

  Future<Message> getMessageDetail({messageId}) async {
    return Message.fromSnapshot(
        await _firestore.collection('messages').doc(messageId).get());
  }
}
