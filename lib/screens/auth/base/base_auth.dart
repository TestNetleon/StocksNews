import 'package:country_code_picker/country_code_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/api/api_response.dart';
import 'package:stocks_news_new/modals/user_res.dart';
import 'package:stocks_news_new/providers/home_provider.dart';
import 'package:stocks_news_new/providers/user_provider.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/utils/utils.dart';
import 'package:stocks_news_new/utils/validations.dart';
import 'package:stocks_news_new/widgets/custom/alert_popup.dart';
import 'package:stocks_news_new/widgets/custom/country_code_picker_widget.dart';
import 'package:stocks_news_new/widgets/screen_title.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import 'package:stocks_news_new/widgets/theme_button.dart';
import 'package:stocks_news_new/widgets/theme_input_field.dart';

import 'base_verify.dart';

class BaseAuth extends StatefulWidget {
  const BaseAuth({super.key});

  @override
  State<BaseAuth> createState() => _BaseAuthState();
}

class _BaseAuthState extends State<BaseAuth> {
  String? countryCode;
  String? _verificationId;
  bool isLoading = false;
  TextEditingController phone = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  void initState() {
    super.initState();
    Utils().showLog('BASE AUTH INIT...');
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getCode();
    });
    closeKeyboard();
  }

  statusIsLoading(status) {
    isLoading = status;
    setState(() {});
  }

  Future<void> _verifyPhoneNumber() async {
    statusIsLoading(true);

    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: '${countryCode ?? '+1'} ${phone.text}',
        verificationCompleted: (PhoneAuthCredential credential) async {
          // Auto-resolve on Android (not iOS)
          await _auth.signInWithCredential(credential);
          Utils().showLog(
              'Phone number automatically verified and user signed in: ${_auth.currentUser}');
          statusIsLoading(false);
        },
        verificationFailed: (FirebaseAuthException e) {
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
          statusIsLoading(false);
        },
        codeSent: (String verificationId, int? resendToken) {
          statusIsLoading(false);

          setState(() {
            _verificationId = verificationId;
          });

          Utils().showLog('PHONE => ${phone.text}');
          String mobile = phone.text;
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BaseVerifyOTP(
                countryCode: countryCode ?? '+1',
                phone: mobile,
                verificationId: _verificationId ?? verificationId,
              ),
            ),
          );
          Utils().showLog('Verification code sent.');
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          statusIsLoading(false);

          setState(() {
            _verificationId = verificationId;
          });
        },
        timeout: const Duration(seconds: 60),
      );
    } catch (e) {
      statusIsLoading(false);

      Utils().showLog('Firebase error $e');
    } finally {}
  }

  _getCode() {
    UserRes? user = context.read<UserProvider>().user;
    if (user?.phone != null && user?.phone != '') {
      phone.text = user?.phone ?? '';
    } else {
      phone.text = '';
    }
    setState(() {});
    if (user?.phoneCode != null && user?.phoneCode != "") {
      countryCode = CountryCode.fromDialCode(user?.phoneCode ?? "").dialCode;
    } else if (geoCountryCode != null && geoCountryCode != "") {
      countryCode = CountryCode.fromCountryCode(geoCountryCode!).dialCode;
    } else {
      countryCode = CountryCode.fromCountryCode("US").dialCode;
    }
  }

  void _onChanged(CountryCode value) {
    countryCode = value.dialCode;
    Utils().showLog("COUNTRY CODE => $countryCode");
    setState(() {});
  }

  _gotoVerify() async {
    closeKeyboard();
    if (isEmpty(phone.text)) {
      return popUpAlert(
        message: "Please enter a valid phone number.",
        title: "Alert",
        icon: Images.alertPopGIF,
      );
    }
    Utils().showLog('$countryCode');

    UserProvider provider = context.read<UserProvider>();
    ApiResponse response = await provider.checkPhoneExist(
      countryCode: countryCode ?? '+1',
      phone: phone.text,
    );
    if (response.status) {
      _verifyPhoneNumber();
    } else {
      //
    }
  }

  @override
  void dispose() {
    phone.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    HomeProvider provider = context.watch<HomeProvider>();

    if (provider.extra?.updateYourPhone == null) {
      return SizedBox();
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(8),
          topRight: Radius.circular(8),
        ),
        border: Border(top: BorderSide(color: ThemeColors.greyBorder)),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: const [
            ThemeColors.bottomsheetGradient,
            ThemeColors.background,
          ],
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ScreenTitle(
            title: provider.extra?.updateYourPhone?.title,
            subTitle: provider.extra?.updateYourPhone?.text,
            subTitleHtml: true,
            dividerPadding: EdgeInsets.only(bottom: 5),
          ),
          IntrinsicHeight(
            child: Container(
              decoration: BoxDecoration(
                color: ThemeColors.white,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Row(
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: ThemeColors.white,
                            ),
                          ),
                          color: ThemeColors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(4),
                            bottomLeft: Radius.circular(4),
                          ),
                        ),
                        child: CountryPickerWidget(
                          onChanged: _onChanged,
                          showBox: false,
                        ),
                      ),
                    ],
                  ),
                  Flexible(
                    child: Stack(
                      alignment: Alignment.centerRight,
                      children: [
                        ThemeInputField(
                          style: stylePTSansRegular(
                            color: Colors.black,
                            fontSize: 18,
                          ),
                          borderRadiusOnly: const BorderRadius.only(
                            topRight: Radius.circular(4),
                            bottomRight: Radius.circular(4),
                          ),
                          controller: phone,
                          onChanged: (p0) {
                            phone.text = p0;
                            setState(() {});
                          },
                          placeholder: "Enter your phone number",
                          keyboardType: TextInputType.phone,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(15),
                          ],
                          textCapitalization: TextCapitalization.none,
                        ),
                        Visibility(
                          visible: phone.text != '',
                          child: Positioned(
                            right: 10,
                            child: InkWell(
                              onTap: () {
                                phone.clear();
                                closeKeyboard();
                                setState(() {});
                              },
                              child: Icon(
                                Icons.close,
                                color: ThemeColors.background,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SpacerVertical(height: 10),
          _button(
              text: isLoading
                  ? provider.extra?.updateYourPhone?.verifyButton ??
                      'Verifying your phone number...'
                  : provider.extra?.updateYourPhone?.updateButton ??
                      'Update my phone number',
              onTap: isLoading ? null : _gotoVerify,
              color: const Color.fromARGB(255, 194, 216, 51),
              textColor: ThemeColors.background),
        ],
      ),
    );
  }

  Widget _button({
    required String text,
    required void Function()? onTap,
    Color? color = ThemeColors.accent,
    Color textColor = Colors.white,
  }) {
    return ThemeButton(
      radius: 30,
      // showArrow: false,
      fontBold: true,
      onPressed: onTap,
      text: text,
      color: color,
      textColor: textColor,
    );
  }
}
