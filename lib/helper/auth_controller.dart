import 'package:get/get.dart';
import 'package:messaging_application/constant/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class AuthController extends GetxController {
  var userId = RxnInt();
  @override
  void onInit() {
    super.onInit();
    _getUserId();
  }

  // @override
  // void onReady() {
  //   super.onReady();
  //   _getUserId().then((_) {
  //     print('userId setelah load: ${userId?.value}');
  //   });
  // }

  Future<String?> checkToken() async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    if (token != null) {
      var url = Uri.parse('${APIService.baseUrl}/auth/verify');
      var res = await http.post(url, headers: {'Authorization': 'Bearer $token'});
      if (res.statusCode == 200) {
        return token;
      }
    }
    return null;
  }

  Future<bool> logout() async {
    var token = await checkToken();
    var url = Uri.parse('${APIService.baseUrl}/auth/logout');
    await http.post(url, headers: {'Authorization': 'Bearer $token'});
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
    return true;
  }

  Future<void> _getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    int? data = prefs.getInt('userId');
    if (data != null) {
      userId.value = data;
    }
  }
}
