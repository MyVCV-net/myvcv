import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:myvcv/models/models.dart';
import 'package:myvcv/repositories/auth/auth_controller.dart';

class JobController extends GetxController {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  AuthController authContoller = Get.put(AuthController());
  final jobsLoading = false.obs;
  List<JobModel> jobList = <JobModel>[].obs;
  @override
  void onInit() {
    super.onInit();
    getDataFromFirebase();
  }

  getDataFromFirebase() async {
    try {
      await _firebaseFirestore.collection('ads').get().then((value) async {
        for (var jobData in value.docs) {
          var appliedUser = jobData['appliedUsers'] as List;
          if (jobData['userId'] != authContoller.id &&
              !appliedUser.contains(jobData['userId'])) {
            await _firebaseFirestore
                .collection('users')
                .doc(jobData['userId'])
                .get()
                .then((userValue) {
              Map<String, dynamic> userData =
                  userValue.data() as Map<String, dynamic>;
              jobList.add(JobModel(
                  academicSpecialization: jobData['academicSpecialization'],
                  ageCategory: jobData['ageCategory'],
                  appliedUsers: jobData['appliedUsers'],
                  city: jobData['city'],
                  country: jobData['country'],
                  currency: jobData['currency'],
                  endDate: jobData['endDate'],
                  experianceYears: jobData['experianceYears'],
                  firstDescription: jobData['firstDescription'],
                  gender: jobData['gender'],
                  jobCategory: jobData['jobCategory'],
                  jobTitle: jobData['jobTitle'],
                  publishDate: jobData['publishDate'],
                  salary: jobData['salary'],
                  secondDescription: jobData['secondDescription'],
                  jobId: jobData.id.toString(),
                  userId: jobData['userId'],
                  userImageUrl: userData['userImageUrl'],
                  username: userData['username'],
                  userEmail: userData['email'],
                  createdAt: jobData['createdAt'].toString()));
            });
          }
        }
      });
      jobsLoading.value = true;
      update();
    } catch (e) {
      jobsLoading.value = true;
      update();
      print(e);
    }
  }
}
