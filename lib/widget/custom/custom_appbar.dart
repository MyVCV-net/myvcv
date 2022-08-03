import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myvcv/screens/screens.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

//MyPrfileAdded Icon
// appBar: AppBar(
//   iconTheme: Theme.of(context).iconTheme,
//   centerTitle: false,
//   elevation: 0,
//   title:
//       Text(, style: TextStyle(color: Color(0xFF0A6077))),
//   actions: <Widget>[
//     IconButton(
//       icon: const Icon(Icons.person_outline),
//       onPressed: () {
//         Navigator.pushNamed(context, EditProfile.routeName);
//       },
//     ),
//   ],
// ),
class CustomAppBar extends StatelessWidget with PreferredSizeWidget {
  final String title;
  final bool searchIcon;
  final bool chatIcon;
  final bool profileIcon;
  final bool selectedColor;
  const CustomAppBar(
      {Key? key,
      required this.title,
      this.searchIcon = true,
      this.chatIcon = true,
      this.selectedColor = false,
      this.profileIcon = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      iconTheme: Theme.of(context).iconTheme,
      elevation: 0,
      backgroundColor: selectedColor
          ? Get.theme.primaryColor
          : Get.theme.appBarTheme.backgroundColor,
      title: title == ''
          ? SizedBox(width: 40, child: Image.asset('assets/Logo.png'))
          : Text(title, style: TextStyle(color: Color(0xFF0e91b5))),
      actions: <Widget>[
        searchIcon
            ? IconButton(
                icon: const Icon(Icons.search),
                tooltip: 'Search',
                onPressed: () {
                  Navigator.pushNamed(context, SearchPage.routeName);
                },
              )
            : Container(),
        // chatIcon
        //     ? IconButton(
        //         icon: const Icon(MdiIcons.chatOutline),
        //         tooltip: 'Chat',
        //         onPressed: () {
        //           Navigator.pushNamed(context, ChatPage.routeName);
        //         },
        //       )
        //     : Container(),
        profileIcon
            ? IconButton(
                icon: const Icon(Icons.person_outline),
                onPressed: () {
                  Navigator.pushNamed(context, EditProfile.routeName);
                },
              )
            : Container(),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(50);
}
