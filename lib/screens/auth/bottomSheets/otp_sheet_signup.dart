import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/providers/user_provider.dart';
import 'package:stocks_news_new/route/my_app.dart';
import 'package:stocks_news_new/screens/auth/otp/pinput.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/preference.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/utils/utils.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import 'package:stocks_news_new/widgets/theme_button.dart';

import '../../../widgets/custom/alert_popup.dart';
import 'edit_email.dart';

otpSignupSheet({
  String? state,
  String? dontPop,
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
      return const OTPSignupBottom();
    },
  );
}

class OTPSignupBottom extends StatefulWidget {
//
  const OTPSignupBottom({super.key});

  @override
  State<OTPSignupBottom> createState() => _OTPSignupBottomState();
}

class _OTPSignupBottomState extends State<OTPSignupBottom> {
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
          icon: Images.alertPopGIF);
    } else {
      closeKeyboard();
      UserProvider provider = context.read<UserProvider>();

      String? fcmToken = await Preference.getFcmToken();
      String? address = await Preference.getLocation();
      String? referralCode = await Preference.getReferral();
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      String versionName = packageInfo.version;
      String buildNumber = packageInfo.buildNumber;
      bool granted = await Permission.notification.isGranted;

      Map request = {
        "username": provider.user?.username ?? "",
        "otp": _controller.text,
        "type": "email",
        "fcm_token": fcmToken ?? "",
        "platform": Platform.operatingSystem,
        "address": address ?? "",
        "build_version": versionName,
        "build_code": buildNumber,
        "fcm_permission": "$granted",
        "referral_code": "$referralCode",
      };

      provider.verifySignupOtp(request);
    }
  }

  void _onResendOtpClick() {
    closeKeyboard();
    _controller.text = '';

    UserProvider provider = context.read<UserProvider>();
    Map request = {
      "username": provider.user?.username ?? "",
      "type": provider.user?.type ?? "",
    };
    provider.signupResendOtp(request);
  }

  @override
  Widget build(BuildContext context) {
    UserProvider provider = context.watch<UserProvider>();
    return Container(
      constraints: BoxConstraints(maxHeight: ScreenUtil().screenHeight - 30),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10.sp), topRight: Radius.circular(10.sp)),
        gradient: const RadialGradient(
          center: Alignment.bottomCenter,
          radius: 0.6,
          // transform: GradientRotation(radians),
          // tileMode: TileMode.decal,
          stops: [
            0.0,
            0.9,
          ],
          colors: [
            Color.fromARGB(255, 0, 93, 12),
            // ThemeColors.accent.withOpacity(0.1),
            Colors.black,
          ],
        ),
        color: ThemeColors.background,
        border: const Border(
          top: BorderSide(color: ThemeColors.greyBorder),
        ),
      ),
      child: Column(
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
          const SpacerVertical(height: 16),
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
            Images.otpSuccessGIT,
            height: 95.sp,
            width: 95.sp,
          ),
          Padding(
            padding: const EdgeInsets.all(Dimen.authScreenPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // const SpacerVertical(height: 50),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    "OTP VERIFICATION",
                    style: stylePTSansBold(fontSize: 22),
                  ),
                ),
                const SpacerVertical(height: 8),
                // Text(
                //   "Please enter the 4-digit verification code that was sent to ${provider.user?.username}. The code is valid for 10 minutes.",
                //   style: stylePTSansRegular(
                //     fontSize: 14,
                //     color: Colors.white,
                //   ),
                // ),
                EditEmail(email: "${provider.user?.username}"),
                const SpacerVertical(),
                // Text(
                //   "Verification Code",
                //   style: stylePTSansRegular(fontSize: 14),
                // ),
                // const SpacerVertical(height: 5),
                // Stack(
                //   alignment: Alignment.center,
                //   children: [
                //     ThemeInputField(
                //       controller: _controller,
                //       placeholder: "",
                //       // keyboardType: TextInputType.phone,
                //       inputFormatters: [mobilrNumberAllow],
                //       maxLength: 4,
                //     ),
                //     Container(
                //       margin: EdgeInsets.only(right: 8.sp),
                //       alignment: Alignment.centerRight,
                //       child: TextButton(
                //         onPressed: _onResendOtpClick,
                //         child: Text(
                //           "Resend",
                //           style: stylePTSansBold(
                //             fontSize: 14,
                //             color: ThemeColors.accent,
                //           ),
                //         ),
                //       ),
                //     ),
                //   ],
                // ),
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
                                text: "${startTiming}S",
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
                EditEmailClick(
                  email: "${provider.user?.username}",
                  fromLoginOTP: false,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
