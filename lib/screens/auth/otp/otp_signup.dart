import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/providers/user_provider.dart';
import 'package:stocks_news_new/screens/auth/otp/pinput.dart';
import 'package:stocks_news_new/screens/tabs/home/widgets/app_bar_home.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/preference.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/utils/utils.dart';
import 'package:stocks_news_new/widgets/base_container.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import 'package:stocks_news_new/widgets/theme_button.dart';

class OTPSignup extends StatefulWidget {
  static const String path = "OTPSignup";
//
  const OTPSignup({super.key});

  @override
  State<OTPSignup> createState() => _OTPSignupState();
}

class _OTPSignupState extends State<OTPSignup> {
  final TextEditingController _controller = TextEditingController();
  // final TextEditingController _emailOtpcontroller = TextEditingController();
  // final TextEditingController _phoneOtpcontroller = TextEditingController();

  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    //   UserRes? user = context.read<UserProvider>().user;
    //   _controller.text = "${user?.otp}";
    // });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onVeryClick() async {
    closeKeyboard();
    UserProvider provider = context.read<UserProvider>();

    String? fcmToken = await Preference.getFcmToken();
    String? address = await Preference.getLocation();

    Map request = {
      "username": provider.user?.username ?? "",
      "otp": _controller.text,
      "type": "email",
      "fcm_token": fcmToken ?? "",
      "platform": Platform.operatingSystem,
      "address": address ?? "",
    };

    provider.verifySignupOtp(request);
  }

  void _onResendOtpClick() {
    closeKeyboard();
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
    return BaseContainer(
      appBar: const AppBarHome(isPopback: true, showTrailing: false),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // SizedBox(
            //   width: MediaQuery.of(context).size.width * .45,
            //   child: Image.asset(Images.logo),
            // ),
            Padding(
              padding: const EdgeInsets.all(Dimen.authScreenPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SpacerVertical(height: 50),
                  Text(
                    "OTP VERIFICATION",
                    style: stylePTSansBold(fontSize: 22),
                  ),
                  const SpacerVertical(height: 8),
                  Text(
                    "Please enter the 4-digit verification code that was sent to ${provider.user?.username}. The code is valid for 10 minutes.",
                    style: stylePTSansRegular(
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
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

                  Container(
                    margin: EdgeInsets.only(right: 8.sp),
                    alignment: Alignment.center,
                    child: TextButton(
                      onPressed: _onResendOtpClick,
                      child: Text(
                        "Resend",
                        style: stylePTSansBold(
                          fontSize: 14,
                          color: ThemeColors.accent,
                        ),
                      ),
                    ),
                  ),

                  const SpacerVertical(),
                  ThemeButton(
                    onPressed: _onVeryClick,
                    text: "Verify and Log In",
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
