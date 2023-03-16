import 'package:cloud_firestore/cloud_firestore.dart';

class Account {
  String? id;
  String email;
  String userName;
  String password;
  String birthDate;
  String image;
  bool status;

  Account(
      {this.id, required this.email, required this.userName, required this.password, required this.birthDate, this.image = 'default.png', this.status = true});

  Map<String, dynamic> toJson() => {'email': email, 'userName': userName, 'password': password, 'birthDate': birthDate, 'image': image, 'status': status};

  static Account fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data()!;
    return Account(
        id: snapshot.id,
        email: data['email'],
        userName: data['userName'],
        password: data['password'],
        birthDate: data['birthDate'],
        image: data['image'],
        status: data['status']);
  }
}
