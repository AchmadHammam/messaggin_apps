import 'dart:convert';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:messaging_application/constant/api_service.dart';
import 'package:messaging_application/helper/auth_controller.dart';
import 'package:http/http.dart' as http;
import 'package:messaging_application/model/chat.dart';
import 'package:messaging_application/model/user.dart';
import 'package:messaging_application/view/login/page.dart';

class FriendController extends GetxController {
  var isLoading = false.obs;
  var limit = 10.obs;
  AuthController authController = Get.put(AuthController());
  final storage = FlutterSecureStorage();

  Future<List<User>> getListFriend({required int page}) async {
    isLoading.value = true;
    try {
      var token = await authController.checkToken();

      var url = Uri.parse('${APIService.baseUrl}/user?page=$page&limit=$limit');

      final response = await http.get(url, headers: {'Authorization': 'Bearer $token'});
      final json = jsonDecode(response.body);
      if (response.statusCode == 200) {
        var data = json['data']['data'];
        var users = (data as List).map((e) => User.fromJson(e)).toList();
        return users;
      } else if (response.statusCode == 401) {
        Get.offAll(LoginPage());
      } else {
        // EasyLoading.showError('Failed to load friends');
      }
    } finally {
      isLoading.value = false;
    }
    return [];
  }

  Future<ChatRoom?> createRoom({required int recevierId}) async {
    isLoading.value = true;
    try {
      EasyLoading.showInfo('Loading...');
      var token = await authController.checkToken();

      var url = Uri.parse('${APIService.baseUrl}/chat/room');
      var body = jsonEncode({'recevierId': recevierId});

      final response = await http.post(
        url,
        headers: {'Authorization': 'Bearer $token', 'Content-Type': 'application/json'},
        body: body,
      );
      final json = jsonDecode(response.body);
      var data = json['data'];
      EasyLoading.dismiss();
      if (response.statusCode == 200) {
        ChatRoom chatRoom = ChatRoom.fromJson(data);
        return chatRoom;
      } else if (response.statusCode == 401) {
        Get.offAll(LoginPage());
      } else {
        EasyLoading.showError('Failed to create chat room');
      }
    } finally {
      isLoading.value = false;
    }
    return null;
  }
}
