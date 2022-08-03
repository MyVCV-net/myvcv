// import 'package:flutter/material.dart';
// import 'package:myvcv/models/models.dart';
// import 'package:myvcv/widget/widgets.dart';

// class MyNetworkCompanyWidget extends StatelessWidget {
//   const MyNetworkCompanyWidget({
//     Key? key,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: 280,
//       child: ListView.separated(
//         scrollDirection: Axis.horizontal,
//         separatorBuilder: (context, intt) =>
//             const SizedBox(height: 0, width: 0),
//         itemCount: CompaniesModel.companiesModel.length,
//         itemBuilder: (context, index) {
//           return VideoImageWidget(
//             videoImageUrl: CompaniesModel.companiesModel[index].videoImageUrl,
//             userImageUrl: CompaniesModel.companiesModel[index].userImageUrl,
//             username: CompaniesModel.companiesModel[index].username,
//             userId: CompaniesModel.companiesModel[index].userId,
//             videoUrl: CompaniesModel.companiesModel[index].videoUrl,
//           );
//         },
//       ),
//     );
//   }
// }
