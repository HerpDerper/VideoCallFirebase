import '../models/chat.dart';
import '../utils/firebase_utils.dart';

class ChatController {
  static void createChat(String name, List<String> accounts) {
    FirebaseUtils.setCollection('Chats');
    FirebaseUtils.collection.add(Chat(accounts: accounts).toJson());
  }

  static void deleteChat(String chatId) {
    FirebaseUtils.setCollection('Chats');
    FirebaseUtils.collection.doc(chatId).delete();
  }
}
