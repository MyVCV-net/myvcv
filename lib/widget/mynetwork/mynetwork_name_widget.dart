import 'package:flutter/material.dart';

class NameWidget extends StatelessWidget {
  final String title;
  const NameWidget({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10),
      child: Row(
        children: [
          Text(title,
              style: TextStyle(
                  color: Color(0xFF0A6077),
                  fontSize: 25,
                  fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
