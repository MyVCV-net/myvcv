import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myvcv/repositories/auth/auth_controller.dart';
import 'package:myvcv/widget/widgets.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class NotificationPage extends StatefulWidget {
  static const String routeName = '/NotificationPage';

  static Route route() {
    return MaterialPageRoute(
      settings: RouteSettings(name: routeName),
      builder: (_) => NotificationPage(),
    );
  }

  const NotificationPage({Key? key}) : super(key: key);

  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  @override
  Widget build(BuildContext context) {
    final authController = Get.put(AuthController());

    return Scaffold(
        extendBody: true,
        appBar: CustomAppBar(title: "Notifications"),
        bottomNavigationBar: NavBar(screen: 4),
        body: Obx(() => authController.user[0].notification.isEmpty
            ? Center(
                child: Text(
                'No Data Found',
                style: TextStyle(fontSize: 20),
              ))
            : Padding(
                padding: const EdgeInsets.all(12.0),
                // child: StaggeredGridView.countBuilder(
                //   crossAxisCount: 4,
                //   itemCount: authController.user[0].notification.length,
                //   itemBuilder: (BuildContext context, int index) =>
                //       NotificationCard(
                //     imageUrl:
                //         authController.user[0].notification[index].imageUrl,
                //     username:
                //         authController.user[0].notification[index].username,
                //     subtitle:
                //         authController.user[0].notification[index].subtitle,
                //     time: authController.user[0].notification[index].time,
                //   ),
                //   staggeredTileBuilder: (int index) =>
                //       StaggeredTile.count(4, 1),
                //   mainAxisSpacing: 4.0,
                //   crossAxisSpacing: 4.0,
                // ),
              )));
  }
}
