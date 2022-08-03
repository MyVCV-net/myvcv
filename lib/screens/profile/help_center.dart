import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:myvcv/repositories/firebase_controller.dart';
import 'package:myvcv/widget/widgets.dart';

class HelpCenter extends StatefulWidget {
  HelpCenter({Key? key}) : super(key: key);

  @override
  State<HelpCenter> createState() => _HelpCenterState();
}

class _HelpCenterState extends State<HelpCenter> {
  TextEditingController helpContoller = TextEditingController();
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: CustomAppBar(
          title: 'Help Center',
          searchIcon: false,
        ),
        body: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              children: [
                SizedBox(
                    width: MediaQuery.of(context).size.width * .2,
                    child: Image.asset('assets/Logo_Name.png')),
                SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: TextFormField(
                    controller: helpContoller,
                    validator: (problemValue) =>
                        problemValue == '' || problemValue == null
                            ? 'Enter a valid message'
                            : null,
                    autofocus: true,
                    maxLength: 250,
                    maxLines: 4,
                    decoration: InputDecoration(
                      hintText:
                          'Report a bug, a translation error or a suggestion',
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.teal)),
                    ),
                  ),
                ),
                // SizedBox(height: 30),
                SizedBox(
                    width: MediaQuery.of(context).size.width * .5,
                    child: ElevatedButton(
                      child: const Text("Send"),
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              const Color(0xFFD0AB37)),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                          ))),
                      onPressed: () async {
                        // print(helpContoller.text);
                        FirebaseController firebaseController =
                            Get.put(FirebaseController());
                        final form = formKey.currentState!;
                        if (form.validate()) {
                          EasyLoading.show(
                            status: 'loading...',
                            maskType: EasyLoadingMaskType.black,
                          );
                          var result = await firebaseController.addHelpCenter(
                              problem: helpContoller.text);
                          if (result) {
                            Get.snackbar('Added Successfully',
                                'Thank You for send to us');
                            helpContoller.clear();
                          } else {
                            Get.snackbar('Someting wrong', 'Please try again');
                          }
                          EasyLoading.dismiss();
                        }
                      },
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
