import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myvcv/repositories/auth/auth_controller.dart';
import 'package:myvcv/repositories/firebase_controller.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:url_launcher/url_launcher.dart';

class QualificationBuilder extends StatelessWidget {
  const QualificationBuilder(
      {Key? key,
      required this.authController,
      required this.firebaseController})
      : super(key: key);

  final AuthController authController;
  final FirebaseController firebaseController;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: authController.user[0].qualificationDocumentUrl.length,
      scrollDirection: Axis.horizontal,
      itemBuilder: (BuildContext context, int index) => QualificationCard(
        name: authController.user[0].qualificationDocumentUrl[index].name,
        file: authController.user[0].qualificationDocumentUrl[index].type ==
            'file',
        url: authController.user[0].qualificationDocumentUrl[index].url,
        firebaseController: firebaseController,
      ),
    );
  }
}

class QualificationCard extends StatelessWidget {
  final bool file;
  final String name;
  final String url;
  const QualificationCard(
      {Key? key,
      required this.file,
      required this.name,
      required this.url,
      required this.firebaseController})
      : super(key: key);
  final FirebaseController firebaseController;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        // print(url);
        if (await canLaunch(url)) {
          await launch(
            url,
            forceSafariVC: true,
            forceWebView: true,
            enableJavaScript: true,
          );
        }
      },
      child: Stack(
        children: [
          Card(
            elevation: 5,
            child: SizedBox(
              width: 150,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  file
                      ? Icon(Icons.content_copy,
                          size: 60, color: Color(0xFF0C6977))
                      : Icon(
                          Icons.image,
                          size: 60,
                          color: Color(0xFF0C6977),
                        ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(name, overflow: TextOverflow.ellipsis),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            right: 0,
            child: InkWell(
              child: Icon(Icons.remove_circle),
              onTap: () async {
                showDialog(
                  context: context,
                  builder: (_) => CupertinoAlertDialog(
                    title: Text('Are you sure ?'),
                    actions: [
                      CupertinoDialogAction(
                        child: Text("Yes"),
                        onPressed: () async {
                          Get.back();
                          EasyLoading.show(
                            status: 'loading...',
                            maskType: EasyLoadingMaskType.black,
                          );
                          var uploadFileResult =
                              await firebaseController.deleteFile(
                                  fileName: name, file: file, urlDownload: url);
                          if (uploadFileResult) {
                            EasyLoading.dismiss();
                            Get.snackbar(
                                "Remove Documnet", "Remove Successfully");
                          } else {
                            EasyLoading.dismiss();
                            Get.snackbar("Error", "Something Wrong");
                          }
                        },
                      ),
                      CupertinoDialogAction(
                        child: Text("No"),
                        onPressed: () {
                          Get.back();
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
