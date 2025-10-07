import 'package:flutter/material.dart';
import 'package:messaging_application/view/menu_calls/page.dart';
import 'package:messaging_application/view/menu_chat/page.dart';
import 'package:messaging_application/view/menu_update/page.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  var menuIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 90, 90, 90),
      appBar: AppBar(
        title: const Text("Menu", style: TextStyle(color: Colors.white)),
        automaticallyImplyLeading: false,
        backgroundColor: const Color.fromARGB(255, 46, 46, 46),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color.fromARGB(255, 46, 46, 46),
        onTap: (value) {
          setState(() {
            menuIndex = value;
          });
        },
        currentIndex: menuIndex,
        selectedItemColor: Colors.white,
        unselectedItemColor: const Color.fromARGB(50, 255, 255, 255),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_rounded),
            label: 'Chats',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.update_rounded),
            label: 'Updates',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.call_rounded),
            label: 'Cals',
          ),
        ],
      ),
      body: IndexedStack(
        index: menuIndex,
        children: const [MenuChatPage(), UpdateMenuPage(), MenuCallsPage()],
      ),
    );
  }
}
