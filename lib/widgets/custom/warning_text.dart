// import 'package:flutter/material.dart';

// import '../../utils/colors.dart';
// import '../../utils/theme.dart';
// import '../spacer_vertical.dart';

// class WarningTextOnLock extends StatelessWidget {
//   final String? warningText;
//   const WarningTextOnLock({super.key, this.warningText});

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         if (warningText != null && warningText != '')
//           Container(
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(8),
//               border: Border.all(
//                 color: ThemeColors.greyBorder,
//                 width: 3,
//               ),
//             ),
//             padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
//             margin: EdgeInsets.symmetric(vertical: 10),
//             child: Text(
//               "$warningText",
//               style: styleBaseRegular(
//                 color: ThemeColors.greyText,
//                 fontSize: 14,
//                 height: 1.3,
//                 fontStyle: FontStyle.italic,
//               ),
//               textAlign: TextAlign.center,
//             ),
//           ),
//         if (warningText == null || warningText == '')
//           SpacerVertical(height: 50),
//       ],
//     );
//   }
// }
