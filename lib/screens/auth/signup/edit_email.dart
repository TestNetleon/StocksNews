// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:provider/provider.dart';
// import 'package:stocks_news_new/providers/user_provider.dart';
// import 'package:stocks_news_new/routes/my_app.dart';
// import 'package:stocks_news_new/utils/colors.dart';
// import 'package:stocks_news_new/utils/theme.dart';
// import 'package:stocks_news_new/widgets/custom/alert_popup.dart';
// import 'package:stocks_news_new/widgets/spacer_vertical.dart';
// import 'package:validators/validators.dart';
// import '../../../utils/constants.dart';
// import '../../../utils/validations.dart';
// import '../../../widgets/theme_button.dart';
// import '../../../widgets/theme_input_field.dart';

// class EditEmail extends StatelessWidget {
//   final String email;
//   final int digit;
//   const EditEmail({
//     super.key,
//     required this.email,
//     this.digit = 4,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return RichText(
//       textAlign: TextAlign.center,
//       text: TextSpan(
//         children: [
//           TextSpan(
//             text: email,
//             style: styleBaseRegular(
//               color: ThemeColors.accent,
//               height: 1.4,
//             ),
//           ),
//           TextSpan(
//             text: " ",
//             style: styleBaseRegular(
//               height: 1.4,
//             ),
//           ),
//           TextSpan(
//             text: "\n The code is valid for 10 minutes.",
//             style: styleBaseRegular(
//               height: 1.5,
//             ),
//           ),
//         ],
//         text: "Please enter the $digit-digit code sent to ",
//         style: styleBaseRegular(
//           height: 1.5,
//         ),
//       ),
//     );
//   }
// }

// class EditEmailClick extends StatefulWidget {
//   final String email;
//   final String? state;
//   final String? dontPop;
//   final bool fromLoginOTP;

//   const EditEmailClick({
//     super.key,
//     required this.email,
//     this.fromLoginOTP = true,
//     this.state,
//     this.dontPop,
//   });

//   @override
//   State<EditEmailClick> createState() => _EditEmailClickState();
// }

// class _EditEmailClickState extends State<EditEmailClick> {
//   final TextEditingController _controller = TextEditingController();

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     UserProvider provider = context.watch<UserProvider>();
//     return Column(
//       children: [
//         Visibility(
//           visible: !widget.fromLoginOTP,
//           child: RichText(
//             textAlign: TextAlign.center,
//             text: TextSpan(
//               children: [
//                 TextSpan(
//                   text: widget.email,
//                   style: styleBaseRegular(color: ThemeColors.accent),
//                 ),
//                 TextSpan(
//                   text: " is not your email address, click here to edit it.",
//                   style: styleBaseRegular(),
//                 ),
//               ],
//               text: "If ",
//               style: styleBaseRegular(),
//             ),
//           ),
//         ),
//         const SpacerVertical(
//           height: 16,
//         ),
//         Visibility(
//           visible: !widget.fromLoginOTP,
//           child: ElevatedButton(
//             style: ElevatedButton.styleFrom(
//               backgroundColor: const Color.fromARGB(255, 53, 125, 62),
//               padding: EdgeInsets.symmetric(horizontal: 10.sp),
//               maximumSize: Size(200.sp, 30.sp),
//               minimumSize: Size(60.sp, 28.sp),
//             ),
//             onPressed: () {
//               _openEditSheet(controller: _controller, provider: provider);
//             },
//             child: Text(
//               "Edit Email Address",
//               style: styleBaseRegular(fontSize: 13),
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   void _openEditSheet(
//       {TextEditingController? controller, required UserProvider provider}) {
//     controller?.clear();
//     showModalBottomSheet(
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.only(
//           topLeft: Radius.circular(5.sp),
//           topRight: Radius.circular(5.sp),
//         ),
//       ),
//       backgroundColor: ThemeColors.transparent,
//       isScrollControlled: true,
//       context: navigatorKey.currentContext!,
//       builder: (context) {
//         return Padding(
//           padding:
//               EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
//           child: Container(
//             padding: const EdgeInsets.only(bottom: 30),
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.only(
//                 topLeft: Radius.circular(10.sp),
//                 topRight: Radius.circular(10.sp),
//               ),
//               gradient: const LinearGradient(
//                 begin: Alignment.topCenter,
//                 end: Alignment.bottomCenter,
//                 colors: [ThemeColors.bottomsheetGradient, Colors.black],
//               ),
//               color: ThemeColors.background,
//               border: const Border(
//                 top: BorderSide(color: ThemeColors.greyBorder),
//               ),
//             ),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 Container(
//                   height: 6.sp,
//                   width: 50.sp,
//                   margin: EdgeInsets.only(top: 8.sp),
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(10.sp),
//                     color: ThemeColors.greyBorder,
//                   ),
//                 ),
//                 const SpacerVertical(height: 16),
//                 Padding(
//                   padding: EdgeInsets.symmetric(horizontal: 10.sp),
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const SpacerVertical(),
//                       Text(
//                         // "NEW EMAIL ADDRESS",
//                         "New Email Address",
//                         style: styleBaseBold(fontSize: 22),
//                       ),
//                       const SpacerVertical(height: 20),
//                       ThemeInputField(
//                         controller: controller,
//                         placeholder: "Enter new email address",
//                         keyboardType: TextInputType.emailAddress,
//                         inputFormatters: [emailFormatter],
//                         textCapitalization: TextCapitalization.none,
//                       ),
//                       const SpacerVertical(height: Dimen.itemSpacing),
//                       ThemeButton(
//                         text: "Send OTP",
//                         onPressed: _onPressed,
//                       ),
//                       const SpacerVertical(),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }

//   void _onPressed() {
//     UserProvider provider = context.read<UserProvider>();
//     if (!isEmail(_controller.text) && !isNumeric(_controller.text)) {
//       // showErrorMessage(
//       //   duration: 10,
//       //   snackbar: false,
//       //   message: "Please enter valid email address",
//       // );

//       popUpAlert(
//           message: "Please enter valid email address.",
//           title: "Alert",
//           icon: Images.alertPopGIF);

//       return;
//     }
//     if (widget.fromLoginOTP) {
//       Map request = {
//         "username": _controller.text.toLowerCase(),
//         "type": "email",
//       };
//       provider.login(request, editEmail: true);
//     } else {
//       Map request = {"username": _controller.text.toLowerCase()};

//       provider.signup(request, editEmail: true);
//     }
//     _controller.clear();
//   }
// }
