import 'package:cloud_firestore/cloud_firestore.dart';

class Chat {
  String? id;
  List<String> accounts;

  Chat({this.id, required this.accounts});

  Map<String, dynamic> toJson() => {'accounts': accounts};

  static Chat fromSnapshot(DocumentSnapshot snapshot) {
    return Chat(id: snapshot.id, accounts: snapshot['accounts']);
  }
}
