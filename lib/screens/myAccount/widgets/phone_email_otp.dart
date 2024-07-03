import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:stocks_news_new/providers/user_provider.dart';
import 'package:stocks_news_new/route/my_app.dart';
import 'package:stocks_news_new/screens/auth/otp/pinput.dart';

import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/utils/utils.dart';
import 'package:stocks_news_new/widgets/custom/alert_popup.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

import '../../../../api/api_response.dart';

phoneEmailOTP({
  String? text,
  bool screenType = false,
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
      return OTPBottomPhone(
        text: text ?? "",
        screenType: screenType,
      );
    },
  );
}

class OTPBottomPhone extends StatefulWidget {
  final String text;
  final bool screenType;

  const OTPBottomPhone({
    super.key,
    required this.text,
    required this.screenType,
  });

  @override
  State<OTPBottomPhone> createState() => _OTPBottomPhoneState();
}

class _OTPBottomPhoneState extends State<OTPBottomPhone> {
  final TextEditingController _controller = TextEditingController();
  int startTiming = 30;
  final FocusNode _otpFocusNode = FocusNode();
  String appSignature = "";

  Timer? _timer;
  @override
  void initState() {
    super.initState();

    _listenCode();
    _startTime();
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

  void _onVeryClick() async {
    if (_controller.text.isEmpty) {
      popUpAlert(
        message: "Please enter a valid OTP.",
        title: "Alert",
        icon: Images.alertPopGIF,
      );
    } else {
      UserProvider provider = context.read<UserProvider>();

      Map request = {
        'token': provider.user?.token,
        'otp': _controller.text.trim(),
      };
      try {
        ApiResponse response = widget.screenType == true
            ? await provider.checkPhoneOtp(request)
            : await provider.checkEmailOtp(request);
        if (response.status) {
          closeKeyboard();
          if (widget.screenType == false) {
            provider.updateUser(email: widget.text);
            provider.setEmailClickText();
          }
          if (widget.screenType == true) {
            provider.updateUser(phone: widget.text);
            provider.setPhoneClickText();
          }

          Navigator.pop(navigatorKey.currentContext!);
          closeKeyboard();
        }
      } catch (e) {
        //
      }
    }
  }

  void _onResendOtpClick(String? text) async {
    _startTime();
    _controller.text = '';
    setState(() {});

    UserProvider provider = context.read<UserProvider>();
    Map request = widget.screenType == true
        ? {
            "token": provider.user?.token ?? "",
            "phone": text,
            "phone_hash": appSignature,
          }
        : {
            "token": provider.user?.token ?? "",
            "email": text?.toLowerCase(),
          };

    try {
      _listenCode();
      ApiResponse response;
      if (widget.screenType == true) {
        response = await provider.emailUpdateOtp(request,
            resendButtonClick: true, email: text ?? "");
      } else {
        response = await provider.phoneUpdateOtp(request,
            resendButtonClick: false, phone: text ?? "");
      }

      if (response.status) {
        _otpFocusNode.requestFocus();
      }
    } catch (e) {}
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
          // gradient: const RadialGradient(
          //   center: Alignment.bottomCenter,
          //   radius: 0.6,
          //   stops: [
          //     0.0,
          //     0.9,
          //   ],
          //   colors: [
          //     Color.fromARGB(255, 0, 93, 12),
          //     // ThemeColors.accent.withOpacity(0.1),
          //     Colors.black,
          //   ],
          // ),
          color: ThemeColors.background,
          border: const Border(
            top: BorderSide(color: ThemeColors.greyBorder),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // SizedBox(
            //   width: MediaQuery.of(context).size.width * .45,
            //   child: Image.asset(Images.logo),
            // ),

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
                    'We have sent the verification code \nto your ${widget.screenType == true ? "phone number +1" : "email"} ${widget.text}',
                    textAlign: TextAlign.center,
                    style: stylePTSansRegular(color: Colors.grey, fontSize: 17),
                  ),
                  const SpacerVertical(height: 8),

                  const SpacerVertical(),

                  CommonPinput(
                    focusNode: _otpFocusNode,
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
                            onTap: () => _onResendOtpClick(widget.text),
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
