import 'dart:convert';

import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:messaging_application/constant/api_service.dart';
import 'package:messaging_application/helper/auth_controller.dart';
import 'package:messaging_application/model/chat.dart';
import 'package:http/http.dart' as http;
// ignore: library_prefixes
import 'package:socket_io_client/socket_io_client.dart' as IO;

class ChatController extends GetxController {
  RxList<Chat> listChat = <Chat>[].obs;
  int limit = 10;
  AuthController authController = AuthController();
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
      print('🛑 Socket manually disconnected');
    } else {
      print('⚠️ Socket already disconnected');
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
          .setTimeout(10)// agar langsung connect
          .build(),
    );

    socket.connect();
    socket.onConnect((_) {
      print('✅ Socket connected: ${socket.id}');
      socket.emit('register');
    });

    socket.on('reload', (data) {
      print("reload");
      pagingController.refresh();
    });

    socket.onConnectError((err) => print('❌ Connect error: $err'));
    socket.onError((err) => print('⚠️ Error: $err'));
    return;
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
      return listChat;
    } catch (e) {
      print(e);
    } finally {
      isLoading.value = false;
    }
    return [];
  }

  Future<Chat?> sendChat({required int chatRoomId, required String message}) async {
    isLoading.value = true;
    try {
      String? token = await authController.checkToken();
      var url = Uri.parse('${APIService.baseUrl}/chat');
      var body = jsonEncode({'message': message, 'chatRoomId': chatRoomId});
      final response = await http.post(
        url,
        headers: {'Authorization': 'Bearer $token', 'Content-Type': 'application/json'},
        body: body,
      );
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        Chat data = Chat.fromJson(json['data']);
        print(data);

        socket.onConnect((_) {
          Future.delayed(Duration(milliseconds: 500), () {
            socket.emit('send_message', data.id);
          });
        });

        return data;
      }
      return null;
    } catch (e) {
      print(e);
    } finally {
      isLoading.value = false;
    }
    return null;
  }
}
