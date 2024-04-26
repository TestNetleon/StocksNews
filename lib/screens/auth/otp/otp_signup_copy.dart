// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:stocks_news_new/modals/user_res.dart';
// import 'package:stocks_news_new/providers/user_provider.dart';
// import 'package:stocks_news_new/utils/colors.dart';
// import 'package:stocks_news_new/utils/constants.dart';
// import 'package:stocks_news_new/utils/theme.dart';
// import 'package:stocks_news_new/utils/utils.dart';
// import 'package:stocks_news_new/widgets/base_container.dart';
// import 'package:stocks_news_new/widgets/colored_text.dart';
// import 'package:stocks_news_new/widgets/rounded_pinput.dart';
// import 'package:stocks_news_new/widgets/spacer_verticle.dart';
// import 'package:stocks_news_new/widgets/theme_button.dart';

// class OTPSignup extends StatefulWidget {
//   static const String path = "OTPSignup";

//   const OTPSignup({super.key});

//   @override
//   State<OTPSignup> createState() => _OTPSignupState();
// }

// class _OTPSignupState extends State<OTPSignup> {
//   final TextEditingController _emailOtpcontroller = TextEditingController();
//   final TextEditingController _phoneOtpcontroller = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
//       UserRes? user = context.read<UserProvider>().user;
//       _emailOtpcontroller.text = "${user?.emailOtp}";
//       _phoneOtpcontroller.text = "${user?.phoneOtp}";
//     });
//   }

//   @override
//   void dispose() {
//     _emailOtpcontroller.dispose();
//     _phoneOtpcontroller.dispose();
//     super.dispose();
//   }

//   void _onVeryClick() {
//     closeKeyboard();
//     UserProvider provider = context.read<UserProvider>();

//     Map request = {
//       "email": provider.user?.email,
//       "email_otp": _emailOtpcontroller.text,
//       "phone": provider.user?.phone,
//       "phone_otp": _phoneOtpcontroller.text,
//     };

//     provider.verifySignupOtp(request);
//   }

//   void _onResendEmailOtpClick() {
//     closeKeyboard();
//     UserProvider provider = context.read<UserProvider>();
//     Map request = {
//       "username": provider.user?.email,
//       "type": "email",
//     };
//     provider.resendOtp(request);
//   }

//   void _onResendPhoneOtpClick() {
//     closeKeyboard();
//     UserProvider provider = context.read<UserProvider>();
//     Map request = {
//       "username": provider.user?.phone,
//       "type": "phone",
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
//                 children: [
//                   const SpacerVerticel(height: 16),
//                   Text(
//                     "Validate Email Address",
//                     style: stylePTSansBold(fontSize: 22),
//                   ),
//                   const SpacerVerticel(height: 8),
//                   Text(
//                     "We have sent an OTP to your email address",
//                     style: stylePTSansRegular(
//                       fontSize: 12,
//                       color: ThemeColors.greyText,
//                     ),
//                   ),
//                   const SpacerVerticel(height: 8),
//                   InputOTP(
//                     pinController: _emailOtpcontroller,
//                     focusNode: FocusNode(),
//                   ),
//                   const SpacerVerticel(height: 12),
//                   Align(
//                     alignment: Alignment.centerRight,
//                     child: TextButton(
//                       onPressed: _onResendEmailOtpClick,
//                       child: Text(
//                         "Resend",
//                         style: stylePTSansBold(
//                           fontSize: 14,
//                           color: ThemeColors.accent,
//                         ),
//                       ),
//                     ),
//                   ),
//                   const SpacerVerticel(height: 30),
//                   Text(
//                     "Validate Phone Number",
//                     style: stylePTSansBold(fontSize: 22),
//                   ),
//                   const SpacerVerticel(height: 8),
//                   Text(
//                     "We have sent an OTP to your phone number",
//                     style: stylePTSansRegular(
//                         fontSize: 12, color: ThemeColors.greyText),
//                   ),
//                   const SpacerVerticel(height: 8),
//                   InputOTP(
//                     pinController: _phoneOtpcontroller,
//                     focusNode: FocusNode(),
//                   ),
//                   const SpacerVerticel(height: 12),
//                   Align(
//                     alignment: Alignment.centerRight,
//                     child: TextButton(
//                       onPressed: _onResendPhoneOtpClick,
//                       child: Text(
//                         "Resend",
//                         style: stylePTSansBold(
//                           fontSize: 14,
//                           color: ThemeColors.accent,
//                         ),
//                       ),
//                     ),
//                   ),
//                   const SpacerVerticel(height: 40),
//                   ThemeButton(
//                     onPressed: _onVeryClick,
//                     text: "Verify",
//                   ),
//                   const SpacerVerticel(),
//                   Text(
//                     "Code not received?",
//                     style: stylePTSansRegular(
//                       fontSize: 14,
//                       color: ThemeColors.greyText,
//                     ),
//                   ),
//                   // const SpacerVerticel(height: Dimen.itemSpacing),
//                   TextButton(
//                     onPressed: () {
//                       Navigator.pop(context);
//                     },
//                     child: ColoredText(
//                       text: "Change Email Address & Number",
//                       coloredLetters: const [
//                         "C",
//                         "h",
//                         "a",
//                         "n",
//                         "g",
//                         "e",
//                         "E",
//                         "m",
//                         "i",
//                         "l",
//                         "A",
//                         "d",
//                         "r",
//                         "s",
//                         "N",
//                         "u",
//                         "b"
//                       ],
//                       color: ThemeColors.accent,
//                       style: stylePTSansBold(fontSize: 14),
//                     ),
//                   )
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
