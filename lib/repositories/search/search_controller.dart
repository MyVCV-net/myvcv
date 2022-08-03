import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:myvcv/models/models.dart';
import 'package:myvcv/repositories/auth/auth_controller.dart';

class SearchController extends GetxController {
  List<SearchModel> allData = <SearchModel>[].obs;
  List<SearchModel> copyAllData = <SearchModel>[].obs;
  final searchLoading = false.obs;
  AuthController authController = Get.put(AuthController());
  @override
  void onInit() async {
    super.onInit();
    FirebaseFirestore.instance
        .collection('users')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        if (doc['id'] != authController.id) {
          allData.add(SearchModel(
              doc["id"],
              doc["userImageUrl"],
              doc["username"],
              doc["major"],
              (doc["follower"] as List).length.toString(),
              '',
              false));
        }
      });
      allData.shuffle();
      update();
      // print(usersArray);
      FirebaseFirestore.instance
          .collection('ads')
          .get()
          .then((QuerySnapshot querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          if (doc['userId'] != authController.id) {
            allData.add(SearchModel(
                doc.id,
                '',
                allData
                    .where((element) => element.id == doc['userId'])
                    .first
                    .name,
                doc["jobTitle"],
                (doc["appliedUsers"] as List).length.toString(),
                doc["endDate"],
                true));
          }
        });
        allData.shuffle();
        update();
      });
    });
    allData.shuffle();
    copyAllData = allData;
    searchLoading.value = true;
    update();
    // print(usersArray);
  }

  search(String username) {
    print(username.isEmpty);
    print(username == '');

    searchLoading.value = false;
    update();
    List<SearchModel> results = [];
    if (username.isEmpty || username == '') {
      results = copyAllData;
      update();
    } else {
      results = copyAllData
          .where((element) =>
              (element.name.toLowerCase().contains(username.toLowerCase()) ||
                  element.major.toLowerCase().contains(username.toLowerCase())))
          .toList();
    }
    allData = results;
    searchLoading.value = true;
    update();
  }
}
