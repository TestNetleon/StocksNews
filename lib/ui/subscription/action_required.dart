import 'dart:io';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:stocks_news_new/api/api_response.dart';
import 'package:stocks_news_new/managers/user.dart';
import 'package:stocks_news_new/modals/user_res.dart';
import 'package:stocks_news_new/models/referral/referral_response.dart';
import 'package:stocks_news_new/routes/my_app.dart';
import 'package:stocks_news_new/ui/account/auth/verify.dart';
import 'package:stocks_news_new/ui/base/app_bar.dart';
import 'package:stocks_news_new/ui/base/button.dart';
import 'package:stocks_news_new/ui/base/country_code.dart';
import 'package:stocks_news_new/ui/base/scaffold.dart';
import 'package:stocks_news_new/ui/base/text_field.dart';
import 'package:stocks_news_new/ui/subscription/manager.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/utils/utils.dart';
import 'package:stocks_news_new/utils/validations.dart';
import 'package:stocks_news_new/widgets/custom/alert_popup.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:stocks_news_new/ui/legal/index.dart';

class MembershipActionRequired extends StatefulWidget {
  static const path = 'MembershipActionRequired';
  const MembershipActionRequired({super.key});

  @override
  State<MembershipActionRequired> createState() =>
      _MembershipActionRequiredState();
}

class _MembershipActionRequiredState extends State<MembershipActionRequired> {
  final TextEditingController _phone = TextEditingController();
  final TextEditingController _name = TextEditingController();

  bool numberVerified = true;

  bool changingCountryCode = false;
  String? countryCode;
  String appSignature = "";
  bool boxChecked = false;

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) _getAppSignature();
    _checkProfile();
  }

  bool checkBox = false;

  _checkProfile() {
    UserManager manager = context.read<UserManager>();
    UserRes? user = manager.user;
    if (user?.phoneCode != null && user?.phoneCode != "") {
      Utils().showLog("CCCC ===>  ${user?.phoneCode}");
      countryCode = CountryCode.fromDialCode(user?.phoneCode ?? "").dialCode;
    } else if (geoCountryCode != null && geoCountryCode != "") {
      countryCode = CountryCode.fromCountryCode(geoCountryCode!).dialCode;
    } else {
      countryCode = CountryCode.fromCountryCode("US").dialCode;
    }
    if (user?.name != null && user?.name != '') {
      _name.text = manager.user?.name ?? "";
    }

    if (user?.phone != null && user?.phone != '') {
      _phone.text = user?.phone ?? "";
    }
    numberVerified = user?.phone != null && user?.phone != "";
  }

  void _getAppSignature() {
    try {
      SmsAutoFill().getAppSignature.then((signature) {
        setState(() {
          appSignature = signature;
          Utils().showLog("App Signature => $appSignature");
        });
      });
    } catch (e) {
      Utils().showLog("autofill error $e");
    }
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

  _verification() async {
    if (isEmpty(_phone.text) || isEmpty(_name.text)) {
      //
    } else {
      bool gotoVerify = await _checkPhoneExist();
      if (!gotoVerify) return;

      if (kDebugMode) {
        await Navigator.pushNamed(context, AccountVerificationIndex.path,
            arguments: {
              'name': _name.text,
              'phone': _phone.text,
              'countryCode': countryCode,
              'update': true,
              'verificationId': '1',
              'callBack': () {
                Navigator.pop(navigatorKey.currentContext!);
              }
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

            await Navigator.pushNamed(context, AccountVerificationIndex.path,
                arguments: {
                  'name': _name.text,
                  'phone': _phone.text,
                  'update': true,
                  'countryCode': countryCode,
                  'verificationId': verificationId,
                  'callBack': () {
                    Navigator.pop(navigatorKey.currentContext!);
                  }
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

  @override
  Widget build(BuildContext context) {
    // MyHomeManager manager = context.watch<MyHomeManager>();
    UserManager userManager = context.watch<UserManager>();
    SubscriptionManager manager = context.read<SubscriptionManager>();

    ReferLogin? labels = manager.layoutData?.actionRequired;

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

    return BaseScaffold(
      appBar: BaseAppBar(showBack: true),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: Pad.pad16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SpacerVertical(height: 24),
              Text(
                labels?.title ?? 'Action Required',
                style: styleBaseBold(fontSize: 32),
              ),
              SpacerVertical(height: 8),
              Text(
                textAlign: TextAlign.center,
                labels?.subTitle ??
                    'In order to purchase our membership, please enter the following details',
                style: styleBaseRegular(fontSize: 18),
              ),
              SpacerVertical(height: 40),
              BaseTextField(
                placeholder: 'Name',
                controller: _name,
                onChanged: (text) {
                  _name.text = text;
                  if (mounted) {
                    setState(() {});
                  }
                },
              ),
              SpacerVertical(height: 20),
              Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: ThemeColors.white),
                      ),
                      color: ThemeColors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(4),
                        bottomLeft: Radius.circular(4),
                      ),
                    ),
                    child: BaseCountryCode(
                      enabled: userManager.user?.phone == "" ||
                          userManager.user?.phone == null,
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
                      editable: userManager.user?.phone == "" ||
                          userManager.user?.phone == null,
                      fillColor: userManager.user?.phone == "" ||
                              userManager.user?.phone == null
                          ? null
                          : ThemeColors.neutral5,
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
              Align(
                alignment: Alignment.centerLeft,
                child: Visibility(
                  visible: labels?.note != null && labels?.note != '',
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Text(
                      textAlign: TextAlign.start,
                      labels?.note ?? '',
                      style: styleBaseRegular(
                        color: ThemeColors.neutral80,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
              ),
              SpacerVertical(height: 24),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: Pad.pad5),
                    child: InkWell(
                      onTap: _changeBox,
                      child: Container(
                        height: 20.sp,
                        width: 20.sp,
                        decoration: BoxDecoration(
                          color: boxChecked
                              ? ThemeColors.primary120
                              : ThemeColors.white,
                          border: Border.all(
                            color: boxChecked
                                ? ThemeColors.white
                                : ThemeColors.primary120,
                          ),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Icon(
                          Icons.check,
                          size: 14.sp,
                          color: boxChecked
                              ? ThemeColors.black
                              : ThemeColors.white,
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.only(left: Pad.pad10),
                      child: AccountAgreeTextMembership(
                        text: labels?.text ?? "",
                      ),
                    ),
                  ),
                ],
              ),
              SpacerVertical(height: 24),
              BaseButton(
                radius: 8,
                onPressed: _phone.text.isEmpty ||
                        _name.text.isEmpty ||
                        !boxChecked ||
                        isLoading
                    ? null
                    : _verification,
                textColor: ThemeColors.black,
                text: isLoading
                    ? labels?.verifyBtnText ?? 'Verifying'
                    : labels?.btnText ?? 'Continue',
              ),
              SpacerVertical(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class AccountAgreeTextMembership extends StatelessWidget {
  final String text;
  const AccountAgreeTextMembership({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return HtmlWidget(
      text,
      customStylesBuilder: (element) {
        if (element.localName == 'a') {
          return {'color': '#1bb449', 'text-decoration': 'none'};
        }
        return null;
      },
      onTapUrl: (url) async {
        if (!(url.startsWith('https:') || url.startsWith('http:'))) {
          Navigator.pushNamed(context, LegalInfoIndex.path, arguments: {
            'slug': url == "terms-of-service"
                ? "terms-of-service"
                : "privacy-policy",
          });
        } else {
          openUrl(url);
        }

        return true;
      },
      textStyle: styleBaseRegular(
        fontSize: 14,
        height: 1.6,
        color: ThemeColors.black,
      ),
    );
  }
}
