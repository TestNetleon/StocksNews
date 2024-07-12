// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:stocks_news_new/providers/user_provider.dart';
import 'package:stocks_news_new/route/my_app.dart';
import 'package:stocks_news_new/screens/auth/otp/pinput_phone.dart';

import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/dialogs.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/utils/utils.dart';
import 'package:stocks_news_new/widgets/custom/alert_popup.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

import '../../../../api/api_response.dart';

phoneOTP({
  required String phone,
  String appSignature = '',
  name = "",
  displayName = "",
  isVerifyIdentity = false,
  required String verificationId,
  required String countryCode,
}) async {
  await showModalBottomSheet(
    useSafeArea: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(5.sp),
        topRight: Radius.circular(5.sp),
      ),
    ),
    backgroundColor: ThemeColors.transparent,
    isScrollControlled: true,
    context: navigatorKey.currentContext!,
    builder: (context) {
      return OTPLoginBottomRefer(
        name: name,
        displayName: displayName,
        phone: phone,
        appSignature: appSignature,
        verificationId: verificationId,
        isVerifyIdentity: isVerifyIdentity,
        countryCode: countryCode,
      );
    },
  );
}

class OTPLoginBottomRefer extends StatefulWidget {
  final String phone;
  final String appSignature;
  final String name;
  final String displayName;
  final String verificationId;
  final bool isVerifyIdentity;
  final String countryCode;

  const OTPLoginBottomRefer({
    super.key,
    required this.phone,
    this.appSignature = '',
    required this.name,
    required this.displayName,
    required this.verificationId,
    required this.isVerifyIdentity,
    required this.countryCode,
  });

  @override
  State<OTPLoginBottomRefer> createState() => _OTPLoginBottomReferState();
}

class _OTPLoginBottomReferState extends State<OTPLoginBottomRefer> {
  final TextEditingController _controller = TextEditingController();
  int startTiming = 30;
  String? verificationId;
  final FocusNode _otpFocusNode = FocusNode();

  Timer? _timer;
  @override
  void initState() {
    super.initState();
    _listenCode();
    _startTime();
    verificationId = widget.verificationId;
    _otpFocusNode.requestFocus();
  }

  Future<void> _listenCode() async {
    try {
      log("trying to listen");
      await SmsAutoFill().listenForCode();
      SmsAutoFill().code.listen((event) {
        _controller.text = event;
        Utils().showLog('Listen $event');
        // setState(() {});
      });
    } catch (e) {
      Utils().showLog('Error while listening OTP $e');
    }
  }

  void _startTime() {
    startTiming = 30;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        startTiming = startTiming - 1;
        Utils().showLog("Start Timer ? $startTiming");
        if (startTiming == 0) {
          startTiming = 30;
          _timer?.cancel();
          Utils().showLog("Timer Stopped ? $startTiming");
        }
      });
    });
  }

  // void _onVeryClick() async {
  //   if (_controller.text.isEmpty) {
  //     popUpAlert(
  //       message: "Please enter a valid OTP.",
  //       title: "Alert",
  //       icon: Images.alertPopGIF,
  //     );
  //   } else {
  //     UserProvider provider = context.read<UserProvider>();
  //     HomeProvider homeProvider = context.read<HomeProvider>();
  //     Map request = {
  //       'token': provider.user?.token,
  //       'phone': widget.phone,
  //       'otp': _controller.text,
  //       'platform': Platform.operatingSystem,
  //       'affiliate_status': 1,
  //     };
  //     try {
  //       ApiResponse response = await provider.verifyReferLogin(request);
  //       if (response.status) {
  //         closeKeyboard();
  //         provider.updateUser(phone: widget.phone);
  //         Extra extra = response.extra;
  //         homeProvider.updateReferShare(extra.referral?.shareText);
  //         // navigatorKey.currentContext!.read<HomeProvider>().getHomeSlider();
  //         Navigator.pop(navigatorKey.currentContext!);
  //         // Navigator.push(
  //         //   navigatorKey.currentContext!,
  //         //   MaterialPageRoute(
  //         //     builder: (context) => const ReferSuccess(),
  //         //   ),
  //         // );
  //         if (widget.isVerifyIdentity) {
  //           showSnackbar(
  //             context: context,
  //             message: response.message,
  //             type: SnackbarType.info,
  //           );
  //         } else {
  //           Navigator.push(
  //             navigatorKey.currentContext!,
  //             MaterialPageRoute(
  //               builder: (_) => const ReferAFriend(),
  //             ),
  //           );
  //         }
  //       }
  //     } catch (e) {
  //       //
  //     }
  //   }
  // }

  // void _onResendOtpClick() async {
  //   _startTime();
  //   _controller.text = '';
  //   setState(() {});
  //   UserProvider provider = context.read<UserProvider>();
  //   Map request = {
  //     "phone": widget.phone,
  //     "phone_hash": widget.appSignature,
  //     "platform": Platform.operatingSystem,
  //     "token": provider.user?.token ?? "",
  //   };
  //   try {
  //     _listenCode();
  //     ApiResponse response = await provider.referLoginApi(request);
  //     if (response.status) {
  //       _otpFocusNode.requestFocus();
  //       // popUpAlert(message: response.message ?? "", title: "title");
  //     }
  //   } catch (e) {
  //     //
  //   }
  // }

  void _onResendOtpClick() async {
    _startTime();
    _controller.text = '';
    setState(() {});
    await FirebaseAuth.instance.verifyPhoneNumber(
      // phoneNumber: "+91${widget.phone}",
      // phoneNumber: kDebugMode ? "+91${widget.phone}" : "+1${widget.phone}",
      phoneNumber: "${widget.countryCode}${widget.phone}",
      verificationCompleted: (PhoneAuthCredential credential) {},
      verificationFailed: (FirebaseAuthException e) {
        popUpAlert(
          message: e.code == "invalid-phone-number"
              ? "The format of the phone number provided is incorrect."
              : e.code == "too-many-requests"
                  ? "We have blocked all requests from this device due to unusual activity. Try again after 24 hours."
                  : e.code == "internal-error"
                      ? "The phone number you entered is either incorrect or not currently in use."
                      : e.message ?? Const.errSomethingWrong,
          title: "Alert",
          icon: Images.alertPopGIF,
        );
      },
      codeSent: (String verificationId, int? resendToken) {
        verificationId = verificationId;
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  Future _verifyPhoneNumber() async {
    // Update the UI - wait for the user to enter the SMS code
    if (_controller.text.isEmpty || _controller.text.length < 6) {
      popUpAlert(
        message: "Please enter a valid OTP.",
        title: "Alert",
        icon: Images.alertPopGIF,
      );
      return;
    }

    String smsCode = _controller.text;

    // Create a PhoneAuthCredential with the code
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: verificationId ?? widget.verificationId,
      smsCode: smsCode,
    );

    showGlobalProgressDialog();

    try {
      // Sign the user in (or link) with the credential
      // UserCredential result =
      await FirebaseAuth.instance.signInWithCredential(credential);
      closeGlobalProgressDialog();
      _updatePhoneNumber();
    } on FirebaseAuthException catch (e) {
      closeGlobalProgressDialog();
      popUpAlert(
        message: e.message ?? Const.errSomethingWrong,
        title: "Alert",
        icon: Images.alertPopGIF,
      );
    } catch (e) {
      log("Here Error $e");
    }
  }

  void _updatePhoneNumber() async {
    closeKeyboard();
    UserProvider provider = context.read<UserProvider>();
    try {
      ApiResponse response = await provider.updatePhone(
        displayName: widget.displayName,
        name: widget.name,
        phone: widget.phone,
        token: provider.user?.token ?? "",
        countryCode: widget.countryCode,
      );
      if (response.status) {
        Navigator.pop(navigatorKey.currentContext!);
        provider.updateUser(phone: widget.phone);
        provider.setPhoneClickText();
        showSnackbar(
          context: navigatorKey.currentContext!,
          message: response.message,
          type: SnackbarType.info,
        );
        // Navigator.popUntil(
        //   navigatorKey.currentContext!,
        //   (route) => route.isFirst,
        // );
        // Navigator.popAndPushNamed(
        //   navigatorKey.currentContext!,
        //   ReferAFriend.path,
        // );
      } else {
        popUpAlert(
          message: response.message ?? Const.errSomethingWrong,
          title: "Alert",
          icon: Images.alertPopGIF,
        );
      }
    } catch (e) {
      popUpAlert(
        message: Const.errSomethingWrong,
        title: "Alert",
        icon: Images.alertPopGIF,
      );
      Navigator.pop(navigatorKey.currentContext!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => closeKeyboard(),
      child: Container(
        constraints: BoxConstraints(maxHeight: ScreenUtil().screenHeight - 30),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10.sp),
            topRight: Radius.circular(10.sp),
          ),
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [ThemeColors.bottomsheetGradient, Colors.black],
          ),
          color: ThemeColors.background,
          border: const Border(
            top: BorderSide(color: ThemeColors.greyBorder),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 6.sp,
              width: 50.sp,
              margin: EdgeInsets.only(top: 8.sp),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.sp),
                color: ThemeColors.greyBorder,
              ),
            ),
            const SpacerVertical(height: 70),
            Container(
              width: MediaQuery.of(context).size.width * .45,
              constraints: BoxConstraints(maxHeight: kTextTabBarHeight - 2.sp),
              child: Image.asset(
                Images.logo,
                fit: BoxFit.contain,
              ),
            ),
            const SpacerVertical(height: 30),
            Image.asset(
              Images.otpVerify,
              height: 95.sp,
              width: 95.sp,
            ),
            Padding(
              padding: const EdgeInsets.all(Dimen.authScreenPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // const SpacerVertical(height: 50),
                  Text(
                    "VERIFICATION OTP SENT",
                    style: stylePTSansBold(fontSize: 22),
                  ),
                  const SpacerVertical(height: 4),
                  Text(
                    'We have sent the verification code \nto your phone number ${widget.countryCode} ${widget.phone}',
                    textAlign: TextAlign.center,
                    style: stylePTSansRegular(color: Colors.grey, fontSize: 17),
                  ),
                  const SpacerVertical(height: 8),
                  const SpacerVertical(),
                  // CommonPinput(
                  //   focusNode: _otpFocusNode,
                  //   controller: _controller,
                  //   onCompleted: (p0) {
                  //     _onVeryClick();
                  //   },
                  // ),
                  CommonPinputPhone(
                    focusNode: _otpFocusNode,
                    controller: _controller,
                    onCompleted: (p0) {
                      _verifyPhoneNumber();
                    },
                  ),
                  startTiming == 30
                      ? Container(
                          margin: EdgeInsets.only(
                            right: 8.sp,
                            top: 20.sp,
                          ),
                          alignment: Alignment.center,
                          child: GestureDetector(
                            onTap: _onResendOtpClick,
                            child: RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                  text: "Didn't receive the OTP? ",
                                  style: stylePTSansBold(
                                      fontSize: 15,
                                      color: ThemeColors.greyText),
                                  children: [
                                    TextSpan(
                                      text: "Resend OTP",
                                      style: stylePTSansBold(
                                          fontSize: 15,
                                          color: ThemeColors.accent),
                                    ),
                                  ]),
                            ),
                          ),
                        )
                      : Container(
                          margin: EdgeInsets.only(
                            right: 8.sp,
                            top: 20.sp,
                          ),
                          alignment: Alignment.center,
                          child: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: "${startTiming}Sec",
                                  style: stylePTSansBold(
                                    fontSize: 15,
                                    color: ThemeColors.accent,
                                  ),
                                ),
                              ],
                              text: "Resend OTP in ",
                              style: stylePTSansRegular(
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ),

                  const SpacerVertical(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
