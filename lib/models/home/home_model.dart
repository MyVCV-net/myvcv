import 'dart:convert';
import 'package:chewie/chewie.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

class HomeModel extends Equatable {
  final ChewieController videoUrl;
  final String videoUrlString;
  final String videoId;
  final String videoDesc;
  final String videoImageUrl;
  final String userImageUrl;
  final String uploadedTime;
  final List videoLike;
  final String username;
  final String userId;

  const HomeModel(
      {required this.videoUrl,
      required this.videoUrlString,
      required this.videoId,
      required this.videoDesc,
      required this.videoImageUrl,
      required this.userImageUrl,
      required this.uploadedTime,
      required this.videoLike,
      required this.username,
      required this.userId});
  HomeModel copyWith({
    ChewieController? videoUrl,
    String? videoUrlString,
    String? videoId,
    String? videoDesc,
    String? videoImageUrl,
    String? userImageUrl,
    String? uploadedTime,
    List? videoLike,
    String? username,
    String? userId,
  }) {
    return HomeModel(
        videoUrl: videoUrl ?? this.videoUrl,
        videoUrlString: videoUrlString ?? this.videoUrlString,
        videoId: videoId ?? this.videoId,
        videoDesc: videoDesc ?? this.videoDesc,
        videoImageUrl: videoImageUrl ?? this.videoImageUrl,
        userImageUrl: userImageUrl ?? this.userImageUrl,
        uploadedTime: uploadedTime ?? this.uploadedTime,
        videoLike: videoLike ?? this.videoLike,
        username: username ?? this.username,
        userId: userId ?? this.userId);
  }

  @override
  List<Object?> get props => [
        videoUrl,
        videoUrlString,
        videoId,
        videoDesc,
        videoImageUrl,
        userImageUrl,
        uploadedTime,
        videoLike,
        username,
        userId
      ];

  static HomeModel fromSnapshot(DocumentSnapshot snap) {
    HomeModel home = HomeModel(
      videoUrl: snap['videoUrl'],
      videoUrlString: snap['videoUrlString'],
      videoId: snap['videoId'],
      videoDesc: snap['videoDesc'],
      videoImageUrl: snap['videoImageUrl'],
      userImageUrl: snap['userImageUrl'],
      uploadedTime: snap['uploadedTime'],
      videoLike: snap['videoLike'],
      username: snap['username'],
      userId: snap['userId'],
    );
    return home;
  }

  // static List<Home> home = [
  //   Home(
  //       uploadedTime: '10',
  //       userImageUrl:
  //           'https://firebasestorage.googleapis.com/v0/b/myvcv-c7726.appspot.com/o/WhatsApp%20Image%202021-07-27%20at%2010.42.24%20AM.jpeg?alt=media&token=4c0a5d02-2000-4533-9d1e-3ee99241d93f',
  //       username: 'Saleh Abbas',
  //       videoDesc: 'Saleh Abbas Search on new opportunity',
  //       videoLike: '12',
  //       videoUrl:
  //           'https://firebasestorage.googleapis.com/v0/b/myvcv-c7726.appspot.com/o/iceland_compressed.mp4?alt=media&token=5c2070ed-4340-457e-9342-ed1cf5543500'),
  //   Home(
  //       uploadedTime: '10',
  //       userImageUrl:
  //           'https://firebasestorage.googleapis.com/v0/b/myvcv-c7726.appspot.com/o/WhatsApp%20Image%202021-07-27%20at%2010.42.24%20AM.jpeg?alt=media&token=4c0a5d02-2000-4533-9d1e-3ee99241d93f',
  //       username: 'Ahmad A',
  //       videoDesc: 'Saleh Abbas Search on new opportunity',
  //       videoLike: '12',
  //       videoUrl:
  //           'https://firebasestorage.googleapis.com/v0/b/myvcv-c7726.appspot.com/o/rio_from_above_compressed.mp4?alt=media&token=84885510-61d6-4caa-8d75-0f3209d4216a'),
  //   Home(
  //       uploadedTime: '10',
  //       userImageUrl:
  //           'https://firebasestorage.googleapis.com/v0/b/myvcv-c7726.appspot.com/o/WhatsApp%20Image%202021-07-27%20at%2010.42.24%20AM.jpeg?alt=media&token=4c0a5d02-2000-4533-9d1e-3ee99241d93f',
  //       username: 'Saleh Abbas',
  //       videoDesc: 'Saleh Abbas Search on new opportunity',
  //       videoLike: '12',
  //       videoUrl:
  //           'https://firebasestorage.googleapis.com/v0/b/myvcv-c7726.appspot.com/o/iceland_compressed.mp4?alt=media&token=5c2070ed-4340-457e-9342-ed1cf5543500'),
  //   Home(
  //       uploadedTime: '10',
  //       userImageUrl:
  //           'https://firebasestorage.googleapis.com/v0/b/myvcv-c7726.appspot.com/o/WhatsApp%20Image%202021-07-27%20at%2010.42.24%20AM.jpeg?alt=media&token=4c0a5d02-2000-4533-9d1e-3ee99241d93f',
  //       username: 'Ahmad A',
  //       videoDesc: 'Saleh Abbas Search on new opportunity',
  //       videoLike: '12',
  //       videoUrl:
  //           'https://firebasestorage.googleapis.com/v0/b/myvcv-c7726.appspot.com/o/rio_from_above_compressed.mp4?alt=media&token=84885510-61d6-4caa-8d75-0f3209d4216a'),
  //   Home(
  //       uploadedTime: '10',
  //       userImageUrl:
  //           'https://firebasestorage.googleapis.com/v0/b/myvcv-c7726.appspot.com/o/WhatsApp%20Image%202021-07-27%20at%2010.42.24%20AM.jpeg?alt=media&token=4c0a5d02-2000-4533-9d1e-3ee99241d93f',
  //       username: 'Saleh Abbas',
  //       videoDesc: 'Saleh Abbas Search on new opportunity',
  //       videoLike: '12',
  //       videoUrl:
  //           'https://firebasestorage.googleapis.com/v0/b/myvcv-c7726.appspot.com/o/iceland_compressed.mp4?alt=media&token=5c2070ed-4340-457e-9342-ed1cf5543500'),
  //   Home(
  //       uploadedTime: '10',
  //       userImageUrl:
  //           'https://firebasestorage.googleapis.com/v0/b/myvcv-c7726.appspot.com/o/WhatsApp%20Image%202021-07-27%20at%2010.42.24%20AM.jpeg?alt=media&token=4c0a5d02-2000-4533-9d1e-3ee99241d93f',
  //       username: 'Ahmad A',
  //       videoDesc: 'Saleh Abbas Search on new opportunity',
  //       videoLike: '12',
  //       videoUrl:
  //           'https://firebasestorage.googleapis.com/v0/b/myvcv-c7726.appspot.com/o/rio_from_above_compressed.mp4?alt=media&token=84885510-61d6-4caa-8d75-0f3209d4216a'),
  //   Home(
  //       uploadedTime: '10',
  //       userImageUrl:
  //           'https://firebasestorage.googleapis.com/v0/b/myvcv-c7726.appspot.com/o/WhatsApp%20Image%202021-07-27%20at%2010.42.24%20AM.jpeg?alt=media&token=4c0a5d02-2000-4533-9d1e-3ee99241d93f',
  //       username: 'Saleh Abbas',
  //       videoDesc: 'Saleh Abbas Search on new opportunity',
  //       videoLike: '12',
  //       videoUrl:
  //           'https://firebasestorage.googleapis.com/v0/b/myvcv-c7726.appspot.com/o/iceland_compressed.mp4?alt=media&token=5c2070ed-4340-457e-9342-ed1cf5543500'),
  //   Home(
  //       uploadedTime: '10',
  //       userImageUrl:
  //           'https://firebasestorage.googleapis.com/v0/b/myvcv-c7726.appspot.com/o/WhatsApp%20Image%202021-07-27%20at%2010.42.24%20AM.jpeg?alt=media&token=4c0a5d02-2000-4533-9d1e-3ee99241d93f',
  //       username: 'Ahmad A',
  //       videoDesc: 'Saleh Abbas Search on new opportunity',
  //       videoLike: '12',
  //       videoUrl:
  //           'https://firebasestorage.googleapis.com/v0/b/myvcv-c7726.appspot.com/o/rio_from_above_compressed.mp4?alt=media&token=84885510-61d6-4caa-8d75-0f3209d4216a'),
  // ];

  Map<String, dynamic> toMap() {
    return {
      'videoUrl': videoUrl,
      'videoUrlString': videoUrlString,
      'videoId': videoId,
      'videoDesc': videoDesc,
      'videoImageUrl': videoImageUrl,
      'userImageUrl': userImageUrl,
      'uploadedTime': uploadedTime,
      'videoLike': videoLike,
      'username': username,
      'userId': userId,
    };
  }

  skillsUrlToMap(List list) async {
    List<HomeModel> datamodel = [];
    for (var skillsId in list) {
      try {
        await FirebaseFirestore.instance
            .collection('skills_video')
            .doc(skillsId)
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
                    datamodel.add(
                      HomeModel(
                        videoUrl: ChewieController(
                            videoPlayerController: videoController),
                        videoUrlString: videoData['videoUrl'],
                        videoId: skillsId,
                        videoDesc: videoData['videoDesc'],
                        videoImageUrl: videoData['videoImageUrl'],
                        userImageUrl: userData['userImageUrl'],
                        uploadedTime: videoData['createdOn'].toString(),
                        videoLike: videoData['videoLike'] as List,
                        username: userData['username'],
                        userId: videoData['userId'],
                      ),
                    );
                  }
                }
              });
            }
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
    return datamodel;
  }

  factory HomeModel.fromMap(Map<String, dynamic> map) {
    var videoController = VideoPlayerController.network(map['videoUrlString']);
    videoController.initialize();
    return HomeModel(
      videoUrl: ChewieController(videoPlayerController: videoController),
      videoUrlString: map['videoUrlString'] ?? '',
      videoId: map['videoId'] ?? '',
      videoDesc: map['videoDesc'] ?? '',
      videoImageUrl: map['videoImageUrl'] ?? '',
      userImageUrl: map['userImageUrl'] ?? '',
      uploadedTime: map['uploadedTime'] ?? '',
      videoLike: map['videoLike'] ?? '',
      username: map['username'] ?? '',
      userId: map['userId'] ?? '',
    );
  }

  skillsFromMap(Map<String, dynamic> map) async {
    VideoPlayerController videoController =
        VideoPlayerController.network(map['videoUrlString']);
    await videoController.initialize();
    return HomeModel(
      videoUrl: ChewieController(videoPlayerController: videoController),
      videoUrlString: map['videoUrlString'] ?? '',
      videoId: map['videoId'] ?? '',
      videoDesc: map['videoDesc'] ?? '',
      videoImageUrl: map['videoImageUrl'] ?? '',
      userImageUrl: map['userImageUrl'] ?? '',
      uploadedTime: map['uploadedTime'] ?? '',
      videoLike: map['videoLike'] ?? '',
      username: map['username'] ?? '',
      userId: map['userId'] ?? '',
    );
  }

  Map toJson() => {
        'videoUrl': videoUrl,
        'videoUrlString': videoUrlString,
        'videoId': videoId,
        'videoDesc': videoDesc,
        'videoImageUrl': videoImageUrl,
        'userImageUrl': userImageUrl,
        'uploadedTime': uploadedTime,
        'videoLike': videoLike,
        'username': username,
        'userId': userId,
      };
  factory HomeModel.fromJson(String source) =>
      HomeModel.fromMap(json.decode(source));
}
