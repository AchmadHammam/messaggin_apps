import 'dart:convert';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:messaging_application/constant/api_service.dart';
import 'package:messaging_application/helper/auth_controller.dart';
import 'package:messaging_application/helper/helper.dart';
import 'package:messaging_application/model/chat.dart';
import 'package:http/http.dart' as http;
import 'package:pointycastle/asymmetric/api.dart' as pc;
// ignore: library_prefixes
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:basic_utils/basic_utils.dart';

class ChatController extends GetxController {
  RxList<Chat> listChat = <Chat>[].obs;
  int limit = 10;
  final storage = FlutterSecureStorage();

  AuthController authController = Get.find<AuthController>();
  RxBool isLoading = false.obs;
  late IO.Socket socket;
  PagingController<int, Chat> pagingController = PagingController(
    getNextPageKey: (state) => state.lastPageIsEmpty ? null : state.nextIntPageKey,
    fetchPage: (int pageKey) {
      return Get.find<ChatController>().getChat(
        chatRoomId: Get.arguments['chatRoomId'],
        page: pageKey,
      );
    },
  );

  @override
  void onInit() {
    super.onInit();
    _initSocketMessager();
  }

  @override
  void onClose() {
    super.onClose();
    if (socket.connected) {
      socket.disconnect();
      socket.close();
    }
  }

  Future<void> _initSocketMessager() async {
    var token = await authController.checkToken();

    if (token == null) {
      return;
    }
    socket = IO.io(
      APIService.socketUrl.trim(),
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .setQuery({'token': token}) // penting: pakai websocket, bukan polling
          .enableAutoConnect()
          // .setTimeout(10) // agar langsung connect
          .build(),
    );

    socket.connect();
    socket.onConnect((_) {
      socket.emit('register');
    });

    socket.on('reload', (data) {
      pagingController.refresh();
    });

    socket.onConnectError((err) => print('❌ Connect error: $err'));
    socket.onError((err) => print('⚠️ Error: $err'));
    return;
  }

  Future<String?> getScreetRecevierId({required int recevierId}) async {
    try {
      String? token = await authController.checkToken();
      var url = Uri.parse('${APIService.baseUrl}/user/screet/$recevierId');
      final response = await http.get(url, headers: {'Authorization': 'Bearer $token'});
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        String screetId = json['data']['publicKey'];
        return screetId;
      }
    } finally {}
    return null;
  }

  Future<List<Chat>> getChat({required int chatRoomId, required int page}) async {
    isLoading.value = true;
    try {
      String? token = await authController.checkToken();
      var url = Uri.parse('${APIService.baseUrl}/chat/$chatRoomId?page=$page&limit=$limit');
      final response = await http.get(url, headers: {'Authorization': 'Bearer $token'});
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        List<Chat> data = (json['data']['data'] as List).map((e) => Chat.fromJson(e)).toList();
        listChat.value = data;
      }
      var privateKeyPem = await storage.read(key: 'privateKey');
      if (privateKeyPem == null) {
        return [];
      }
      final pc.RSAPrivateKey privateKey = CryptoUtils.rsaPrivateKeyFromPemPkcs1(privateKeyPem);
      return listChat.map((chat) {
        var decryptedMessage = decryptMessage(privateKey, chat.message!);
        if (decryptedMessage == null) {
          chat.message = null;
        } else {
          chat.message = decryptedMessage;
        }
        return chat;
      }).toList();
    } finally {
      isLoading.value = false;
    }
  }

  Future<Chat?> sendChat({
    required int chatRoomId,
    required String message,
    required int recevierId,
  }) async {
    isLoading.value = true;
    try {
      String? token = await authController.checkToken();
      var url = Uri.parse('${APIService.baseUrl}/chat');
      // start encrypt message reciever
      String? screetId = await getScreetRecevierId(recevierId: recevierId);
      if (screetId == null) {
        return null;
      }
      final pc.RSAPublicKey publicKeyReceiver = CryptoUtils.rsaPublicKeyFromPem(screetId);
      var encryptReciver = encryptMessage(message, publicKeyReceiver);
      // end
      // start encrypt message sender
      var publicKeySender = await storage.read(key: 'publicKey');
      if (publicKeySender == null) {
        return null;
      }
      final pc.RSAPublicKey privateKeySender = CryptoUtils.rsaPublicKeyFromPem(publicKeySender);
      var encryptSender = encryptMessage(message, privateKeySender);
      // end

      var body = jsonEncode({
        'chatRoomId': chatRoomId,
        'recevier': ({"id": recevierId, "message": encryptReciver}),
        'sender': ({"id": authController.userId.value, "message": encryptSender}),
      });
      final response = await http.post(
        url,
        headers: {'Authorization': 'Bearer $token', 'Content-Type': 'application/json'},
        body: body,
      );

      final json = jsonDecode(response.body);
      if (response.statusCode == 200) {
        Chat data = Chat.fromJson(json['data']);
        if (!socket.connected) {
          socket.connect();
        }

        socket.emit('send_message', data.id);

        return data;
      } else if (response.statusCode == 401) {
        await authController.logout();
      } else if (response.statusCode == 422) {
        var json = jsonDecode(response.body);
        EasyLoading.showError(json['message'] ?? 'Validation Error');
      }
      return null;
    } finally {
      isLoading.value = false;
    }
  }
}
