import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myvcv/screens/screens.dart';

class SignUpPage extends StatefulWidget {
  static const String routeName = '/SignUpPage';

  static Route route() {
    return MaterialPageRoute(
      settings: RouteSettings(name: routeName),
      builder: (_) => SignUpPage(),
    );
  }

  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(elevation: 0),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Center(
                child: SizedBox(
                    width: 100, child: Image.asset('assets/Logo_Name.png'))),
            const SizedBox(
              height: 50,
            ),
            Center(
                child: SizedBox(
                    width: 300, child: Image.asset('assets/SignUpChart.png'))),
            const SizedBox(
              height: 100,
            ),
            Column(
              children: [
                Center(
                    child: SizedBox(
                        width: 250,
                        height: 50,
                        child: ElevatedButton(
                          child: const Text("Recruiters"),
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  const Color(0xFF2DABC9)),
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                              ))),
                          onPressed: () {
                            Get.to(() => RecruitersPage());
                          },
                        ))),
                const SizedBox(
                  height: 50,
                ),
                Center(
                    child: SizedBox(
                        width: 250,
                        height: 50,
                        child: ElevatedButton(
                          child: const Text("Job Seeker"),
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  const Color(0xFF2DABC9)),
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                              ))),
                          onPressed: () {
                            Get.to(() => JobSeekerPage());
                          },
                        ))),
                const SizedBox(
                  height: 50,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
