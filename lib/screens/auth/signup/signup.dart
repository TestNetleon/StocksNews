// // ignore_for_file: avoid_print, use_build_context_synchronously

// import 'dart:developer';
// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:provider/provider.dart';
// import 'package:sign_in_with_apple/sign_in_with_apple.dart';
// import 'package:stocks_news_new/providers/user_provider.dart';
// import 'package:stocks_news_new/screens/auth/createAccount/create_account.dart';
// import 'package:stocks_news_new/screens/tabs/home/widgets/app_bar_home.dart';
// // import 'package:stocks_news_new/screens/auth/otp/otp_login.dart';
// //
// import 'package:stocks_news_new/utils/colors.dart';
// import 'package:stocks_news_new/utils/constants.dart';
//  
// import 'package:stocks_news_new/utils/preference.dart';
// import 'package:stocks_news_new/utils/theme.dart';
// import 'package:stocks_news_new/utils/utils.dart';
// import 'package:stocks_news_new/widgets/base_container.dart';
// import 'package:stocks_news_new/widgets/spacer_vertical.dart';
// import 'package:stocks_news_new/widgets/theme_button.dart';

// import '../login/login.dart';

// class SignUp extends StatefulWidget {
//   final String? dntPop;
//   final String? state;
//   static const String path = "SignUp";

//   const SignUp({super.key, this.dntPop, this.state});

//   @override
//   State<SignUp> createState() => _SignUpState();
// }

// class _SignUpState extends State<SignUp> {
//   final TextEditingController _controller = TextEditingController();
//   final GoogleSignIn _googleSignIn = GoogleSignIn();

//   @override
//   void initState() {
//     super.initState();

//     log("---State is ${widget.state}, ---Dont pop up is${widget.dntPop}---");
//   }

//   // void _onLoginClick() {
//   //   closeKeyboard();
//   //   if (!isEmail(_controller.text) && !isNumeric(_controller.text)) {
//   //     showErrorMessage(
//   //       message: "Please enter valid email address",
//   //     );
//   //     return;
//   //   } else if (isNumeric(_controller.text) &&
//   //       (isEmpty(_controller.text) || !isLength(_controller.text, 3))) {
//   //     showErrorMessage(message: "Please enter valid phone number");
//   //     return;
//   //   }

//   //   UserProvider provider = context.read<UserProvider>();

//   //   Map request = {
//   //     "username": _controller.text,
//   //     "type": isEmail(_controller.text) ? "email" : "phone",
//   //   };

//   //   provider.login(request);
//   // }

//   void _handleSignIn() async {
//     if (await _googleSignIn.isSignedIn()) {
//       print("Already Signed In *******");
//       await _googleSignIn.signOut();
//       print("Signed out *******");
//     }

//     try {
//       print("Signed In ******* ##");
//       String? fcmToken = await Preference.getFcmToken();
//       String? address = await Preference.getLocation();

//       GoogleSignInAccount? account = await _googleSignIn.signIn();
//       print("Signed In *******");
//       print(account.toString());

//       if (account != null) {
//         UserProvider provider = context.read<UserProvider>();
//         Map request = {
//           "displayName": account.displayName ?? "",
//           "email": account.email,
//           "id": account.id,
//           "photoUrl": account.photoUrl ?? "",
//           "fcm_token": fcmToken ?? "",
//           "platform": Platform.operatingSystem,
//           "address": address ?? "",
//           // "serverAuthCode": account?.serverAuthCode,
//         };
//         provider.googleLogin(request, dontPop: "true");
//       }
//     } catch (error) {
//       print("Error in Signed In *******");
//       showErrorMessage(message: "$error");

//       print(error);
//     }
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   void _handleSignInApple(id, displayName, email) async {
//     try {
//       String? fcmToken = await Preference.getFcmToken();
//       String? address = await Preference.getLocation();

//       UserProvider provider = context.read<UserProvider>();
//       Map request = {
//         "displayName": displayName ?? "",
//         "email": email ?? "",
//         "id": id ?? "",
//         "fcm_token": fcmToken ?? "",
//         "platform": Platform.operatingSystem,
//         "address": address ?? "",
//       };
//       provider.appleLogin(request, dontPop: "true");
//       // GoogleSignInAccount:{displayName: Netleon Family, email: testnetleon@gmail.com, id: 110041963646228833065, photoUrl: https://lh3.googleusercontent.com/a/ACg8ocJocVZ9k-umOKg7MEzLfpG4d_GBrUFYY8o84_r3Am95dA, serverAuthCode: null}
//     } catch (error) {
//       showErrorMessage(message: "$error");
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BaseContainer(
//       appBar: const AppBarHome(isPopback: true, showTrailing: false),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             // Container(
//             //   padding: EdgeInsets.symmetric(vertical: 12.sp),
//             //   width: MediaQuery.of(context).size.width * .45,
//             //   child: Image.asset(Images.logo),
//             // ),
//             Padding(
//               padding: const EdgeInsets.all(Dimen.authScreenPadding),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const SpacerVertical(height: 16),
//                   Text(
//                     "SIGN UP",
//                     style: stylePTSansBold(fontSize: 24),
//                   ),
//                   const SpacerVertical(height: 40),
//                   ThemeButton(
//                     onPressed: () {
//                       Navigator.pushNamed(context, CreateAccount.path);
//                     },
//                     child: SizedBox(
//                       width: double.infinity,
//                       child: Stack(
//                         alignment: Alignment.center,
//                         children: [
//                           const Positioned(left: 0, child: Icon(Icons.person)),
//                           Text(
//                             "Sign Up with Email Address",
//                             style: stylePTSansRegular(fontSize: 14),
//                             textAlign: TextAlign.center,
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                   const SpacerVertical(),
//                   Column(
//                     children: [
//                       Stack(
//                         alignment: Alignment.center,
//                         children: [
//                           Divider(
//                             color: ThemeColors.dividerDark,
//                             height: 1.sp,
//                             thickness: 1.sp,
//                           ),
//                           Container(
//                             color: ThemeColors.background,
//                             padding: EdgeInsets.symmetric(horizontal: 8.sp),
//                             child: Text(
//                               "or continue with",
//                               style: stylePTSansRegular(
//                                 fontSize: 12,
//                                 color: ThemeColors.greyText,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                       const SpacerVertical(),
//                       ThemeButton(
//                         onPressed: () async {
//                           _handleSignIn();
//                         },
//                         color: ThemeColors.primaryLight,
//                         child: SizedBox(
//                           width: double.infinity,
//                           child: Stack(
//                             alignment: Alignment.center,
//                             children: [
//                               Positioned(
//                                 left: 0,
//                                 child: Image.asset(
//                                   Images.google,
//                                   width: 16.sp,
//                                   height: 16.sp,
//                                   fit: BoxFit.contain,
//                                 ),
//                               ),
//                               Text(
//                                 "Continue with Google",
//                                 style: stylePTSansRegular(fontSize: 14),
//                                 textAlign: TextAlign.center,
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                       // const SpacerVertical(height: ),

//                       Visibility(
//                         visible: Platform.isIOS,
//                         child: Padding(
//                           padding:
//                               const EdgeInsets.only(top: Dimen.itemSpacing),
//                           child: ThemeButton(
//                             onPressed: () async {
//                               try {
//                                 // flutter: AuthorizationAppleID(000150.6a1410656f504cdcb3d81a2c25231878.1000, Netleon, Technologies, netleonweb@gmail.com, null)
//                                 // if(Platform.isIOS && Platform.version)
//                                 final AuthorizationCredentialAppleID
//                                     credential =
//                                     await SignInWithApple.getAppleIDCredential(
//                                   scopes: [
//                                     AppleIDAuthorizationScopes.email,
//                                     AppleIDAuthorizationScopes.fullName,
//                                   ],
//                                 );
//                                 _handleSignInApple(
//                                   credential.userIdentifier,
//                                   credential.givenName != null
//                                       ? "${credential.givenName} ${credential.familyName}"
//                                       : null,
//                                   credential.email,
//                                 );
//                                 print(credential.userIdentifier);
//                               } catch (e) {
//                                 print("Error Apple Sign IN - $e");
//                                 if (e.toString().contains(
//                                     "SignInWithAppleNotSupportedException")) {
//                                   showErrorMessage(
//                                     message:
//                                         "Sign in with Apple not supported in this device",
//                                   );
//                                 }
//                               }
//                               // Now send the credential (especially `credential.authorizationCode`) to your server to create a session
//                               // after they have been validated with Apple (see `Integration` section for more information on how to do this)
//                             },
//                             color: ThemeColors.white,
//                             child: SizedBox(
//                               width: double.infinity,
//                               child: Stack(
//                                 alignment: Alignment.center,
//                                 children: [
//                                   Positioned(
//                                     left: 0,
//                                     child: Image.asset(
//                                       Images.apple,
//                                       width: 16.sp,
//                                       height: 16.sp,
//                                       fit: BoxFit.contain,
//                                       color: ThemeColors.background,
//                                     ),
//                                   ),
//                                   Text(
//                                     "Continue with Apple",
//                                     style: stylePTSansRegular(
//                                         fontSize: 15,
//                                         color: ThemeColors.background),
//                                     textAlign: TextAlign.center,
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),

//                       // Visibility(
//                       //     visible: Platform.isIOS,
//                       //     child: Container(
//                       //       margin: EdgeInsets.only(top: Dimen.itemSpacing.sp),
//                       //       child: SignInWithAppleButton(
//                       //         style: SignInWithAppleButtonStyle.whiteOutlined,
//                       //         iconAlignment: IconAlignment.left,
//                       //         onPressed: () async {
//                       //           try {
//                       //             // flutter: AuthorizationAppleID(000150.6a1410656f504cdcb3d81a2c25231878.1000, Netleon, Technologies, netleonweb@gmail.com, null)
//                       //             // if(Platform.isIOS && Platform.version)
//                       //             final AuthorizationCredentialAppleID
//                       //                 credential = await SignInWithApple
//                       //                     .getAppleIDCredential(
//                       //               scopes: [
//                       //                 AppleIDAuthorizationScopes.email,
//                       //                 AppleIDAuthorizationScopes.fullName,
//                       //               ],
//                       //             );
//                       //             _handleSignInApple(
//                       //               credential.userIdentifier,
//                       //               credential.givenName != null
//                       //                   ? "${credential.givenName} ${credential.familyName}"
//                       //                   : null,
//                       //               credential.email,
//                       //             );
//                       //             print(credential.userIdentifier);
//                       //           } catch (e) {
//                       //             print("Error Apple Sign IN - $e");
//                       //             if (e.toString().contains(
//                       //                 "SignInWithAppleNotSupportedException")) {
//                       //               showErrorMessage(
//                       //                 message:
//                       //                     "Sign in with Apple not supported in this device",
//                       //               );
//                       //             }
//                       //           }
//                       //         },
//                       //       ),
//                       //     )),
//                     ],
//                   ),
//                   TextButton(
//                     onPressed: () {
//                       log("${widget.dntPop}");
//                       if (widget.dntPop != null) {
//                         Navigator.pushReplacement(
//                             context,
//                             createRoute(Login(
//                               dontPop: widget.dntPop,
//                               state: widget.state,
//                             )));
//                       } else {
//                         Navigator.pop(context);
//                       }
//                     },
//                     child: RichText(
//                       text: TextSpan(
//                         children: [
//                           TextSpan(
//                             text: "Already have an account? ",
//                             style: stylePTSansRegular(
//                               fontSize: 13,
//                               color: ThemeColors.accent,
//                             ),
//                           ),
//                           TextSpan(
//                             text: "Log In",
//                             style: stylePTSansRegular(fontSize: 13),
//                           ),
//                         ],
//                       ),
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
