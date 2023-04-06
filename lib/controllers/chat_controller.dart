import 'dart:async';

import '../models/chat.dart';
import '../models/message.dart';
import '../models/account.dart';
import 'account_controller.dart';
import '../utils/firebase_utils.dart';

class ChatController {
  static void createChat(List<String> accounts) {
    FirebaseUtils.setCollection('Chats');
    FirebaseUtils.collection.add(Chat(accounts: accounts, lastMessageTime: DateTime.now()).toJson());
  }

  static void updateChat(String chatId, Message message) {
    FirebaseUtils.setCollection('Chats');
    FirebaseUtils.collection.doc(chatId).update({'lastMessageTime': message.dateSent});
  }

  static void deleteChat(Chat chat) {
    FirebaseUtils.setCollection('Chats');
    FirebaseUtils.collection.doc(chat.id).delete();
  }

  static Stream<List<Chat>> getChats() {
    FirebaseUtils.setCollection('Chats');
    return FirebaseUtils.collection
        .orderBy('lastMessageTime', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => Chat.fromSnapshot(doc)).toList());
  }

  static Stream<Account> getAccountFromChat(Chat chat) {
    FirebaseUtils.setCollection('Accounts');
    return AccountController.getAccountById(chat.accounts[0] == FirebaseUtils.auth.currentUser!.uid ? chat.accounts[1] : chat.accounts[0]).asStream();
  }
}
