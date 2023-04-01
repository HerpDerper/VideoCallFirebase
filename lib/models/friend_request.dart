import 'package:cloud_firestore/cloud_firestore.dart';

class FriendRequest {
  String? id;
  String sender, receiver;

  FriendRequest({this.id, required this.sender, required this.receiver});

  Map<String, dynamic> toJson() => {'sender': sender, 'receiver': receiver};

  static FriendRequest fromSnapshot(DocumentSnapshot snapshot) => FriendRequest(id: snapshot.id, sender: snapshot['sender'], receiver: snapshot['receiver']);
}
