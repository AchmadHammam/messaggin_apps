import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:messaging_application/view/splash/page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.rosarioTextTheme(),
        scaffoldBackgroundColor: const Color.fromARGB(255, 90, 90, 90),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color.fromARGB(255, 46, 46, 46),
          iconTheme: IconThemeData(color: Colors.white),
          leadingWidth: 30,
        ),
      ),
      builder: EasyLoading.init(),
      home: const SplashScreen(),
    );
  }
}
