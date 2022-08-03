import 'package:flutter/material.dart';
import 'package:myvcv/models/models.dart';

class AboutUsWidget extends StatelessWidget {
  final AboutUsModel aboutus;
  // final String description;
  const AboutUsWidget({
    Key? key,
    required this.aboutus,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: SizedBox(
            width: 250,
            child: Center(
                child: Text(aboutus.description,
                    style: TextStyle(fontSize: 20)))));
  }
}
