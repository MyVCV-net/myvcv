import 'package:chewie/chewie.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:myvcv/models/mynetwork/mynetwork_model.dart';
import 'package:myvcv/repositories/auth/auth_controller.dart';
import 'package:video_player/video_player.dart';

class MynetworkController extends GetxController {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final companyLoading = false.obs;
  final profilesLoading = false.obs;
  List<MyNetworkModel> mynetworkCompanies = <MyNetworkModel>[].obs;
  List<MyNetworkModel> mynetworkProfiles = <MyNetworkModel>[].obs;

  ChewieController? chewieController;
  @override
  void onInit() async {
    super.onInit();
    //Change value to name2
    //   if (mynetworkCompanies.isEmpty) {
    //   if (GetStorage().hasData('company')) {
    //     var decoded = json.decode(GetStorage().read('company'));
    //     for (var item in decoded) {
    //    iniPlayer(link: item[''], videoId: videoId, userId: userId, videoImageUrl: videoImageUrl, userImageUrl: userImageUrl, username: username, isCompany: isCompany);

    //     }
    //     companyLoading.value = true;
    //     update();
    //   } else {
    //      getLimitDataCompanies();
    //   }
    // }
    await getLimitDataCompanies();
    await getLimitDataProfiles();
    // if (GetStorage().hasData('profile')) {
    //   mynetworkProfiles
    //       .add(MyNetworkModel.fromJson(GetStorage().read('profile')));
    // } else {
    //   getLimitDataProfiles();
    // }
  }

  Future<void> getLimitDataCompanies() async {
    var auth = Get.put(AuthController());
    try {
      await _firebaseFirestore
          .collection('profile_video')
          .get()
          .then((value) async {
        for (var doc in value.docs) {
          if (!auth.following.contains(doc['userId']) &&
              doc['userId'] != auth.user[0].id) {
            await _firebaseFirestore
                .collection('users')
                .doc(doc['userId'])
                .get()
                .then((userValue) async {
              if (userValue.data() != null) {
                var userData = userValue.data() as Map<String, dynamic>;
                if (!userData['isJobSeeker']) {
                  await iniPlayer(
                      link: doc['videoUrl'],
                      videoId: doc.id,
                      userId: userData['id'],
                      videoImageUrl: doc['videoImageUrl'],
                      userImageUrl: userData['userImageUrl'],
                      username: userData['username'],
                      isCompany: true);
                  companyLoading.value = true;
                  update();
                }
              }
            });
          }
        }
      });
      companyLoading.value = true;
      update();
    } on FirebaseAuthException catch (e) {
      Get.snackbar('Error', e.toString());
      companyLoading.value = true;
      update();
    } on PlatformException catch (e) {
      Get.snackbar('Error', e.toString());
      companyLoading.value = true;
      update();
    } catch (e) {
      Get.snackbar('Error', e.toString());
      companyLoading.value = true;
      update();
    }
  }

  Future<void> getLimitDataProfiles() async {
    var auth = Get.put(AuthController());
    try {
      await _firebaseFirestore
          .collection('profile_video')
          .get()
          .then((value) async {
        for (var doc in value.docs) {
          if (!auth.following.contains(doc['userId']) &&
              doc['userId'] != auth.user[0].id) {
            await _firebaseFirestore
                .collection('users')
                .doc(doc['userId'])
                .get()
                .then((userValue) async {
              if (userValue.data() != null) {
                var userData = userValue.data() as Map<String, dynamic>;
                if (userData['isJobSeeker']) {
                  print(doc['videoUrl']);
                  await iniPlayer(
                      link: doc['videoUrl'],
                      videoId: doc.id,
                      userId: userData['id'],
                      videoImageUrl: doc['videoImageUrl'],
                      userImageUrl: userData['userImageUrl'],
                      username: userData['username'],
                      isCompany: false);
                  profilesLoading.value = true;
                  update();
                }
              }
            });
          }
        }
      });
      profilesLoading.value = true;
      update();
    } on FirebaseAuthException catch (e) {
      Get.snackbar('Error', e.toString());
      profilesLoading.value = true;
      update();
    } on PlatformException catch (e) {
      Get.snackbar('Error', e.toString());
      profilesLoading.value = true;
      update();
    } catch (e) {
      Get.snackbar('Error', e.toString());
      profilesLoading.value = true;
      update();
    }
  }

  Future<void> iniPlayer(
      {required String link,
      required String videoId,
      required String userId,
      required String videoImageUrl,
      required String userImageUrl,
      required String username,
      required bool isCompany}) async {
    late VideoPlayerController videoPlayerController;
    videoPlayerController = VideoPlayerController.network(link);
    await Future.wait([videoPlayerController.initialize()]);
    chewieController =
        ChewieController(videoPlayerController: videoPlayerController);
    if (isCompany) {
      mynetworkCompanies.add(MyNetworkModel(
          userId: userId,
          videoUrl: chewieController!,
          videoImageUrl: videoImageUrl,
          videoUrlString: link,
          userImageUrl: userImageUrl,
          username: username,
          videoId: videoId));
      companyLoading.value = true;
    } else {
      mynetworkProfiles.add(MyNetworkModel(
          userId: userId,
          videoUrl: chewieController!,
          videoImageUrl: videoImageUrl,
          videoUrlString: link,
          userImageUrl: userImageUrl,
          username: username,
          videoId: videoId));
      profilesLoading.value = true;
    }

    // GetStorage().write('company', mynetworkCompanies);
    // GetStorage().write('profile', mynetworkProfiles);
    update();
  }
}
