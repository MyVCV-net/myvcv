import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:myvcv/models/models.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:myvcv/screens/auth/login_page.dart';

enum loginType { google, facebook, email }

class AuthController extends GetxController with StateMixin {
  StreamSubscription<dynamic>? streemValue;
  @override
  void onInit() {
    super.onInit();
    checkIfUserLogedin();
  }

  checkIfUserLogedin() {
    if (GetStorage().hasData('user') && user.isEmpty) {
      // UserModel.fromJson(GetStorage().read('user'));
      // print(GetStorage().read('user'));
      // print(UserModel.fromJson(GetStorage().read('user')));
      user.add(UserModel.fromJson(GetStorage().read('user')));
      streemChanges();
    }
  }

  streemChanges() async {
    _auth.authStateChanges().listen((User? user) {
      if (user == null) {
        print('User is currently signed out!');
      } else {
        print('User is signed in!');
      }
    });
    Stream documentStream =
        _firebaseFirestore.collection('users').doc(user[0].id).snapshots();

    try {
      streemValue = documentStream.listen((event) async {
        print(user.isNotEmpty);
        if (user.isNotEmpty) {
          final snapShot = await _firebaseFirestore
              .collection('users')
              .doc(user[0].id)
              .get();
          if (snapShot == null || !snapShot.exists) {
            print('notexists');
            await logout();
            Get.offAll(LoginPage());
          } else {
            // print('User Exsist');
            Map<String, dynamic> newData = event.data() as Map<String, dynamic>;
            String? token = await FirebaseMessaging.instance.getToken();
            List tokenList = newData['token'] as List;
            if (!tokenList.contains(token)) {
              await _firebaseFirestore
                  .collection('users')
                  .doc(user[0].id)
                  .update(
                {
                  'token': FieldValue.arrayUnion([token])
                },
              );
            }
            if (newData.toString() != user[0].toMap().toString() &&
                user.isNotEmpty) {
              user[0] = user[0].copyWith(
                id: newData['id'] ?? '',
                username: newData['username'] ?? '',
                email: newData['email'] ?? '',
                isJobSeeker: newData.containsKey('isJobSeeker')
                    ? newData['isJobSeeker']
                    : '',
                userImageUrl: newData.containsKey('userImageUrl')
                    ? newData['userImageUrl']
                    : '',
                major: newData.containsKey('major') ? newData['major'] : '',
                businessModel: newData.containsKey('businessModel')
                    ? newData['businessModel']
                    : '',
                pitchYourselfVideoUrl: await dataModel.pitchYourselfUrlToMap(
                    newData.containsKey('pitchYourselfVideoUrl')
                        ? newData['pitchYourselfVideoUrl'] as List
                        : []),
                gender: newData.containsKey('gender') ? newData['gender'] : [],
                dob: newData.containsKey('dob') ? newData['dob'] : [],
                city: newData.containsKey('city') ? newData['city'] : [],
                country:
                    newData.containsKey('country') ? newData['country'] : [],
                token: newData.containsKey('token')
                    ? newData['token'] as List
                    : [],
                skillsUrl: await dataModel.skillsUrlToMap(
                    newData.containsKey('skillsUrl')
                        ? newData['skillsUrl'] as List
                        : []),
                follower: newData.containsKey('follower')
                    ? newData['follower'] as List
                    : [],
                following: newData.containsKey('following')
                    ? newData['following'] as List
                    : [],
                qualificationDocumentUrl:
                    dataModel.qualificationDocumentUrlToMap(
                        newData.containsKey('qualificationDocumentUrl')
                            ? newData['qualificationDocumentUrl'] as List
                            : []),
                contactInfoData: dataModel.contactInfoDataToMap(
                    newData.containsKey('contactInfoData')
                        ? newData['contactInfoData'] as List
                        : []),
                ads: await adsModel.adsModelToMap(
                    newData.containsKey('ads') ? newData["ads"] as List : []),
                notification: await notificationModel.notificationModelToMap(
                    newData.containsKey('notification')
                        ? newData["notification"] as List
                        : []),
              );
              GetStorage().write('user', user[0].toJson());
              update();
            }
          }
        }
      });
    } catch (e) {
      print(e);
    }
  }

  // Firebase Authantication Variable
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  //GetX Variable Observe
  final isFromSource = false.obs;
  final pageLoading = false.obs;
  List<UserModel> user = <UserModel>[].obs;
  Rx<loginType> loginTypeValue = loginType.email.obs;
  //Define DataModel Class
  DataModel dataModel = DataModel(name: '');
  AdsModel adsModel = AdsModel(
      academicSpecialization: '',
      ageCategory: '',
      appliedUsers: const [],
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

  //Google Variable
  GoogleSignInAccount? googleUser;
  GoogleSignInAuthentication? googleAuth;
  OAuthCredential? googleCredential;
  UserCredential? googleData;
  //Facebook Variable
  LoginResult? facebookResult;
  OAuthCredential? facebookCredential;
  UserCredential? facebookFirebase;
  //Auth Method
  Future<bool> createUserWithEmailAndPassword(
      {required String username,
      required String email,
      required String password,
      required bool isJobSeeker,
      required String businessModel}) async {
    // print(loginTypeValue.value);

    if (loginTypeValue.value == loginType.email) {
      try {
        UserCredential userCredantal = await _auth
            .createUserWithEmailAndPassword(email: email, password: password);
        try {
          await createUser(
              id: userCredantal.user!.uid,
              email: email,
              username: username,
              userImageUrl: '',
              isJobSeeker: isJobSeeker,
              businessModel: businessModel);
        } on FirebaseAuthException catch (e) {
          Get.snackbar('Error', e.toString());
          return false;
        } on PlatformException catch (e) {
          Get.snackbar('Error', e.toString());
          return false;
        } catch (e) {
          Get.snackbar('Error', e.toString());
          return false;
        }
        return true;
      } on FirebaseAuthException catch (e) {
        Get.snackbar('Error', e.toString());
        return false;
      } on PlatformException catch (e) {
        Get.snackbar('Error', e.toString());
        return false;
      } catch (e) {
        Get.snackbar('Error', e.toString());
        return false;
      }
    } else {
      UserCredential? userCredantal;
      try {
        AuthCredential credential =
            EmailAuthProvider.credential(email: email, password: password);
        try {
          userCredantal =
              await _auth.currentUser?.linkWithCredential(credential);
        } on PlatformException catch (e) {
          print(e);
          Get.snackbar('Error', e.toString());
          return false;
        } catch (e) {
          print(e);
          Get.snackbar('Error', e.toString());
          return false;
        }
        try {
          await createUser(
              id: userCredantal!.user!.uid,
              email: email,
              username: username,
              userImageUrl: user[0].userImageUrl,
              isJobSeeker: isJobSeeker,
              businessModel: businessModel);
        } on PlatformException catch (e) {
          print(e);
        } catch (e) {
          print(e);
        }
        return true;
      } on FirebaseAuthException catch (e) {
        Get.snackbar('Error', e.toString());
        return false;
      } on PlatformException catch (e) {
        Get.snackbar('Error', e.toString());
        return false;
      } catch (e) {
        Get.snackbar('Error', e.toString());
        return false;
      }
    }
  }

  Future<bool> loginWithEmailAndPassword(email, password) async {
    pageLoading.update((val) {
      pageLoading.value = true;
      update();
    });
    loginTypeValue.value = loginType.email;
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      var exsistResult = await existsUser(userCredential.user!.uid);
      pageLoading.update((val) {
        pageLoading.value = false;
        update();
      });
      if (exsistResult == true) {
        return true;
      } else {
        return false;
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        Get.snackbar('Error', 'No user found for that email');
        pageLoading.update((val) {
          pageLoading.value = false;
          update();
        });
        return false;
      } else if (e.code == 'wrong-password') {
        Get.snackbar('Error', 'Wrong password provided for that user');
        pageLoading.update((val) {
          pageLoading.value = false;
          update();
        });
        return false;
      } else {
        pageLoading.update((val) {
          pageLoading.value = false;
          update();
        });
        return false;
      }
    } on PlatformException catch (e) {
      print(e);
      return false;
    }
  }

  Future<String> googleSignAuth() async {
    loginTypeValue.value = loginType.google;
    final googleSignIn = GoogleSignIn();
    try {
      googleUser = await googleSignIn.signIn();
      if (googleUser == null) return "false";
      googleAuth = await googleUser!.authentication;
      googleCredential = GoogleAuthProvider.credential(
          accessToken: googleAuth!.accessToken, idToken: googleAuth!.idToken);

      googleData = await _auth.signInWithCredential(googleCredential!);
      if (!googleData!.additionalUserInfo!.isNewUser) {
        var exsistResult = await existsUser(googleData!.user!.uid);
        if (exsistResult == true) {
          return "true";
        } else {
          return "false";
        }
      } else {
        user.add(UserModel(
          id: googleData!.user!.uid,
          username: googleData!.user!.displayName == null ||
                  googleData!.user!.displayName == ''
              ? ''
              : googleData!.user!.displayName.toString(),
          email: googleData!.user!.email ?? googleUser!.email,
          isJobSeeker: false,
          userImageUrl: googleData!.user!.photoURL == null ||
                  googleData!.user!.photoURL == ''
              ? ''
              : googleData!.user!.photoURL.toString(),
          major: '',
          businessModel: '',
          gender: '',
          dob: '',
          city: '',
          country: '',
          token: const [],
          pitchYourselfVideoUrl: const [],
          skillsUrl: const [],
          follower: const [],
          following: const [],
          qualificationDocumentUrl: const [],
          contactInfoData: const [],
          ads: const [],
          notification: const [],
        ));
        isFromSource.value = true;
        return "new";
      }
    } on FirebaseAuthException catch (e) {
      print(e);
      return 'false';
    } on PlatformException catch (err) {
      Get.snackbar("Error", err.toString());
      return 'false';
    } catch (e) {
      Get.snackbar("Error", e.toString());
      return 'false';
    }
  }

  Future<String> facebookLogin() async {
    loginTypeValue.value = loginType.facebook;
    try {
      facebookResult =
          await FacebookAuth.i.login(permissions: ["public_profile", "email"]);
      if (facebookResult!.status == LoginStatus.success) {
        Map<String, dynamic> facebookData = await FacebookAuth.i
            .getUserData(fields: "id,name , email, picture");
        facebookCredential =
            FacebookAuthProvider.credential(facebookResult!.accessToken!.token);
        facebookFirebase =
            await _auth.signInWithCredential(facebookCredential!);
        if (!facebookFirebase!.additionalUserInfo!.isNewUser) {
          // print(facebookFirebase!.user!.uid);
          var exsistResult = await existsUser(facebookFirebase!.user!.uid);
          if (exsistResult == true) {
            return "true";
          } else {
            return "false";
          }
        } else {
          // print(facebookFirebase);
          //TODO:: check if get gender from facebook
          user.add(UserModel(
            id: facebookFirebase!.user!.uid,
            username: facebookFirebase!.user!.displayName ?? '',
            email: facebookFirebase!.user!.providerData[0].email ??
                facebookData['email'] ??
                '',
            isJobSeeker: true,
            userImageUrl: facebookFirebase!.user!.photoURL ??
                (facebookFirebase!.additionalUserInfo!.profile
                    as Map<String, dynamic>)['url'] ??
                '',
            major: '',
            businessModel: '',
            gender: '',
            dob: '',
            city: '',
            country: '',
            token: const [],
            pitchYourselfVideoUrl: const [],
            skillsUrl: const [],
            follower: const [],
            following: const [],
            qualificationDocumentUrl: const [],
            contactInfoData: const [],
            ads: const [],
            notification: const [],
          ));
          update();
          isFromSource.value = true;
          return "new";
        }
      } else {
        return "false";
      }
    } on PlatformException catch (e) {
      Get.snackbar("Error", e.toString());
      print(e);
      return "false";
    } catch (e) {
      Get.snackbar("Error", e.toString());
      print(e);
      return "false";
    }
  }

  Future<bool> logout() async {
    try {
      // HomeController homeController = Get.put(HomeController());
      streemValue!.cancel();
      await _auth.signOut();
      GetStorage().write('user', null);
      // Get.delete<HomeController>();
      // homeController.home.clear();
      user.clear();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> existsUser(String uid) async {
    bool existsUserResult = false;
    try {
      await _firebaseFirestore
          .collection('users')
          .doc(uid)
          .get()
          .then((value) async {
        Map<String, dynamic> data = value.data() as Map<String, dynamic>;

        user.add(
          UserModel(
            id: data['id'],
            username: data['username'],
            email: data['email'],
            isJobSeeker:
                data.containsKey('isJobSeeker') ? data['isJobSeeker'] : '',
            userImageUrl:
                data.containsKey('userImageUrl') ? data['userImageUrl'] : '',
            major: data.containsKey('major') ? data['major'] : '',
            businessModel:
                data.containsKey('businessModel') ? data['businessModel'] : '',
            pitchYourselfVideoUrl: await dataModel.pitchYourselfUrlToMap(
                data.containsKey('pitchYourselfVideoUrl')
                    ? data['pitchYourselfVideoUrl'] as List
                    : []),
            gender: data.containsKey('gender') ? data['gender'] : '',
            dob: data.containsKey('dob') ? data['dob'] : '',
            city: data.containsKey('city') ? data['city'] : '',
            country: data.containsKey('country') ? data['country'] : '',
            token: data.containsKey('token') ? data['token'] as List : [],
            skillsUrl: await dataModel.skillsUrlToMap(
                data.containsKey('skillsUrl') ? data['skillsUrl'] as List : []),
            follower:
                data.containsKey('follower') ? data['follower'] as List : [],
            following:
                data.containsKey('following') ? data['following'] as List : [],
            qualificationDocumentUrl: dataModel.qualificationDocumentUrlToMap(
                data.containsKey('qualificationDocumentUrl')
                    ? data['qualificationDocumentUrl'] as List
                    : []),
            contactInfoData: dataModel.contactInfoDataToMap(
                data.containsKey('contactInfoData')
                    ? data['contactInfoData'] as List
                    : []),
            ads: await adsModel.adsModelToMap(
                data.containsKey('ads') ? data["ads"] as List : []),
            notification: await notificationModel.notificationModelToMap(
                data.containsKey('notification')
                    ? data["notification"] as List
                    : []),
          ),
        );
        GetStorage().write('user', user[0].toJson());
        existsUserResult = true;
      }).onError((error, stackTrace) async {
        Get.snackbar("Eroor", error.toString());
        existsUserResult = false;
        await logout();
      });
      print('create new doc');
      return existsUserResult;
    } catch (e) {
      await logout();
      return existsUserResult;
    }
  }

  Future<bool> createUser(
      {required String id,
      username,
      email,
      userImageUrl,
      businessModel,
      required bool isJobSeeker}) async {
    try {
      await _firebaseFirestore.collection('users').doc(id).set({
        'id': id,
        'username': username,
        'email': email,
        'isJobSeeker': isJobSeeker,
        'userImageUrl': userImageUrl,
        'major': '',
        'businessModel': businessModel ?? '',
        'pitchYourselfVideoUrl': [],
        'gender': '',
        'dob': '',
        'city': '',
        'country': '',
        'token': [],
        'following': [],
        'follower': [],
        'skillsUrl': [],
        'qualificationDocumentUrl': [],
        'contactInfoData': [],
        'ads': [],
        'notification': [],
        'chatUsers': [],
      });
      user.clear();
      user.add(UserModel(
        id: id,
        username: username ?? '',
        email: email ?? '',
        isJobSeeker: isJobSeeker,
        userImageUrl: userImageUrl ?? '',
        major: '',
        businessModel: businessModel ?? '',
        gender: '',
        dob: '',
        city: '',
        country: '',
        token: const [],
        pitchYourselfVideoUrl: const [],
        skillsUrl: const [],
        follower: const [],
        following: const [],
        qualificationDocumentUrl: const [],
        contactInfoData: const [],
        ads: const [],
        notification: const [],
      ));
      GetStorage().write('user', user[0].toJson());
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> forgetPassword({required String email}) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return true;
    } catch (e) {
      Get.snackbar("Error", e.toString());
      return false;
    }
  }

  //Getter Method
  String get id => user.isEmpty ? '' : user[0].id;
  String get username => user.isEmpty ? '' : user[0].username;
  String get email => user.isEmpty ? '' : user[0].email;
  bool get isJobSeeker => user.isEmpty ? false : user[0].isJobSeeker;
  String get userImageUrl => user.isEmpty ? '' : user[0].userImageUrl;
  String get major => user.isEmpty ? '' : user[0].major;
  String get businessModel => user.isEmpty ? '' : user[0].businessModel;
  // String get pitchYourselfVideoUrl =>
  //     user.isEmpty ? '' : user[0].pitchYourselfVideoUrl;
  List<DataModel> get skillsUrl => user.isEmpty ? [] : user[0].skillsUrl;
  List get follower => user.isEmpty ? [] : user[0].follower;
  List get following => user.isEmpty ? [] : user[0].following;
  List<DataModel> get qualificationDocumentUrl =>
      user.isEmpty ? [] : user[0].qualificationDocumentUrl;
  List<DataModel> get contactInfoData =>
      user.isEmpty ? [] : user[0].contactInfoData;
  List<AdsModel> get ads => user.isEmpty ? [] : user[0].ads;
  List<NotificationModel> get notification =>
      user.isEmpty ? [] : user[0].notification;

//Other Function Getter
  bool followingVideo(String videoId) {
    return user[0].following.contains(videoId);
  }

  int get skillsNumber => user.isNotEmpty
      ? user[0].skillsUrl.isEmpty
          ? 0
          : user[0].skillsUrl.length
      : 0;
  int get followerNumber => user.isNotEmpty
      ? user[0].follower.isEmpty
          ? 0
          : user[0].follower.length
      : 0;
  int get followingNumber => user.isNotEmpty
      ? user[0].following.isEmpty
          ? 0
          : user[0].following.length
      : 0;
}
