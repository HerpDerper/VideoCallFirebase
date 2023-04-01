import 'package:cloud_firestore/cloud_firestore.dart';

class Chat {
  String? id;
  String name;
  List<String> accounts;

  Chat({this.id, required this.name, required this.accounts});

  Map<String, dynamic> toJson() => {'name': name, 'accounts': accounts};

  static Chat fromSnapshot(DocumentSnapshot snapshot) => Chat(id: snapshot.id, name: snapshot['name'], accounts: snapshot['accounts']);
}
