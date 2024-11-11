import 'dart:developer';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:stocks_news_new/screens/auth/bottomSheets/aggree_conditions.dart';
import 'package:stocks_news_new/screens/auth/newFlow/verify_otp.dart';
import 'package:stocks_news_new/screens/tabs/home/widgets/app_bar_home.dart';
// import 'package:stocks_news_new/screens/auth/otp/otp_login.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';

import 'package:stocks_news_new/utils/dialogs.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/utils/utils.dart';
import 'package:stocks_news_new/widgets/base_container.dart';
import 'package:stocks_news_new/widgets/custom/country_code_picker_login_widget.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import 'package:stocks_news_new/widgets/theme_button.dart';
import 'package:stocks_news_new/widgets/theme_input_field.dart';
import 'package:validators/validators.dart';

import '../../../widgets/custom/alert_popup.dart';

class Login extends StatefulWidget {
  static const String path = "Login";
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextInputFormatter _formatter = FilteringTextInputFormatter.digitsOnly;
  final TextEditingController _controller = TextEditingController(text: "");
  String? countryCode;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => {});
  }

  void getCountryCode() {
    if (geoCountryCode != null && geoCountryCode != "") {
      countryCode = CountryCode.fromCountryCode(geoCountryCode!).dialCode;
    } else {
      countryCode = CountryCode.fromCountryCode("US").dialCode;
    }
  }

  void _onLoginClick() async {
    closeKeyboard();
    if (!isEmail(_controller.text) && _controller.text.length < 4) {
      popUpAlert(
        message: "Please enter valid phone number",
        title: "Alert",
        icon: Images.alertPopGIF,
      );
      return;
    }

    log("Entered NUmber => ${"$countryCode ${_controller.text}"}");

    showGlobalProgressDialog();
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: "$countryCode ${_controller.text}",
      verificationCompleted: (PhoneAuthCredential credential) {
        closeGlobalProgressDialog();
      },
      verificationFailed: (FirebaseAuthException e) {
        closeGlobalProgressDialog();
        log("Error message => ${e.code} ${e.message} ${e.stackTrace}");
        popUpAlert(
          message: e.code == "invalid-phone-number"
              ? "The format of the phone number provided is incorrect."
              : e.code == "too-many-requests"
                  ? "We have blocked all requests from this device due to unusual activity. Try again after 24 hours."
                  : e.code == "internal-error"
                      ? "The phone number you entered is either incorrect or not currently in use."
                      : e.message ?? Const.errSomethingWrong,
          title: "Alert",
          icon: Images.alertPopGIF,
        );
      },
      codeSent: (String verificationId, int? resendToken) {
        closeGlobalProgressDialog();
        Navigator.push(
          context,
          createRoute(
            VerifyOTP(
              phone: _controller.text,
              verificationId: verificationId,
              countryCode: countryCode!,
            ),
          ),
        );
        // referOTP(
        //   name: name.text,
        //   displayName: displayName.text,
        //   phone: mobile.text,
        //   appSignature: appSignature,
        //   verificationId: verificationId,
        //   countryCode: countryCode!,
        // );
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        closeKeyboard();
      },
      child: BaseContainer(
        appBar: const AppBarHome(
          isPopBack: true,
          canSearch: false,
          showTrailing: false,
          title: "",
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(Dimen.authScreenPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SpacerVertical(height: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Enter your phone\nnumber",
                          style: stylePTSansBold(fontSize: 28),
                        ),
                        const SpacerVertical(height: 5),
                        Text(
                          "We will send you confirmation code",
                          style: stylePTSansRegular(
                            fontSize: 16,
                            color: ThemeColors.greyText,
                          ),
                        ),
                      ],
                    ),
                    const SpacerVertical(height: 30),
                    IntrinsicHeight(
                      child: Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Color.fromARGB(255, 38, 38, 38),
                              borderRadius: BorderRadius.circular(40),
                            ),
                            padding: EdgeInsets.only(left: 10, right: 2),
                            child: CountryPickerLoginWidget(
                              textStyle: stylePTSansBold(
                                color: Colors.white,
                                fontSize: 24,
                              ),
                              onChanged: (value) {
                                countryCode = value.dialCode;
                              },
                            ),
                          ),
                          Flexible(
                            child: ThemeInputField(
                              fillColor: Colors.transparent,
                              cursorColor: ThemeColors.accent,
                              style: stylePTSansBold(
                                color: Colors.white,
                                fontSize: 24,
                              ),
                              hintStyle: stylePTSansBold(
                                color: Colors.grey,
                                fontSize: 24,
                              ),
                              isUnderline: false,
                              controller: _controller,
                              placeholder: "000 000 0000",
                              keyboardType: TextInputType.phone,
                              inputFormatters: [
                                _formatter,
                                LengthLimitingTextInputFormatter(15)
                              ],
                              textCapitalization: TextCapitalization.none,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SpacerVertical(height: Dimen.itemSpacing),
                    AgreeConditions(),
                    const SpacerVertical(height: Dimen.itemSpacing),
                    ThemeButton(text: "Log in", onPressed: _onLoginClick),
                    SpacerVertical(height: 15),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
