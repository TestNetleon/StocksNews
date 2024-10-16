import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/providers/user_provider.dart';
import 'package:stocks_news_new/screens/auth/otp/pinput_phone.dart';
import 'package:stocks_news_new/screens/auth/signup/edit_email.dart';
import 'package:stocks_news_new/screens/tabs/home/widgets/app_bar_home.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/utils/utils.dart';
import 'package:stocks_news_new/widgets/base_container.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import 'package:stocks_news_new/widgets/theme_button.dart';

import '../../../widgets/custom/alert_popup.dart';

class BaseVerifyOTP extends StatefulWidget {
  final String phone, countryCode;
//
  const BaseVerifyOTP({
    required this.phone,
    required this.countryCode,
    super.key,
  });

  @override
  State<BaseVerifyOTP> createState() => _BaseVerifyOTPState();
}

class _BaseVerifyOTPState extends State<BaseVerifyOTP> {
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
    if (_controller.text.isEmpty || _controller.text.length < 6) {
      popUpAlert(
        message: "Please enter a valid OTP.",
        title: "Alert",
        icon: Images.alertPopGIF,
      );
      return;
    }
  }

  void _onResendOtpClick() async {
    _startTime();
    _controller.clear();
    setState(() {});
  }

  void _requestLogin() async {
    closeKeyboard();
    UserProvider provider = context.read<UserProvider>();

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
