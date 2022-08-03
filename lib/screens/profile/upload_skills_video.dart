import 'dart:io';
import 'dart:typed_data';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myvcv/repositories/auth/auth_controller.dart';
import 'package:myvcv/repositories/firebase_controller.dart';
import 'package:myvcv/widget/widgets.dart';
import 'package:video_player/video_player.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class UploadSkillsVideo extends StatefulWidget {
  static const String routeName = '/UploadSkillsVideo';

  static Route route({required userId}) {
    return MaterialPageRoute(
      settings: RouteSettings(name: routeName),
      builder: (_) => UploadSkillsVideo(),
    );
  }

  const UploadSkillsVideo({Key? key}) : super(key: key);

  @override
  _UploadSkillsVideoState createState() => _UploadSkillsVideoState();
}

class _UploadSkillsVideoState extends State<UploadSkillsVideo> {
  TextEditingController videoDescription = TextEditingController();
  final formKey = GlobalKey<FormState>();
  XFile? videoSelectedFile;
  VideoPlayerController? videoController;
  ChewieController? chewieController;
  @override
  Widget build(BuildContext context) {
    final FirebaseController firebaseController = Get.put(FirebaseController());
    final AuthController authController = Get.find();
    return InkWell(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: CustomAppBar(
            title: 'Skills Video',
            chatIcon: false,
            searchIcon: false,
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Form(
                key: formKey,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 5),
                      child: Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            "Video Description",
                            style: TextStyle(fontSize: 18),
                          )),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 1,
                      height: MediaQuery.of(context).size.height * .11,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        child: TextFormField(
                          textAlign: TextAlign.center,
                          maxLength: 75,
                          maxLines: 4,
                          controller: videoDescription,
                          validator: (desc) =>
                              desc == null ? 'Enter a valid Description' : null,
                          onChanged: (value) {
                            setState(() {});
                          },
                          autofillHints: const [AutofillHints.email],
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.fromLTRB(
                                20.0, 10.0, 20.0, 10.0),
                            // hintText: 'Video Description',
                            // labelText: 'Video Description',
                            // labelStyle: TextStyle(fontSize: 30),
                            // prefixIcon: Icon(icons, color: Color(0xFF14917A)),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                              borderSide: const BorderSide(
                                  color: Color(0xFF14917A), width: 1.5),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                              borderSide: const BorderSide(
                                color: Colors.grey,
                                width: 1.5,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                              borderSide: const BorderSide(
                                color: Colors.grey,
                                width: 1.5,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "Add Video (20s)",
                          style: TextStyle(fontSize: 18),
                        )),
                  ),
                  SizedBox(
                      width: Get.width * .9,
                      child: ElevatedButton(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.add_photo_alternate_outlined),
                            SizedBox(
                              width: 5,
                            ),
                            Text("Pick Video"),
                          ],
                        ),
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                const Color(0xFF4dad79)),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ))),
                        onPressed: () async {
                          final picker = ImagePicker();
                          XFile? pickedFile = await picker.pickVideo(
                              source: ImageSource.gallery,
                              maxDuration: Duration(seconds: 20));

                          if (pickedFile != null) {
                            videoController = VideoPlayerController.file(
                                File(pickedFile.path));
                            await videoController!.initialize();

                            if (videoController!.value.duration.inSeconds >
                                20) {
                              videoController = null;
                              pickedFile = null;
                              Get.snackbar("Duration", "Max Duration is 20s");
                            } else {
                              setState(() {
                                chewieController = ChewieController(
                                    videoPlayerController: videoController!);
                                videoSelectedFile = pickedFile;
                              });
                            }
                          }
                        },
                      )),
                  SizedBox(
                      width: Get.width * .9,
                      child: ElevatedButton(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.video_camera_front_rounded),
                            SizedBox(
                              width: 5,
                            ),
                            Text("Camera"),
                          ],
                        ),
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                const Color(0xFF4dad79)),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ))),
                        onPressed: () async {
                          final ImagePicker _picker = ImagePicker();
                          XFile? cameraVideo = await _picker.pickVideo(
                              source: ImageSource.camera,
                              maxDuration: const Duration(seconds: 20));
                          if (cameraVideo != null && cameraVideo.path != '') {
                            videoController = VideoPlayerController.file(
                                File(cameraVideo.path));
                            await videoController!.initialize();
                            setState(() {
                              chewieController = ChewieController(
                                  videoPlayerController: videoController!);
                              videoSelectedFile = cameraVideo;
                            });
                          }
                        },
                      )),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "Preview",
                          style: TextStyle(fontSize: 18),
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        Center(
                            child: Card(
                          child: AspectRatio(
                            aspectRatio: 16 / 9,
                            child: chewieController != null
                                ? videoController!.value.isInitialized
                                    ? ClipRRect(
                                        borderRadius: BorderRadius.circular(15),
                                        child: Chewie(
                                          controller: chewieController!,
                                        ))
                                    : null
                                : Center(
                                    child: Text(
                                      'Preview',
                                      style: TextStyle(fontSize: 20),
                                    ),
                                  ),
                          ),
                        )),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(videoDescription.text,
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                SizedBox(
                                  height: 30,
                                  width: 30,
                                  child: authController.user[0].userImageUrl !=
                                              '' ||
                                          authController
                                              .user[0].userImageUrl.isNotEmpty
                                      ? CachedNetworkImage(
                                          imageUrl: authController.userImageUrl,
                                          imageBuilder:
                                              (context, imageProvider) =>
                                                  Container(
                                                    width: 30.0,
                                                    height: 30.0,
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      image: DecorationImage(
                                                          image: imageProvider,
                                                          fit: BoxFit.cover),
                                                    ),
                                                  ),
                                          placeholder: (context, url) =>
                                              CircularProgressIndicator(),
                                          errorWidget: (context, url, error) =>
                                              Image.asset(
                                                'assets/account.png',
                                              ))
                                      : Image.asset(
                                          'assets/account.png',
                                        ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      left: 10, right: 0, top: 0),
                                  child: Text(authController.username),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      left: 10, right: 0, top: 0),
                                  child: Text("."),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      left: 10, right: 0, top: 0),
                                  child: Text("Now"),
                                )
                              ],
                            ),
                            Row(
                              children: const [
                                Text("0"),
                                Icon(
                                  Icons.favorite,
                                  color: Colors.white,
                                )
                              ],
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                    width: Get.width * .7,
                    child: ElevatedButton(
                        child: const Text("Upload Video"),
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                const Color(0xFFD0AB37)),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                            ))),
                        onPressed: () async {
                          final form = formKey.currentState!;

                          if (videoSelectedFile != null && form.validate()) {
                            Uint8List? uint8list =
                                await VideoThumbnail.thumbnailData(
                              video: videoSelectedFile!.path,
                              imageFormat: ImageFormat.JPEG,
                              quality: 25,
                            );
                            Get.back();
                            EasyLoading.show(
                              status: 'loading...',
                              maskType: EasyLoadingMaskType.black,
                            );
                            var uploadFileResult =
                                await firebaseController.uploadSkillsVideo(
                                    file: videoSelectedFile!,
                                    image: uint8list!,
                                    desc: videoDescription.text,
                                    uid: authController.id);
                            if (uploadFileResult) {
                              EasyLoading.dismiss();
                              Get.snackbar("Added Video", "Added Successfully");
                            } else {
                              EasyLoading.dismiss();
                              Get.snackbar("Error", "Something Wrong");
                            }
                          }
                        })),
              ),
            ],
          )),
    );
  }
}
