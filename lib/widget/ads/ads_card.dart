import 'package:flutter/material.dart';
import 'package:myvcv/repositories/auth/auth_controller.dart';

class AdsCard extends StatelessWidget {
  final String jobTitle;
  final String publishTime;
  final String appliedNumber;
  final AuthController authController;
  final bool status;
  const AdsCard(
      {Key? key,
      required this.jobTitle,
      required this.publishTime,
      required this.appliedNumber,
      required this.authController,
      required this.status})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: ListTile(
          title: Text(jobTitle, style: TextStyle(fontSize: 18)),
          subtitle: Text("Published at :  $publishTime",
              style: TextStyle(
                  color: Theme.of(context).iconTheme.color!.withOpacity(0.5),
                  fontSize: 12)),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: status ? Colors.green : Colors.blueGrey,
                  borderRadius: const BorderRadius.all(Radius.circular(15)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      // spreadRadius: 5,
                      blurRadius: 7,
                      offset: const Offset(2, 2), // changes position of shadow
                    ),
                  ],
                ),
                child: status
                    ? Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        child: Text(
                          "Published",
                          style: TextStyle(color: Colors.white),
                        ),
                      )
                    : Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        child: Text(
                          "Unpublished",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
              )
            ],
          ),
        ));
  }
}
