import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:messaging_application/view/login/page.dart';
import 'package:messaging_application/view/menu/page.dart';
import 'package:messaging_application/view/splash/controller.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  SplashController splashController = SplashController();
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      splashController.checkToken().then((value) {
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
