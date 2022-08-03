import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:myvcv/models/models.dart';
import 'package:myvcv/repositories/auth/auth_controller.dart';
import 'package:timeago/timeago.dart' as timeago;

class RecController extends GetxController {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final recLoading = false.obs;
  List<RecModel> recList = <RecModel>[].obs;
  AuthController authController = Get.put(AuthController());

  @override
  void onInit() async {
    super.onInit();
    await getMyRec();
  }

  getMyRec() async {
    await FirebaseFirestore.instance
        .collection('user_recommendation')
        .get()
        .then((value) async {
      final allData = value.docs.map((doc) => doc.data()).toList();
      for (var x in allData) {
        // print(authController.user[0].id);
        // print(x['to_user'] == authController.user[0].id);
        if (x['to_user'] == authController.user[0].id) {
          final fifteenAgo = DateTime.now().difference(x['createdOn'].toDate());
          await _firebaseFirestore
              .collection('users')
              .doc(x['from_user'])
              .get()
              .then((documentSnapshot) async {
            Map<String, dynamic> userData =
                documentSnapshot.data()! as Map<String, dynamic>;
            recList.add(RecModel(
                createOn: timeago
                    .format(DateTime.now().subtract(fifteenAgo))
                    .toString(),
                fromId: x['from_user'],
                recommandation: x['recommendation'],
                toId: x['to_user'],
                fromUsername: userData['username'],
                fromPhoto: userData['userImageUrl']));
          });
        }
        // recLoading.value = true;
        // update();
      }
      recLoading.value = true;
      update();
    });
  }
}
