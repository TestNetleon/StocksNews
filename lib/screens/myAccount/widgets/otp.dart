import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/api/api_response.dart';
import 'package:stocks_news_new/providers/user_provider.dart';
import 'package:stocks_news_new/screens/auth/otp/pinput.dart';

import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/utils/utils.dart';
import 'package:stocks_news_new/widgets/custom/alert_popup.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import 'package:stocks_news_new/widgets/theme_button.dart';

//
class MyAccountOTP extends StatefulWidget {
  final String? otp;
  final String email;
  final String name;
  const MyAccountOTP({
    super.key,
    this.otp,
    required this.email,
    required this.name,
  });

  @override
  State<MyAccountOTP> createState() => _MyAccountOTPState();
}

class _MyAccountOTPState extends State<MyAccountOTP> {
  final TextEditingController otpController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // otpController.text = widget.otp ?? "";
  }

  void _onResendOtpClick(BuildContext context, UserProvider provider) async {
    UserProvider provider = context.read<UserProvider>();
    Map request = {
      "token": provider.user?.token ?? "",
      "email": widget.email,
    };

    try {
      ApiResponse response = await provider.resendUpdateEmailOtp(request);
      if (response.status) {
        Utils().showLog("updating OTP via resend OTP.......");

        // otpController.text = response.data["otp"].toString();
      }
    } catch (e) {
      //
    }
  }

  void _verify(BuildContext context, UserProvider provider) async {
    try {
      ApiResponse response = await context.read<UserProvider>().updateProfile(
            token: context.read<UserProvider>().user?.token ?? "",
            name: widget.name,
            email: widget.email,
            verifyOTP: true,
            otp: otpController.text,
          );
      if (!mounted) return;

      if (response.status) {
        Utils().showLog("updating user via email.......");
        provider.updateUser(email: widget.email);
      } else {
        popUpAlert(
            message: response.message ?? "",
            title: "Alert",
            icon: Images.alertPopGIF);
      }
    } catch (e) {
      //
    }
  }

  @override
  Widget build(BuildContext context) {
    UserProvider provider = context.read<UserProvider>();

    return Padding(
      padding: const EdgeInsets.all(Dimen.authScreenPadding),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const SpacerVertical(height: 50),
            Align(
              alignment: Alignment.center,
              child: Text(
                "OTP VERIFICATION",
                style: stylePTSansBold(fontSize: 22),
              ),
            ),
            const SpacerVertical(height: 8),
            Text(
              "Please enter the 4-digit verification code that was sent to ${widget.email}. The code is valid for 10 minutes.",
              style: stylePTSansRegular(
                fontSize: 14,
                color: Colors.white,
                height: 1.4,
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
            //       controller: otpController,
            //       placeholder: "",
            //       // keyboardType: TextInputType.phone,
            //       inputFormatters: [mobilrNumberAllow],
            //       maxLength: 4,
            //     ),
            //     Container(
            //       margin: EdgeInsets.only(right: 8.sp),
            //       alignment: Alignment.centerRight,
            //       child: TextButton(
            //         onPressed: () => _onResendOtpClick(context, provider),
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
              controller: otpController,
              onCompleted: (p0) {
                _verify(context, provider);
              },
            ),

            Container(
              margin: EdgeInsets.only(right: 8.sp),
              alignment: Alignment.center,
              child: TextButton(
                onPressed: () => _onResendOtpClick(context, provider),
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
              onPressed: () => _verify(context, provider),
              text: "Verify",
            ),
            const SpacerVertical(),
          ],
        ),
      ),
    );
  }
}
