import 'dart:async';

import '../models/chat.dart';
import '../models/account.dart';
import 'account_controller.dart';
import '../utils/firebase_utils.dart';

class ChatController {
  static void createChat(String name, List<String> accounts) {
    FirebaseUtils.setCollection('Chats');
    FirebaseUtils.collection.add(Chat(accounts: accounts).toJson());
  }

  static void deleteChat(Chat chat) {
    FirebaseUtils.setCollection('Chats');
    FirebaseUtils.collection.doc(chat.id).delete();
  }

  static Stream<List<Chat>> getChats() {
    FirebaseUtils.setCollection('Chats');
    return FirebaseUtils.collection
        .where('accounts', arrayContains: FirebaseUtils.auth.currentUser!.uid)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => Chat.fromSnapshot(doc)).toList());
  }

  static Stream<Account> getAccountFromChat(Chat chat) {
    FirebaseUtils.setCollection('Accounts');
    return AccountController.getAccountById(chat.accounts[0] != FirebaseUtils.auth.currentUser!.uid ? chat.accounts[0] : chat.accounts[1]).asStream();
  }
}
