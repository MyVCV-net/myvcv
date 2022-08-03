import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:myvcv/repositories/auth/auth_controller.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:myvcv/repositories/firebase_controller.dart';

class ContantInfoBuilder extends StatelessWidget {
  const ContantInfoBuilder(
      {Key? key,
      required this.authController,
      required this.firebaseController})
      : super(key: key);

  final AuthController authController;
  final FirebaseController firebaseController;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: authController.user[0].contactInfoData.length * 60,
      child: ListView.builder(
        itemCount: authController.user[0].contactInfoData.length,
        itemBuilder: (BuildContext context, int index) => ContactCard(
          title: authController.user[0].contactInfoData[index].name,
          type: authController.user[0].contactInfoData[index].type,
          firebaseController: firebaseController,
        ),
      ),
    );
  }
}

class ContactCard extends StatelessWidget {
  final String title;
  final String type;
  const ContactCard(
      {Key? key,
      required this.title,
      required this.type,
      required this.firebaseController})
      : super(key: key);
  final FirebaseController firebaseController;
  @override
  Widget build(BuildContext context) {
    return ListTile(
        leading: Icon(
            type == 'phone'
                ? Icons.contact_phone
                : type == 'facebook'
                    ? Icons.facebook
                    : type == 'skype'
                        ? MdiIcons.skype
                        : type == 'twitter'
                            ? MdiIcons.twitter
                            : type == 'linkedIn'
                                ? MdiIcons.linkedin
                                : Icons.email,
            color: Color(0xFF0C6977),
            size: 40),
        title: Text(title),
        trailing: InkWell(
            onTap: () {
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
                        await firebaseController.removeContact(title, type);
                        EasyLoading.dismiss();
                      },
                    ),
                    CupertinoDialogAction(
                      child: Text("No"),
                      onPressed: () {
                        Get.back();
                      },
                    )
                  ],
                ),
              );
            },
            child: Icon(Icons.remove_circle)));
  }
}
