import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myvcv/repositories/auth/auth_controller.dart';
import 'package:myvcv/repositories/mynetwork/mynetwork_controller.dart';
import 'package:myvcv/widget/widgets.dart';

class MyNetworkPage extends StatefulWidget {
  static const String routeName = '/MyNetworkPage';

  static Route route() {
    return MaterialPageRoute(
      settings: RouteSettings(name: routeName),
      builder: (_) => MyNetworkPage(),
    );
  }

  const MyNetworkPage({Key? key}) : super(key: key);

  @override
  _MyNetworkPageState createState() => _MyNetworkPageState();
}

class _MyNetworkPageState extends State<MyNetworkPage> {
  @override
  Widget build(BuildContext context) {
    AuthController authcon = Get.put(AuthController());
    print(authcon.following);
    return Scaffold(
        extendBody: true,
        appBar: CustomAppBar(title: ""),
        bottomNavigationBar: NavBar(screen: 1),
        body: ListView(children: [
          SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: [
                NameWidget(
                  title: "Companies",
                ),
                SizedBox(
                    height: 280,
                    child: GetBuilder<MynetworkController>(
                      autoRemove: false,
                      init: Get.put(MynetworkController(), permanent: true),
                      builder: (controller) => controller.companyLoading.value
                          ? controller.mynetworkCompanies.isNotEmpty
                              ? ListView.separated(
                                  scrollDirection: Axis.horizontal,
                                  separatorBuilder: (context, intt) =>
                                      const SizedBox(height: 0, width: 0),
                                  itemCount:
                                      controller.mynetworkCompanies.length,
                                  itemBuilder: (context, index) {
                                    return VideoImageWidget(
                                      videoImageUrl: controller
                                          .mynetworkCompanies[index]
                                          .videoImageUrl,
                                      userImageUrl: controller
                                          .mynetworkCompanies[index]
                                          .userImageUrl,
                                      username: controller
                                          .mynetworkCompanies[index].username,
                                      userId: controller
                                          .mynetworkCompanies[index].userId,
                                      videoUrl: controller
                                          .mynetworkCompanies[index].videoUrl,
                                      videoId: controller
                                          .mynetworkCompanies[index].videoId,
                                    );
                                  },
                                )
                              : Center(
                                  child: Text('No Companies Found'),
                                )
                          : Center(
                              child: CircularProgressIndicator(),
                            ),
                    )),
                NameWidget(
                  title: "My Network",
                ),
                SizedBox(
                    height: 280,
                    child: GetBuilder<MynetworkController>(
                      autoRemove: false,
                      init: Get.put(MynetworkController(), permanent: true),
                      builder: (controller) => controller.profilesLoading.value
                          ? controller.mynetworkProfiles.isNotEmpty
                              ? ListView.separated(
                                  scrollDirection: Axis.horizontal,
                                  separatorBuilder: (context, intt) =>
                                      const SizedBox(height: 0, width: 0),
                                  itemCount:
                                      controller.mynetworkProfiles.length,
                                  itemBuilder: (context, index) {
                                    return VideoImageWidget(
                                      videoImageUrl: controller
                                          .mynetworkProfiles[index]
                                          .videoImageUrl,
                                      userImageUrl: controller
                                          .mynetworkProfiles[index]
                                          .userImageUrl,
                                      username: controller
                                          .mynetworkProfiles[index].username,
                                      userId: controller
                                          .mynetworkProfiles[index].userId,
                                      videoUrl: controller
                                          .mynetworkProfiles[index].videoUrl,
                                      videoId: controller
                                          .mynetworkProfiles[index].videoId,
                                    );
                                  },
                                )
                              : Center(
                                  child: Text('No Profiles Found'),
                                )
                          : Center(child: CircularProgressIndicator()),
                    )),
              ],
            ),
          )
        ]));
  }
}
