import 'package:flutter/material.dart';

class MenuCallsPage extends StatefulWidget {
  const MenuCallsPage({super.key});

  @override
  State<MenuCallsPage> createState() => _MenuCallsPageState();
}

class _MenuCallsPageState extends State<MenuCallsPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(child: Text("Calls")),
    );
  }
}
