import 'dart:convert';
import 'package:chewie/chewie.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

class MyNetworkModel extends Equatable {
  final String userId;
  final String userImageUrl;
  final ChewieController videoUrl;
  final String videoImageUrl;
  final String videoUrlString;
  final String username;
  final String videoId;

  const MyNetworkModel({
    required this.userId,
    required this.videoUrl,
    required this.videoImageUrl,
    required this.videoUrlString,
    required this.userImageUrl,
    required this.username,
    required this.videoId,
  });

  @override
  List<Object?> get props => [
        userId,
        videoUrl,
        videoImageUrl,
        videoUrlString,
        userImageUrl,
        username,
        videoId,
      ];

  // static List<MyNetworkModel> mynetworkList = [
  //   MyNetworkModel(
  //       userId: '1',
  //       userImageUrl:
  //           'https://firebasestorage.googleapis.com/v0/b/myvcv-c7726.appspot.com/o/WhatsApp%20Image%202021-07-27%20at%2010.42.24%20AM.jpeg?alt=media&token=4c0a5d02-2000-4533-9d1e-3ee99241d93f',
  //       videoImageUrl:
  //           'https://firebasestorage.googleapis.com/v0/b/myvcv-c7726.appspot.com/o/video-marketing-statistics-artwork-section2-1280x717.57575757576-c-default.jpg?alt=media&token=cdfc19c2-e6b0-4a4c-a9f8-1a5f9e3c8ff5',
  //       videoUrl:
  //           'https://firebasestorage.googleapis.com/v0/b/myvcv-c7726.appspot.com/o/Video%20CV.mov?alt=media&token=5a86770c-57b2-4464-88e1-ca8a348c7dbb',
  //       username: 'Saleh Abbas')
  // ];

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'userImageUrl': userImageUrl,
      'videoUrl': videoUrl,
      'videoImageUrl': videoImageUrl,
      'videoUrlString': videoUrlString,
      'username': username,
      'videoId': videoId,
    };
  }

  Future<List<MyNetworkModel>> pitchYourselfVideoUrlToMap(List list) async {
    List<MyNetworkModel> profileList = [];
    for (var videoId in list) {
      try {
        await FirebaseFirestore.instance
            .collection('profile_video')
            .doc(videoId)
            .get()
            .then((DocumentSnapshot skillsDocSnapshot) async {
          if (skillsDocSnapshot.exists) {
            if (skillsDocSnapshot.data() != null) {
              Map<String, dynamic> videoData =
                  skillsDocSnapshot.data()! as Map<String, dynamic>;
              await FirebaseFirestore.instance
                  .collection('users')
                  .doc(videoData['userId'])
                  .get()
                  .then((DocumentSnapshot userDocSnapshot) async {
                if (userDocSnapshot.exists) {
                  if (userDocSnapshot.data() != null) {
                    Map<String, dynamic> userData =
                        userDocSnapshot.data()! as Map<String, dynamic>;
                    VideoPlayerController videoController =
                        VideoPlayerController.network(videoData['videoUrl']);
                    await videoController.initialize();
                    profileList.add(MyNetworkModel(
                        userId: videoData['userId'],
                        videoUrl: ChewieController(
                            videoPlayerController: videoController),
                        videoImageUrl: videoData['videoImageUrl'],
                        videoUrlString: videoData['videoUrl'],
                        userImageUrl: userData['userImageUrl'],
                        username: userData['username'],
                        videoId: videoId));
                  }
                }
              });
            }
            // HomeModel(
            //     videoUrl: ChewieController(
            //         videoPlayerController: videoController),
            //     videoUrlString: videoData['videoUrl'],
            //     videoId: profileId,
            //     videoDesc: videoData['videoDesc'],
            //     videoImageUrl: videoData['videoImageUrl'],
            //     userImageUrl: userData['userImageUrl'],
            //     uploadedTime: videoData['createdOn'],
            //     videoLike: videoData['videoLike'] as List,
            //     username: userData['username']),
          } else {
            print('Document does not exist on the database');
          }
        });
      } on FirebaseException catch (e) {
        print(e);
      } on PlatformException catch (e) {
        print(e);
      } catch (e) {
        print(e);
      }
    }
    return profileList;
  }

  factory MyNetworkModel.fromMap(Map<String, dynamic> map) {
    return MyNetworkModel(
      userId: map['userId'] ?? '',
      userImageUrl: map['userImageUrl'] ?? '',
      videoUrl: map['videoUrl'] as ChewieController,
      videoImageUrl: map['videoImageUrl'] ?? '',
      videoUrlString: map['videoUrlString'] ?? '',
      username: map['username'] ?? '',
      videoId: map['videoId'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory MyNetworkModel.fromJson(String source) =>
      MyNetworkModel.fromMap(json.decode(source));
}
