import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:intl/intl.dart';
import 'package:messaging_application/helper/auth_controller.dart';
import 'package:messaging_application/model/chat.dart';
import 'package:messaging_application/view/chat/controller.dart';

class ChatPage extends StatefulWidget {
  final int chatRoomId;
  final String chatRoomName;
  const ChatPage({super.key, required this.chatRoomId, required this.chatRoomName});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController messageController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  ChatController chatController = Get.put(ChatController());
  AuthController authController = Get.put(AuthController());
  late PagingController<int, Chat> pagingController;
  @override
  void initState() {
    super.initState();
    pagingController = chatController.pagingController;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: CircleAvatar(
                backgroundImage: NetworkImage(
                  'https://placehold.co/600x400/png?text=Profile+Image',
                ),
              ),
            ),
            Text(widget.chatRoomName, style: TextStyle(color: Colors.white)),
          ],
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            PagingListener(
              controller: pagingController,
              builder: (context, state, fetchNextPage) {
                return RefreshIndicator(
                  onRefresh: () async {
                    pagingController.refresh();
                  },
                  child: SafeArea(
                    child: PagedListView(
                      state: state,
                      fetchNextPage: fetchNextPage,
                      builderDelegate: PagedChildBuilderDelegate<Chat>(
                        itemBuilder: (context, item, index) {
                          Chat chat = item;
                          return Container(
                            margin: EdgeInsets.only(
                              bottom: MediaQuery.of(context).size.height * .07,
                            ),
                            padding: EdgeInsets.symmetric(
                              vertical: MediaQuery.of(context).size.height * .02,
                              horizontal: MediaQuery.of(context).size.width * .025,
                            ),
                            child: ConstrainedBox(
                              constraints: BoxConstraints(
                                maxWidth: MediaQuery.of(context).size.width * .7,
                                minWidth: MediaQuery.of(context).size.width * .3,
                              ),
                              child: Container(
                                margin: EdgeInsets.only(
                                  left: chat.senderId == authController.userId.value
                                      ? MediaQuery.of(context).size.width * .05
                                      : 0,
                                  right: chat.senderId != authController.userId.value
                                      ? MediaQuery.of(context).size.width * .05
                                      : 0,
                                  bottom: MediaQuery.of(context).size.height * .005,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color.fromARGB(255, 46, 46, 46),
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.shade800,
                                      spreadRadius: 2,
                                      blurRadius: 5,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                  child: Column(
                                    children: [
                                      Align(
                                        alignment: chat.senderId == authController.userId.value
                                            ? Alignment.centerRight
                                            : Alignment.centerLeft,
                                        child: Text(
                                          chat.message,
                                          style: TextStyle(color: Colors.white, fontSize: 16),
                                        ),
                                      ),
                                      Align(
                                        alignment: chat.senderId == authController.userId.value
                                            ? Alignment.bottomLeft
                                            : Alignment.bottomRight,
                                        child: Text(
                                          DateFormat('hh:mm a').format(chat.createdAt!),
                                          style: TextStyle(
                                            color: Colors.white.withValues(alpha: .6),
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                );
              },
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 46, 46, 46),
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        width: double.infinity,
                        height: MediaQuery.of(context).size.height * .075,
                        child: TextFormField(
                          style: TextStyle(color: Colors.white, fontSize: 16),
                          controller: messageController,
                          decoration: InputDecoration(
                            hintStyle: TextStyle(color: Colors.white, fontSize: 16),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 10,
                              // vertical: 10,
                            ),
                            border: InputBorder.none,
                            hintText: "Send a message...",
                          ),
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 2.5),
                      height: MediaQuery.of(context).size.height * .05,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color.fromARGB(255, 46, 46, 46),
                      ),
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        iconSize: 15,
                        icon: Icon(Icons.send, color: Colors.white),
                        onPressed: () {
                          setState(() {
                            chatController.sendChat(
                              chatRoomId: widget.chatRoomId,
                              message: messageController.text,
                            );
                            messageController.clear();
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
