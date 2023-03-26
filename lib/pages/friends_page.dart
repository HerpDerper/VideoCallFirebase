import 'package:flutter/material.dart';
import 'package:flutter_video_call/pages/chat_page.dart';

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
  String userNameSearch = '';

  Stream<List<Account>> _getFriends() {
    return FirebaseUtils.collection.snapshots().map((snapshot) => snapshot.docs.map((doc) => Account.fromSnapshot(doc)).toList());
  }

  void searchFriend(String userName) async {
    FirebaseUtils.setCollection('Accounts');
    Account account = await FirebaseUtils.collection.where('userName', isEqualTo: 'userName').get().then((value) => Account.fromSnapshot(value.docs[0]));
    AppUtils(controller: AccountController(context: context, account: account)).showAccountInfoDialog(context);
  }

  Future<String> _getFriendsImage(String imageName) => FirebaseUtils.storage.ref().child(imageName).getDownloadURL();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 38, 35, 55),
      appBar: AppBar(
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
              onSubmitted: (userName) => searchFriend(userName),
            ),
          ),
        ),
      ),
      body: Center(
        child: StreamBuilder(
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
                        title: Text(
                          account.userName,
                        ),
                        subtitle: Text(
                          style: const TextStyle(color: Colors.grey),
                          account.status ? 'Online' : 'Offline',
                        ),
                        leading: FutureBuilder(
                          future: _getFriendsImage(account.image),
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
                        onTap: () => Navigator.push(
                            context, DialogRoute(builder: (context) => ChatPage(accountId: account.id!, accountName: account.userName), context: context)),
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
