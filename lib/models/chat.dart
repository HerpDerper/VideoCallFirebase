import 'package:cloud_firestore/cloud_firestore.dart';

class Chat {
  String? id;
  List<String> accounts;
  String meetingId;
  DateTime lastMessageTime;

  Chat({this.id, required this.accounts, required this.meetingId, required this.lastMessageTime});

  Map<String, dynamic> toJson() => {'accounts': accounts, 'meetingId': meetingId, 'lastMessageTime': lastMessageTime};

  static Chat fromSnapshot(DocumentSnapshot snapshot) => Chat(
        id: snapshot.id,
        accounts: List.from(snapshot['accounts']),
        meetingId: snapshot['meetingId'],
        lastMessageTime: snapshot['lastMessageTime'].toDate(),
      );
}
