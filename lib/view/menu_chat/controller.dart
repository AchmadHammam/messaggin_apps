import 'dart:convert';

import 'package:get/get.dart';
import 'package:messaging_application/constant/api_service.dart';
import 'package:messaging_application/helper/auth_controller.dart';
import 'package:messaging_application/model/chat.dart';
import 'package:http/http.dart' as http;
import 'package:messaging_application/view/login/page.dart';

class MenuChatController extends GetxController {
  var isLoading = false.obs;
  var limit = 10.obs;
  AuthController authController = AuthController();

  Future<List<ChatRoom>> getListChatRoom({required int page}) async {
    isLoading.value = true;
    try {
      var token = await authController.checkToken();

      var url = Uri.parse(
        '${APIService.baseUrl}/chat/room?page=$page&limit=$limit',
      );

      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        List<ChatRoom> data = (json['data']['data'] as List)
            .map((e) => ChatRoom.fromJson(e))
            .toList();
        return data;
      } else if (response.statusCode == 401) {
        Get.offAll(LoginPage());
      }
      return [];
    } catch (e) {
      print(e);
      return [];
    } finally {
      isLoading.value = false;
    }
  }
}
