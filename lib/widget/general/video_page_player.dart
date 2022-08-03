import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:myvcv/widget/widgets.dart';

class VideoPagePlayer extends StatefulWidget {
  static const String routeName = '/VideoPagePlayer';

  static Route route({required chewieController, required username}) {
    return MaterialPageRoute(
      settings: RouteSettings(name: routeName),
      builder: (_) => VideoPagePlayer(
          chewieController: chewieController, username: username),
    );
  }

  final ChewieController chewieController;
  final String username;

  const VideoPagePlayer(
      {Key? key, required this.chewieController, required this.username})
      : super(key: key);

  @override
  State<VideoPagePlayer> createState() => _VideoPagePlayerState();
}

class _VideoPagePlayerState extends State<VideoPagePlayer> {
  @override
  void dispose() {
    super.dispose();
    widget.chewieController.pause();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: CustomAppBar(
        title: "${widget.username}",
        chatIcon: false,
        searchIcon: false,
        selectedColor: true,
      ),
      body: SafeArea(
        child: Chewie(
          controller: widget.chewieController,
        ),
      ),
    );
  }
}
