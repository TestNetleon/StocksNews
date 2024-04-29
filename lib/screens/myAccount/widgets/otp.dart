import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/api/api_response.dart';
import 'package:stocks_news_new/providers/user_provider.dart';

import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/utils/validations.dart';
import 'package:stocks_news_new/widgets/spacer_verticle.dart';
import 'package:stocks_news_new/widgets/theme_button.dart';
import 'package:stocks_news_new/widgets/theme_input_field.dart';

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
        log("updating OTP via resend OTP.......");

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
        log("updating user via email.......");
        provider.updateUser(email: widget.email);
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
            const SpacerVerticel(height: 50),
            Text(
              "OTP VERIFICATION",
              style: stylePTSansBold(fontSize: 22),
            ),
            const SpacerVerticel(height: 8),
            Text(
              "Please enter the 4-digit verification code that was sent to ${widget.email}. The code is valid for 30 minutes.",
              style: stylePTSansRegular(
                fontSize: 14,
                color: Colors.white,
              ),
            ),
            const SpacerVerticel(),
            Text(
              "Verification Code",
              style: stylePTSansRegular(fontSize: 14),
            ),
            const SpacerVerticel(height: 5),
            Stack(
              alignment: Alignment.center,
              children: [
                ThemeInputField(
                  controller: otpController,
                  placeholder: "",
                  // keyboardType: TextInputType.phone,
                  inputFormatters: [mobilrNumberAllow],
                  maxLength: 4,
                ),
                Container(
                  margin: EdgeInsets.only(right: 8.sp),
                  alignment: Alignment.centerRight,
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
              ],
            ),
            const SpacerVerticel(),
            ThemeButton(
              onPressed: () => _verify(context, provider),
              text: "Verify",
            ),
            const SpacerVerticel(),
          ],
        ),
      ),
    );
  }
}
