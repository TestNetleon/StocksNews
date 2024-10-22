import 'dart:async';
import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:stocks_news_new/api/api_response.dart';
import 'package:stocks_news_new/providers/home_provider.dart';
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

class BaseVerifyOTP extends StatefulWidget {
  final String phone, countryCode, verificationId;
//
  const BaseVerifyOTP({
    required this.phone,
    required this.countryCode,
    required this.verificationId,
    super.key,
  });

  @override
  State<BaseVerifyOTP> createState() => _BaseVerifyOTPState();
}

class _BaseVerifyOTPState extends State<BaseVerifyOTP> {
  final TextEditingController _controller = TextEditingController();

  int startTiming = 30;
  Timer? _timer;
  String? _verificationId;

  Future _verifyPhoneNumber() async {
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
      verificationId: _verificationId ?? widget.verificationId,
      smsCode: smsCode,
    );

    showGlobalProgressDialog();

    try {
      await FirebaseAuth.instance.signInWithCredential(credential);
      closeGlobalProgressDialog();
      _updateProfile();
    } on FirebaseAuthException catch (e) {
      closeGlobalProgressDialog();
      popUpAlert(
        message: e.message ?? Const.errSomethingWrong,
        title: "Alert",
        icon: Images.alertPopGIF,
      );
    } catch (e) {
      closeGlobalProgressDialog();

      log("Here Error $e");
    }
  }

  _updateProfile() async {
    UserProvider provider = context.read<UserProvider>();
    HomeProvider homeProvider = context.read<HomeProvider>();

    ApiResponse response = await provider.updateProfile(
      token: provider.user?.token ?? '',
      name: provider.user?.name ?? '',
      email: provider.user?.email ?? '',
      phone: widget.phone,
      countryCode: widget.countryCode,
    );
    await homeProvider.getHomeSlider(showProgress: true);
    if (response.status) {
      Navigator.pop(context);
    }
  }

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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Utils().showLog('PHONE => ${widget.phone}');

      _listenCode();
      _startTime();
      _verificationId = widget.verificationId;
      setState(() {});
    });
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

    _verifyPhoneNumber();
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
        _verificationId = verificationId;
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        _verificationId = verificationId;
      },
    );
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
                      text: "Verify and update",
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
