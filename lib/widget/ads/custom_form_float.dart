import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myvcv/screens/screens.dart';

class CustomFloatingRecroterForm extends StatelessWidget {
  const CustomFloatingRecroterForm({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        Get.to(AdsPageRecruiterForm());
      },
      child: const Icon(
        Icons.add,
        size: 40,
        color: Colors.white,
      ),
      backgroundColor: const Color(0xFF0A6077),
    );
  }
}
