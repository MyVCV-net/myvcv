import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myvcv/repositories/auth/auth_controller.dart';
import 'package:myvcv/widget/widgets.dart';

import '../screens.dart';

class ChatPage extends StatefulWidget {
  static const String routeName = '/ChatPage';

  static Route route() {
    return MaterialPageRoute(
      settings: RouteSettings(name: routeName),
      builder: (_) => ChatPage(),
    );
  }

  const ChatPage({Key? key}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(title: "Chat"),
        body: SafeArea(
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(32),
                        topRight: Radius.circular(32),
                        bottomLeft: Radius.circular(32),
                        bottomRight: Radius.circular(32)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        blurRadius: 7,
                        offset:
                            const Offset(2, 2), // changes position of shadow
                      ),
                    ],
                  ),
                  child: TextField(
                    onChanged: (value) {},
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 20.0),
                      hintText: 'Search by name or email',
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 200,
                height: 200,
                child: GetBuilder<AuthController>(
                    init: Get.put(AuthController()),
                    builder: (controller) =>
                        controller.user[0].chatUsers.isNotEmpty
                            ? ListView.separated(
                                scrollDirection: Axis.horizontal,
                                separatorBuilder: (context, intt) =>
                                    const SizedBox(height: 0, width: 0),
                                itemCount: controller.user[0].chatUsers.length,
                                itemBuilder: (context, index) {
                                  return Container(
                                    width: 200,
                                    height: 200,
                                    child: UserChatCard(
                                      imageUrl: controller.user[0]
                                          .chatUsers[index].userImageUrl,
                                      username: controller
                                          .user[0].chatUsers[index].username,
                                    ),
                                  );
                                })
                            : Center(
                                child: Text('Empty'),
                              )),
              ),
            ],
          ),
        ));
  }
}

class UserChatCard extends StatelessWidget {
  const UserChatCard({
    Key? key,
    required this.imageUrl,
    required this.username,
  }) : super(key: key);

  final String imageUrl;
  final String username;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Get.to(MessagesPage());
      },
      leading: imageUrl != '' && imageUrl != null
          ? CachedNetworkImage(
              imageUrl: imageUrl,
              imageBuilder: (context, imageProvider) => Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(60)),
                  image: DecorationImage(
                    image: imageProvider,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              placeholder: (context, url) => CircularProgressIndicator(),
              errorWidget: (context, url, error) => Image.asset(
                'assets/account.png',
              ),
            )
          : Image.asset(
              'assets/account.png',
            ),
      title: Text(username),
      // subtitle: Text(message),
      // trailing: Column(
      //   children: [
      //     const Text("20:30"),
      //     Container(
      //         decoration: const BoxDecoration(
      //           // color: Color(0xFFFFE),//!Change it
      //           borderRadius: BorderRadius.all(Radius.circular(50)),
      //         ),
      //         child: const Padding(
      //           padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 3),
      //           child: Text("2"),
      //         ))
      //   ],
      // ),
    );
  }
}
