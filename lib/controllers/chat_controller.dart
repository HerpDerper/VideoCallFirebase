import 'package:flutter_video_call/models/message.dart';

import '../models/chat.dart';
import '../utils/firebase_utils.dart';

class ChatController {
  static void createChat(String name, List<String> accounts, Message message) {
    FirebaseUtils.setCollection('Chats');
    FirebaseUtils.collection.add(Chat(name: name, accounts: accounts).toJson()).then((doc) => doc.collection('Messages').add(message.toJson()));
  }

  static void deleteChat(String chatId) {
    FirebaseUtils.setCollection('Chats');
    FirebaseUtils.collection.doc(chatId).delete();
  }
}
