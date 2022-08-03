// import 'package:flutter/material.dart';
// import 'package:myvcv/models/models.dart';
// import 'package:myvcv/widget/widgets.dart';

// class MyNetworkProfileWidget extends StatelessWidget {
//   const MyNetworkProfileWidget({
//     Key? key,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Expanded(
//       child: GridView.builder(
//         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//             crossAxisCount: 2, childAspectRatio: 0.76),
//         itemCount: MyNetworkModel.mynetworkList.length,
//         itemBuilder: (context, index) {
//           return VideoImageWidget(
//             videoImageUrl: MyNetworkModel.mynetworkList[index].videoImageUrl,
//             userImageUrl: MyNetworkModel.mynetworkList[index].userImageUrl,
//             username: MyNetworkModel.mynetworkList[index].username,
//             userId: MyNetworkModel.mynetworkList[index].userId,
//             videoUrl: MyNetworkModel.mynetworkList[index].videoUrl,
//           );
//         },
//       ),
//     );
//   }
// }
