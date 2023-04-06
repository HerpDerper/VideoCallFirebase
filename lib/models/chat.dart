import 'package:cloud_firestore/cloud_firestore.dart';

class Chat {
  String? id;
  List<String> accounts;
  DateTime lastMessageTime;

  Chat({this.id, required this.accounts, required this.lastMessageTime});

  Map<String, dynamic> toJson() => {'accounts': accounts, 'lastMessageTime': lastMessageTime};

  static Chat fromSnapshot(DocumentSnapshot snapshot) => Chat(
        id: snapshot.id,
        accounts: List.from(snapshot['accounts']),
        lastMessageTime: snapshot['lastMessageTime'].toDate(),
      );
}
