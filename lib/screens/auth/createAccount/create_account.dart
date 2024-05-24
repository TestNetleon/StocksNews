import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/providers/user_provider.dart';
// import 'package:stocks_news_new/screens/auth/otp/otp_login.dart';

import 'package:stocks_news_new/utils/constants.dart';

import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/utils/utils.dart';
import 'package:stocks_news_new/utils/validations.dart';
import 'package:stocks_news_new/widgets/base_container.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import 'package:stocks_news_new/widgets/theme_button.dart';
import 'package:stocks_news_new/widgets/theme_input_field.dart';
import 'package:validators/validators.dart';

//
class CreateAccount extends StatefulWidget {
  static const String path = "CreateAccount";

  const CreateAccount({super.key});

  @override
  State<CreateAccount> createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  final TextEditingController _controller = TextEditingController();
  // ignore: unused_field
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  void _onLoginClick() {
    closeKeyboard();
    if (!isEmail(_controller.text) && !isNumeric(_controller.text)) {
      // showErrorMessage(
      //   message: "Please enter valid email address",
      // );
      return;
    }

    // else if (isNumeric(_controller.text) &&
    //     (isEmpty(_controller.text) || !isLength(_controller.text, 3))) {
    //   showErrorMessage(message: "Please enter valid phone number");
    //   return;
    // }

    UserProvider provider = context.read<UserProvider>();

    Map request = {"username": _controller.text.toLowerCase()};

    provider.signup(request);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseContainer(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                borderRadius: BorderRadius.circular(30.sp),
                child: Container(
                  padding: EdgeInsets.all(15.sp),
                  child: const Icon(Icons.arrow_back_ios_new_rounded),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(Dimen.authScreenPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // const SpacerVertical(height: 16),
                  Text(
                    "CREATE ACCOUNT",
                    style: stylePTSansBold(fontSize: 24),
                  ),
                  const SpacerVertical(height: 40),
                  Text(
                    "Email Address",
                    style: stylePTSansRegular(fontSize: 14),
                  ),
                  const SpacerVertical(height: 5),
                  ThemeInputField(
                    controller: _controller,
                    placeholder: "Enter email address",
                    keyboardType: TextInputType.emailAddress,
                    inputFormatters: [emailFormatter],
                    textCapitalization: TextCapitalization.none,
                  ),
                  const SpacerVertical(height: Dimen.itemSpacing),
                  ThemeButton(
                    text: "Next",
                    onPressed: _onLoginClick,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
