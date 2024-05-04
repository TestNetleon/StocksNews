import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/providers/user_provider.dart';
import 'package:stocks_news_new/screens/tabs/home/widgets/app_bar_home.dart';

import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/preference.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/utils/validations.dart';
import 'package:stocks_news_new/widgets/base_container.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import 'package:stocks_news_new/widgets/theme_button.dart';
import 'package:stocks_news_new/widgets/theme_input_field.dart';

//
class OTPLogin extends StatefulWidget {
  static const String path = "OTPLogin";
  final String? state;
  final String? dontPop;
  const OTPLogin({super.key, this.state, this.dontPop});

  @override
  State<OTPLogin> createState() => _OTPLoginState();
}

class _OTPLoginState extends State<OTPLogin> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    //   UserRes? user = context.read<UserProvider>().user;
    //   _controller.text = "${user?.otp}";
    // });
    log("---State is ${widget.state}, ---Dont pop up is${widget.dontPop}---");
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onVeryClick() async {
    UserProvider provider = context.read<UserProvider>();
    String? fcmToken = await Preference.getFcmToken();

    Map request = {
      "username": provider.user?.username ?? "",
      "type": "email",
      "otp": _controller.text,
      "fcm_token": fcmToken ?? "",
    };

    provider.verifyLoginOtp(request,
        state: widget.state, dontPop: widget.dontPop);
  }

  void _onResendOtpClick() {
    UserProvider provider = context.read<UserProvider>();
    Map request = {
      "username": provider.user?.username ?? "",
      "type": "email",
    };
    provider.resendOtp(request);
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
                    "Please enter the 4-digit verification code that was sent to ${provider.user?.username}. The code is valid for 30 minutes.",
                    style: stylePTSansRegular(
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
                  const SpacerVertical(),
                  Text(
                    "Verification Code",
                    style: stylePTSansRegular(fontSize: 14),
                  ),
                  const SpacerVertical(height: 5),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      ThemeInputField(
                        controller: _controller,
                        placeholder: "",
                        // keyboardType: TextInputType.phone,
                        inputFormatters: [mobilrNumberAllow],
                        maxLength: 4,
                      ),
                      Container(
                        margin: EdgeInsets.only(right: 8.sp),
                        alignment: Alignment.centerRight,
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
                    ],
                  ),
                  const SpacerVertical(),
                  ThemeButton(
                    onPressed: _onVeryClick,
                    text: "Verify",
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
