import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/message.dart';
import '../utils/firebase_utils.dart';

class MessageController {
  Stream<Message> getMessageById(String chatId, String messageId) {
    FirebaseUtils.setCollection('Chats');
    return FirebaseUtils.collection.doc(chatId).collection('Messages').doc().snapshots().map((snapshot) => Message.fromSnapshot(snapshot));
  }

  static Stream<List<Message>> getMessages(QueryDocumentSnapshot? querySnapshot) {
    return querySnapshot!.reference
        .collection('Messages')
        .orderBy('dateSent', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => Message.fromSnapshot(doc)).toList());
  }

  static void createMessage(String chatId, Message message) {
    FirebaseUtils.setCollection('Chats');
    FirebaseUtils.collection.doc(chatId).collection('Messages').add(message.toJson());
  }

  static void editMessage(Message message) {
    FirebaseUtils.setCollection('Chats');
    message.isEdited = true;
    FirebaseUtils.collection.doc().collection('Messages').doc(message.id).set(message.toJson());
  }

  static void deleteMessage(String chatId, String messageId) {
    FirebaseUtils.setCollection('Chats');
    FirebaseUtils.collection.doc(chatId).collection('Messages').doc(messageId).delete();
  }
}
