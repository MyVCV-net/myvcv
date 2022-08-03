import 'package:get/get.dart';
import 'package:myvcv/repositories/auth/auth_controller.dart';
import 'package:myvcv/repositories/home/home_controller.dart';
import 'package:myvcv/repositories/job/job_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    // print('permanent: true');
    // Get.lazyPut(() => HomeController());
    // Get.lazyPut(() => MynetworkController());
    Get.lazyPut(() => JobController());
    Get.lazyPut(() => AuthController());
  }
}
