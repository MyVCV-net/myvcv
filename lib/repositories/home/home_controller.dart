import 'package:chewie/chewie.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:myvcv/models/models.dart';
import 'package:myvcv/repositories/auth/auth_controller.dart';
import 'package:video_player/video_player.dart';
import 'package:timeago/timeago.dart' as timeago;

class HomeController extends GetxController {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final homeLoading = false.obs;
  List<HomeModel> home = <HomeModel>[].obs;
  ChewieController? chewieController;
  @override
  void onInit() async {
    super.onInit();
    await getLimitData();
    // if (home.isEmpty) {
    //   if (GetStorage().hasData('home')) {
    //     var decoded = json.decode(GetStorage().read('home'));
    //     for (var item in decoded) {
    //       iniPlayer(
    //         link: item['videoUrlString'] ?? '',
    //         videoDesc: item['videoDesc'] ?? '',
    //         userImageUrl: item['userImageUrl'] ?? '',
    //         uploadedTime: item['uploadedTime'] ?? '',
    //         videoLike: item['videoLike'] ?? '',
    //         username: item['username'] ?? '',
    //         videoId: item['videoId'] ?? '',
    //       );
    //     }
    //     homeLoading.value = true;
    //     update();
    //     streemChanges();
    //   } else {
    //     await getLimitData();
    //     streemChanges();
    //   }
    // }
  }

  @override
  void onClose() {
    super.onClose();
  }
  // streemChanges() async {
  //   for (var xxx in home) {
  //     print(xxx.videoId);
  //     Stream documentStream = FirebaseFirestore.instance
  //         .collection('skills_video')
  //         .doc(xxx.videoId)
  //         .snapshots();
  //     documentStream.listen((event) async {
  //       Map<String, dynamic> newData = event.data() as Map<String, dynamic>;
  //       print(newData['createdOn']);
  //       GetStorage().write('home', null);
  //     });
  //   }
  // }

  addUserToLikeList({required String videoId, required String userId}) async {
    Iterable<HomeModel> contain =
        home.where((element) => element.videoId == videoId);
    if (contain.isNotEmpty) {
      // contain.first.videoLike.add(userId);
      if (contain.first.videoLike.contains(userId)) {
        contain.first.videoLike.remove(userId);
        await FirebaseFirestore.instance
            .collection('skills_video')
            .doc(videoId)
            .update(
          {
            'videoLike': FieldValue.arrayRemove([userId])
          },
        );
      } else {
        contain.first.videoLike.add(userId);
        await FirebaseFirestore.instance
            .collection('skills_video')
            .doc(videoId)
            .update(
          {
            'videoLike': FieldValue.arrayUnion([userId])
          },
        );
      }
    }
    update();
  }

  getLimitData() async {
    print('in');
    AuthController authController = Get.put(AuthController());
    await _firebaseFirestore
        .collection('skills_video')
        // .limit(10)
        .where("userId", isNotEqualTo: authController.id)
        .get()
        .then((value) async {
      home.clear();
      for (var doc in value.docs) {
        // print(doc);
        await FirebaseFirestore.instance
            .collection('users')
            .doc(doc['userId'])
            .get()
            .then((DocumentSnapshot documentSnapshot) async {
          if (documentSnapshot.exists) {
            Map<String, dynamic> userData =
                documentSnapshot.data()! as Map<String, dynamic>;
            final fifteenAgo =
                DateTime.now().difference(doc['createdOn'].toDate());
            // print(doc['videoUrl']);
            await iniPlayer(
              link: doc['videoUrl'],
              videoId: doc.id,
              videoDesc: doc['videoDesc'],
              videoImageUrl: doc['videoImageUrl'],
              userImageUrl: userData['userImageUrl'],
              uploadedTime: timeago
                  .format(DateTime.now().subtract(fifteenAgo))
                  .toString(),
              videoLike: doc['videoLike'] as List,
              username: userData['username'],
              userId: doc['userId'],
            );
          }
        });
      }
      homeLoading.value = true;
    });
    homeLoading.value = true;
    update();
    // print(home);
    // print(jsonEncode(home));
  }

  Future<void> iniPlayer({
    required String link,
    required String videoId,
    required String videoDesc,
    required String videoImageUrl,
    required String userImageUrl,
    required String uploadedTime,
    required List videoLike,
    required String username,
    required String userId,
  }) async {
    // print(link);
    try {
      late VideoPlayerController videoPlayerController;
      videoPlayerController = VideoPlayerController.network(link);
      try {
        await Future.wait([videoPlayerController.initialize()]);
      } on PlatformException catch (err) {
        Get.snackbar("Error PlatformException", err.message.toString());
        homeLoading.value = true;
        update();
      } catch (err) {
        Get.snackbar("Catch Error", err.toString());
        homeLoading.value = true;
        update();
      }
      chewieController = ChewieController(
        videoPlayerController: videoPlayerController,
        autoInitialize: true,
        looping: true,
      );
      home.add(HomeModel(
        videoUrl: chewieController!,
        videoUrlString: link,
        videoId: videoId,
        videoDesc: videoDesc,
        videoImageUrl: videoImageUrl,
        userImageUrl: userImageUrl,
        uploadedTime: uploadedTime,
        videoLike: videoLike,
        username: username,
        userId: userId,
      ));
      homeLoading.value = true;
      update();
    } on PlatformException catch (err) {
      Get.snackbar("Error PlatformException", err.message.toString());
      homeLoading.value = true;
      update();
    } catch (err) {
      Get.snackbar("Catch Error", err.toString());
      homeLoading.value = true;
      update();
    }
  }

  // @override
  // void onClose() {
  //   super.onClose();
  //   chewieController!.dispose();
  // }

}
