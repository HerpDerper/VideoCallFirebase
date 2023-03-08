import '../pages/profile_page.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  final List<Widget> pages = [const ChannelsPage(), const FriendsPage, const ProfilePage()];
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 38, 35, 55),
      body: pages[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.chat_bubble)),
          BottomNavigationBarItem(icon: Icon(Icons.hail)),
          BottomNavigationBarItem(icon: Icon(Icons.person)),
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
