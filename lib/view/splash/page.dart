import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:messaging_application/helper/auth_controller.dart';
import 'package:messaging_application/view/login/page.dart';
import 'package:messaging_application/view/menu/page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  AuthController authController = AuthController();
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      authController.checkToken().then((value) {
        print(value);
        if (value != null) {
          Get.offAll(MenuPage());
        } else {
          Get.offAll(LoginPage());
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(child: Center(child: Text("Splash Screen")));
  }
}
