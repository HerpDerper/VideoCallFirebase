import 'package:flutter/material.dart';
import 'package:flutter_video_call/controllers/chat_controller.dart';

import 'chat_page.dart';
import '../models/account.dart';
import '../utils/app_utils.dart';
import '../utils/firebase_utils.dart';
import '../controllers/account_controller.dart';

class ChannelsPage extends StatefulWidget {
  const ChannelsPage({super.key, required});

  @override
  State<ChannelsPage> createState() => ChannelsPageState();
}

class ChannelsPageState extends State<ChannelsPage> {
  Stream<List<Account>> _getChats() {
    return FirebaseUtils.collection.snapshots().map((snapshot) => snapshot.docs.map((doc) => Account.fromSnapshot(doc)).toList());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 38, 35, 55),
      body: Center(
        child: StreamBuilder(
          stream: _getChats(),
          builder: (context, snapshotChats) {
            if (snapshotChats.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator(
                color: Color.fromARGB(255, 123, 118, 155),
              );
            }
            return ListView(
              children: snapshotChats.data!.map(
                (account) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                    child: Card(
                      color: Colors.deepPurple,
                      child: ListTile(
                        textColor: Colors.white,
                        iconColor: Colors.white,
                        trailing: PopupMenuButton(
                          tooltip: 'Actions',
                          itemBuilder: (context) => [
                            PopupMenuItem(
                              child: const Text(
                                'Delete chat',
                              ),
                              onTap: () => ChatController.deleteChat('chatId'),
                            ),
                          ],
                        ),
                        title: Text(
                          account.userName,
                        ),
                        subtitle: Text(
                          style: const TextStyle(color: Colors.grey),
                          account.status ? 'Online' : 'Offline',
                        ),
                        leading: FutureBuilder(
                          future: AccountController.getAccountImageByName(account.image),
                          builder: (context, snapshotImage) {
                            if (snapshotImage.connectionState == ConnectionState.waiting) {
                              return const CircleAvatar(
                                radius: 30,
                                backgroundColor: Colors.transparent,
                                child: CircularProgressIndicator(
                                  color: Color.fromARGB(255, 123, 118, 155),
                                ),
                              );
                            }
                            return CircleAvatar(
                              radius: 30,
                              backgroundColor: Colors.deepPurple,
                              backgroundImage: NetworkImage(
                                snapshotImage.data.toString(),
                              ),
                              child: CircleAvatar(
                                radius: 27,
                                backgroundColor: Colors.transparent,
                                child: Align(
                                  alignment: Alignment.bottomRight,
                                  child: CircleAvatar(
                                    backgroundColor: account.status ? Colors.green : Colors.transparent,
                                    radius: 7,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        onTap: () => AppUtils.switchScreen(ChatPage(account: account), context),
                      ),
                    ),
                  );
                },
              ).toList(),
            );
          },
        ),
      ),
    );
  }
}
