import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:myvcv/repositories/job/job_controller.dart';
import 'package:myvcv/widget/widgets.dart';

class JobsPage extends StatefulWidget {
  static const String routeName = '/JobsPage';

  static Route route() {
    return MaterialPageRoute(
      settings: RouteSettings(name: routeName),
      builder: (_) => JobsPage(),
    );
  }

  const JobsPage({Key? key}) : super(key: key);

  @override
  _JobsPageState createState() => _JobsPageState();
}

class _JobsPageState extends State<JobsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: CustomAppBar(title: "Jobs"),
      bottomNavigationBar: NavBar(screen: 2),
      body: GetBuilder<JobController>(
          autoRemove: false,
          init: Get.put(JobController(), permanent: true),
          builder: (controller) => controller.jobsLoading.value
              ? controller.jobList.isNotEmpty
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: AlignedGridView.count(
                        crossAxisCount: 2,
                        mainAxisSpacing: 2,
                        crossAxisSpacing: 2,
                        itemCount: controller.jobList.length,
                        itemBuilder: (context, index) {
                          return JobCard(jobs: controller.jobList[index]);
                        },
                      ),
                    )
                  : Center(
                      child: Text(
                        "No Jobs Found",
                        style: TextStyle(fontSize: 20),
                      ),
                    )
              : Center(
                  child: CircularProgressIndicator(),
                )),
    );
  }
}
