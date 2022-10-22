import 'package:cached_network_image/cached_network_image.dart';
import 'package:chewie/chewie.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:myvcv/models/models.dart';
import 'package:myvcv/repositories/auth/auth_controller.dart';
import 'package:myvcv/widget/widgets.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';
import '../screens.dart';

class UserProfile extends StatefulWidget {
  static const String routeName = '/UserProfile';

  static Route route({required userId, required username}) {
    return MaterialPageRoute(
      settings: RouteSettings(name: routeName),
      builder: (_) => UserProfile(
        userId: userId,
        username: username,
      ),
    );
  }

  final userId;
  final username;

  const UserProfile({Key? key, required this.userId, required this.username})
      : super(key: key);

  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  DataModel dataModel = DataModel(name: '');
  var userProfile;
  AdsModel adsModel = AdsModel(
      academicSpecialization: '',
      ageCategory: '',
      appliedUsers: [],
      city: '',
      country: '',
      currency: '',
      endDate: '',
      experianceYears: '',
      firstDescription: '',
      gender: '',
      jobCategory: '',
      jobTitle: '',
      publishDate: '',
      salary: '',
      secondDescription: '',
      userId: '',
      userImageUrl: '',
      username: '',
      userEmail: '',
      createdAt: '');
  NotificationModel notificationModel = NotificationModel(
      imageUrl: '', subtitle: '', time: '', userId: '', username: '');

  TextEditingController recContoller = TextEditingController();
  @override
  void initState() {
    super.initState();
    getProfileData();
  }

  getProfileData() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.userId)
        .get()
        .then((value) async {
      Map<String, dynamic> data = value.data() as Map<String, dynamic>;

      userProfile = UserModel(
        id: data['id'] ?? '',
        username: data['username'] ?? '',
        email: data['email'] ?? '',
        isJobSeeker: data['isJobSeeker'] ?? '',
        userImageUrl: data['userImageUrl'] ?? '',
        major: data['major'] ?? '',
        businessModel: data['businessModel'] ?? '',
        pitchYourselfVideoUrl: await dataModel
            .pitchYourselfUrlToMap(data['pitchYourselfVideoUrl'] as List),
        gender: data['gender'],
        dob: data['dob'],
        city: data['city'],
        country: data['country'],
        token: data['token'] as List,
        skillsUrl: await dataModel.skillsUrlToMap(data['skillsUrl'] as List),
        follower: data['follower'] as List,
        following: data['following'] as List,
        qualificationDocumentUrl: dataModel.qualificationDocumentUrlToMap(
            data['qualificationDocumentUrl'] as List),
        contactInfoData:
            dataModel.contactInfoDataToMap(data['contactInfoData'] as List),
        ads: await adsModel.adsModelToMap(data["ads"] as List),
        notification: await notificationModel
            .notificationModelToMap(data["notification"] as List),
 
      );
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    AuthController authController = Get.put(AuthController());
    print(userProfile);
    return Scaffold(
      appBar: CustomAppBar(
        title: widget.username,
        searchIcon: false,
        chatIcon: false,
        profileIcon: false,
      ),
      body: userProfile != null
          ? ListView(
              children: [
                //User Image
                Center(
                  child: userProfile.userImageUrl != '' ||
                          userProfile.userImageUrl.isNotEmpty
                      ? CachedNetworkImage(
                          imageUrl: userProfile.userImageUrl,
                          imageBuilder: (context, imageProvider) => Container(
                            height: 120,
                            width: 120,
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(60)),
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

                //User Username
                Center(
                  child: Text(userProfile.username,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ),
                //User Major
                InkWell(
                    onTap: () => Get.to(EditProfile()),
                    child: Center(
                      child: Text("${userProfile.major}",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: userProfile.major != ''
                                  ? Colors.white
                                  : Colors.blue)),
                    )),

                //User Info
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 70, vertical: 20),
                  child: Center(
                      child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          Text("Skills"),
                          Text("${userProfile.skillsUrl.length}")
                        ],
                      ),
                      const Spacer(),
                      Column(
                        children: [
                          Text("Followers"),
                          Text('${userProfile.follower.length}')
                        ],
                      ),
                      const Spacer(),
                      Column(
                        children: [
                          Text("Following"),
                          Text("${userProfile.following.length}")
                        ],
                      )
                    ],
                  )),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Obx(
                      () => SizedBox(
                          width: 150,
                          height: 50,
                          child: authController.followingVideo(widget.userId)
                              ? InkWell(
                                  onTap: () async {
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
                                  },
                                  child: Card(
                                      child: Center(child: Text('Unfollow'))))
                              : InkWell(
                                  onTap: () async {
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
                                  },
                                  child: Card(
                                      child: Center(child: Text('Follow'))))),
                    ),
                    InkWell(
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                                  title: Text('Your Recommendation'),
                                  content: TextField(
                                    controller: recContoller,
                                    autofocus: true,
                                    maxLines: 3,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.teal)),
                                    ),
                                  ),
                                  actions: [
                                    TextButton(
                                        onPressed: () async {
                                          if (recContoller.text != '') {
                                            Get.back();
                                            EasyLoading.show(
                                              status: 'loading...',
                                              maskType:
                                                  EasyLoadingMaskType.black,
                                            );
                                            await FirebaseFirestore.instance
                                                .collection(
                                                    'user_recommendation')
                                                .add({
                                              "to_user": userProfile.id,
                                              "from_user": authController.id,
                                              "recommendation":
                                                  recContoller.text,
                                              'createdOn':
                                                  FieldValue.serverTimestamp()
                                            });
                                            recContoller.clear();
                                            EasyLoading.dismiss();
                                            Get.snackbar("Added Successfully",
                                                "Add Recommendation Successfully");
                                          }
                                        },
                                        child: Text('Submit'))
                                  ],
                                ));
                      },
                      child: SizedBox(
                        width: 150,
                        height: 50,
                        child: Card(
                          child: Center(
                            child: Text('Recomandation'),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                Divider(),
                //Pitch Yourself
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 35, vertical: 20),
                  child: Row(
                    children: const [
                      Text(
                        "Pitch Yourself",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: userProfile.pitchYourselfVideoUrl != null &&
                          userProfile.pitchYourselfVideoUrl.isNotEmpty
                      ? InkWell(
                          onTap: () async {
                            EasyLoading.show(
                              // status: 'loading...',
                              maskType: EasyLoadingMaskType.black,
                            );
                            VideoPlayerController xx =
                                VideoPlayerController.network(
                                    userProfile.pitchYourselfVideoUrl[0].url);
                            await xx.initialize();
                            EasyLoading.dismiss();
                            Get.to(VideoPagePlayer(
                              chewieController:
                                  ChewieController(videoPlayerController: xx),
                              username: userProfile.username,
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
                                        imageUrl: userProfile
                                            .pitchYourselfVideoUrl[0]
                                            .videoImageUrl,
                                        imageBuilder:
                                            (context, imageProvider) => Image(
                                                image: imageProvider,
                                                fit: BoxFit.cover),
                                        placeholder: (context, url) => Center(
                                            child: SizedBox(
                                                width: 30,
                                                child:
                                                    CircularProgressIndicator())),
                                        errorWidget: (context, url, error) =>
                                            Icon(Icons.error),
                                      ))),
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
                      : Container(),
                ),

                //Skills & works
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 35, vertical: 20),
                  child: Row(
                    children: const [
                      Text(
                        "Skills & works",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: SizedBox(
                    height: 280,
                    child: GridView.count(
                        crossAxisCount: 3,
                        crossAxisSpacing: 10.0,
                        mainAxisSpacing: 10.0,
                        shrinkWrap: true,
                        children: List.generate(userProfile.skillsUrl.length,
                            (index) {
                          return InkWell(
                              onTap: () async {
                                EasyLoading.show(
                                  // status: 'loading...',
                                  maskType: EasyLoadingMaskType.black,
                                );
                                VideoPlayerController xx =
                                    VideoPlayerController.network(
                                        userProfile.skillsUrl[index].url);
                                await xx.initialize();
                                EasyLoading.dismiss();
                                Get.to(VideoPagePlayer(
                                  chewieController: ChewieController(
                                      videoPlayerController: xx),
                                  username: userProfile.username,
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
                                              imageUrl: userProfile
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
                                ],
                              ));
                        })),
                  ),
                ),
                //Other Qualification
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 35, vertical: 20),
                  child: Row(children: const [
                    Text(
                      "Other Qualification",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                    ),
                  ]),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    height: 150,
                    child: ListView.builder(
                      itemCount: userProfile.qualificationDocumentUrl.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (BuildContext context, int index) => InkWell(
                        onTap: () async {
                          var url =
                              userProfile.qualificationDocumentUrl[index].url;

                          if (await canLaunch(url)) {
                            await launch(
                              url,
                              forceSafariVC: true,
                              forceWebView: true,
                              enableJavaScript: true,
                            );
                          }
                        },
                        child: Card(
                          elevation: 5,
                          child: SizedBox(
                            width: 150,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                userProfile.qualificationDocumentUrl[index]
                                            .type ==
                                        'file'
                                    ? Icon(Icons.content_copy,
                                        size: 60, color: Color(0xFF0C6977))
                                    : Icon(
                                        Icons.image,
                                        size: 60,
                                        color: Color(0xFF0C6977),
                                      ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                      userProfile
                                          .qualificationDocumentUrl[index].name,
                                      overflow: TextOverflow.ellipsis),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                //Contact Info
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 35, vertical: 20),
                  child: Row(
                    children: const [
                      Text(
                        "Contact Info",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      elevation: 10,
                      child: SizedBox(
                        height: 60,
                        child: ListView.builder(
                            itemCount: userProfile.contactInfoData.length,
                            itemBuilder: (BuildContext context, int index) =>
                                ListTile(
                                  leading: Icon(
                                      userProfile.contactInfoData[index].type ==
                                              'phone'
                                          ? Icons.contact_phone
                                          : userProfile.contactInfoData[index]
                                                      .type ==
                                                  'facebook'
                                              ? Icons.facebook
                                              : userProfile
                                                          .contactInfoData[
                                                              index]
                                                          .type ==
                                                      'skype'
                                                  ? MdiIcons.skype
                                                  : userProfile
                                                              .contactInfoData[
                                                                  index]
                                                              .type ==
                                                          'twitter'
                                                      ? MdiIcons.twitter
                                                      : userProfile
                                                                  .contactInfoData[
                                                                      index]
                                                                  .type ==
                                                              'linkedIn'
                                                          ? MdiIcons.linkedin
                                                          : Icons.email,
                                      color: Color(0xFF0C6977),
                                      size: 40),
                                  title: Text(
                                      userProfile.contactInfoData[index].name),
                                )),
                      ),
                    )),
              ],
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
