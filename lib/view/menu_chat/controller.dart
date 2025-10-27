import 'dart:convert';

import 'package:basic_utils/basic_utils.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:messaging_application/constant/api_service.dart';
import 'package:messaging_application/helper/auth_controller.dart';
import 'package:messaging_application/helper/helper.dart';
import 'package:messaging_application/model/chat.dart';
import 'package:http/http.dart' as http;
import 'package:messaging_application/view/login/page.dart';
import 'package:pointycastle/asymmetric/api.dart' as pc;

class MenuChatController extends GetxController {
  var isLoading = false.obs;
  var limit = 10.obs;
  AuthController authController = Get.put(AuthController());

  final storage = FlutterSecureStorage();

  Future<List<ChatRoom>> getListChatRoom({required int page}) async {
    isLoading.value = true;
    try {
      var token = await authController.checkToken();

      var url = Uri.parse('${APIService.baseUrl}/chat/room?page=$page&limit=$limit');

      final response = await http.get(url, headers: {'Authorization': 'Bearer $token'});

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        List<ChatRoom> data = (json['data']['data'] as List)
            .map((e) => ChatRoom.fromJson(e))
            .toList();
        var privateKeyPem = await storage.read(key: 'privateKey');
        if (privateKeyPem == null) {
          Get.offAll(LoginPage());
          return [];
        }
        final pc.RSAPrivateKey privateKey = CryptoUtils.rsaPrivateKeyFromPemPkcs1(privateKeyPem);
        return data.map((room) {
          if (room.lastChatMessage != null) {
            var decryptedMessage = decryptMessage(privateKey, room.lastChatMessage!.message!);
            if (decryptedMessage == null) {
              room.lastChatMessage!.message = null;
            } else {
              room.lastChatMessage!.message = decryptedMessage;
            }
          }
          return room;
        }).toList();
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

  Future<bool> createChatRoom({required int recevierId}) async {
    isLoading.value = true;
    try {
      EasyLoading.showInfo('Loading...');
      String? token = await authController.checkToken();
      var url = Uri.parse('${APIService.baseUrl}/chat/room');
      final response = await http.post(
        url,
        headers: {'Authorization': 'Bearer $token', 'Content-Type': 'application/json'},
        body: jsonEncode({'recevierId': recevierId}),
      );
      if (response.statusCode == 200) {
        return true;
      }
    } finally {
      EasyLoading.dismiss();
      isLoading.value = false;
    }
    return false;
  }
}
