// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:stocks_news_new/utils/colors.dart';
// import 'package:stocks_news_new/utils/constants.dart';
// import 'package:stocks_news_new/utils/theme.dart';
// import 'package:stocks_news_new/widgets/spacer_verticle.dart';

// class HomeGradientBox extends StatelessWidget {
//   final String name;
//   final String value;
//   final String valueChanged;
//   final String valueChangedPer;
//   final bool positive;
//   final int type;

//   const HomeGradientBox({
//     required this.name,
//     required this.value,
//     required this.valueChanged,
//     required this.valueChangedPer,
//     this.positive = false,
//     this.type = 1,
//     super.key,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Expanded(
//       child: Container(
//         decoration: BoxDecoration(
//           border: Border.all(color: ThemeColors.greyBorder),
//           borderRadius: BorderRadius.circular(Dimen.radius.r),
//           gradient: LinearGradient(
//             colors: const [ThemeColors.gradientDark, ThemeColors.gradientLight],
//             begin: type == 1
//                 ? Alignment.topLeft
//                 : type == 2
//                     ? Alignment.topRight
//                     : type == 3
//                         ? Alignment.bottomLeft
//                         : Alignment.bottomRight,
//             end: type == 1
//                 ? Alignment.bottomRight
//                 : type == 2
//                     ? Alignment.bottomLeft
//                     : type == 3
//                         ? Alignment.topRight
//                         : Alignment.topLeft,
//           ),
//         ),
//         padding: EdgeInsets.all(8.sp),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(name, style: stylePTSansBold()),
//             const SpacerVerticel(height: 12),
//             Row(
//               crossAxisAlignment: CrossAxisAlignment.end,
//               children: [
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(value, style: stylePTSansBold()),
//                       const SpacerVerticel(height: 3),
//                       Text(
//                         "$valueChanged ($valueChangedPer)",
//                         style: stylePTSansBold(
//                           color: positive ? Colors.green : Colors.red,
//                           fontSize: 12,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 Container(
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(5.r),
//                     color: positive
//                         ? ThemeColors.transparentGreen
//                         : ThemeColors.transparentRed,
//                   ),
//                   margin: EdgeInsets.only(left: 8.sp),
//                   padding: const EdgeInsets.all(3),
//                   child: Icon(
//                     positive
//                         ? Icons.arrow_upward_rounded
//                         : Icons.arrow_downward_rounded,
//                     color: positive
//                         ? ThemeColors.lightGreen
//                         : ThemeColors.lightRed,
//                     size: 20.sp,
//                   ),
//                 )
//               ],
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
