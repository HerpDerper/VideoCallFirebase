import 'package:flutter/material.dart';
import 'package:flutter_video_call/utils/firebase_utils.dart';

import 'chat_page.dart';
import '../utils/app_utils.dart';
import '../controllers/chat_controller.dart';
import '../controllers/account_controller.dart';

class ChannelsPage extends StatefulWidget {
  const ChannelsPage({super.key, required});

  @override
  State<ChannelsPage> createState() => ChannelsPageState();
}

class ChannelsPageState extends State<ChannelsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 38, 35, 55),
      body: Center(
        child: StreamBuilder(
          stream: ChatController.getChats(),
          builder: (context, snapshotChats) {
            if (!snapshotChats.hasData) {
              return const Center(
                child: Text(
                  'No chats found',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.normal,
                    color: Colors.white,
                  ),
                ),
              );
            }
            if (snapshotChats.data!.isEmpty) {
              return const Center(
                child: Text(
                  'No chats found',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.normal,
                    color: Colors.white,
                  ),
                ),
              );
            }
            if (snapshotChats.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator(
                color: Color.fromARGB(255, 123, 118, 155),
              );
            }
            return ListView(
              children: snapshotChats.data!.map(
                (chat) {
                  if (!chat.accounts.contains(FirebaseUtils.auth.currentUser!.uid)) {
                    return Container();
                  }
                  return StreamBuilder(
                    stream: ChatController.getAccountFromChat(chat),
                    builder: (context, snapshotAccount) {
                      if (!snapshotAccount.hasData) {
                        return Container();
                      }
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
                                  onTap: () => ChatController.deleteChat(chat),
                                ),
                              ],
                            ),
                            title: Text(
                              snapshotAccount.data!.userName,
                            ),
                            subtitle: Text(
                              style: const TextStyle(color: Colors.grey),
                              snapshotAccount.data!.status ? 'Online' : 'Offline',
                            ),
                            leading: FutureBuilder(
                              future: AccountController.getAccountImageByName(snapshotAccount.data!.image),
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
                                        backgroundColor: snapshotAccount.data!.status ? Colors.green : Colors.transparent,
                                        radius: 7,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                            onTap: () => AppUtils.switchScreen(ChatPage(account: snapshotAccount.data!), context),
                          ),
                        ),
                      );
                    },
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
