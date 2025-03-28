// import 'package:flutter/material.dart';
// import 'package:stocks_news_new/utils/colors.dart';

// //
// class ThemeAlertDialog extends StatelessWidget {
//   final List<Widget> children;
//   final EdgeInsets? contentPadding;
//   final EdgeInsets? insetPadding;
//   const ThemeAlertDialog({
//     super.key,
//     this.children = const <Widget>[],
//     this.contentPadding,
//     this.insetPadding,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       insetPadding:
//           insetPadding ?? EdgeInsets.symmetric(horizontal: 35, vertical: 20),
//       shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(10),
//           side: BorderSide(
//               color: ThemeColors.greyText.withOpacity(0.5), width: 2)),
//       elevation: 5,
//       // backgroundColor: ThemeColors.primaryLight,
//       contentPadding: EdgeInsets.zero,
//       content: Container(
//         decoration: const BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//             colors: [
//               Color.fromARGB(255, 23, 23, 23),
//               // ThemeColors.greyBorder,
//               Color.fromARGB(255, 48, 48, 48),
//             ],
//           ),
//         ),
//         padding: contentPadding ?? EdgeInsets.fromLTRB(18, 16, 18, 10),
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             mainAxisSize: MainAxisSize.min,
//             children: children,
//           ),
//         ),
//       ),
//     );
//   }
// }
