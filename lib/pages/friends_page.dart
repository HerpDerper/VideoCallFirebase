import '../models/account.dart';
import '../utils/firebase_utils.dart';

import 'package:flutter/material.dart';

class FriendsPage extends StatefulWidget {
  const FriendsPage({super.key});

  @override
  State<FriendsPage> createState() => FriendsPageState();
}

class FriendsPageState extends State<FriendsPage> {
  Stream<List<Account>> _getFriends() {
    FirebaseUtils.setCollection('Accounts');
    return FirebaseUtils.collection.snapshots().map((snapshot) => snapshot.docs.map((doc) => Account.fromJson(doc.data() as Map<String, dynamic>)).toList());
  }

  Future<String> _getFriendsImage(String imageName) => FirebaseUtils.storage.ref().child(imageName).getDownloadURL();

  @override
  Widget build(BuildContext context) {
    return Center(
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
                return Card(
                  color: Colors.deepPurple,
                  child: ListTile(
                    leading: FutureBuilder(
                      future: _getFriendsImage(account.image),
                      builder: (context, snapshotImage) {
                        return CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.deepPurple,
                          backgroundImage: NetworkImage(
                            snapshotImage.data.toString(),
                          ),
                          child: CircleAvatar(
                            backgroundColor: Colors.transparent,
                            child: Builder(
                              builder: (context) {
                                Color statusColor = Colors.white;
                                switch (account.status) {
                                  case 'Online':
                                    statusColor = Colors.green;
                                    break;
                                  case 'Offline':
                                    statusColor = Colors.grey;
                                    break;
                                }
                                return Align(
                                  alignment: Alignment.bottomRight,
                                  child: CircleAvatar(
                                    backgroundColor: statusColor,
                                    radius: 7,
                                  ),
                                );
                              },
                            ),
                          ),
                        );
                      },
                    ),
                    textColor: Colors.white,
                    title: Text(
                      account.userName,
                    ),
                    subtitle: Text(
                      style: const TextStyle(color: Colors.grey),
                      account.status,
                    ),
                  ),
                );
              },
            ).toList(),
          );
        },
      ),
    );
  }
}
