import 'package:flutter/material.dart';

import '../models/account.dart';
import '../pages/profile_page.dart';
import '../pages/friends_page.dart';
import '../pages/channels_page.dart';
import '../pages/friend_requests_page.dart';
import '../controllers/account_controller.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  int currentIndex = 3;
  late AccountController controller = AccountController(context: context, account: Account(email: '', userName: '', password: '', birthDate: ''));
  String appBarTitle = 'Chats';

  void updateState(int index) {
    setState(() {
      currentIndex = index;
      switch (currentIndex) {
        case 0:
          appBarTitle = 'Chats';
          break;
        case 1:
          appBarTitle = 'Friends';
          break;
        case 2:
          appBarTitle = 'Friend requests';
          break;
        case 3:
          appBarTitle = 'Profile settings';
          break;
      }
    });
    Navigator.pop(context);
  }

  @override
  void initState() {
    super.initState();
    controller.updateStatus(true);
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      controller.updateStatus(true);
      return;
    }
    if (state == AppLifecycleState.inactive) {
      controller.updateStatus(false);
      return;
    }
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
          FriendRequestsPage(),
          ProfilePage(),
        ],
      ),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 13, 12, 17),
        title: Text(appBarTitle),
      ),
      drawer: Drawer(
        backgroundColor: const Color.fromARGB(255, 27, 24, 43),
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.deepPurple,
              ),
              child: StreamBuilder(
                stream: controller.getMyAccount(),
                builder: (context, snapshotAccount) {
                  if (snapshotAccount.hasData) {
                    controller.account = snapshotAccount.data;
                    controller.updateStatus(true);
                  }
                  return FutureBuilder(
                    future: controller.getAccountImage(),
                    builder: (context, snapshotImage) {
                      return CircleAvatar(
                        backgroundColor: Colors.transparent,
                        backgroundImage: NetworkImage(
                          snapshotImage.data.toString(),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            ListTile(
              leading: const Icon(
                Icons.forum_rounded,
                color: Colors.white,
              ),
              title: const Text(
                'Chats',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              onTap: () => updateState(0),
            ),
            ListTile(
              leading: const Icon(
                Icons.emoji_people_rounded,
                color: Colors.white,
              ),
              title: const Text(
                'Friends',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              onTap: () => updateState(1),
            ),
            ListTile(
              leading: const Icon(
                Icons.person_add_rounded,
                color: Colors.white,
              ),
              title: const Text(
                'Friend requests',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              onTap: () => updateState(2),
            ),
            ListTile(
              leading: const Icon(
                Icons.settings,
                color: Colors.white,
              ),
              title: const Text(
                'Profile settings',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              onTap: () => updateState(3),
            ),
          ],
        ),
      ),
    );
  }
}
