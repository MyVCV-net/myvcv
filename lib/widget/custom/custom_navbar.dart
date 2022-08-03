import 'package:dot_navigation_bar/dot_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myvcv/screens/screens.dart';

class NavBar extends StatelessWidget {
  final int screen;

  const NavBar({Key? key, required this.screen}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> screenList = <Widget>[
      HomePage(),
      MyNetworkPage(),
      JobsPage(),
      AdsPage(),
      NotificationPage(),
      ProfilePage()
    ];

    void _handleIndexChanged(int i) {
      // Navigator.pushReplacement(
      //   context,
      //   PageRouteBuilder(
      //     pageBuilder: (context, animation1, animation2) => screenList[i],
      //     transitionDuration: Duration.zero,
      //   ),
      // );
      Get.off(screenList[i], duration: Duration.zero);
    }

    return DotNavigationBar(
      marginR: EdgeInsets.symmetric(horizontal: 30, vertical: 0),
      boxShadow: [
        BoxShadow(
          color: Theme.of(context).iconTheme.color!.withOpacity(0.2),
          blurRadius: 1,
        )
      ],
      unselectedItemColor: Theme.of(context).iconTheme.color!.withOpacity(0.5),
      itemPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      currentIndex: screen,
      onTap: _handleIndexChanged,
      paddingR: const EdgeInsets.symmetric(vertical: 7, horizontal: 10),
      backgroundColor: Theme.of(context).primaryColor,
      items: [
        /// Home
        DotNavigationBarItem(
          icon:
              Icon(Icons.home, size: MediaQuery.of(context).size.width * 0.05),
          selectedColor: Theme.of(context).iconTheme.color,
        ),

        /// MyNetwork
        DotNavigationBarItem(
          icon: Icon(Icons.group_outlined,
              size: MediaQuery.of(context).size.width * 0.05),
          selectedColor: Theme.of(context).iconTheme.color,
        ),

        /// Jobs
        DotNavigationBarItem(
          icon: Icon(Icons.home_repair_service_outlined,
              size: MediaQuery.of(context).size.width * 0.05),
          selectedColor: Theme.of(context).iconTheme.color,
        ),

        /// Ads
        DotNavigationBarItem(
          icon: Icon(Icons.grid_view_rounded,
              size: MediaQuery.of(context).size.width * 0.05),
          selectedColor: Theme.of(context).iconTheme.color,
        ),

        /// Notifications
        DotNavigationBarItem(
          icon: Icon(Icons.notifications,
              size: MediaQuery.of(context).size.width * 0.05),
          selectedColor: Theme.of(context).iconTheme.color,
        ),

        /// Profile
        DotNavigationBarItem(
          icon: Icon(Icons.person,
              size: MediaQuery.of(context).size.width * 0.05),
          selectedColor: Theme.of(context).iconTheme.color,
        ),
      ],
    );
  }
}
