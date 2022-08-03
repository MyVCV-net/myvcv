import 'package:cached_network_image/cached_network_image.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myvcv/models/models.dart';
import 'package:myvcv/repositories/auth/auth_controller.dart';
import 'package:myvcv/repositories/home/home_controller.dart';
import 'package:myvcv/screens/screens.dart';

class HomeCard extends StatefulWidget {
  const HomeCard({Key? key, required this.home, required this.index})
      : super(key: key);

  final HomeModel home;
  final int index;

  @override
  State<HomeCard> createState() => _HomeCardState();
}

class _HomeCardState extends State<HomeCard> {
  Future<void>? _future;
  bool isLikeIt = false;

  @override
  Widget build(BuildContext context) {
    var authController = Get.put(AuthController());
    var homeController = Get.put(HomeController());
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
          child: FutureBuilder(
              future: _future,
              builder: (context, snapshot) {
                return Center(
                    child: AspectRatio(
                  aspectRatio: 16 / 9,
                  // aspectRatio: home.videoUrl.aspectRatio,
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Chewie(
                        controller: widget.home.videoUrl,
                      )),
                ));
              }),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 1.0, horizontal: 20),
          child: Text(widget.home.videoDesc,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () {
                  widget.home.videoUrl.pause();
                  Get.to(UserProfile(
                      userId: widget.home.userId,
                      username: widget.home.username));
                },
                child: Row(
                  children: [
                    SizedBox(
                      height: 30,
                      width: 30,
                      child: widget.home.userImageUrl != ''
                          ? CachedNetworkImage(
                              imageUrl: widget.home.userImageUrl,
                              imageBuilder: (context, imageProvider) =>
                                  Container(
                                width: 30.0,
                                height: 30.0,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                      image: imageProvider, fit: BoxFit.cover),
                                ),
                              ),
                              placeholder: (context, url) =>
                                  CircularProgressIndicator(),
                              errorWidget: (context, url, error) => Image.asset(
                                'assets/account.png',
                              ),
                            )
                          : Image.asset(
                              'assets/account.png',
                            ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 10, right: 0, top: 0),
                      child: Text(widget.home.username),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 10, right: 0, top: 0),
                      child: Text("."),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 10, right: 0, top: 0),
                      child: Text(widget.home.uploadedTime),
                    )
                  ],
                ),
              ),
              Row(
                children: [
                  GetBuilder<HomeController>(
                      init: HomeController(),
                      builder: (controller) {
                        Iterable<HomeModel> contain = controller.home.where(
                            (element) =>
                                element.videoId == widget.home.videoId);
                        return Text("${contain.first.videoLike.length}");
                      }),
                  InkWell(
                    onTap: () async {
                      homeController.addUserToLikeList(
                        userId: authController.user[0].id,
                        videoId: widget.home.videoId,
                      );
                    },
                    child: Icon(
                      Icons.favorite,
                      color: widget.home.videoLike
                              .contains(authController.user[0].id)
                          ? Colors.red
                          : Theme.of(context).iconTheme.color,
                    ),
                  )
                ],
              )
            ],
          ),
        )
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
    widget.home.videoUrl.pause();
  }
}
