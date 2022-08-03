import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myvcv/repositories/auth/auth_controller.dart';
import 'package:myvcv/widget/widgets.dart';

class MessagesPage extends StatefulWidget {
  static const String routeName = '/MessagesPage';

  static Route route() {
    return MaterialPageRoute(
      settings: RouteSettings(name: routeName),
      builder: (_) => MessagesPage(),
    );
  }

  const MessagesPage({Key? key}) : super(key: key);

  @override
  _MessagesPageState createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  List<MessageBubble> messageBubbles = [];
  final messageBubble = const MessageBubble(
    sender: "saleh",
    text: "Hello saleh ok",
    isMe: true,
  );
  final messageBubble1 = const MessageBubble(
    sender: "saleh",
    text: "Hi bro, how are you? Please can recommend me on my profile",
    isMe: false,
  );
  @override
  void initState() {
    super.initState();
    setState(() {
      messageBubbles.add(messageBubble);
      messageBubbles.add(messageBubble1);
      messageBubbles.add(messageBubble1);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   iconTheme: const IconThemeData(
      //     color: Colors.black, //change your color here
      //   ),
      //   centerTitle: false,
      //   actions: <Widget>[
      //     Padding(
      //       padding: const EdgeInsets.all(8.0),
      //       child: Container(
      //         width: 40,
      //         height: 40,
      //         decoration: const BoxDecoration(
      //           shape: BoxShape.circle,
      //           image: DecorationImage(
      //               image: NetworkImage(
      //                 "https://media-exp1.licdn.com/dms/image/C4D03AQHKdwIyMPgkpw/profile-displayphoto-shrink_800_800/0/1627423597770?e=1636588800&v=beta&t=fLqmv_xO5nfXfSPiCM6bnHKJxptyaNKeNIomNMrhrkk",
      //               ),
      //               fit: BoxFit.fill),
      //         ),
      //       ),
      //     ),
      //   ],
      //   title: const Text("Saleh Abbas",
      //       style: TextStyle(color: Color(0xFF0A6077))),
      //   elevation: 0,
      //   backgroundColor: Colors.white,
      // ),
      appBar: CustomAppBar(title: "Saleh Abbas"),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
                child: ListView(
              reverse: true,
              children: messageBubbles,
            )),
            Container(
              decoration: const BoxDecoration(
                border: Border(),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(32),
                              topRight: Radius.circular(32),
                              bottomLeft: Radius.circular(32),
                              bottomRight: Radius.circular(32)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              // spreadRadius: 5,
                              blurRadius: 7,
                              offset: const Offset(
                                  2, 2), // changes position of shadow
                            ),
                          ],
                        ),
                        child: TextField(
                          // controller: messageTextController,
                          onChanged: (value) {
                            // messageText = value;
                          },
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 20.0),
                            hintText: 'Type your message here...',
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF247D7C),
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(32),
                              topRight: Radius.circular(32),
                              bottomLeft: Radius.circular(32),
                              bottomRight: Radius.circular(32)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              blurRadius: 7,
                              offset: const Offset(
                                  2, 2), // changes position of shadow
                            ),
                          ],
                        ),
                        // color: Color(0xFF247D7C),
                        child: Center(
                          child: IconButton(
                            iconSize: 20,
                            icon: const Icon(Icons.send),
                            color: Colors.white,
                            // tooltip: 'Show Snackbar',
                            onPressed: () {
                              // Navigator.pushNamed(context, SearchPage.id);
                            },
                          ),
                        )),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageBubble extends StatelessWidget {
  const MessageBubble(
      {Key? key, required this.sender, required this.text, required this.isMe})
      : super(key: key);
  final String sender;
  final String text;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find();

    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          isMe
              ? const Text(
                  "20:30",
                  style: TextStyle(
                    fontSize: 12.0,
                    color: Colors.white,
                  ),
                )
              : const Padding(
                  padding: EdgeInsets.only(left: 50.0),
                  child: Text(
                    "20:29",
                    style: TextStyle(
                      fontSize: 12.0,
                      color: Colors.white,
                    ),
                  ),
                ),
          isMe
              ? Material(
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20.0),
                      bottomLeft: Radius.circular(20.0),
                      bottomRight: Radius.circular(20.0)),
                  elevation: 2.0,
                  color: const Color(0xFFDEFFF3),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 15.0, horizontal: 20.0),
                    child: Text(
                      text,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 15.0,
                      ),
                    ),
                  ),
                )
              : Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0, bottom: 25),
                      child: CachedNetworkImage(
                        imageUrl: authController.user[0].userImageUrl,
                        imageBuilder: (context, imageProvider) => Container(
                          height: 30,
                          width: 30,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(60)),
                            image: DecorationImage(
                              image: imageProvider,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        placeholder: (context, url) =>
                            CircularProgressIndicator(),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      ),
                    ),
                    Expanded(
                      child: Material(
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(20.0),
                          bottomRight: Radius.circular(20.0),
                          topRight: Radius.circular(20.0),
                        ),
                        elevation: 2.0,
                        color: const Color(0xFF409D7C),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 15.0, horizontal: 20.0),
                          child: Text(
                            text,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
        ],
      ),
    );
  }
}
