// import 'dart:async';

// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:stocks_news_new/providers/user_provider.dart';
// import 'package:stocks_news_new/routes/my_app.dart';
// import 'package:stocks_news_new/utils/colors.dart';
// import 'package:stocks_news_new/utils/constants.dart';
// import 'package:stocks_news_new/utils/theme.dart';
// import 'package:stocks_news_new/widgets/base_container.dart';
// import 'package:stocks_news_new/widgets/spacer_vertical.dart';
// import 'package:stocks_news_new/widgets/theme_button.dart';

// class SignUpSuccess extends StatelessWidget {
//   static const String path = "SignUpSuccess";

//   const SignUpSuccess({super.key});

//   @override
//   Widget build(BuildContext context) {
//     UserProvider userProvider = context.watch<UserProvider>();
//     return BaseContainer(
//       body: Column(
//         children: [
//           SizedBox(
//             width: MediaQuery.of(context).size.width * .45,
//             child: Image.asset(Images.logo),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(Dimen.authScreenPadding),
//             child: Column(
//               children: [
//                 const SpacerVertical(height: 16),
//                 Image.asset(Images.referSuccess),
//                 const SpacerVertical(),
//                 Text(
//                   userProvider.user?.signUpSuccessful ?? "SUCCESS",
//                   style: styleBaseBold(fontSize: 24),
//                 ),
//                 const SpacerVertical(height: Dimen.itemSpacing),
//                 Text(
//                   userProvider.user?.yourAccountHasBeenCreated ??
//                       "You have successfully registered to Stocks.news, please explore the best stock",
//                   style: styleBaseRegular(
//                     fontSize: 16,
//                     color: ThemeColors.white,
//                   ),
//                   textAlign: TextAlign.center,
//                 ),
//                 const SpacerVertical(),
//                 ThemeButton(
//                   onPressed: () {
//                     Navigator.popUntil(
//                         navigatorKey.currentContext!, (route) => route.isFirst);
//                     // Navigator.pushReplacement(
//                     //   navigatorKey.currentContext!,
//                     //   MaterialPageRoute(
//                     //     builder: (_) => const Tabs(
//                     //       showRef: false,
//                     //       showMembership: true,
//                     //     ),
//                     //   ),
//                     // );
//                     Timer(const Duration(seconds: 1), () {
//                       navigatorKey.currentContext!
//                           .read<UserProvider>()
//                           .user
//                           ?.signupStatus = false;
//                     });
//                   },
//                   // text: "Get Start",
//                   text: "GET START",
//                   // textStyle: styleBaseBold(),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
