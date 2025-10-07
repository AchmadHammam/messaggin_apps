import 'dart:convert';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:messaging_application/constant/api_service.dart';
import 'package:messaging_application/model/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginController extends GetxController {
  var isLoading = false.obs;

  Future<bool> login({required String email, required String password}) async {
    isLoading.value = true;
    final prefs = await SharedPreferences.getInstance();
    var url = Uri.parse('${APIService.baseUrl}/auth/login');
    try {
      EasyLoading.showInfo('Loading...');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );
      EasyLoading.dismiss();
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final data = LoginResponse.fromJson(json);
        prefs.setString('token', data.data.token);
        prefs.setInt('userId', data.data.user.id);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    } finally {
      EasyLoading.dismiss();
      isLoading.value = false;
    }
  }
}
