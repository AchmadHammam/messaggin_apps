import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:intl/intl.dart';
import 'package:messaging_application/helper/auth_controller.dart';
import 'package:messaging_application/helper/helper.dart';
import 'package:messaging_application/model/chat.dart';
import 'package:messaging_application/view/chat/page.dart';
import 'package:messaging_application/view/list_friend/page.dart';
import 'package:messaging_application/view/menu_chat/controller.dart';

class MenuChatPage extends StatefulWidget {
  const MenuChatPage({super.key});

  @override
  State<MenuChatPage> createState() => _MenuChatPageState();
}

class _MenuChatPageState extends State<MenuChatPage> with RouteAware, WidgetsBindingObserver {
  MenuChatController chatController = MenuChatController();
  AuthController authController = Get.put(AuthController());

  late PagingController<int, ChatRoom> pagingController;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    pagingController = PagingController(
      getNextPageKey: (state) => state.lastPageIsEmpty ? null : state.nextIntPageKey,
      fetchPage: (int pageKey) {
        return chatController.getListChatRoom(page: pageKey);
      },
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Subscribe to the RouteObserver
    routeObserver.subscribe(this, ModalRoute.of(context) as PageRoute<dynamic>);
  }

  @override
  void didPopNext() {
    pagingController.refresh();
    super.didPopNext();
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
    routeObserver.unsubscribe(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // Aplikasi kembali aktif / halaman fokus lagi
      pagingController.refresh();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(ListFriendPage());
        },
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
                    margin: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * .015),
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
                            chatRoomName: authController.userId.value == item.user1.id
                                ? item.user2.nama!
                                : item.user1.nama!,
                            recevierId: authController.userId.value == item.user1.id
                                ? item.user2.id
                                : item.user1.id,
                          ),
                          arguments: {'chatRoomId': item.id},
                        );
                      },
                      title: Text(
                        authController.userId.value == item.user1.id
                            ? item.user2.nama!
                            : item.user1.nama!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(
                          'https://placehold.co/600x400/png?text=Profile+Image',
                        ),
                      ),
                      subtitle: Text(
                        (item.lastChatMessage != null && item.lastChatMessage!.message != null)
                            ? item.lastChatMessage!.message!
                            : '',
                        style: const TextStyle(color: Colors.white, fontSize: 12, height: 1.5),
                      ),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            item.lastChatMessage != null
                                ? DateFormat('HH:mm').format(item.lastChatMessage!.createdAt!)
                                : '',
                            style: const TextStyle(color: Colors.white, fontSize: 8),
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
