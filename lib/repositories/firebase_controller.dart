import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myvcv/models/models.dart';
import 'auth/auth_controller.dart';

class FirebaseController extends GetxController {
  final authController = Get.put(AuthController());
  UploadTask? uploadFile({required String dest, required File file}) {
    try {
      final ref = FirebaseStorage.instance.ref(dest);
      return ref.putFile(file);
    } on FirebaseException catch (e) {
      Get.snackbar("Error", e.toString());
      return null;
    } catch (e) {
      print(e);
    }
  }

  Future uploadToFireStorage(
      String fileName, File uploadedFile, String fileExt) async {
    var type = 'file';
    var imageExtension = [
      'JPG',
      'PNG',
      'GIF',
      'WEBP',
      'TIFF',
      'PSD',
      'RAW',
      'BMP',
      'HEIF',
      'INDD',
      'JPEG 2000',
      'SVG',
      'AI',
      'EPS'
    ];
    fileExt = fileExt.toUpperCase();
    if (imageExtension.contains(fileExt)) {
      type = 'image';
    }
    final destination = 'users/${authController.id}/docs/$fileName';
    try {
      final task = uploadFile(dest: destination, file: uploadedFile);
      final snapshot = await task!.whenComplete(() => {});
      final urlDownload = await snapshot.ref.getDownloadURL();
      // print(urlDownload);
      await FirebaseFirestore.instance
          .collection('users')
          .doc(authController.user[0].id)
          .update(
        {
          'qualificationDocumentUrl': FieldValue.arrayUnion([
            {'name': fileName, 'type': type, 'url': urlDownload}
          ])
        },
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  Future deleteFile(
      {required String fileName,
      required bool file,
      required String urlDownload}) async {
    var fileType = 'file';
    if (!file) {
      fileType = 'image';
    }
    // print("FileName: $fileName , FileType: $fileType , url: $urlDownload");
    try {
      FirebaseStorage.instance.refFromURL(urlDownload).delete();
      await FirebaseFirestore.instance
          .collection('users')
          .doc(authController.user[0].id)
          .update(
        {
          'qualificationDocumentUrl': FieldValue.arrayRemove([
            {'name': fileName, 'type': fileType, 'url': urlDownload}
          ])
        },
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  Future uploadPicthYourSelf(XFile file, Uint8List image) async {
    var pitchYourSelfFileName = file.name;
    var pitchYourSelfUploadedFile = File(file.path);
    final videoDestination =
        'users/${authController.id}/pitchYourSelf/$pitchYourSelfFileName';
    try {
      final task =
          uploadFile(dest: videoDestination, file: pitchYourSelfUploadedFile);
      final snapshot = await task!.whenComplete(() => {});
      final urlDownload = await snapshot.ref.getDownloadURL();
      final imageDestination =
          'users/${authController.id}/pitchYourSelf/image/$pitchYourSelfFileName.jpeg';
      final ref = FirebaseStorage.instance.ref(imageDestination);
      var imageUrl = ref.putData(image);
      final imageSnapshot = await imageUrl.whenComplete(() => {});
      final imageUrlDownload = await imageSnapshot.ref.getDownloadURL();
      var insertToProfileFirestore =
          await FirebaseFirestore.instance.collection('profile_video').add({
        "userId": authController.id,
        "videoImageUrl": imageUrlDownload,
        "videoUrl": urlDownload,
        'createdOn': FieldValue.serverTimestamp()
      });
      await FirebaseFirestore.instance
          .collection('users')
          .doc(authController.user[0].id)
          .update(
        {
          'pitchYourselfVideoUrl':
              FieldValue.arrayUnion([insertToProfileFirestore.id])
        },
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  Future removePicthYourSelf(String url) async {
    try {
      // FirebaseStorage.instance.refFromURL(url).delete();
      await FirebaseFirestore.instance
          .collection('profile_video')
          .doc(authController.user[0].pitchYourselfVideoUrl[0].firebaseId)
          .delete();
      await FirebaseFirestore.instance
          .collection('users')
          .doc(authController.user[0].id)
          .update({
        'pitchYourselfVideoUrl': FieldValue.arrayRemove(
            [authController.user[0].pitchYourselfVideoUrl[0].firebaseId]),
      });
      return true;
    } catch (e) {
      return false;
    }
  }

  Future uploadSkillsVideo(
      {required XFile file,
      required Uint8List image,
      required String desc,
      required String uid}) async {
    var skillsFileName = file.name;
    var skillsUploadedFile = File(file.path);
    final videoDestination =
        'users/${authController.id}/skills/$skillsFileName';
    final imageDestination =
        'users/${authController.id}/skills/image/$skillsFileName.jpeg';
    try {
      final task = uploadFile(dest: videoDestination, file: skillsUploadedFile);
      final snapshot = await task!.whenComplete(() => {});
      final urlDownload = await snapshot.ref.getDownloadURL();
      final ref = FirebaseStorage.instance.ref(imageDestination);
      var imageUrl = ref.putData(image);
      final imageSnapshot = await imageUrl.whenComplete(() => {});
      final imageUrlDownload = await imageSnapshot.ref.getDownloadURL();
      var insertToProfileFirestore =
          await FirebaseFirestore.instance.collection('skills_video').add({
        "userId": authController.id,
        "videoDesc": desc,
        "videoLike": [],
        "videoImageUrl": imageUrlDownload,
        "videoUrl": urlDownload,
        'createdOn': FieldValue.serverTimestamp()
      });
      await FirebaseFirestore.instance
          .collection('users')
          .doc(authController.user[0].id)
          .update(
        {
          'skillsUrl': FieldValue.arrayUnion([insertToProfileFirestore.id])
        },
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  Future deleteSkills({required String url}) async {
    // print(url);
    List<DataModel> skillsDelete = authController.user[0].skillsUrl
        .where((element) => element.url == url)
        .toList();
    try {
      FirebaseStorage.instance.refFromURL(url).delete();
      FirebaseStorage.instance
          .refFromURL(skillsDelete[0].videoImageUrl)
          .delete();
      await FirebaseFirestore.instance
          .collection('skills_video')
          .doc(skillsDelete[0].firebaseId)
          .delete();
      await FirebaseFirestore.instance
          .collection('users')
          .doc(authController.user[0].id)
          .update(
        {
          'skillsUrl': FieldValue.arrayRemove([skillsDelete[0].firebaseId])
        },
      );
      authController.user[0].skillsUrl.remove(skillsDelete[0]);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> removeContact(String title, String type) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(authController.user[0].id)
          .update(
        {
          'contactInfoData': FieldValue.arrayRemove([
            {'name': title, 'type': type}
          ])
        },
      );
      Get.snackbar("Remove", "Remove contact successfully");
    } on FirebaseException catch (e) {
      Get.snackbar("Error", e.toString());
    } on PlatformException catch (e) {
      Get.snackbar("Error", e.toString());
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }

  Future<void> updateContact(String title, String type) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(authController.user[0].id)
          .update(
        {
          'contactInfoData': FieldValue.arrayUnion([
            {'name': title, 'type': type}
          ])
        },
      ).then((value) => Get.snackbar(
              "Added successfully", "Added new contact successfully"));
    } on FirebaseException catch (e) {
      Get.snackbar("Error", e.toString());
    } on PlatformException catch (e) {
      Get.snackbar("Error", e.toString());
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }

  Future changeUserProfile(
      {required XFile? imagePath,
      required String username,
      required String major,
      required String gender,
      required String dob,
      required String country,
      required String city}) async {
    try {
      var urlDownload;
      if (imagePath != null && imagePath.path != '') {
        final profileImageDestination =
            'users/${authController.id}/profile/${imagePath.name}';
        final profilePic = uploadFile(
            dest: profileImageDestination, file: File(imagePath.path));
        final snapshot = await profilePic!.whenComplete(() => {});
        urlDownload = await snapshot.ref.getDownloadURL();
      } else {
        urlDownload = authController.userImageUrl;
      }

      await FirebaseFirestore.instance
          .collection('users')
          .doc(authController.user[0].id)
          .update(
        {
          'userImageUrl': urlDownload,
          'username': username,
          'major': major,
          'gender': gender,
          'dob': dob,
          'country': country,
          'city': city
        },
      );
      return true;
    } on FirebaseException catch (e) {
      Get.snackbar("Error", e.toString());
      return false;
    } on PlatformException catch (e) {
      Get.snackbar("Error", e.toString());
      return false;
    } catch (e) {
      Get.snackbar("Error", e.toString());
      return false;
    }
  }

  Future<bool> addAds({
    required String title,
    required String descOne,
    required String descTwo,
    required String jobCategory,
    required String academicSpecialization,
    required String experianceYears,
    required String ageCategory,
    required String gender,
    required String country,
    required String city,
    required String salary,
    required String currency,
    required String firstDate,
    required String lastDate,
  }) async {
    try {
      var insertJobToFirebase =
          await FirebaseFirestore.instance.collection('ads').add({
        'userId': authController.user[0].id,
        'appliedUsers': [],
        'jobTitle': title,
        'firstDescription': descOne,
        'secondDescription': descTwo,
        'jobCategory': jobCategory,
        'academicSpecialization': academicSpecialization,
        'experianceYears': experianceYears,
        'ageCategory': ageCategory,
        'gender': gender,
        'country': country,
        'city': city,
        'salary': salary,
        'currency': currency,
        'publishDate': firstDate,
        'endDate': lastDate,
        'createdAt': FieldValue.serverTimestamp()
      });
      await FirebaseFirestore.instance
          .collection('users')
          .doc(authController.user[0].id)
          .update(
        {
          'ads': FieldValue.arrayUnion([insertJobToFirebase.id])
        },
      );
      return true;
    } on FirebaseException catch (e) {
      print(e);
      return false;
    } on PlatformException catch (e) {
      print(e);
      return false;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> addHelpCenter({required String problem}) async {
    try {
      await FirebaseFirestore.instance
          .collection('help')
          .add({'userId': authController.user[0].id, 'problem': problem});

      return true;
    } on FirebaseException catch (e) {
      print(e);
      return false;
    } on PlatformException catch (e) {
      print(e);
      return false;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> applyAds({required String adsId}) async {
    try {
      var insertAppliedAdsToFirebase =
          await FirebaseFirestore.instance.collection('applyAds').add({
        'adsId': adsId,
        'appliedUserId': authController.user[0].id,
        'videoId': authController.user[0].pitchYourselfVideoUrl[0].url,
        'feedback': '',
        'status': '',
        'appliedDate': FieldValue.serverTimestamp(),
        'watched': false
      });
      await FirebaseFirestore.instance
          .collection('users')
          .doc(authController.user[0].id)
          .update(
        {
          'ads': FieldValue.arrayUnion([insertAppliedAdsToFirebase.id])
        },
      );
      await FirebaseFirestore.instance.collection('ads').doc(adsId).update(
        {
          'appliedUsers': FieldValue.arrayUnion([authController.user[0].id])
        },
      );
      return true;
    } on FirebaseException catch (e) {
      print(e);
      return false;
    } on PlatformException catch (e) {
      print(e);
      return false;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
