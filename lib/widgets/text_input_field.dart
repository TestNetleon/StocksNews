// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';

// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:stocks_news_new/utils/colors.dart';
// import 'package:stocks_news_new/utils/theme.dart';

// //
// class TextInputField extends StatelessWidget {
//   const TextInputField({
//     required this.controller,
//     this.onTap,
//     this.keyboardType = TextInputType.name,
//     this.prifix = false,
//     this.maxLength = 40,
//     this.minLines = 1,
//     this.editable = true,
//     this.shadow = true,
//     this.filled = false,
//     this.onButtonClick,
//     this.borderColor,
//     this.contentPadding,
//     this.style,
//     this.hintStyle,
//     this.textCapitalization = TextCapitalization.sentences,
//     this.hintText,
//     this.onChanged,
//     this.suffix,
//     this.inputFormatters,
//     super.key,
//   });

//   final TextEditingController controller;
//   final bool prifix;
//   final Widget? suffix;
//   final TextInputType keyboardType;
//   final int maxLength;
//   final int minLines;
//   final EdgeInsets? contentPadding;
//   final bool editable;
//   final bool shadow;
//   final bool filled;
//   final TextStyle? style, hintStyle;
//   final Color? borderColor;
//   final TextCapitalization textCapitalization;
//   final Function()? onButtonClick, onTap;
//   final String? hintText;
//   final Function(String)? onChanged;
//   final List<TextInputFormatter>? inputFormatters;

//   Widget _prefix({EdgeInsets? padding}) {
//     return Padding(
//       padding: padding ??
//           EdgeInsets.only(
//             left: !shadow && Platform.isIOS ? 12.sp : 8.sp,
//             right: 8.sp,
//           ),
//       child: Text(
//         '+91',
//         style: style ?? styleBaseBold(fontSize: 15),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     var outlineInputBorder = OutlineInputBorder(
//       borderRadius: BorderRadius.circular(6),
//       borderSide: BorderSide(
//         color: borderColor ?? ThemeColors.border,
//         width: 1,
//       ),
//     );
//     return Stack(
//       alignment: Alignment.centerLeft,
//       children: [
//         TextField(
//           onTap: onTap,
//           controller: controller,
//           keyboardType: keyboardType,
//           maxLength: maxLength,
//           minLines: minLines,
//           maxLines: minLines,
//           enabled: editable,
//           textCapitalization: textCapitalization,
//           style: style ?? styleBaseBold(fontSize: 16),
//           inputFormatters: inputFormatters,
//           decoration: InputDecoration(
//             suffixIcon: suffix,
//             hintText: hintText,
//             hintStyle: hintStyle ??
//                 styleBaseBold(
//                   fontSize: 15,
//                   color: ThemeColors.greyText,
//                 ),
//             constraints: BoxConstraints(
//               minHeight: 0,
//               maxHeight: minLines > 1 ? 150 : 50,
//             ),
//             contentPadding: contentPadding ??
//                 EdgeInsets.fromLTRB(
//                   prifix ? 45.sp : 12.sp,
//                   10.sp,
//                   onButtonClick != null ? 80.sp : 12.sp,
//                   10.sp,
//                 ),
//             filled: true,
//             fillColor: Colors.white,
//             enabledBorder: outlineInputBorder,
//             border: outlineInputBorder,
//             focusedBorder: outlineInputBorder,
//             counterText: '',
//           ),
//           onChanged: onChanged,
//         ),
//         prifix
//             ? _prefix(
//                 padding: EdgeInsets.fromLTRB(
//                 12.sp,
//                 10.sp,
//                 onButtonClick != null ? 80.sp : 12.sp,
//                 12.sp,
//               ))
//             : const SizedBox(),
//       ],
//     );
//   }
// }
