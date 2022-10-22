import 'dart:io';
import 'dart:typed_data';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chewie/chewie.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myvcv/repositories/auth/auth_controller.dart';
import 'package:myvcv/repositories/firebase_controller.dart';
import 'package:myvcv/widget/widgets.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:video_player/video_player.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import '../screens.dart';

class MyProfilePage extends StatefulWidget {
  static const String routeName = '/MyProfilePage';

  static Route route() {
    return MaterialPageRoute(
      settings: RouteSettings(name: routeName),
      builder: (_) => MyProfilePage(),
    );
  }

  const MyProfilePage({Key? key}) : super(key: key);

  @override
  _MyProfilePageState createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage> {
  TextEditingController contactType = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController contact = TextEditingController();
  TextEditingController fileName = TextEditingController();
  FilePickerResult? result;
  File? uploadedFile;
  UploadTask? task;
  var contantValue;
  var fileExt;

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.put(AuthController());
    final FirebaseController firebaseController = Get.put(FirebaseController());
    return Scaffold(
      appBar: CustomAppBar(
        title: authController.username,
        searchIcon: false,
        chatIcon: false,
        profileIcon: true,
      ),
      body: ListView(
        children: [
          //User Image
          Obx(
            () => Center(
              child: authController.user[0].userImageUrl != '' ||
                      authController.user[0].userImageUrl.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: authController.userImageUrl,
                      imageBuilder: (context, imageProvider) => Container(
                        height: 120,
                        width: 120,
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
                      errorWidget: (context, url, error) => Image.asset(
                        'assets/account.png',
                        height: 120,
                        width: 120,
                      ),
                    )
                  : Image.asset(
                      'assets/account.png',
                      height: 120,
                      width: 120,
                    ),
            ),
          ),
          //User Username
          Center(
              child: Obx(
            () => Text(authController.username,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          )),
          //User Major
          InkWell(
            onTap: () => Get.to(EditProfile()),
            child: Center(
                child: Obx(
              () => Text(
                  authController.major != ''
                      ? authController.major
                      : 'Add Major',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: authController.major != ''
                          ? Colors.white
                          : Colors.blue)),
            )),
          ),
          //User Info
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 70, vertical: 20),
            child: Center(
                child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Text("Skills"),
                    Obx(() => Text("${authController.skillsNumber}"))
                  ],
                ),
                const Spacer(),
                Column(
                  children: [
                    Text("Followers"),
                    Obx(() => Text('${authController.followerNumber}'))
                  ],
                ),
                const Spacer(),
                Column(
                  children: [
                    Text("Following"),
                    Obx(() => Text("${authController.followingNumber}"))
                  ],
                )
              ],
            )),
          ),
          Divider(),
          //Pitch Yourself
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 20),
            child: Row(
              children: [
                Text(
                  "Pitch Yourself",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                ),
                Spacer(),
                Obx(
                  () => authController.user[0].pitchYourselfVideoUrl.isEmpty
                      ? InkWell(
                          child: Icon(Icons.add),
                          onTap: () async {
                            await uploadPitchYourself(
                                context, firebaseController);
                          },
                        )
                      : InkWell(
                          child: Icon(
                            Icons.remove_circle,
                          ),
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (_) => CupertinoAlertDialog(
                                title: Text('Are you sure ?'),
                                actions: [
                                  CupertinoDialogAction(
                                    child: Text("Yes"),
                                    onPressed: () async {
                                      Get.back();
                                      EasyLoading.show(
                                        status: 'loading...',
                                        maskType: EasyLoadingMaskType.black,
                                      );
                                      firebaseController.removePicthYourSelf(
                                          authController.user[0]
                                              .pitchYourselfVideoUrl[0].url);
                                      EasyLoading.dismiss();
                                    },
                                  ),
                                  CupertinoDialogAction(
                                    child: Text("No"),
                                    onPressed: () {
                                      Get.back();
                                    },
                                  )
                                ],
                              ),
                            );
                          },
                        ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Obx(
              () => authController.user[0].pitchYourselfVideoUrl.isNotEmpty
                  ? InkWell(
                      onTap: () async {
                        EasyLoading.show(
                          // status: 'loading...',
                          maskType: EasyLoadingMaskType.black,
                        );
                        VideoPlayerController xx =
                            VideoPlayerController.network(authController
                                .user[0].pitchYourselfVideoUrl[0].url);
                        await xx.initialize();
                        EasyLoading.dismiss();
                        Get.to(VideoPagePlayer(
                          chewieController:
                              ChewieController(videoPlayerController: xx),
                          username: authController.username,
                        ));
                      },
                      child: Stack(
                        children: [
                          Container(
                              height: 200,
                              width: Get.width,
                              margin: const EdgeInsets.all(2),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: CachedNetworkImage(
                                  imageUrl: authController.user[0]
                                      .pitchYourselfVideoUrl[0].videoImageUrl,
                                  imageBuilder: (context, imageProvider) =>
                                      Image(
                                          image: imageProvider,
                                          fit: BoxFit.cover),
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
                              width: Get.width,
                              child: Center(
                                child: CircleAvatar(
                                  backgroundColor: Colors.black,
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
                    )
                  : InkWell(
                      onTap: () async {
                        await uploadPitchYourself(context, firebaseController);
                      },
                      child: SizedBox(
                        height: 180,
                        child: Card(
                            child: Center(
                          child: Text('Add Pitch Yourself'),
                        )),
                      ),
                    ),
            ),
          ),
          //Skills & works
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 20),
            child: Row(
              children: [
                Text(
                  "Skills & works",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                ),
                Spacer(),
                InkWell(
                  child: Icon(Icons.add_circle),
                  onTap: () {
                    Get.to(UploadSkillsVideo());
                  },
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: SizedBox(
              height: 280,
              child: Obx(
                () => authController.user[0].skillsUrl.isEmpty
                    ? InkWell(
                        onTap: () {
                          Get.to(UploadSkillsVideo());
                        },
                        child: Card(
                            child: Center(child: Text(' Add Your Skills'))))
                    : GridView.count(
                        crossAxisCount: 3,
                        crossAxisSpacing: 10.0,
                        mainAxisSpacing: 10.0,
                        shrinkWrap: true,
                        children: List.generate(
                            authController.user[0].skillsUrl.length, (index) {
                          return InkWell(
                              onTap: () async {
                                EasyLoading.show(
                                  // status: 'loading...',
                                  maskType: EasyLoadingMaskType.black,
                                );
                                VideoPlayerController xx =
                                    VideoPlayerController.network(authController
                                        .user[0].skillsUrl[index].url);
                                await xx.initialize();
                                EasyLoading.dismiss();
                                Get.to(VideoPagePlayer(
                                  chewieController: ChewieController(
                                      videoPlayerController: xx),
                                  username: authController.username,
                                ));
                              },
                              child: Stack(
                                children: [
                                  Stack(
                                    children: [
                                      Container(
                                          height: 200,
                                          width: 150,
                                          margin: const EdgeInsets.all(2),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            child: CachedNetworkImage(
                                              imageUrl: authController
                                                  .user[0]
                                                  .skillsUrl[index]
                                                  .videoImageUrl,
                                              imageBuilder:
                                                  (context, imageProvider) =>
                                                      Image(
                                                          image: imageProvider,
                                                          fit: BoxFit.cover),
                                              placeholder: (context, url) => Center(
                                                  child: SizedBox(
                                                      width: 30,
                                                      child:
                                                          CircularProgressIndicator())),
                                              errorWidget:
                                                  (context, url, error) =>
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
                                              backgroundColor: Colors.black,
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
                                  Positioned(
                                    right: 0,
                                    child: InkWell(
                                      child: Icon(Icons.remove_circle),
                                      onTap: () async {
                                        showDialog(
                                          context: context,
                                          builder: (_) => CupertinoAlertDialog(
                                            title: Text('Are you sure ?'),
                                            actions: [
                                              CupertinoDialogAction(
                                                child: Text("Yes"),
                                                onPressed: () async {
                                                  Get.back();
                                                  EasyLoading.show(
                                                    status: 'loading...',
                                                    maskType:
                                                        EasyLoadingMaskType
                                                            .black,
                                                  );
                                                  var uploadFileResult =
                                                      await firebaseController
                                                          .deleteSkills(
                                                              url: authController
                                                                  .user[0]
                                                                  .skillsUrl[
                                                                      index]
                                                                  .url);
                                                  if (uploadFileResult) {
                                                    EasyLoading.dismiss();
                                                    Get.snackbar(
                                                        "Remove Skills",
                                                        "Remove Skills Successfully");
                                                    setState(() {});
                                                  } else {
                                                    EasyLoading.dismiss();
                                                    Get.snackbar("Error",
                                                        "Something Wrong");
                                                  }
                                                },
                                              ),
                                              CupertinoDialogAction(
                                                child: Text("No"),
                                                onPressed: () {
                                                  Get.back();
                                                },
                                              )
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  )
                                ],
                              ));
                        })),
              ),
            ),
          ),
          //Other Qualification
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 20),
            child: Row(children: [
              Text(
                "Other Qualification",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              ),
              Spacer(),
              InkWell(
                  child: Icon(Icons.cloud_upload),
                  onTap: () async {
                    await uploadFiles(context, firebaseController);
                  })
            ]),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              height: 150,
              child: Obx(
                () => authController.user[0].qualificationDocumentUrl.isEmpty
                    ? InkWell(
                        onTap: () async {
                          await uploadFiles(context, firebaseController);
                        },
                        child: Card(
                          elevation: 10,
                          child: Center(
                            child: Text("Add Your Docs"),
                          ),
                        ),
                      )
                    : QualificationBuilder(
                        authController: authController,
                        firebaseController: firebaseController,
                      ),
              ),
            ),
          ),
          //Contact Info
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 20),
            child: Row(
              children: [
                Text(
                  "Contact Info",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                ),
                Spacer(),
                InkWell(
                    child: Icon(Icons.add_circle),
                    onTap: () async {
                      await uploadContactInfo(
                          context, authController, firebaseController);
                    })
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
                elevation: 10,
                child: Obx(
                  () => authController.user[0].contactInfoData.isEmpty
                      ? InkWell(
                          onTap: () async {
                            await uploadContactInfo(
                                context, authController, firebaseController);
                          },
                          child: SizedBox(
                              height: 100,
                              child: Center(child: Text("Add Your Contact"))),
                        )
                      : ContantInfoBuilder(
                          authController: authController,
                          firebaseController: firebaseController,
                        ),
                )),
          ),
        ],
      ),
    );
  }

//Methods
  uploadPitchYourself(
      BuildContext context, FirebaseController firebaseController) async {
    showDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: Text('Pitch YourSelf'),
        content: StatefulBuilder(
          builder: (context, setState) => Column(
            children: [
              SizedBox(
                  width: MediaQuery.of(context).size.width * .5,
                  child: ElevatedButton(
                    child: const Text("Pick Video"),
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            const Color(0xFFD0AB37)),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                        ))),
                    onPressed: () async {
                      final picker = ImagePicker();
                      var pickedFile = await picker.pickVideo(
                          source: ImageSource.gallery,
                          maxDuration: Duration(seconds: 20));
                      if (pickedFile == null) {
                        return;
                      }
                      VideoPlayerController testLengthController =
                          VideoPlayerController.file(
                              File(pickedFile.path)); //Your file here
                      await testLengthController.initialize();
                      if (testLengthController.value.duration.inSeconds > 30) {
                        pickedFile = null;
                        Get.snackbar("Duration", "Max Duration is 30s");
                      } else {
                        Uint8List? uint8list =
                            await VideoThumbnail.thumbnailData(
                          video: pickedFile.path,
                          imageFormat: ImageFormat.JPEG,
                          quality: 25,
                        );
                        if (pickedFile != null) {
                          Get.back();
                          EasyLoading.show(
                            status: 'loading...',
                            maskType: EasyLoadingMaskType.black,
                          );
                          var uploadFileResult = await firebaseController
                              .uploadPicthYourSelf(pickedFile, uint8list!);
                          if (uploadFileResult) {
                            pickedFile = null;
                            EasyLoading.dismiss();
                            Get.snackbar("Added Video", "Added Successfully");
                          } else {
                            EasyLoading.dismiss();
                            Get.snackbar("Error", "Something Wrong");
                          }
                        }
                      }
                      testLengthController.dispose();
                    },
                  )),
              SizedBox(
                  width: MediaQuery.of(context).size.width * .5,
                  child: ElevatedButton(
                    child: const Text("Camera"),
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            const Color(0xFFD0AB37)),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                        ))),
                    onPressed: () async {
                      final ImagePicker _picker = ImagePicker();
                      final XFile? video = await _picker.pickVideo(
                          source: ImageSource.camera,
                          maxDuration: const Duration(seconds: 30));
                      Uint8List? uint8list = await VideoThumbnail.thumbnailData(
                        video: video!.path,
                        imageFormat: ImageFormat.JPEG,
                        quality: 25,
                      );
                      if (video != null) {
                        Get.back();
                        EasyLoading.show(
                          status: 'loading...',
                          maskType: EasyLoadingMaskType.black,
                        );
                        var uploadFileResult = await firebaseController
                            .uploadPicthYourSelf(video, uint8list!);
                        if (uploadFileResult) {
                          // video = null;
                          EasyLoading.dismiss();
                          Get.snackbar("Added Video", "Added Successfully");
                        } else {
                          EasyLoading.dismiss();
                          Get.snackbar("Error", "Something Wrong");
                        }
                      }
                    },
                  )),
            ],
          ),
        ),
      ),
    );
  }

  uploadContactInfo(BuildContext context, AuthController authController,
      FirebaseController firebaseController) async {
    showDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: Text('Contant Information'),
        content: StatefulBuilder(
          builder: (context, setState) => Center(
            child: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    DropdownButton(
                      value: contantValue,
                      items: const [
                        DropdownMenuItem(
                            value: 'facebook', child: Text("Facebook")),
                        DropdownMenuItem(value: 'email', child: Text("Email")),
                        DropdownMenuItem(value: 'phone', child: Text("Phone")),
                        DropdownMenuItem(value: 'skype', child: Text("Skype")),
                        DropdownMenuItem(
                            value: 'twitter', child: Text("Twitter")),
                        DropdownMenuItem(
                            value: 'linkedIn', child: Text("LinkedIn")),
                      ],
                      onChanged: (value) {
                        setState(() {
                          contactType.text = value.toString();
                          contantValue = value;
                        });
                      },
                      hint: const Text("Contact Type"),
                      disabledHint: const Text("Disabled"),
                      elevation: 8,
                      isExpanded: true,
                    ),
                    TextFormField(
                      keyboardType: contantValue == 'phone'
                          ? TextInputType.phone
                          : contantValue == 'email'
                              ? TextInputType.emailAddress
                              : TextInputType.text,
                      controller: contact,
                      validator: (contactValue) => contactValue!.isEmpty
                          ? 'Enter a valid contact'
                          : null,
                      decoration: InputDecoration(
                        labelText: "Contact",
                        fillColor: Colors.white,
                        disabledBorder: InputBorder.none,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        actions: [
          CupertinoDialogAction(
            child: Text("Save"),
            onPressed: () async {
              final form = _formKey.currentState!;
              if (form.validate() && contantValue != null) {
                Get.back();
                EasyLoading.show(
                  status: 'loading...',
                  maskType: EasyLoadingMaskType.black,
                );
                await firebaseController.updateContact(
                    contact.text, contantValue);
                contact.clear();
                contactType.clear();
                contantValue = null;
                EasyLoading.dismiss();
              }
            },
          ),
          CupertinoDialogAction(
            child: Text("Close"),
            onPressed: () {
              contact.clear();
              contactType.clear();
              Get.back();
            },
          )
        ],
      ),
    );
  }

  uploadFiles(
      BuildContext context, FirebaseController firebaseController) async {
    showDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: Text('Your Qualification'),
        content: StatefulBuilder(
          builder: (context, setState) => Column(
            children: [
              result == null
                  ? SizedBox(
                      width: MediaQuery.of(context).size.width * .5,
                      child: ElevatedButton(
                        child: const Text("Select File"),
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                const Color(0xFFD0AB37)),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                            ))),
                        onPressed: () async {
                          result = await FilePicker.platform.pickFiles();
                          if (result != null) {
                            PlatformFile file = result!.files.first;
                            setState(() {
                              fileName.text = file.name;
                              uploadedFile = File(file.path!);
                              fileExt = file.extension;
                            });
                          }
                        },
                      ))
                  : Container(),
              result != null
                  ? Column(
                      children: [
                        Align(
                            alignment: Alignment.centerLeft,
                            child: Text("File Name: ")),
                        Card(
                          child: TextFormField(
                            controller: fileName,
                            decoration: const InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 20.0),
                              // labelText: 'File Name',
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ],
                    )
                  : Container(),
              result != null
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                            width: MediaQuery.of(context).size.width * .2,
                            child: ElevatedButton(
                              child: const Text("Upload"),
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          const Color(0xFFD0AB37)),
                                  shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                  ))),
                              onPressed: () async {
                                Get.back();
                                EasyLoading.show(
                                  status: 'loading...',
                                  maskType: EasyLoadingMaskType.black,
                                );
                                var uploadFileResult = await firebaseController
                                    .uploadToFireStorage(
                                        fileName.text, uploadedFile!, fileExt);

                                if (uploadFileResult) {
                                  result = null;
                                  fileName.clear();
                                  uploadedFile = null;
                                  fileExt = null;
                                  EasyLoading.dismiss();
                                  Get.snackbar(
                                      "Added Documnet", "Added Successfully");
                                } else {
                                  result = null;
                                  fileName.clear();
                                  uploadedFile = null;
                                  fileExt = null;
                                  EasyLoading.dismiss();
                                  Get.snackbar("Error", "Something Wrong");
                                }
                              },
                            )),
                        SizedBox(
                          width: 10,
                        ),
                        SizedBox(
                            width: MediaQuery.of(context).size.width * .2,
                            child: ElevatedButton(
                              child: const Text("Cancel"),
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          const Color(0xFFD0AB37)),
                                  shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                  ))),
                              onPressed: () async {
                                Get.back();
                                result = null;
                                fileName.clear();
                                uploadedFile = null;
                                fileExt = null;
                              },
                            )),
                      ],
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }
}
