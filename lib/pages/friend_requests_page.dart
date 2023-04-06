import 'package:flutter/material.dart';

import '../models/account.dart';
import '../utils/app_utils.dart';
import '../controllers/account_controller.dart';
import '../controllers/friend_request_controller.dart';

class FriendRequestsPage extends StatefulWidget {
  const FriendRequestsPage({super.key});

  @override
  State<FriendRequestsPage> createState() => FriendRequestsPageState();
}

class FriendRequestsPageState extends State<FriendRequestsPage> {
  late AccountController controller = AccountController(context: context, account: Account(email: '', userName: '', password: '', birthDate: ''));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 38, 35, 55),
      body: Center(
        child: StreamBuilder(
          stream: FriendRequestController.getFriendRequests(),
          builder: (context, snapshotChats) {
            if (!snapshotChats.hasData) {
              return Container();
            }
            if (snapshotChats.data!.isEmpty) {
              return const Center(
                child: Text(
                  'No new friend requests',
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
                (friendRequest) {
                  return StreamBuilder(
                    stream: FriendRequestController.getAccountFromRequest(friendRequest),
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
                                    'Accept',
                                  ),
                                  onTap: () => FriendRequestController.acceptFriendRequest(friendRequest),
                                ),
                                PopupMenuItem(
                                  child: const Text(
                                    'Decline',
                                  ),
                                  onTap: () => FriendRequestController.deleteFriendRequest(friendRequest),
                                ),
                              ],
                            ),
                            title: Text(
                              snapshotAccount.data!.userName,
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
                                );
                              },
                            ),
                            onTap: () => AppUtils(controller: AccountController(context: context, account: snapshotAccount.data)).showAccountInfoDialog(),
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
