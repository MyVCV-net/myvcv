import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:myvcv/config/theme.dart';
import 'package:myvcv/repositories/home_binding.dart';
import 'package:myvcv/screens/screens.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling a background message: ${message.messageId}");
  // if (settings.authorizationStatus == AuthorizationStatus.authorized) {}
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await GetStorage.init();
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  await messaging.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );
  await FirebaseMessaging.instance.subscribeToTopic('users');
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print(message.notification);
    Get.snackbar(message.notification!.title.toString(),
        message.notification!.body.toString());
  });

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  GetStorage box = GetStorage();
  runApp(GetMaterialApp(
    debugShowCheckedModeBanner: false,
    themeMode: box.hasData('theme')
        ? box.read('theme') == 'dark'
            ? ThemeMode.dark
            : box.read('theme') == 'light'
                ? ThemeMode.light
                : ThemeMode.system
        : ThemeMode.system,
    theme: GeneralTheme.lightTheme,
    darkTheme: GeneralTheme.darkTheme,
    initialBinding: HomeBinding(),
    builder: EasyLoading.init(),
    // onGenerateRoute: AppRouter.onGenerateRoute,
    initialRoute: "/",
    getPages: [
      GetPage(
          name: "/",
          page: () {
            return box.hasData('isFirstTime')
                ? box.hasData('user')
                    ? HomePage()
                    : LoginPage()
                : AboutUsPage();
          }),
      GetPage(name: LoginPage.routeName, page: () => LoginPage()),
      GetPage(name: AdsPage.routeName, page: () => AdsPage()),
      GetPage(
          name: AdsPageRecruiterForm.routeName,
          page: () => AdsPageRecruiterForm()),
      GetPage(name: JobSeekerPage.routeName, page: () => JobSeekerPage()),
      GetPage(name: LoginPage.routeName, page: () => LoginPage()),
      GetPage(name: RecruitersPage.routeName, page: () => RecruitersPage()),
      GetPage(name: SignUpPage.routeName, page: () => SignUpPage()),
      GetPage(name: JobsPage.routeName, page: () => JobsPage()),
      GetPage(name: AboutUsPage.routeName, page: () => AboutUsPage()),
      GetPage(name: ForgetPassword.routeName, page: () => ForgetPassword()),
      GetPage(name: MyNetworkPage.routeName, page: () => MyNetworkPage()),
      GetPage(name: NotificationPage.routeName, page: () => NotificationPage()),
      GetPage(name: Recommendation.routeName, page: () => Recommendation()),
      GetPage(name: ProfilePage.routeName, page: () => ProfilePage()),
      GetPage(name: SearchPage.routeName, page: () => SearchPage()),
      GetPage(name: MyProfilePage.routeName, page: () => MyProfilePage()),
      GetPage(
          name: JobDesc.routeName,
          page: () => JobDesc(
                selectedJobId: '',
              )),
      GetPage(name: SettingsPage.routeName, page: () => SettingsPage()),
      GetPage(name: EditProfile.routeName, page: () => EditProfile()),
      GetPage(
          name: UploadSkillsVideo.routeName, page: () => UploadSkillsVideo()),
      GetPage(
          name: UserProfile.routeName,
          page: () => UserProfile(userId: '', username: '')),
    ],
  ));
}
