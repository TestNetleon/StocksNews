// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:provider/provider.dart';
// import 'package:stocks_news_new/providers/user_provider.dart';
// // import 'package:stocks_news_new/screens/auth/otp/otp_login.dart';

// import 'package:stocks_news_new/utils/constants.dart';
//  
// import 'package:stocks_news_new/utils/theme.dart';
// import 'package:stocks_news_new/utils/utils.dart';
// import 'package:stocks_news_new/utils/validations.dart';
// import 'package:stocks_news_new/widgets/spacer_vertical.dart';
// import 'package:stocks_news_new/widgets/theme_button.dart';
// import 'package:stocks_news_new/widgets/theme_input_field.dart';
// import 'package:validators/validators.dart';

// import '../../../route/my_app.dart';
// import '../../../utils/colors.dart';

// createAccountSheet({
//   String? state,
//   String? dontPop,
// }) {
//   showModalBottomSheet(
//     shape: RoundedRectangleBorder(
//       borderRadius: BorderRadius.only(
//         topLeft: Radius.circular(5.sp),
//         topRight: Radius.circular(5.sp),
//       ),
//     ),
//     backgroundColor: ThemeColors.transparent,
//     isScrollControlled: true,
//     context: navigatorKey.currentContext!,
//     builder: (context) {
//       return const CreateAccountBottom();
//     },
//   );
// }

// class CreateAccountBottom extends StatefulWidget {
//   const CreateAccountBottom({super.key});

//   @override
//   State<CreateAccountBottom> createState() => _CreateAccountBottomState();
// }

// class _CreateAccountBottomState extends State<CreateAccountBottom> {
//   final TextEditingController _controller = TextEditingController();
//   // ignore: unused_field
//   final GoogleSignIn _googleSignIn = GoogleSignIn();

 

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       constraints: BoxConstraints(maxHeight: ScreenUtil().screenHeight - 30),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.only(
//             topLeft: Radius.circular(10.sp), topRight: Radius.circular(10.sp)),
//         gradient: const RadialGradient(
//           center: Alignment.bottomCenter,
//           radius: 0.6,
//           // transform: GradientRotation(radians),
//           // tileMode: TileMode.decal,
//           stops: [
//             0.0,
//             0.9,
//           ],
//           colors: [
//             Color.fromARGB(255, 0, 93, 12),
//             // ThemeColors.accent.withOpacity(0.1),
//             Colors.black,
//           ],
//         ),
//         color: ThemeColors.background,
//         border: const Border(
//           top: BorderSide(color: ThemeColors.greyBorder),
//         ),
//       ),
//       child: Column(
//         children: [
//           // Align(
//           //   alignment: Alignment.centerLeft,
//           //   child: InkWell(
//           //     onTap: () {
//           //       Navigator.pop(context);
//           //     },
//           //     borderRadius: BorderRadius.circular(30.sp),
//           //     child: Container(
//           //       padding: EdgeInsets.all(15.sp),
//           //       child: const Icon(Icons.arrow_back_ios_new_rounded),
//           //     ),
//           //   ),
//           // ),
//           Container(
//             height: 6.sp,
//             width: 50.sp,
//             margin: EdgeInsets.only(top: 8.sp),
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(10.sp),
//               color: ThemeColors.greyBorder,
//             ),
//           ),
//           const SpacerVertical(height: 16),
//           Container(
//             width: MediaQuery.of(context).size.width * .45,
//             constraints: BoxConstraints(maxHeight: kTextTabBarHeight - 2.sp),
//             child: Image.asset(
//               Images.logo,
//               fit: BoxFit.contain,
//             ),
//           ),
//           const SpacerVertical(height: 10),
//           Padding(
//             padding: const EdgeInsets.all(Dimen.authScreenPadding),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // const SpacerVertical(height: 16),
//                 Text(
//                   "CREATE ACCOUNT",
//                   style: stylePTSansBold(fontSize: 24),
//                 ),
//                 const SpacerVertical(height: 40),
                
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
