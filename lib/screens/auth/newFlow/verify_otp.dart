import 'dart:async';
import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/providers/user_provider.dart';
import 'package:stocks_news_new/screens/auth/otp/pinput_phone.dart';
import 'package:stocks_news_new/screens/auth/signup/edit_email.dart';
import 'package:stocks_news_new/screens/tabs/home/widgets/app_bar_home.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/dialogs.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/utils/utils.dart';
import 'package:stocks_news_new/widgets/base_container.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import 'package:stocks_news_new/widgets/theme_button.dart';

import '../../../widgets/custom/alert_popup.dart';

class VerifyOTP extends StatefulWidget {
  final String phone, verificationId, countryCode;
//
  const VerifyOTP({
    required this.phone,
    required this.verificationId,
    required this.countryCode,
    super.key,
  });

  @override
  State<VerifyOTP> createState() => _VerifyOTPState();
}

class _VerifyOTPState extends State<VerifyOTP> {
  final TextEditingController _controller = TextEditingController();

  int startTiming = 30;
  Timer? _timer;
  String? verificationId;

  void _startTime() {
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

  @override
  void initState() {
    super.initState();
    verificationId = widget.verificationId;
    _startTime();
  }

  @override
  void dispose() {
    _controller.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void _onVeryClick() async {
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
      _requestLogin();
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

  void _onResendOtpClick() async {
    _startTime();
    _controller.text = '';
    setState(() {});
    await FirebaseAuth.instance.verifyPhoneNumber(
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

  void _requestLogin() async {
    closeKeyboard();
    UserProvider provider = context.read<UserProvider>();

    // String? fcmToken = await Preference.getFcmToken();
    // String? address = await Preference.getLocation();
    // // String? referralCode = await Preference.getReferral();
    // PackageInfo packageInfo = await PackageInfo.fromPlatform();
    // String versionName = packageInfo.version;
    // String buildNumber = packageInfo.buildNumber;
    // bool granted = await Permission.notification.isGranted;

    Map request = {
      "phone": widget.phone,
      "phone_code": widget.countryCode,
    };

    provider.checkLogin(request);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        closeKeyboard();
      },
      child: BaseContainer(
        appBar: const AppBarHome(
          isPopback: true,
          canSearch: false,
          showTrailing: false,
          title: "",
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              const SpacerVertical(height: 30),
              Image.asset(Images.otpSuccessGIT, height: 95.sp, width: 95.sp),
              Padding(
                padding: const EdgeInsets.all(Dimen.authScreenPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        "OTP VERIFICATION",
                        style: stylePTSansBold(fontSize: 22),
                      ),
                    ),
                    const SpacerVertical(height: 8),
                    EditEmail(email: widget.phone),
                    const SpacerVertical(),
                    CommonPinputPhone(
                      controller: _controller,
                      onCompleted: (p0) {
                        _onVeryClick();
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
                                  text: "Resend OTP",
                                  style: stylePTSansBold(
                                      fontSize: 15, color: ThemeColors.accent),
                                ),
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
                    ThemeButton(
                      onPressed: _onVeryClick,
                      text: "Verify and Log in",
                    ),
                    const SpacerVertical(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
