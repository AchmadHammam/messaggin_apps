import 'dart:convert';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:messaging_application/constant/api_service.dart';
import 'package:http/http.dart' as http;

class RegisterController extends GetxController {
  var isLoading = false.obs;
  Future<bool> register({
    required String email,
    required String password,
    required String name,
    required String confirmPassword,
  }) async {
    isLoading.value = true;
    EasyLoading.showInfo('Loading...');
    try {
      var data = jsonEncode({
        'email': email,
        'password': password,
        'nama': name,
        'password_confirmation': confirmPassword,
      });
      var url = Uri.parse('${APIService.baseUrl}/auth/register');
      var response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: data,
      );
      if (response.statusCode == 200) {
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
