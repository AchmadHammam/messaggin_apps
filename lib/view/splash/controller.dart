import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashController extends GetxController {
  Future<String?> checkToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }
}
