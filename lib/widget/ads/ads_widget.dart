// import 'package:flutter/material.dart';
// import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
// import 'package:myvcv/models/ads/ads_model.dart';
// import 'ads_card.dart';

// class AdsWidget extends StatelessWidget {
//   const AdsWidget({
//     Key? key,
//     required this.isJobSeeker,
//   }) : super(key: key);

//   final bool isJobSeeker;

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(12.0),
//       child: StaggeredGridView.countBuilder(
//         crossAxisCount: 4,
//         itemCount: AdsModel.ads.length,
//         itemBuilder: (BuildContext context, int index) => AdsCard(
//             imageUrl: AdsModel.ads[index].imageUrl,
//             title: AdsModel.ads[index].title,
//             publishTime: AdsModel.ads[index].appliedAt,
//             statusType: AdsModel.ads[index].type),
//         staggeredTileBuilder: (int index) => StaggeredTile.count(4, 0.8),
//         mainAxisSpacing: 4.0,
//         crossAxisSpacing: 4.0,
//       ),
//     );
//   }
// }
