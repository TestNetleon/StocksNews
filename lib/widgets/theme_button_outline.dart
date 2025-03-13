// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:stocks_news_new/utils/colors.dart';
// import 'package:stocks_news_new/utils/constants.dart';
// import 'package:stocks_news_new/utils/theme.dart';

// //
// class ThemeButtonOutlined extends StatelessWidget {
//   const ThemeButtonOutlined({
//     required this.onPressed,
//     this.text = "Submit",
//     this.borderColor = ThemeColors.accent,
//     this.textColor = Colors.white,
//     this.textSize = 18,
//     this.fullWidth = false,
//     this.radius = Dimen.radius,
//     this.fontBold = true,
//     this.elevation = 2,
//     this.padding,
//     this.margin,
//     this.textStyle,
//     this.textAlign = TextAlign.center,
//     super.key,
//   });

//   final String text;
//   final Color? borderColor;
//   final Color textColor;
//   final Function onPressed;
//   final double textSize;
//   final double radius;
//   final bool fullWidth, fontBold;
//   final double elevation;
//   final EdgeInsets? padding, margin;
//   final TextAlign? textAlign;
//   final TextStyle? textStyle;

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.symmetric(horizontal: 1.sp),
//       child: ElevatedButton(
//         onPressed: () => onPressed(),
//         style: ElevatedButton.styleFrom(
//           backgroundColor: Colors.transparent,
//           elevation: 0,
//           minimumSize: const Size.fromHeight(45),
//           padding: padding ??
//               EdgeInsets.symmetric(horizontal: 16.sp, vertical: 8.sp),
//           // (fullWidth
//           //     ? EdgeInsets.symmetric(horizontal: 16.sp, vertical: 10.sp)
//           //     : EdgeInsets.symmetric(horizontal: 5.sp, vertical: 5.sp)),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(radius.sp),
//             side: BorderSide(
//               color: borderColor ?? Colors.transparent,
//               width: 1.sp,
//             ),
//           ),
//         ),
//         child: Text(
//           textAlign: textAlign,
//           text,
//           style: fontBold
//               ? textStyle ??
//                   styleBaseBold(
//                     fontSize: textSize,
//                     color: textColor,
//                   )
//               : textStyle ??
//                   styleBaseRegular(
//                     fontSize: textSize,
//                     color: textColor,
//                   ),
//         ),
//       ),
//     );
//   }
// }
