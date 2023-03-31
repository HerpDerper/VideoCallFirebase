import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/account.dart';
import '../models/message.dart';
import '../components/widgets.dart';
import '../utils/firebase_utils.dart';
import '../controllers/chat_controller.dart';
import '../controllers/account_controller.dart';
import '../controllers/message_controller.dart';

class ChatPage extends StatefulWidget {
  final Account account;

  const ChatPage({super.key, required this.account});

  @override
  State<ChatPage> createState() => ChatPageState();
}

class ChatPageState extends State<ChatPage> {
  TextEditingController controllerMessage = TextEditingController();
  String chatId = '';

  void _submitMessage() {
    if (controllerMessage.text.isNotEmpty) {
      String dateSent = DateFormat('dd.MM.yyyy HH:mm').format(DateTime.now());
      Message message = Message(dateSent: dateSent, text: controllerMessage.text, sender: FirebaseUtils.auth.currentUser!.uid);
      if (chatId == '') {
        ChatController.createChat([widget.account.id!, FirebaseUtils.auth.currentUser!.uid], message);
      } else {
        MessageController.createMessage(chatId, message);
      }
      controllerMessage.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    FirebaseUtils.setCollection('Chats');
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 38, 35, 55),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 22, 20, 32),
        title: Row(
          children: [
            FutureBuilder(
              future: AccountController.getAccountImageByName(widget.account.image),
              builder: (context, snapshotImage) {
                if (snapshotImage.connectionState == ConnectionState.waiting) {
                  return const CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.transparent,
                    child: CircularProgressIndicator(
                      color: Color.fromARGB(255, 123, 118, 155),
                    ),
                  );
                }
                return CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.transparent,
                  backgroundImage: NetworkImage(
                    snapshotImage.data.toString(),
                  ),
                );
              },
            ),
            Text(
              widget.account.userName,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Text(
                style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.w300),
                widget.account.status ? 'Online' : 'Offline',
              ),
            ),
          ],
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 38, 35, 55),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                ),
              ),
              child: StreamBuilder(
                stream: FirebaseUtils.collection.snapshots(),
                builder: (context, snapshotChats) {
                  if (snapshotChats.hasData) {
                    if (snapshotChats.data!.docs.isNotEmpty) {
                      List<QueryDocumentSnapshot?> chatList = snapshotChats.data!.docs
                          .where((field) => field['accounts'][0] == widget.account.id && field['accounts'][1] == FirebaseUtils.auth.currentUser!.uid)
                          .toList();
                      QueryDocumentSnapshot? data = chatList.isNotEmpty ? chatList.first : null;
                      if (data != null) {
                        chatId = data.id;
                      }
                      if (data != null) {
                        return StreamBuilder(
                          stream: MessageController.getMessages(chatList.first),
                          builder: (context, snapshotMessages) {
                            if (!snapshotMessages.hasData) {
                              return const Center(
                                child: CircularProgressIndicator(
                                  color: Color.fromARGB(255, 123, 118, 155),
                                ),
                              );
                            }
                            return ListView(
                              reverse: true,
                              children: snapshotMessages.data!.map(
                                (message) {
                                  return ChatWidgets.messagesCard(message.sender == FirebaseUtils.auth.currentUser!.uid, message.text, message.dateSent);
                                },
                              ).toList(),
                            );
                          },
                        );
                      } else {
                        return const Center(
                          child: Text(
                            'No messages found',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.normal,
                              color: Colors.white,
                            ),
                          ),
                        );
                      }
                    } else {
                      return Container();
                    }
                  } else {
                    return Container();
                  }
                },
              ),
            ),
          ),
          Container(
            color: const Color.fromARGB(255, 38, 35, 55),
            child: Container(
              margin: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 38, 35, 55),
                border: Border.all(
                  color: Colors.indigo,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextField(
                controller: controllerMessage,
                style: const TextStyle(
                  color: Colors.white,
                ),
                decoration: InputDecoration(
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.white,
                    ),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.white,
                    ),
                  ),
                  labelStyle: const TextStyle(
                    color: Colors.white,
                  ),
                  labelText: 'Enter message',
                  suffixIcon: IconButton(
                    icon: const Icon(
                      Icons.send,
                      color: Colors.white,
                    ),
                    onPressed: () => _submitMessage(),
                  ),
                ),
                onSubmitted: (value) => _submitMessage(),
              ),
            ),
          )
        ],
      ),
    );
  }
}
