import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:messaging_application/helper/helper.dart';
import 'package:messaging_application/model/user.dart';
import 'package:messaging_application/view/chat/page.dart';
import 'package:messaging_application/view/list_friend/controller.dart';

class ListFriendPage extends StatefulWidget {
  const ListFriendPage({super.key});

  @override
  State<ListFriendPage> createState() => _ListFriendPageState();
}

class _ListFriendPageState extends State<ListFriendPage> with RouteAware, WidgetsBindingObserver {
  PagingController<int, User>? pagingController;
  FriendController friendController = Get.put(FriendController());
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    pagingController = PagingController(
      getNextPageKey: (state) => state.lastPageIsEmpty ? null : state.nextIntPageKey,
      fetchPage: (pageKey) => friendController.getListFriend(page: pageKey),
    );
  }

  @override
  void didChangeDependencies() {
    routeObserver.subscribe(this, ModalRoute.of(context) as PageRoute<dynamic>);
    super.didChangeDependencies();
  }

  @override
  void didPopNext() {
    pagingController?.refresh();
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
      pagingController?.refresh();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "List Friend",
          style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        minimum: EdgeInsets.symmetric(
          vertical: MediaQuery.of(context).size.height * .02,
          horizontal: MediaQuery.of(context).size.width * .05,
        ),
        child: PagingListener(
          controller: pagingController!,
          builder: (context, state, fetchNextPage) {
            return PagedListView(
              state: state,
              fetchNextPage: fetchNextPage,
              builderDelegate: PagedChildBuilderDelegate<User>(
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
                      friendController.createRoom(recevierId: item.id).then((chatRoom) {
                        if (chatRoom != null) {
                          Get.to(
                            () => ChatPage(
                              chatRoomId: chatRoom.id,
                              chatRoomName: item.nama!,
                              recevierId: item.id,
                            ),
                            arguments: {'chatRoomId': item.id},
                          );
                        }
                      });
                    },

                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(
                        'https://placehold.co/600x400/png?text=Profile+Image',
                      ),
                    ),
                    title: Text(
                      item.nama!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: Text(
                      item.email,
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
