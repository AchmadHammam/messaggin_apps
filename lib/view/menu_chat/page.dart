import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:intl/intl.dart';
import 'package:messaging_application/helper/auth_controller.dart';
import 'package:messaging_application/model/chat.dart';
import 'package:messaging_application/view/chat/page.dart';
import 'package:messaging_application/view/menu_chat/controller.dart';

class MenuChatPage extends StatefulWidget {
  const MenuChatPage({super.key});

  @override
  State<MenuChatPage> createState() => _MenuChatPageState();
}

class _MenuChatPageState extends State<MenuChatPage> {
  MenuChatController chatController = MenuChatController();
  AuthController authController = AuthController();
  late PagingController<int, ChatRoom> pagingController;
  int? userId;
  @override
  void initState() {
    super.initState();
    pagingController = PagingController(
      getNextPageKey: (state) =>
          state.lastPageIsEmpty ? null : state.nextIntPageKey,
      fetchPage: (int pageKey) {
        return chatController.getListChatRoom(page: pageKey);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
      body: PagingListener(
        controller: pagingController,
        builder: (context, state, fetchNextPage) {
          return RefreshIndicator(
            onRefresh: () async {
              pagingController.refresh();
            },
            child: SafeArea(
              minimum: EdgeInsets.symmetric(
                vertical: MediaQuery.of(context).size.height * .02,
                horizontal: MediaQuery.of(context).size.width * .05,
              ),
              child: PagedListView(
                state: state,
                fetchNextPage: fetchNextPage,
                builderDelegate: PagedChildBuilderDelegate<ChatRoom>(
                  itemBuilder: (context, item, index) => Container(
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

                    child: ListTile(
                      onTap: () {
                        Get.to(
                          ChatPage(
                            chatRoomId: item.id,
                            chatRoomName: userId != item.user1.id
                                ? item.user1.nama!
                                : item.user2.nama!,
                          ),
                        );
                      },
                      title: Text(
                        userId != item.user1.id
                            ? item.user1.nama!
                            : item.user2.nama!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(
                          'https://placehold.co/600x400/png?text=Profile+Image',
                        ),
                      ),
                      subtitle: Text(
                        item.lastChatMessage != null
                            ? item.lastChatMessage!.message
                            : '',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          height: 1.5,
                        ),
                      ),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            item.lastChatMessage != null
                                ? DateFormat(
                                    'HH:mm',
                                  ).format(item.lastChatMessage!.createdAt!)
                                : '',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                          Container(
                            width: 15,
                            height: 15,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.green),
                              color: Colors.green,
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              item.totalUnread.toString(),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                // height: -1,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
