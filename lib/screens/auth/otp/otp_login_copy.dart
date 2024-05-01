// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:stocks_news_new/modals/user_res.dart';
// import 'package:stocks_news_new/providers/user_provider.dart';

// import 'package:stocks_news_new/utils/colors.dart';
// import 'package:stocks_news_new/utils/constants.dart';
// import 'package:stocks_news_new/utils/theme.dart';
// import 'package:stocks_news_new/widgets/base_container.dart';
// import 'package:stocks_news_new/widgets/rounded_pinput.dart';
// import 'package:stocks_news_new/widgets/spacer_vertical.dart';
// import 'package:stocks_news_new/widgets/theme_button.dart';
// import 'package:validators/validators.dart';

// class OTPLogin extends StatefulWidget {
//   static const String path = "OTPLogin";
//
//   const OTPLogin({super.key});

//   @override
//   State<OTPLogin> createState() => _OTPLoginState();
// }

// class _OTPLoginState extends State<OTPLogin> {
//   final TextEditingController _controller = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
//       UserRes? user = context.read<UserProvider>().user;
//       _controller.text = "${user?.otp}";
//     });
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   void _onVeryClick() {
//     UserProvider provider = context.read<UserProvider>();

//     Map request = {
//       "username": provider.user?.username,
//       "type": isEmail(provider.user?.username ?? '') ? "email" : "phone",
//       "otp": _controller.text,
//     };

//     provider.verifyLoginOtp(request);
//   }

//   void _onResendOtpClick() {
//     UserProvider provider = context.read<UserProvider>();
//     Map request = {
//       "username": provider.user?.username,
//       "type": isEmail(provider.user?.username ?? '') ? "email" : "phone",
//     };
//     provider.resendOtp(request);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BaseContainer(
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             SizedBox(
//               width: MediaQuery.of(context).size.width * .45,
//               child: Image.asset(Images.logo),
//             ),
//             Padding(
//               padding: const EdgeInsets.all(Dimen.authScreenPadding),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   const SpacerVertical(height: 50),
//                   Text(
//                     "Validate OTP",
//                     style: stylePTSansBold(fontSize: 22),
//                   ),
//                   const SpacerVertical(height: 8),
//                   Text(
//                     "We have sent an OTP to your registered phone/email address",
//                     style: stylePTSansRegular(
//                         fontSize: 12, color: ThemeColors.greyText),
//                   ),
//                   const SpacerVertical(height: 8),
//                   InputOTP(
//                     pinController: _controller,
//                     focusNode: FocusNode(),
//                   ),
//                   const SpacerVertical(height: 12),
//                   Align(
//                     alignment: Alignment.centerRight,
//                     child: TextButton(
//                       onPressed: _onResendOtpClick,
//                       child: Text(
//                         "Resend",
//                         style: stylePTSansBold(
//                           fontSize: 14,
//                           color: ThemeColors.accent,
//                         ),
//                       ),
//                     ),
//                   ),
//                   const SpacerVertical(height: 30),
//                   ThemeButton(
//                     onPressed: _onVeryClick,
//                     text: "Verify",
//                   ),
//                   const SpacerVertical(),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
