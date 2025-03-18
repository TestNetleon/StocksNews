// import 'package:flutter/material.dart';
// import 'package:stocks_news_new/utils/colors.dart';

// class MembershipButton extends StatelessWidget {
//   MembershipButton({super.key});

//   final kInnerDecoration = BoxDecoration(
//     color: ThemeColors.background,
//     border: Border.all(color: Colors.white),
//     borderRadius: const BorderRadius.only(
//       topRight: Radius.circular(16),
//       bottomLeft: Radius.circular(16),
//     ),
//   );

//   final kGradientBoxDecoration = BoxDecoration(
//     gradient: const LinearGradient(colors: [Colors.green, Colors.redAccent]),
//     border: Border.all(
//       color: ThemeColors.background,
//     ),
//     borderRadius: const BorderRadius.only(
//       topRight: Radius.circular(20),
//       bottomLeft: Radius.circular(20),
//     ),
//   );

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 66.0,
//       decoration: kGradientBoxDecoration,
//       child: Padding(
//         padding: const EdgeInsets.all(4.0),
//         child: Container(
//           decoration: kInnerDecoration,
//           child: const Text("Button Title with your style"),
//         ),
//       ),
//     );
//   }
// }
