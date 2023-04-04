import 'package:cloud_firestore/cloud_firestore.dart';

class Account {
  String? id;
  String email, userName, password, birthDate, image;
  bool status;
  List<String> friends;

  Account({
    this.id,
    required this.email,
    required this.userName,
    required this.password,
    required this.birthDate,
    this.image = 'dusa.gif',
    this.status = true,
    this.friends = const [],
  });

  Map<String, dynamic> toJson() => {
        'email': email,
        'userName': userName,
        'password': password,
        'birthDate': birthDate,
        'image': image,
        'status': status,
        'friends': friends,
      };

  static Account fromSnapshot(DocumentSnapshot snapshot) => Account(
        id: snapshot.id,
        email: snapshot['email'],
        userName: snapshot['userName'],
        password: snapshot['password'],
        birthDate: snapshot['birthDate'],
        image: snapshot['image'],
        status: snapshot['status'],
        friends: List.from(snapshot['friends']),
      );
}
