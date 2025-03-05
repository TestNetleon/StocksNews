import 'package:country_code_picker/country_code_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/api/api_response.dart';
import 'package:stocks_news_new/managers/user.dart';
import 'package:stocks_news_new/modals/user_res.dart';
import 'package:stocks_news_new/ui/account/update/delete.dart';
import 'package:stocks_news_new/ui/account/update/email_verify.dart';
import 'package:stocks_news_new/ui/base/app_bar.dart';
import 'package:stocks_news_new/ui/base/base_scroll.dart';
import 'package:stocks_news_new/ui/base/scaffold.dart';
import 'package:stocks_news_new/ui/base/text_field.dart';
import 'package:stocks_news_new/ui/base/toaster.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/utils/utils.dart';
import 'package:stocks_news_new/utils/validations.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import 'package:validators/validators.dart';
import '../../../widgets/custom/alert_popup.dart';
import '../../base/button.dart';
import '../../base/country_code.dart';
import '../auth/verify.dart';
import 'update_pic.dart';

class UpdatePersonalDetailIndex extends StatefulWidget {
  static const path = 'UpdatePersonalDetailIndex';
  const UpdatePersonalDetailIndex({super.key});

  @override
  State<UpdatePersonalDetailIndex> createState() =>
      _UpdatePersonalDetailIndexState();
}

class _UpdatePersonalDetailIndexState extends State<UpdatePersonalDetailIndex> {
  String? countryCode;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _update(check: true);
    });
  }

  TextEditingController name = TextEditingController();
  TextEditingController displayName = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController phone = TextEditingController();

  _update({check = false}) {
    UserManager manager = context.read<UserManager>();
    UserRes? user = manager.user;
    if (check) {
      if (user?.name != null && user?.name != '') {
        name.text = manager.user?.name ?? '';
      }
      if (user?.displayName != null && user?.displayName != '') {
        displayName.text = manager.user?.displayName ?? '';
      }
      if (user?.email != null && user?.email != '') {
        email.text = manager.user?.email ?? '';
        manager.onChangeEmail(email.text);
      }
      if (user?.phone != null && user?.phone != '') {
        phone.text = manager.user?.phone ?? '';
        manager.onChangePhone(
          phone: phone.text,
          countryCode: user?.phoneCode ?? '',
        );
      }
      if (user?.phoneCode != null && user?.phoneCode != "") {
        countryCode = CountryCode.fromDialCode(user?.phoneCode ?? "").dialCode;
      } else if (geoCountryCode != null && geoCountryCode != "") {
        countryCode = CountryCode.fromCountryCode(geoCountryCode!).dialCode;
      } else {
        countryCode = CountryCode.fromCountryCode("US").dialCode;
      }

      setState(() {});
    } else {
      if (isEmpty(name.text)) {
        TopSnackbar.show(message: 'Please enter your name');
      } else if (isEmpty(displayName.text)) {
        TopSnackbar.show(message: 'Please enter your display name');
      } else {
        closeKeyboard();

        manager.updatePersonalDetails(
          name: name.text,
          displayName: displayName.text,
        );
      }
    }
  }

  _updatePhone() {
    if (isEmpty(phone.text)) {
      TopSnackbar.show(message: 'Enter valid phone number');
      return;
    }
    Navigator.pushNamed(context, AccountVerificationIndex.path, arguments: {
      'phone': phone.text,
      'countryCode': countryCode,
      'verificationId': '1',
    });
  }

  bool isLoading = false;

  setLoading(status) {
    isLoading = status;
    if (mounted) {
      setState(() {});
    }
  }

  Future<bool> _checkPhoneExist() async {
    UserManager manager = context.read<UserManager>();

    ApiResponse response = await manager.checkPhoneExist(
      phone: phone.text,
      countryCode: countryCode!,
    );
    if (response.status) {
      return true;
    } else {
      return false;
    }
  }

  _verifyPhone() async {
    closeKeyboard();
    if (isEmpty(phone.text)) {
      TopSnackbar.show(message: 'Enter valid phone number');
      return;
    } else {
      bool gotoVerify = await _checkPhoneExist();
      if (!gotoVerify) return;
      if (kDebugMode) {
        Navigator.pushNamed(context, AccountVerificationIndex.path, arguments: {
          'phone': phone.text,
          'countryCode': countryCode,
          'verificationId': '1',
          'update': true,
        });

        return;
      }
      setLoading(true);
      try {
        await FirebaseAuth.instance.verifyPhoneNumber(
          phoneNumber: '${countryCode ?? '+1'} ${phone.text}',
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
          codeSent: (String verificationId, int? resendToken) {
            setLoading(false);

            Navigator.pushNamed(context, AccountVerificationIndex.path,
                arguments: {
                  'phone': phone.text,
                  'countryCode': countryCode,
                  'verificationId': verificationId,
                  'update': true,
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
      } finally {
        setLoading(false);
      }
    }
  }

  _verifyEmail() async {
    closeKeyboard();

    if (isEmpty(email.text) || !isEmail(email.text)) {
      TopSnackbar.show(message: 'Enter valid email address');
      return;
    }
    UserManager manager = context.read<UserManager>();

    ApiResponse response = await manager.checkEmailExist(email.text);
    if (response.status) {
      Navigator.pushNamed(context, AccountEmailVerificationIndex.path,
          arguments: {
            'email': email.text,
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    UserManager manager = context.watch<UserManager>();
    return BaseScaffold(
      appBar: BaseAppBar(
        showBack: true,
        title: 'Personal Details',
        onSaveClick: _update,
      ),
      body: Column(
        children: [
          Expanded(
            child: BaseScroll(
              children: [
                PersonalDetailUpdatePic(),
                SpacerVertical(height: 25),
                BaseTextField(
                  placeholder: 'Name',
                  controller: name,
                  textCapitalization: TextCapitalization.words,
                  keyboardType: TextInputType.name,
                ),
                SpacerVertical(height: 18),
                BaseTextField(
                  controller: displayName,
                  placeholder: 'Display Name',
                  textCapitalization: TextCapitalization.words,
                ),
                SpacerVertical(height: 18),
                Stack(
                  alignment: Alignment.centerRight,
                  children: [
                    BaseTextField(
                      controller: email,
                      placeholder: 'Email',
                      keyboardType: TextInputType.emailAddress,
                      textCapitalization: TextCapitalization.none,
                      onChanged: (p0) {
                        // email.text = p0;
                        // setState(() {});
                        manager.onChangeEmail(p0);
                      },
                      contentPadding: EdgeInsets.only(
                        top: Pad.pad16,
                        bottom: Pad.pad16,
                        left: Pad.pad16,
                        right: 90,
                      ),
                    ),
                    Positioned(
                      right: 10,
                      child: GestureDetector(
                        onTap: manager.emailVerified ? null : _verifyEmail,
                        child: Text(
                          manager.emailVerified ? 'Verified' : 'Update',
                          style: styleBaseBold(
                            fontSize: 14,
                            color: ThemeColors.secondary100,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SpacerVertical(height: 18),
                Stack(
                  alignment: Alignment.centerRight,
                  children: [
                    Row(
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
                          child: BaseCountryCode(
                            onChanged: (CountryCode value) {
                              countryCode = value.dialCode;
                              setState(() {});
                              manager.onChangePhone(
                                phone: phone.text,
                                countryCode: countryCode!,
                              );
                            },
                          ),
                        ),
                        Expanded(
                          child: BaseTextField(
                            placeholder: 'Phone number',
                            controller: phone,
                            keyboardType: TextInputType.phone,
                            onChanged: (p0) {
                              phone.text = p0;
                              setState(() {});
                              manager.onChangePhone(
                                phone: phone.text,
                                countryCode: countryCode!,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                    Positioned(
                      right: 10,
                      child: InkWell(
                        onTap: manager.phoneVerified ? null : _verifyPhone,
                        child: Text(
                          manager.phoneVerified ? 'Verified' : 'Update',
                          style: styleBaseBold(
                            fontSize: 14,
                            color: ThemeColors.secondary100,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: Pad.pad16, vertical: 10),
            child: BaseButton(
              fontBold: false,
              icon: Images.delete,
              text: 'Delete Account',
              onPressed: () {
                Navigator.pushNamed(context, DeletePersonalDetail.path);
              },
              color: ThemeColors.white,
              textColor: ThemeColors.neutral40,
              side: BorderSide(
                color: ThemeColors.neutral20,
                width: 2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
