import 'package:cached_network_image/cached_network_image.dart';
import 'package:chewie/chewie.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myvcv/repositories/auth/auth_controller.dart';
import 'package:myvcv/screens/screens.dart';
import 'package:myvcv/widget/general/video_page_player.dart';

class VideoImageWidget extends StatefulWidget {
  final String videoImageUrl;
  final String userImageUrl;
  final String username;
  final String userId;
  final String videoId;
  final ChewieController videoUrl;
  const VideoImageWidget(
      {Key? key,
      required this.videoImageUrl,
      required this.userImageUrl,
      required this.username,
      required this.userId,
      required this.videoId,
      required this.videoUrl})
      : super(key: key);

  @override
  State<VideoImageWidget> createState() => _VideoImageWidgetState();
}

class _VideoImageWidgetState extends State<VideoImageWidget> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    var authController = Get.put(AuthController());
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                Get.to(VideoPagePlayer(
                    chewieController: widget.videoUrl,
                    username: widget.username));
              },
              child: Stack(
                children: [
                  Container(
                      height: 200,
                      width: 150,
                      margin: const EdgeInsets.all(2),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: CachedNetworkImage(
                          imageUrl: widget.videoImageUrl,
                          imageBuilder: (context, imageProvider) =>
                              Image(image: imageProvider, fit: BoxFit.cover),
                          placeholder: (context, url) => Center(
                              child: SizedBox(
                                  width: 30,
                                  child: CircularProgressIndicator())),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                        ),
                      )),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Container(
                      color: Colors.black12,
                      height: 200,
                      width: 150,
                      child: Center(
                        child: CircleAvatar(
                          child: Icon(
                            Icons.play_arrow,
                            color: Colors.white,
                            size: 40,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 160,
              child: Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Row(
                        children: [
                          InkWell(
                            onTap: () {
                              Get.to(UserProfile(
                                  userId: widget.userId,
                                  username: widget.username));
                            },
                            child: SizedBox(
                              height: 30,
                              width: 30,
                              child: widget.userImageUrl != ''
                                  ? CachedNetworkImage(
                                      imageUrl: widget.userImageUrl,
                                      imageBuilder: (context, imageProvider) =>
                                          Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(50)),
                                          image: DecorationImage(
                                            image: imageProvider,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      placeholder: (context, url) =>
                                          CircularProgressIndicator(),
                                      errorWidget: (context, url, error) =>
                                          Image.asset(
                                        'assets/account.png',
                                      ),
                                    )
                                  : Image.asset(
                                      'assets/account.png',
                                    ),
                            ),
                          ),
                          SizedBox(
                            width: 2,
                          ),
                          Text(widget.username,
                              overflow: TextOverflow.ellipsis),
                        ],
                      ),
                      GetBuilder<AuthController>(
                        builder: (controller) => !isLoading
                            ? authController.followingVideo(widget.userId)
                                ? InkWell(
                                    onTap: () async {
                                      setState(() {
                                        isLoading = true;
                                      });
                                      authController.user[0].following
                                          .remove(widget.userId);
                                      await FirebaseFirestore.instance
                                          .collection('users')
                                          .doc(authController.user[0].id)
                                          .update(
                                        {
                                          'following': FieldValue.arrayRemove(
                                              [widget.userId]),
                                        },
                                      );
                                      await FirebaseFirestore.instance
                                          .collection('users')
                                          .doc(widget.userId)
                                          .update(
                                        {
                                          'follower': FieldValue.arrayRemove(
                                              [authController.user[0].id]),
                                        },
                                      );
                                      setState(() {
                                        isLoading = false;
                                      });
                                    },
                                    child: SizedBox(
                                      height: 25,
                                      child: CircleAvatar(
                                        backgroundColor:
                                            Theme.of(context).iconTheme.color,
                                        child: Icon(
                                          Icons.done,
                                          color: Theme.of(context).primaryColor,
                                          size: 20,
                                        ),
                                      ),
                                    ),
                                  )
                                : InkWell(
                                    onTap: () async {
                                      setState(() {
                                        isLoading = true;
                                      });
                                      authController.user[0].following
                                          .add(widget.userId);

                                      await FirebaseFirestore.instance
                                          .collection('users')
                                          .doc(authController.user[0].id)
                                          .update(
                                        {
                                          'following': FieldValue.arrayUnion(
                                              [widget.userId])
                                        },
                                      );
                                      await FirebaseFirestore.instance
                                          .collection('users')
                                          .doc(widget.userId)
                                          .update(
                                        {
                                          'follower': FieldValue.arrayUnion(
                                              [authController.user[0].id]),
                                        },
                                      );
                                      setState(() {
                                        isLoading = false;
                                      });
                                    },
                                    child: SizedBox(
                                      height: 25,
                                      child: CircleAvatar(
                                        backgroundColor:
                                            Theme.of(context).iconTheme.color,
                                        child: Icon(
                                          Icons.add,
                                          color: Theme.of(context).primaryColor,
                                          size: 20,
                                        ),
                                      ),
                                    ),
                                  )
                            : SizedBox(
                                height: 25,
                                width: 25,
                                child:
                                    Center(child: CircularProgressIndicator()),
                              ),
                      ),
                    ]),
              ),
            )
          ],
        ),
      ),
    );
  }
}
