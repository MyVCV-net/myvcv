// import 'package:flutter/material.dart';
// import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
// import 'package:myvcv/models/models.dart';
// import 'package:myvcv/widget/widgets.dart';

// class NotificationWidget extends StatelessWidget {
//   const NotificationWidget({
//     Key? key,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(12.0),
//       child: StaggeredGridView.countBuilder(
//         crossAxisCount: 4,
//         itemCount: NotificationModel.notification.length,
//         itemBuilder: (BuildContext context, int index) => NotificationCard(
//           imageUrl: NotificationModel.notification[index].imageUrl,
//           username: NotificationModel.notification[index].username,
//           subtitle: NotificationModel.notification[index].subtitle,
//           time: NotificationModel.notification[index].time,
//         ),
//         staggeredTileBuilder: (int index) => StaggeredTile.count(4, 1),
//         mainAxisSpacing: 4.0,
//         crossAxisSpacing: 4.0,
//       ),
//     );
//   }
// }
