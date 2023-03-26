import 'package:flutter/material.dart';

import '../components/widgets.dart';
import '../utils/firebase_utils.dart';

class ChatPage extends StatefulWidget {
  final String accountId;
  final String accountName;

  const ChatPage({super.key, required this.accountId, required this.accountName});

  @override
  State<ChatPage> createState() => ChatPageState();
}

class ChatPageState extends State<ChatPage> {
  TextEditingController messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    FirebaseUtils.setCollection('Chats');
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 38, 35, 55),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 22, 20, 32),
        title: Text(widget.accountName),
        elevation: 0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(18.0),
            child: Center(
              child: Text(
                'Last seen: 04:50',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.normal,
                  color: Colors.white,
                ),
              ),
            ),
          ),
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
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data!.docs.isNotEmpty) {
                      return ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        reverse: true,
                        itemBuilder: (context, i) {
                          return ChatWidgets.messagesCard(i, 'text', 'time');
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
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Color.fromARGB(255, 123, 118, 155),
                      ),
                    );
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
                controller: messageController,
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
                    onPressed: () {
                      messageController.clear();
                    },
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
