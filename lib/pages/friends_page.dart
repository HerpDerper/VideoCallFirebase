import 'dart:async';
import 'package:flutter/material.dart';

import '../models/account.dart';
import '../utils/app_utils.dart';
import '../utils/firebase_utils.dart';
import '../controllers/account_controller.dart';

class FriendsPage extends StatefulWidget {
  const FriendsPage({super.key});

  @override
  State<FriendsPage> createState() => FriendsPageState();
}

class FriendsPageState extends State<FriendsPage> {
  late AccountController controller = AccountController(context: context, account: Account(email: '', userName: '', password: '', birthDate: ''));

  Stream<List<Account>> _getFriends() {
    FirebaseUtils.setCollection('Accounts');
    StreamController<List<Account>> streamController = StreamController.broadcast();
    List<Account> friendsList = [];
    for (String friendId in controller.account!.friends) {
      AccountController.getAccountById(friendId).then((acc) {
        friendsList.add(acc);
        streamController.sink.add(friendsList);
      });
    }
    return streamController.stream;
  }

  void searchNewFriend(String userName) async {
    FirebaseUtils.setCollection('Accounts');
    await FirebaseUtils.collection.where('userName', isEqualTo: userName).get().then((value) {
      if (value.docs.isEmpty || controller.account!.userName == userName) {
        AppUtils.showInfoMessage('No users found', context);
        return;
      }
      AppUtils(controller: AccountController(context: context, account: Account.fromSnapshot(value.docs.first))).showFriendAddDialog();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 38, 35, 55),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color.fromARGB(255, 22, 20, 32),
        title: SizedBox(
          width: double.infinity,
          height: 40,
          child: Center(
            child: TextField(
              style: const TextStyle(
                color: Colors.white,
              ),
              decoration: InputDecoration(
                hintStyle: const TextStyle(
                  color: Colors.grey,
                ),
                prefixIcon: const Icon(
                  Icons.search,
                  color: Colors.white,
                ),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.add),
                  color: Colors.white,
                  onPressed: () {},
                ),
              ),
              onSubmitted: (userName) => searchNewFriend(userName),
            ),
          ),
        ),
      ),
      body: Center(
        child: StreamBuilder(
          stream: controller.getMyAccount(),
          builder: (context, snapshotAccount) {
            if (snapshotAccount.hasData) {
              controller.account = snapshotAccount.data!;
              return StreamBuilder(
                stream: _getFriends(),
                builder: (context, snapshotFriends) {
                  if (snapshotFriends.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator(
                      color: Color.fromARGB(255, 123, 118, 155),
                    );
                  }
                  return ListView(
                    children: snapshotFriends.data!.map(
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
                                      'Delete',
                                    ),
                                    onTap: () => controller.deleteFriend(account.id!),
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
                              onTap: () => AppUtils(controller: controller).showAccountInfoDialog(),
                            ),
                          ),
                        );
                      },
                    ).toList(),
                  );
                },
              );
            }
            return Container();
          },
        ),
      ),
    );
  }
}
