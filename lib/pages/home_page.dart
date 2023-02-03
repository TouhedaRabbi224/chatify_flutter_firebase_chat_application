//packages
import 'package:flutter/material.dart';

//pages
import '../pages/chats_page.dart';
import '../pages/users_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentPage = 0;
  final List<Widget> _pages = [
    ChatsPage(),
    UsersPage(),
  ];
  @override
  Widget build(BuildContext context) {
    return _buildUI();
  }

  Widget _buildUI() {
    return Scaffold(
      body: _pages[_currentPage],
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentPage,
          onTap: (_index) {
            setState(() {
              _currentPage = _index;
            });
          },
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.chat_bubble_sharp), label: 'Chats'),
            BottomNavigationBarItem(
                icon: Icon(Icons.supervised_user_circle_sharp), label: 'Users'),
          ]),
    );
  }
}
