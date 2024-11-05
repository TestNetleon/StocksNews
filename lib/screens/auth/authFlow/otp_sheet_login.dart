// import 'dart:async';
// import 'dart:developer';
// import 'dart:io';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:package_info_plus/package_info_plus.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:provider/provider.dart';
// import 'package:stocks_news_new/route/my_app.dart';
// import 'package:stocks_news_new/screens/auth/signup/edit_email.dart';
// import 'package:stocks_news_new/screens/auth/otp/pinput.dart';
// import 'package:stocks_news_new/utils/colors.dart';
// import 'package:stocks_news_new/utils/constants.dart';
// import 'package:stocks_news_new/utils/dialogs.dart';
// import 'package:stocks_news_new/utils/theme.dart';
// import 'package:stocks_news_new/utils/utils.dart';
// import 'package:stocks_news_new/widgets/custom/alert_popup.dart';
// import 'package:stocks_news_new/widgets/spacer_vertical.dart';

// import '../../../database/preference.dart';
// import '../../../providers/user_provider.dart';

// otpLoginFirstSheet({
//   String? id,
//   required String mobile,
//   required String countryCode,
//   required String verificationId,
// }) async {
//   await showModalBottomSheet(
//     useSafeArea: true,
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
//       return OTPLoginBottom(
//         id: id,
//         mobile: mobile,
//         countryCode: countryCode,
//         verificationId: verificationId,
//       );
//     },
//   );
// }

// class OTPLoginBottom extends StatefulWidget {
//   final String? id;
//   final String mobile;
//   final String countryCode;
//   final String verificationId;
//   final Function()? onSubmit;

//   const OTPLoginBottom({
//     super.key,
//     this.id,
//     required this.mobile,
//     required this.countryCode,
//     this.onSubmit,
//     required this.verificationId,
//   });

//   @override
//   State<OTPLoginBottom> createState() => _OTPLoginBottomState();
// }

// class _OTPLoginBottomState extends State<OTPLoginBottom> {
//   final TextEditingController _controller = TextEditingController();

//   int startTiming = 30;
//   Timer? _timer;
//   String? _verificationId;

//   void _startTime() {
//     _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
//       setState(() {
//         startTiming = startTiming - 1;
//         Utils().showLog("Start Timer ? $startTiming");
//         if (startTiming == 0) {
//           startTiming = 30;
//           _timer?.cancel();
//           Utils().showLog("Timer Stopped ? $startTiming");
//         }
//       });
//     });
//   }

//   @override
//   void initState() {
//     super.initState();
//     // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
//     //   UserRes? user = context.read<UserProvider>().user;
//     //   _controller.text = "${user?.otp}";
//     // });

//     _startTime();
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     _timer?.cancel();
//     super.dispose();
//   }

//   void _onVeryClick() async {
//     if (_controller.text.isEmpty || _controller.text.length < 6) {
//       popUpAlert(
//         message: "Please enter a valid OTP.",
//         title: "Alert",
//         icon: Images.alertPopGIF,
//       );
//       return;
//     }
//     if (kDebugMode) {
//       _getProfile();
//       return;
//     }

//     String smsCode = _controller.text;

//     PhoneAuthCredential credential = PhoneAuthProvider.credential(
//       verificationId: _verificationId ?? widget.verificationId,
//       smsCode: smsCode,
//     );

//     showGlobalProgressDialog();

//     try {
//       await FirebaseAuth.instance.signInWithCredential(credential);
//       closeGlobalProgressDialog();
//       _getProfile();
//     } on FirebaseAuthException catch (e) {
//       closeGlobalProgressDialog();
//       popUpAlert(
//         message: e.message ?? Const.errSomethingWrong,
//         title: "Alert",
//         icon: Images.alertPopGIF,
//       );
//     } catch (e) {
//       closeGlobalProgressDialog();

//       log("Here Error $e");
//     }

//     // if (widget.onSubmit != null) {
//     //   widget.onSubmit!();
//     // } else {
//     //   Navigator.pop(context);
//     //   completeLoginFirstSheet();
//     // }
//   }

//   _getProfile() async {
//     UserProvider provider = context.read<UserProvider>();
//     String? fcmToken = await Preference.getFcmToken();
//     String? address = await Preference.getLocation();
//     PackageInfo packageInfo = await PackageInfo.fromPlatform();
//     String versionName = packageInfo.version;
//     String buildNumber = packageInfo.buildNumber;
//     bool granted = await Permission.notification.isGranted;
//     String? referralCode = await Preference.getReferral();

//     Map request = {
//       "phone": widget.mobile,
//       "phone_code": widget.countryCode,
//       "otp": _controller.text,
//       "fcm_token": fcmToken ?? "",
//       "platform": Platform.operatingSystem,
//       "address": address ?? "",
//       "build_version": versionName,
//       "build_code": buildNumber,
//       "fcm_permission": "$granted",
//       "referral_code": referralCode ?? "",
//     };
//     if (memCODE != null && memCODE != '') {
//       request['distributor_code'] = memCODE;
//     }

//     provider.finalVerifyOTP(request);
//   }

//   void _onResendOtpClick() async {
//     _startTime();
//     _controller.text = '';
//     setState(() {});
//     await FirebaseAuth.instance.verifyPhoneNumber(
//       phoneNumber: "${widget.countryCode} ${widget.mobile}",
//       verificationCompleted: (PhoneAuthCredential credential) {},
//       verificationFailed: (FirebaseAuthException e) {
//         popUpAlert(
//           message: e.code == "invalid-phone-number"
//               ? "The format of the phone number provided is incorrect."
//               : e.code == "too-many-requests"
//                   ? "We have blocked all requests from this device due to unusual activity. Try again after 24 hours."
//                   : e.code == "internal-error"
//                       ? "The phone number you entered is either incorrect or not currently in use."
//                       : e.message ?? Const.errSomethingWrong,
//           title: "Alert",
//           icon: Images.alertPopGIF,
//         );
//       },
//       codeSent: (String verificationId, int? resendToken) {
//         _verificationId = verificationId;
//       },
//       codeAutoRetrievalTimeout: (String verificationId) {
//         _verificationId = verificationId;
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         closeKeyboard();
//       },
//       child: Container(
//         constraints: BoxConstraints(maxHeight: ScreenUtil().screenHeight - 30),
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.only(
//             topLeft: Radius.circular(10.sp),
//             topRight: Radius.circular(10.sp),
//           ),
//           gradient: const LinearGradient(
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//             colors: [ThemeColors.bottomsheetGradient, Colors.black],
//           ),
//           color: ThemeColors.background,
//           border: const Border(
//             top: BorderSide(color: ThemeColors.greyBorder),
//           ),
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             // SizedBox(
//             //   width: MediaQuery.of(context).size.width * .45,
//             //   child: Image.asset(Images.logo),
//             // ),
//             Container(
//               height: 6.sp,
//               width: 50.sp,
//               margin: EdgeInsets.only(top: 8.sp),
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(10.sp),
//                 color: ThemeColors.greyBorder,
//               ),
//             ),
//             // const SpacerVertical(height: 70),
//             // Container(
//             //   width: MediaQuery.of(context).size.width * .45,
//             //   constraints: BoxConstraints(maxHeight: kTextTabBarHeight - 2.sp),
//             //   child: Image.asset(
//             //     Images.logo,
//             //     fit: BoxFit.contain,
//             //   ),
//             // ),
//             const SpacerVertical(height: 30),
//             Image.asset(
//               Images.otpVerify,
//               height: 95.sp,
//               width: 95.sp,
//             ),
//             Padding(
//               padding: const EdgeInsets.all(Dimen.authScreenPadding),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   // const SpacerVertical(height: 50),
//                   Text(
//                     "VERIFICATION OTP SENT",
//                     style: stylePTSansBold(fontSize: 22),
//                   ),
//                   const SpacerVertical(height: 8),
//                   // Text(
//                   //   "Please enter the 4-digit verification code that was sent to ${provider.user?.username}. The code is valid for 10 minutes.",
//                   //   style: stylePTSansRegular(
//                   //     fontSize: 14,
//                   //     color: Colors.white,
//                   //   ),
//                   // ),
//                   EditEmail(
//                     email: "${widget.countryCode}${widget.mobile}",
//                     digit: 6,
//                   ),
//                   const SpacerVertical(),
//                   CommonPinput(
//                     separatorWidth: 5,
//                     length: 6,
//                     controller: _controller,
//                     onCompleted: (p0) {
//                       _onVeryClick();
//                     },
//                   ),
//                   startTiming == 30
//                       ? Container(
//                           margin: EdgeInsets.only(
//                             right: 8.sp,
//                             top: 20.sp,
//                           ),
//                           alignment: Alignment.center,
//                           child: GestureDetector(
//                             onTap: _onResendOtpClick,
//                             child: RichText(
//                               textAlign: TextAlign.center,
//                               text: TextSpan(
//                                 text: "Resend OTP",
//                                 style: stylePTSansBold(
//                                     fontSize: 15, color: ThemeColors.accent),
//                               ),
//                             ),
//                           ),
//                         )
//                       : Container(
//                           margin: EdgeInsets.only(
//                             right: 8.sp,
//                             top: 20.sp,
//                           ),
//                           alignment: Alignment.center,
//                           child: RichText(
//                             text: TextSpan(
//                               children: [
//                                 TextSpan(
//                                   text: "${startTiming}Sec",
//                                   style: stylePTSansBold(
//                                     fontSize: 15,
//                                     color: ThemeColors.accent,
//                                   ),
//                                 ),
//                               ],
//                               text: "Resend OTP in ",
//                               style: stylePTSansRegular(
//                                 fontSize: 15,
//                               ),
//                             ),
//                           ),
//                         ),

//                   const SpacerVertical(),
//                   const SpacerVertical(),
//                   EditEmailClick(email: widget.mobile),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
