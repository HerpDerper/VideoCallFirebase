import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  String? id;
  String dateSent, text, sender;
  bool isEdited;

  Message({this.id, required this.dateSent, required this.text, required this.sender, this.isEdited = false});

  Map<String, dynamic> toJson() => {'dateSent': dateSent, 'text': text, 'sender': sender, 'isEdited': isEdited};

  static Message fromSnapshot(DocumentSnapshot snapshot) =>
      Message(id: snapshot.id, dateSent: snapshot['dateSent'], text: snapshot['text'], sender: snapshot['sender'], isEdited: snapshot['isEdited']);
}
