import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/api/api_response.dart';
import 'package:stocks_news_new/managers/user.dart';
import 'package:stocks_news_new/modals/user_res.dart';
import 'package:stocks_news_new/models/referral/referral_response.dart';
import 'package:stocks_news_new/routes/my_app.dart';
import 'package:stocks_news_new/ui/account/auth/verify.dart';
import 'package:stocks_news_new/ui/base/button.dart';
import 'package:stocks_news_new/ui/base/country_code.dart';
import 'package:stocks_news_new/ui/base/text_field.dart';
import 'package:stocks_news_new/ui/base/toaster.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/utils/utils.dart';
import 'package:stocks_news_new/utils/validations.dart';
import 'package:stocks_news_new/widgets/custom/alert_popup.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import 'package:country_code_picker/country_code_picker.dart';

class AppleLoginErrorIndex extends StatefulWidget {
  final Map? extraRequest;
  final ReferLogin? data;
  const AppleLoginErrorIndex({
    super.key,
    this.extraRequest,
    this.data,
  });

  @override
  State<AppleLoginErrorIndex> createState() => _AppleLoginErrorIndexState();
}

class _AppleLoginErrorIndexState extends State<AppleLoginErrorIndex> {
  TextEditingController _phone = TextEditingController();
  String? countryCode;
  bool boxChecked = false;
  bool changingCountryCode = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _setCountryCode();
    });
  }

  _setCountryCode() {
    UserRes? user = context.read<UserManager>().user;
    if (user?.phone != null && user?.phone != '') {
      _phone.text = user?.phone ?? '';
    } else {
      _phone.text = '';
    }
    if (user?.phoneCode != null && user?.phoneCode != "") {
      countryCode = CountryCode.fromDialCode(user?.phoneCode ?? "").dialCode;
    } else if (geoCountryCode != null && geoCountryCode != "") {
      countryCode = CountryCode.fromCountryCode(geoCountryCode!).dialCode;
    } else {
      countryCode = CountryCode.fromCountryCode("US").dialCode;
    }
  }

  bool isLoading = false;

  setLoading(status) {
    print('Status $status');
    isLoading = status;
    if (mounted) {
      setState(() {});
    }
  }

  _changeBox() {
    boxChecked = !boxChecked;
    if (mounted) {
      setState(() {});
    }
  }

  Future<bool> _checkPhoneExist() async {
    UserManager manager = context.read<UserManager>();

    ApiResponse response = await manager.checkPhoneExist(
      phone: _phone.text,
      countryCode: countryCode!,
    );
    if (response.status) {
      return true;
    } else {
      return false;
    }
  }

  _verification() async {
    if (isEmpty(_phone.text)) {
      TopSnackbar.show(message: 'Please enter a valid phone number');
    } else {
      closeKeyboard();
      if (kDebugMode) {
        bool gotoVerify = await _checkPhoneExist();
        if (!gotoVerify) return;
        Navigator.pop(navigatorKey.currentContext!);

        Navigator.pushNamed(
            navigatorKey.currentContext!, AccountVerificationIndex.path,
            arguments: {
              'phone': _phone.text,
              'countryCode': countryCode,
              'verificationId': '1',
              'fromAppleVerify': true,
              'extraRequest': widget.extraRequest,
            });
        return;
      }

      setLoading(true);

      try {
        await FirebaseAuth.instance.verifyPhoneNumber(
          phoneNumber: '${countryCode ?? '+1'} ${_phone.text}',
          verificationCompleted: (PhoneAuthCredential credential) async {
            await FirebaseAuth.instance.signInWithCredential(credential);

            setLoading(false);
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
            setLoading(false);
            Utils().showLog('$e');
          },
          codeSent: (String verificationId, int? resendToken) async {
            setLoading(false);
            bool gotoVerify = await _checkPhoneExist();
            if (!gotoVerify) return;
            Navigator.pop(navigatorKey.currentContext!);

            Navigator.pushNamed(
                navigatorKey.currentContext!, AccountVerificationIndex.path,
                arguments: {
                  'phone': _phone.text,
                  'countryCode': countryCode,
                  'verificationId': verificationId,
                  'fromAppleVerify': true,
                  'extraRequest': widget.extraRequest,
                });
            Utils().showLog('Verification code sent.');
          },
          codeAutoRetrievalTimeout: (String verificationId) {
            Utils().showLog('Time Out');
            setLoading(false);
          },
          timeout: const Duration(seconds: 60),
        );
      } catch (e) {
        Utils().showLog('Firebase error $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    UserManager userManager = context.watch<UserManager>();

    if (!changingCountryCode) {
      if (userManager.user?.phoneCode != null &&
          userManager.user?.phoneCode != "") {
        countryCode =
            CountryCode.fromDialCode(userManager.user?.phoneCode ?? "")
                .dialCode;
      } else if (geoCountryCode != null && geoCountryCode != "") {
        countryCode = CountryCode.fromCountryCode(geoCountryCode!).dialCode;
      } else {
        countryCode = CountryCode.fromCountryCode("US").dialCode;
      }
    }

    return Column(
      children: [
        const SpacerVertical(height: 20),

        Text(
          widget.data?.title ?? "Enter Phone Number",
          style: styleBaseBold(
            fontSize: 20,
          ),
        ),
        const SpacerVertical(height: 10),
        Text(
          textAlign: TextAlign.center,
          widget.data?.text ?? "",
          style: styleBaseRegular(
            fontSize: 14,
            color: ThemeColors.greyText,
            height: 1.3,
          ),
        ),
        const SpacerVertical(height: 10),
        Text(
          textAlign: TextAlign.center,
          widget.data?.note ?? "",
          style: styleBaseRegular(
            fontSize: 14,
            color: ThemeColors.greyText,
            height: 1.3,
          ),
        ),
        const SpacerVertical(height: 20),
        // BaseTextField(
        //   onChanged: (p0) {
        //     p0 = _phone.text;
        //     setState(() {});
        //   },
        //   controller: _phone,
        //   keyboardType: TextInputType.number,
        //   hintText: 'Phone number',
        // ),

        Row(
          children: [
            Container(
              decoration: BoxDecoration(
                // border: Border(
                //   bottom: BorderSide(color: ThemeColors.white),
                // ),
                // color: ThemeColors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(4),
                  bottomLeft: Radius.circular(4),
                ),
              ),
              child: BaseCountryCode(
                onChanged: (CountryCode value) {
                  changingCountryCode = true;
                  countryCode = value.dialCode;
                  if (mounted) {
                    setState(() {});
                  }
                },
              ),
            ),
            Expanded(
              child: BaseTextField(
                placeholder: 'Phone number',
                controller: _phone,
                keyboardType: TextInputType.phone,
                onChanged: (text) {
                  _phone.text = text;
                  if (mounted) {
                    setState(() {});
                  }
                },
              ),
            ),
          ],
        ),
        const SpacerVertical(height: 20),
        BaseButton(
          text: isLoading
              ? widget.data?.verifyBtnText ?? 'Verifying'
              : widget.data?.btnText ?? 'Continue',
          onPressed: _phone.text.isEmpty ? null : _verification,
        ),
        const SpacerVertical(height: 20),
      ],
    );
  }
}
