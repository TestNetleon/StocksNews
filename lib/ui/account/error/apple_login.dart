import 'package:flutter/material.dart';
import 'package:stocks_news_new/ui/base/button.dart';
import 'package:stocks_news_new/ui/base/text_field.dart';
import 'package:stocks_news_new/ui/base/toaster.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/utils/validations.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

class AppleLoginErrorIndex extends StatefulWidget {
  const AppleLoginErrorIndex({super.key});

  @override
  State<AppleLoginErrorIndex> createState() => _AppleLoginErrorIndexState();
}

class _AppleLoginErrorIndexState extends State<AppleLoginErrorIndex> {
  TextEditingController _email = TextEditingController();

  _onTap() {
    if (isEmpty(_email.text) || !isEmpty(_email.text)) {
      TopSnackbar.show(message: 'Please enter a valid email address');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "Enter Email Address",
          style: styleBaseBold(
            fontSize: 20,
          ),
        ),
        const SpacerVertical(height: 10),
        Text(
          textAlign: TextAlign.center,
          "Looks like there is some issue with registration, please enter your Apple ID using that you want to sign up. You will receive an OTP for verification on this email address.",
          style: styleBaseRegular(
            fontSize: 14,
            color: ThemeColors.greyText,
            height: 1.3,
          ),
        ),
        const SpacerVertical(height: 10),
        Text(
          textAlign: TextAlign.center,
          "After successful sign up you will be able to login with Apple ID.",
          style: styleBaseRegular(
            fontSize: 14,
            color: ThemeColors.greyText,
            height: 1.3,
          ),
        ),
        const SpacerVertical(height: 20),
        BaseTextField(
          onChanged: (p0) {
            p0 = _email.text;
            setState(() {});
          },
          controller: _email,
          hintText: 'Enter email address',
        ),
        const SpacerVertical(height: 20),
        BaseButton(
          text: 'Next',
          onPressed: _email.text.isEmpty ? null : _onTap,
        ),
      ],
    );
  }
}
