import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stocks_news_new/route/my_app.dart';
import 'package:stocks_news_new/screens/auth/authFlow/complete_login.dart';
import 'package:stocks_news_new/screens/auth/signup/edit_email.dart';
import 'package:stocks_news_new/screens/auth/otp/pinput.dart';

import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/utils/utils.dart';
import 'package:stocks_news_new/widgets/custom/alert_popup.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

otpLoginFirstSheet({
  String? id,
  required String mobile,
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
      return OTPLoginBottom(
        id: id,
        mobile: mobile,
      );
    },
  );
}

class OTPLoginBottom extends StatefulWidget {
  final String? id;
  final String mobile;
  final Function()? onSubmit;

  const OTPLoginBottom({
    super.key,
    this.id,
    required this.mobile,
    this.onSubmit,
  });

  @override
  State<OTPLoginBottom> createState() => _OTPLoginBottomState();
}

class _OTPLoginBottomState extends State<OTPLoginBottom> {
  final TextEditingController _controller = TextEditingController();

  int startTiming = 30;
  Timer? _timer;

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
    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    //   UserRes? user = context.read<UserProvider>().user;
    //   _controller.text = "${user?.otp}";
    // });

    _startTime();
  }

  @override
  void dispose() {
    _controller.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void _onVeryClick() async {
    if (_controller.text.isEmpty) {
      popUpAlert(
        message: "Please enter a valid OTP.",
        title: "Alert",
        icon: Images.alertPopGIF,
      );
    } else {
      if (widget.onSubmit != null) {
        widget.onSubmit!();
      } else {
        Navigator.pop(context);
        completeLoginFirstSheet();
      }

      // UserProvider provider = context.read<UserProvider>();
      // String? fcmToken = await Preference.getFcmToken();
      // String? address = await Preference.getLocation();
      // PackageInfo packageInfo = await PackageInfo.fromPlatform();
      // String versionName = packageInfo.version;
      // String buildNumber = packageInfo.buildNumber;
      // bool granted = await Permission.notification.isGranted;
      // Map request = {
      //   "username": widget.mobile,
      //   "type": "email",
      //   "otp": _controller.text,
      //   "fcm_token": fcmToken ?? "",
      //   "platform": Platform.operatingSystem,
      //   "address": address ?? "",
      //   "build_version": versionName,
      //   "build_code": buildNumber,
      //   "fcm_permission": "$granted",
      //   "apple_id": widget.id ?? "",
      // };
      // provider.verifyLoginOtp(request);
    }
  }

  void _onResendOtpClick() {
    _startTime();
    _controller.text = '';
    setState(() {});
    // UserProvider provider = context.read<UserProvider>();
    // Map request = {
    //   "username": widget.mobile,
    //   "type": "email",
    // };
    // provider.resendOtp(request);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        closeKeyboard();
      },
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
            // const SpacerVertical(height: 70),
            // Container(
            //   width: MediaQuery.of(context).size.width * .45,
            //   constraints: BoxConstraints(maxHeight: kTextTabBarHeight - 2.sp),
            //   child: Image.asset(
            //     Images.logo,
            //     fit: BoxFit.contain,
            //   ),
            // ),
            const SpacerVertical(height: 30),
            Image.asset(
              Images.otpSuccessGIT,
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
                  const SpacerVertical(height: 8),
                  // Text(
                  //   "Please enter the 4-digit verification code that was sent to ${provider.user?.username}. The code is valid for 10 minutes.",
                  //   style: stylePTSansRegular(
                  //     fontSize: 14,
                  //     color: Colors.white,
                  //   ),
                  // ),
                  EditEmail(email: widget.mobile),
                  const SpacerVertical(),
                  CommonPinput(
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
                  const SpacerVertical(),
                  EditEmailClick(email: widget.mobile),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
