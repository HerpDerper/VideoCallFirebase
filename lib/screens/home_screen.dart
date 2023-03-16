import '../models/account.dart';
import '../pages/profile_page.dart';
import '../pages/friends_page.dart';
import '../pages/channels_page.dart';
import '../controllers/account_controller.dart';

import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  int currentIndex = 0;
  late AccountController controller;

  @override
  void initState() {
    controller = AccountController(context: context, account: Account(email: '', userName: '', password: '', birthDate: ''));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 38, 35, 55),
      body: IndexedStack(
        index: currentIndex,
        children: const [
          ChannelsPage(),
          FriendsPage(),
          ProfilePage(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color.fromARGB(255, 22, 20, 32),
        selectedItemColor: Colors.purple,
        unselectedItemColor: Colors.white,
        currentIndex: currentIndex,
        items: [
          const BottomNavigationBarItem(
            label: '',
            icon: Icon(
              size: 30,
              Icons.forum_rounded,
            ),
          ),
          const BottomNavigationBarItem(
            label: '',
            icon: Icon(
              size: 30,
              Icons.emoji_people_rounded,
            ),
          ),
          BottomNavigationBarItem(
            label: '',
            icon: StreamBuilder(
              stream: controller.getAccount(),
              builder: (context, snapshotAccount) {
                if (snapshotAccount.hasData) {
                  controller.account = snapshotAccount.data!;
                }
                return FutureBuilder(
                  future: controller.getAccountImage(),
                  builder: (context, snapshotImage) {
                    return CircleAvatar(
                      radius: 15,
                      backgroundColor: Colors.deepPurple,
                      backgroundImage: NetworkImage(
                        snapshotImage.data.toString(),
                      ),
                      child: CircleAvatar(
                        radius: 13.5,
                        backgroundColor: Colors.transparent,
                        child: Builder(
                          builder: (context) {
                            return Align(
                              alignment: Alignment.bottomRight,
                              child: CircleAvatar(
                                backgroundColor: controller.account!.status ? Colors.green : Colors.grey,
                                radius: 3,
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  },
                );
              },
            ),
            /*Icon(
              size: 30,
              Icons.person_rounded,
            ),*/
          ),
        ],
        onTap: (value) => setState(() => currentIndex = value),
      ),
    );
  }
}
