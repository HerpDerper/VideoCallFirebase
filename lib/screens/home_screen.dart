import '../pages/profile_page.dart';
import '../pages/friends_page.dart';
import '../pages/channels_page.dart';

import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  int currentIndex = 0;

  @override
  void initState() {
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
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.chat_bubble,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.hail_sharp,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person,
            ),
            label: '',
          ),
        ],
        backgroundColor: const Color.fromARGB(255, 38, 35, 55),
        selectedItemColor: Colors.purple,
        unselectedItemColor: Colors.white,
        currentIndex: currentIndex,
        onTap: (value) => setState(() => currentIndex = value),
      ),
    );
  }
}
