import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:myvcv/models/models.dart';
import 'package:myvcv/repositories/auth/auth_controller.dart';
import 'package:myvcv/repositories/firebase_controller.dart';
import 'package:myvcv/repositories/job/job_controller.dart';
import 'package:myvcv/widget/widgets.dart';

class JobDesc extends StatefulWidget {
  static const String routeName = '/JobDesc';

  static Route route({selectedJobId}) {
    return MaterialPageRoute(
      settings: RouteSettings(name: routeName),
      builder: (_) => JobDesc(selectedJobId: selectedJobId),
    );
  }

  const JobDesc({Key? key, required this.selectedJobId}) : super(key: key);
  final String selectedJobId;
  @override
  State<JobDesc> createState() => _JobDescState();
}

class _JobDescState extends State<JobDesc> {
  JobModel? selectedJobData;
  @override
  void initState() {
    super.initState();
    final JobController jobController = Get.put(JobController());
    selectedJobData = jobController.jobList
        .where((element) => element.jobId == widget.selectedJobId)
        .first;
  }

  @override
  Widget build(BuildContext context) {
    // final JobController jobController = Get.put(JobController());
    final AuthController authContoller = Get.put(AuthController());

    return Scaffold(
        appBar: CustomAppBar(title: selectedJobData!.username),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Column(
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Column(
                      children: [
                        SizedBox(
                          width: 150,
                          height: 150,
                          child: CachedNetworkImage(
                            imageUrl: selectedJobData!.userImageUrl,
                            imageBuilder: (context, imageProvider) => Container(
                              width: 30.0,
                              height: 30.0,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                    image: imageProvider, fit: BoxFit.cover),
                              ),
                            ),
                            placeholder: (context, url) =>
                                CircularProgressIndicator(),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error),
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                          selectedJobData!.username,
                          style: TextStyle(fontSize: 20),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                          selectedJobData!.jobTitle,
                          style: TextStyle(fontSize: 20),
                        ),
                        Text(
                          "${selectedJobData!.city} ${selectedJobData!.country != '' ? ',' : ''}  ${selectedJobData!.country}",
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  SizedBox(
                    height: 60,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListView(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        children: [
                          Row(
                            children: [
                              JobDescCard(
                                title:
                                    '${selectedJobData!.experianceYears} Years',
                              ),
                              JobDescCard(
                                title:
                                    '${selectedJobData!.salary} ${selectedJobData!.currency}/M',
                              ),
                              JobDescCard(
                                title: '${selectedJobData!.gender.capitalize}',
                              ),
                              JobDescCard(
                                title:
                                    'Age Group: ${selectedJobData!.ageCategory} ',
                              ),
                              JobDescCard(
                                title:
                                    '${selectedJobData!.jobCategory.capitalize}',
                              ),
                              JobDescCard(
                                title:
                                    '${selectedJobData!.academicSpecialization.capitalize}',
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  Divider(),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Job Description',
                        style: TextStyle(
                            color: Get.theme.iconTheme.color,
                            fontSize: 30.0,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: Container(
                      height: Get.height / 3.5,
                      child: ListView(
                        // crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            selectedJobData!.firstDescription,
                            style: TextStyle(
                              fontSize: 20.0,
                              color: Get.theme.iconTheme.color,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            selectedJobData!.secondDescription,
                            style: TextStyle(
                              fontSize: 20.0,
                              color: Get.theme.iconTheme.color,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text('Deadline: ${selectedJobData!.endDate}')),
                  )
                ],
              ),
            ],
          ),
        ),
        floatingActionButton: authContoller.isJobSeeker
            ? authContoller.user[0].ads.contains(selectedJobData!.jobId)
                ? Container()
                : Align(
                    alignment: Alignment.bottomCenter,
                    child: GestureDetector(
                      onTap: () async {
                        FirebaseController firebaseController =
                            Get.put(FirebaseController());
                        EasyLoading.show(
                          status: 'loading...',
                          maskType: EasyLoadingMaskType.black,
                        );
                        bool applyResult = await firebaseController.applyAds(
                            adsId: selectedJobData!.jobId);
                        if (applyResult) {
                          EasyLoading.dismiss();
                          Get.back();
                          Get.snackbar("Applied Successfully",
                              "Applied Job Succesffuly");
                        } else {}
                      },
                      child: Card(
                        elevation: 6,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        color: Get.theme.primaryColor,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 50, vertical: 8.0),
                          child: Text(
                            'Apply',
                            style: TextStyle(
                                color: Get.theme.iconTheme.color, fontSize: 28),
                          ),
                        ),
                      ),
                    ),
                  )
            : Container());
  }
}

class JobDescCard extends StatelessWidget {
  final String title;
  const JobDescCard({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 8.0),
        child: Text(
          title,
          style: TextStyle(color: Colors.black, fontSize: 18),
        ),
      ),
    );
  }
}
