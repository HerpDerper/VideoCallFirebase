import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_video_call/models/message.dart';

import '../models/chat.dart';
import '../models/account.dart';
import '../utils/firebase_utils.dart';

class ChatController {
  Chat? chat;

  ChatController({this.chat});

  Stream<Chat> getChatById(String chatId) {
    FirebaseUtils.setCollection('Chats');
    return FirebaseUtils.collection.doc(chatId).snapshots().map((snapshot) => Chat.fromSnapshot(snapshot));
  }

  // Stream<List<Chat>> searchAccounts(String userName) {
  //   FirebaseUtils.setCollection('Accounts');
  //   return FirebaseUtils.collection
  //       .where('userName', isEqualTo: userName)
  //       .snapshots()
  //       .map((snapshot) => snapshot.docs.map((doc) => Account.fromSnapshot(doc)).toList());
  // }

  void createChat(Message message, List<Account> accounts) {
    FirebaseUtils.setCollection('Chats');
    FirebaseUtils.collection
        .doc()
        .collection('Messages')
        .add(Chat(messages: [message], accounts: accounts, lastMessage: message.text, lastMessageTime: message.dateSent).toJson());
  }

  void deleteChat() {
    FirebaseUtils.setCollection('Chats');
    FirebaseUtils.collection.doc(chat!.id).delete();
  }
}
