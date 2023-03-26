import 'package:cloud_firestore/cloud_firestore.dart';

import 'account.dart';
import 'message.dart';

class Chat {
  String? id;
  List<Message> messages;
  List<Account> accounts;
  String lastMessage;
  String lastMessageTime;

  Chat({this.id, required this.messages, required this.accounts, required this.lastMessage, required this.lastMessageTime});

  Map<String, dynamic> toJson() => {'messages': messages, 'accounts': accounts, 'lastMessage': lastMessage, 'lastMessageTime': lastMessageTime};

  static Chat fromSnapshot(DocumentSnapshot snapshot) {
    return Chat(
      id: snapshot.id,
      messages: snapshot['messages'],
      accounts: snapshot['accounts'],
      lastMessage: snapshot['lastMessage'],
      lastMessageTime: snapshot['lastMessageTime'],
    );
  }
}
