import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myvcv/repositories/auth/auth_controller.dart';
import 'package:myvcv/widget/widgets.dart';

class AdsPage extends StatefulWidget {
  const AdsPage({Key? key}) : super(key: key);
  static const String routeName = '/AdsPage';
  static Route route() {
    return MaterialPageRoute(
      settings: RouteSettings(name: routeName),
      builder: (_) => AdsPage(),
    );
  }

  @override
  _AdsPageState createState() => _AdsPageState();
}

class _AdsPageState extends State<AdsPage> {
  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.put(AuthController());
    final bool isJobSeeker = authController.user[0].isJobSeeker;

    return Scaffold(
        extendBody: true,
        floatingActionButton:
            isJobSeeker ? Container() : CustomFloatingRecroterForm(),
        appBar: CustomAppBar(title: "Ads"),
        bottomNavigationBar: NavBar(screen: 3),
        body: isJobSeeker
            ? Container()
            : Obx(
                () => authController.user[0].ads.isEmpty
                    ? Center(
                        child: Text(
                        'No Data Found',
                        style: TextStyle(fontSize: 20),
                      ))
                    : Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: GridView.count(
                          crossAxisCount: 1,
                          childAspectRatio: 5,
                          shrinkWrap: true,
                          children: List.generate(
                              authController.user[0].ads.length, (index) {
                            var temp = DateTime.now().toUtc();
                            var d1 =
                                DateTime.utc(temp.year, temp.month, temp.day);
                            var d2 = DateTime.parse(
                                    authController.user[0].ads[index].endDate)
                                .toUtc();
                            print(authController.user[0].ads[index].endDate);
                            return AdsCard(
                                jobTitle:
                                    authController.user[0].ads[index].jobTitle,
                                publishTime: authController
                                    .user[0].ads[index].publishDate,
                                appliedNumber: authController
                                    .user[0].ads[index].appliedUsers.length
                                    .toString(),
                                authController: authController,
                                status: (d1.isBefore(d2)));
                          }),
                        ),
                      ),
              ));
  }
}
