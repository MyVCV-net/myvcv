// import 'package:flutter/material.dart';
// import 'package:myvcv/screens/jobs/job_desc.dart';
// import 'package:myvcv/widget/general/video_page_player.dart';
// import 'package:myvcv/screens/screens.dart';

// class AppRouter {
//   static Route onGenerateRoute(RouteSettings settings) {
//     // print('Route: ${settings.name}');
//     switch (settings.name) {
//       case '/':
//         return HomePage.route();
//       case VideoPagePlayer.routeName:
//         return VideoPagePlayer.route(videoPlayerController: settings.arguments);
//       case AdsPage.routeName:
//         return AdsPage.route();
//       case AdsPageRecruiterForm.routeName:
//         return AdsPageRecruiterForm.route();
//       case JobSeekerPage.routeName:
//         return JobSeekerPage.route();
//       case LoginPage.routeName:
//         return LoginPage.route();
//       case RecruitersPage.routeName:
//         return RecruitersPage.route();
//       case SignUpPage.routeName:
//         return SignUpPage.route();
//       case ChatPage.routeName:
//         return ChatPage.route();
//       case MessagesPage.routeName:
//         return MessagesPage.route();
//       case JobsPage.routeName:
//         return JobsPage.route();
//       case AboutUsPage.routeName:
//         return AboutUsPage.route();
//       case MyNetworkPage.routeName:
//         return MyNetworkPage.route();
//       case NotificationPage.routeName:
//         return NotificationPage.route();
//       case ProfilePage.routeName:
//         return ProfilePage.route();
//       case SearchPage.routeName:
//         return SearchPage.route();
//       case MyProfilePage.routeName:
//         return MyProfilePage.route();
//       case JobDesc.routeName:
//         return JobDesc.route();
//       case SettingsPage.routeName:
//         return SettingsPage.route();
//       case EditProfile.routeName:
//         return EditProfile.route();
//       default:
//         return _errorRoute();
//     }
//   }

//   static Route _errorRoute() {
//     return MaterialPageRoute(
//       settings: const RouteSettings(name: '/error'),
//       builder: (_) => Scaffold(
//         appBar: AppBar(
//           title: const Text('Error'),
//         ),
//         body: const Center(
//           child: Text('Something went wrong!'),
//         ),
//       ),
//     );
//   }
// }
