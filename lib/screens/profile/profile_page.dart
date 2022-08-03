import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myvcv/repositories/auth/auth_controller.dart';
import 'package:myvcv/repositories/home/home_controller.dart';
import 'package:myvcv/widget/profile/rate_app_init_widget.dart';
import 'package:myvcv/widget/widgets.dart';
import 'package:rate_my_app/rate_my_app.dart';
import 'package:url_launcher/url_launcher.dart';
import '../screens.dart';

class ProfilePage extends StatefulWidget {
  static const String routeName = '/ProfilePage';

  static Route route({required rateMyApp}) {
    return MaterialPageRoute(
      settings: RouteSettings(name: routeName),
      builder: (_) => ProfilePage(),
    );
  }

  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.put(AuthController());
    return Scaffold(
        extendBody: true,
        appBar: CustomAppBar(title: "Profile"),
        bottomNavigationBar: NavBar(screen: 5),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(top: 12.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Column(
                      // crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Obx(
                          () => ListTile(
                            leading: authController.user.isNotEmpty
                                ? authController.user[0].userImageUrl != '' ||
                                        authController
                                            .user[0].userImageUrl.isNotEmpty
                                    ? CachedNetworkImage(
                                        imageUrl: authController.userImageUrl,
                                        imageBuilder:
                                            (context, imageProvider) =>
                                                Container(
                                          height: 50,
                                          width: 50,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(50)),
                                            image: DecorationImage(
                                              image: imageProvider,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        placeholder: (context, url) =>
                                            CircularProgressIndicator(),
                                        errorWidget: (context, url, error) =>
                                            Image.asset('assets/account.png'),
                                      )
                                    : Image.asset('assets/account.png')
                                : Image.asset('assets/account.png'),
                            title: Obx(() => Text(authController.username)),
                            subtitle: const Text("See your profile"),
                            onTap: () {
                              Get.to(MyProfilePage());
                            },
                          ),
                        ),
                        const Divider(),
                        ListTile(
                          leading:
                              const Icon(Icons.recommend_outlined, size: 40),
                          title: const Text("Recommendation"),
                          onTap: () {
                            Navigator.pushNamed(
                                context, Recommendation.routeName);
                          },
                        ),
                        const Divider(),
                        ListTile(
                          leading: const Icon(Icons.settings, size: 40),
                          title: const Text("Settings"),
                          onTap: () {
                            Navigator.pushNamed(
                                context, SettingsPage.routeName);
                          },
                        ),
                        const Divider(),
                        ListTile(
                          leading: const Icon(Icons.question_answer, size: 40),
                          title: const Text("Help & Support"),
                          onTap: () {
                            Get.to(HelpCenter());
                          },
                        ),
                        const Divider(),
                        ListTile(
                          leading: const Icon(Icons.book, size: 40),
                          title: const Text("Terms & Policies"),
                          onTap: () async {
                            final url = "https://myvcv.net/app_privacy.html";
                            if (await canLaunch(url)) {
                              await launch(
                                url,
                                forceSafariVC: true,
                                forceWebView: true,
                                enableJavaScript: true,
                              );
                            }
                          },
                        ),
                        const Divider(),
                        RateAppInitWidget(
                          builder: (rateMyApp) => ListTile(
                            leading: const Icon(Icons.star_rate, size: 40),
                            title: const Text("Rate App"),
                            onTap: () {
                              rateMyApp.showStarRateDialog(
                                context,
                                title: 'Rate This App',
                                message:
                                    'Do you like this app? Please leave a rating',
                                starRatingOptions:
                                    StarRatingOptions(initialRating: 4),
                                actionsBuilder: (BuildContext context,
                                        double? stars) =>
                                    stars == null
                                        ? [
                                            RateMyAppNoButton(
                                              rateMyApp,
                                              text: 'CANCEL',
                                            )
                                          ]
                                        : [
                                            TextButton(
                                              child: Text('OK'),
                                              onPressed: () async {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                      content: Text(
                                                          'Thanks for your feedback!')),
                                                );

                                                final launchAppStore =
                                                    stars >= 4;

                                                var event = RateMyAppEventType
                                                    .rateButtonPressed;

                                                await rateMyApp
                                                    .callEvent(event);

                                                if (launchAppStore) {
                                                  rateMyApp.launchStore();
                                                }

                                                Navigator.of(context).pop();
                                              },
                                            ),
                                            RateMyAppNoButton(
                                              rateMyApp,
                                              text: 'CANCEL',
                                            )
                                          ],
                              );
                            },
                          ),
                        ),
                        const Divider(),
                        ListTile(
                          leading: const Icon(Icons.logout, size: 40),
                          title: const Text("Logout"),
                          onTap: () async {
                            var logoutResult = await authController.logout();
                            if (logoutResult) {
                              // Get.delete<HomeController>();
                              // HomeController home = Get.put(HomeController());
                              // home.onClose();
                              Get.to(() => LoginPage());
                              // Get.offUntil(
                              //     GetPageRoute(page: () => LoginPage()),
                              //     ModalRoute.withName('toNewLogin'));
                              // Timer(Duration(milliseconds: 300),
                              //     () => Get.delete<HomeController>());
                            }
                          },
                        ),
                        const Divider(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  // Widget buildOkButton(double stars) => TextButton(
  //       child: Text('OK'),
  //       onPressed: () async {
  //         ScaffoldMessenger.of(context).showSnackBar(
  //           SnackBar(content: Text('Thanks for your feedback!')),
  //         );

  //         final launchAppStore = stars >= 4;

  //         final event = RateMyAppEventType.rateButtonPressed;

  //         await widget.rateMyApp.callEvent(event);

  //         if (launchAppStore) {
  //           widget.rateMyApp.launchStore();
  //         }

  //         Navigator.of(context).pop();
  //       },
  //     );

  // Widget buildCancelButton() => RateMyAppNoButton(
  //       widget.rateMyApp,
  //       text: 'CANCEL',
  //     );
}
