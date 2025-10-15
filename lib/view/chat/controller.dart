import 'package:get/get.dart';
import 'package:messaging_application/model/chat.dart';

class ChatController extends GetxController {
  RxList<Chat> listChat = <Chat>[].obs;

  void addChat(Chat value) {
    listChat.add(value);
  }
}
