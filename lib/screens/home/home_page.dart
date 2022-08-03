import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myvcv/repositories/home/home_controller.dart';
import 'package:myvcv/widget/widgets.dart';

class HomePage extends StatefulWidget {
  static const String routeName = '/';
  const HomePage({Key? key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute(
      settings: RouteSettings(name: routeName),
      builder: (_) => HomePage(),
    );
  }

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    HomeController home = Get.put(HomeController(), permanent: true);
    return Scaffold(
        extendBody: true,
        appBar: CustomAppBar(title: ""),
        bottomNavigationBar: NavBar(screen: 0),
        body: GetBuilder<HomeController>(
          init: home,
          autoRemove: false,
          builder: (controller) => controller.homeLoading.value
              ? controller.home.isNotEmpty
                  ? ListView.builder(
                      itemCount: controller.home.length,
                      itemBuilder: (context, index) {
                        return HomeCard(
                            home: controller.home[index], index: index);
                      })
                  : Center(
                      child: Text('No Video Found'),
                    )
              : Center(
                  child: CircularProgressIndicator(),
                ),
        ));
  }
}
