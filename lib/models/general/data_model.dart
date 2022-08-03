import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class DataModel extends Equatable {
  final String name;
  final String url;
  final String type;
  final String videoImageUrl;
  final String appDescription;
  final String firebaseId;

  const DataModel(
      {required this.name,
      this.url = '',
      this.type = '',
      this.videoImageUrl = '',
      this.appDescription = '',
      this.firebaseId = ''});

  @override
  List<Object?> get props => [name, url, type, videoImageUrl, appDescription];

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'url': url,
      'type': type,
      'videoImageUrl': videoImageUrl,
      'appDescription': appDescription,
      'firebaseId': firebaseId
    };
  }

  factory DataModel.fromMap(Map<String, dynamic> map) {
    return DataModel(
        name: map['name'] ?? '',
        url: map['url'] ?? '',
        type: map['type'] ?? '',
        videoImageUrl: map['videoImageUrl'] ?? '',
        appDescription: map['appDescription'] ?? '',
        firebaseId: map['firebaseId'] ?? '');
  }

  String toJson() => json.encode(toMap());

  factory DataModel.fromJson(String source) =>
      DataModel.fromMap(json.decode(source));

  Future<List<DataModel>> skillsUrlToMap(List list) async {
    List<DataModel> datamodel = [];
    // print(list);
    for (var skillsId in list) {
      await FirebaseFirestore.instance
          .collection('skills_video')
          .doc(skillsId)
          .get()
          .then((DocumentSnapshot documentSnapshot) async {
        if (documentSnapshot.exists) {
          Map<String, dynamic> videoData =
              documentSnapshot.data()! as Map<String, dynamic>;
          await FirebaseFirestore.instance
              .collection('users')
              .doc(videoData['userId'])
              .get()
              .then((DocumentSnapshot documentSnapshot) async {
            if (documentSnapshot.exists) {
              Map<String, dynamic> userData =
                  documentSnapshot.data()! as Map<String, dynamic>;
              datamodel.add(DataModel(
                  firebaseId: skillsId,
                  url: videoData['videoUrl'],
                  appDescription: videoData['videoDesc'],
                  type: 'skills',
                  videoImageUrl: videoData['videoImageUrl'],
                  name: userData['username']));
            }
          });
        } else {
          print('Document does not exist on the database');
        }
      });
    }
    return datamodel;
  }

  Future<List<DataModel>> pitchYourselfUrlToMap(List list) async {
    List<DataModel> datamodel = [];
    for (var skillsId in list) {
      await FirebaseFirestore.instance
          .collection('profile_video')
          .doc(skillsId)
          .get()
          .then((DocumentSnapshot documentSnapshot) async {
        if (documentSnapshot.exists) {
          Map<String, dynamic> videoData =
              documentSnapshot.data()! as Map<String, dynamic>;
          await FirebaseFirestore.instance
              .collection('users')
              .doc(videoData['userId'])
              .get()
              .then((DocumentSnapshot documentSnapshot) async {
            if (documentSnapshot.exists) {
              Map<String, dynamic> userData =
                  documentSnapshot.data()! as Map<String, dynamic>;
              datamodel.add(DataModel(
                  firebaseId: skillsId,
                  url: videoData['videoUrl'],
                  type: 'profile',
                  videoImageUrl: videoData['videoImageUrl'],
                  name: userData['username']));
            }
          });
        } else {
          print('Document does not exist on the database');
        }
      });
    }
    return datamodel;
  }

  qualificationDocumentUrlToMap(List list) {
    List<DataModel> datamodel = [];
    for (var x in list) {
      datamodel.add(DataModel(name: x['name'], type: x['type'], url: x['url']));
    }
    return datamodel;
  }

  contactInfoDataToMap(List list) {
    List<DataModel> datamodel = [];
    for (var contactDataFromFirebase in list) {
      datamodel.add(DataModel(
          name: contactDataFromFirebase['name'],
          type: contactDataFromFirebase['type']));
    }
    return datamodel;
  }
}
