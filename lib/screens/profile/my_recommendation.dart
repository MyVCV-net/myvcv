import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myvcv/repositories/recommandation/recommandation_controller.dart';
import 'package:myvcv/widget/custom/custom_appbar.dart';
import '../screens.dart';

class Recommendation extends StatefulWidget {
  static const String routeName = '/Recommendation';

  static Route route() {
    return MaterialPageRoute(
      settings: RouteSettings(name: routeName),
      builder: (_) => Recommendation(),
    );
  }

  const Recommendation({Key? key}) : super(key: key);

  @override
  State<Recommendation> createState() => _RecommendationState();
}

class _RecommendationState extends State<Recommendation> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'My Recommendation'),
      body: GetBuilder<RecController>(
        init: Get.put(RecController()),
        autoRemove: false,
        builder: (controller) => controller.recLoading.value
            ? controller.recList.isNotEmpty
                ? ListView.builder(
                    itemCount: controller.recList.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                            child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Column(
                            children: [
                              Text(controller.recList[index].recommandation),
                              SizedBox(
                                height: 10,
                              ),
                              Align(
                                alignment: Alignment.bottomLeft,
                                child: Row(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        Get.to(UserProfile(
                                            userId: controller
                                                .recList[index].fromId,
                                            username: controller
                                                .recList[index].fromUsername));
                                      },
                                      child: SizedBox(
                                        height: 30,
                                        width: 30,
                                        child: controller
                                                    .recList[index].fromPhoto !=
                                                ''
                                            ? CachedNetworkImage(
                                                imageUrl: controller
                                                    .recList[index].fromPhoto,
                                                imageBuilder:
                                                    (context, imageProvider) =>
                                                        Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                50)),
                                                    image: DecorationImage(
                                                      image: imageProvider,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                                placeholder: (context, url) =>
                                                    CircularProgressIndicator(),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        Image.asset(
                                                  'assets/account.png',
                                                ),
                                              )
                                            : Image.asset(
                                                'assets/account.png',
                                              ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                        "${controller.recList[index].fromUsername} . ${controller.recList[index].createOn}"),
                                  ],
                                ),
                              )
                            ],
                          ),
                        )),
                      );
                    })
                : Center(
                    child: Text('No Recommandation Found'),
                  )
            : Center(
                child: CircularProgressIndicator(),
              ),
      ),
    );
  }
}
