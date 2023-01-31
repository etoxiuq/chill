import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String uid;
  String name;
  String gender;
  String interestedIn;
  String photo;
  Timestamp age;
  GeoPoint location;

  User({
    required this.uid,
    required this.name,
    required this.gender,
    required this.interestedIn,
    required this.photo,
    required this.age,
    required this.location,
  });

  static User fromSnapshot(DocumentSnapshot snapshot) {
    String id = snapshot.id;
    String name = snapshot['name'];
    String photo = snapshot['photoUrl'];
    Timestamp age = snapshot['age'];
    GeoPoint location = snapshot['location'];
    String gender = snapshot['gender'];
    String interestedIn = snapshot['interestedIn'];
    return User(
      uid: id,
      name: name,
      gender: gender,
      interestedIn: interestedIn,
      photo: photo,
      age: age,
      location: location,
    );
  }
}
