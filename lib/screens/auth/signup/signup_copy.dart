// // ignore_for_file: avoid_print

// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:provider/provider.dart';
// import 'package:stocks_news_new/providers/user_provider.dart';
// import 'package:stocks_news_new/utils/colors.dart';
// import 'package:stocks_news_new/utils/constants.dart';
//  
// import 'package:stocks_news_new/utils/theme.dart';
// import 'package:stocks_news_new/utils/utils.dart';
// import 'package:stocks_news_new/utils/validations.dart';
// import 'package:stocks_news_new/widgets/base_container.dart';
// import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
// import 'package:stocks_news_new/widgets/spacer_vertical.dart';
// import 'package:stocks_news_new/widgets/theme_button.dart';
// import 'package:stocks_news_new/widgets/theme_button_outline.dart';
// import 'package:stocks_news_new/widgets/theme_input_field.dart';
// import 'package:validators/validators.dart';
//
// class SignUp extends StatefulWidget {
//   static const String path = "SignUp";

//   const SignUp({super.key});

//   @override
//   State<SignUp> createState() => _SignUpState();
// }

// class _SignUpState extends State<SignUp> {
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _phoneController = TextEditingController();

//   final GoogleSignIn _googleSignIn = GoogleSignIn();
//   // You can add Firebase Authentication here if needed

//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
//       _emailController.text = "email801@gmail.com";
//       _phoneController.text = "8000000001";
//     });
//   }

//   void _onSignupClick() {
//     closeKeyboard();
//     if (!isEmail(_emailController.text)) {
//       showErrorMessage(message: "Please enter valid email address");
//       return;
//     } else if (isEmpty(_phoneController.text)) {
//       showErrorMessage(message: "Please enter valid phone number");
//       return;
//     }
//     UserProvider provider = context.read<UserProvider>();
//     Map request = {
//       "phone": _phoneController.text,
//       "email": _emailController.text
//     };
//     provider.signup(request);
//   }

//   void _handleSignIn() async {
//     if (await _googleSignIn.isSignedIn()) {
//       print("Already Signed In *******");
//       await _googleSignIn.signOut();
//       print("Signed out *******");
//     }

//     try {
//       print("Signed In ******* ##");
//       GoogleSignInAccount? account = await _googleSignIn.signIn();
//       print("Signed In *******");
//       print(account.toString());
//     } catch (error) {
//       print("Error in Signed In *******");
//       print(error);
//     }
//   }

//   @override
//   void dispose() {
//     _emailController.dispose();
//     _phoneController.dispose();
//     super.dispose();
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
//                   const SpacerVertical(height: 16),
//                   Text(
//                     "Sign Up",
//                     style: stylePTSansBold(fontSize: 24),
//                   ),
//                   const SpacerVertical(height: 40),
//                   ThemeInputField(
//                     controller: _emailController,
//                     placeholder: "Enter your email address",
//                     keyboardType: TextInputType.emailAddress,
//                     inputFormatters: [emailFormatter],
//                   ),
//                   const SpacerVertical(height: Dimen.itemSpacing),
//                   ThemeInputField(
//                     controller: _phoneController,
//                     placeholder: "Enter phone number",
//                     keyboardType: TextInputType.phone,
//                     inputFormatters: [mobilrNumberAllow],
//                     maxLength: 15,
//                   ),
//                   const SpacerVertical(height: Dimen.itemSpacing),
//                   ThemeButton(
//                     onPressed: _onSignupClick,
//                     text: "Sign Up",
//                   ),
//                   const SpacerVertical(),
//                   Text(
//                     "Already have an account?",
//                     style: stylePTSansRegular(
//                       fontSize: 14,
//                       color: ThemeColors.greyText,
//                     ),
//                   ),
//                   const SpacerVertical(height: Dimen.itemSpacing),
//                   ThemeButtonOutlined(
//                     onPressed: () {
//                       Navigator.pop(context);
//                     },
//                     text: "Login",
//                     textStyle: stylePTSansBold(),
//                   ),
//                   const SpacerVertical(height: Dimen.itemSpacing),
//                   ThemeButton(
//                     onPressed: () async {
//                       _handleSignIn();
//                     },
//                     // text: "Continue with Google",
//                     // textStyle: stylePTSansBold(),
//                     color: ThemeColors.primaryLight,
//                     padding: EdgeInsets.symmetric(
//                       vertical: 12.sp,
//                       horizontal: 15.sp,
//                     ),
//                     child: Row(
//                       children: [
//                         Image.asset(
//                           Images.google,
//                           width: 20.sp,
//                           height: 20.sp,
//                         ),
//                         const SpacerHorizontal(width: Dimen.itemSpacing),
//                         Text(
//                           "Continue with Google",
//                           style: stylePTSansBold(),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
