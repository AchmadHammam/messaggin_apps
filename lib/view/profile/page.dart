import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:messaging_application/helper/auth_controller.dart';
import 'package:messaging_application/view/login/page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  AuthController authController = AuthController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 90, 90, 90),
      appBar: AppBar(
        title: const Text("Profile", style: TextStyle(color: Colors.white)),
        automaticallyImplyLeading: false,
        backgroundColor: const Color.fromARGB(255, 46, 46, 46),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
      ),
      body: SafeArea(
        minimum: EdgeInsets.symmetric(
          vertical: MediaQuery.of(context).size.height * .02,
        ),
        child: Column(
          children: [
            ListTile(
              leading: Icon(Icons.logout, color: Colors.white),
              title: Text("Logout", style: TextStyle(color: Colors.white)),
              onTap: () {
                authController.logout().then((v) => Get.offAll(LoginPage()));
              },
            ),
          ],
        ),
      ),
    );
  }
}
