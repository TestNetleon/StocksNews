import 'dart:developer';
import 'dart:io';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:stocks_news_new/api/api_response.dart';
import 'package:stocks_news_new/modals/user_res.dart';
import 'package:stocks_news_new/providers/home_provider.dart';
import 'package:stocks_news_new/providers/user_provider.dart';
import 'package:stocks_news_new/screens/myAccount/widgets/my-account_header.dart';
import 'package:stocks_news_new/screens/myAccount/widgets/otp.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/dialogs.dart';
import 'package:stocks_news_new/widgets/alphabet_inputformatter.dart';
import 'package:stocks_news_new/widgets/custom/alert_popup.dart';
import 'package:stocks_news_new/widgets/custom/country_code_picker_widget.dart';
import 'package:stocks_news_new/widgets/theme_button.dart';
import 'package:validators/validators.dart';
import '../../utils/theme.dart';
import '../../utils/utils.dart';
import '../../utils/validations.dart';
import '../../widgets/spacer_vertical.dart';
import '../../widgets/theme_input_field.dart';
import '../auth/base/base_verify.dart';
import '../contactUs/contact_us_item.dart';

class MyAccountContainer extends StatefulWidget {
  const MyAccountContainer({super.key});

  @override
  State<MyAccountContainer> createState() => _MyAccountContainerState();
}

class _MyAccountContainerState extends State<MyAccountContainer>
    with WidgetsBindingObserver {
  final picker = ImagePicker();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController displayController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  final TextInputFormatter _formatter = FilteringTextInputFormatter.digitsOnly;
  String appSignature = "";
  String? countryCode;

  // bool emailVerified = false;
  // bool phoneVerified = false;

  // _validate() {
  //   UserRes? user = context.read<UserProvider>().user;
  //   if (user?.email != null && user?.email != '') {
  //     emailController.text = ;
  //   }
  // }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    nameController.dispose();
    emailController.dispose();
    displayController.dispose();
    mobileController.dispose();
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    UserProvider provider = context.read<UserProvider>();
    provider.keyboardVisibility(context);
  }

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) _getAppSignature();

    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UserProvider>().resetVerification();
      _updateUser();
      // _callAPI();
    });
  }

  void _getAppSignature() {
    try {
      SmsAutoFill().getAppSignature.then((signature) {
        setState(() {
          appSignature = signature;
          setState(() {});
          Utils().showLog("App Signature => $appSignature");
        });
      });
    } catch (e) {
      Utils().showLog("autofill error $e");
    }
  }

  // _callAPI() {
  //   // UserProvider userProvider = context.read<UserProvider>();
  //   // if (userProvider.user?.affiliateStatus == 0) {
  //   //   return;
  //   // }
  //   LeaderBoardProvider provider = context.read<LeaderBoardProvider>();
  //   UserProvider userProvider = context.read<UserProvider>();
  //   if (userProvider.user?.affiliateStatus == 1) {
  //     provider.getReferData(checkAppUpdate: false);
  //   }
  // }

  void _updateUser() {
    UserProvider provider = context.read<UserProvider>();

    UserRes? user = context.read<UserProvider>().user;
    if (user?.email != '' && user?.email != null) {
      provider.setEmailClickText();
    }

    // UserRes? user = context.read<UserProvider>().user;
    // countryCode = user?.phoneCode == null || user?.phoneCode == ""
    //     ? CountryCode.fromCountryCode(Intl.getCurrentLocale().split('_').last)
    //             .dialCode ??
    //         ""
    //     : CountryCode.fromDialCode(user?.phoneCode ?? " ").dialCode ?? "";

    if (user?.phoneCode != null && user?.phoneCode != "") {
      countryCode = CountryCode.fromDialCode(user?.phoneCode ?? "").dialCode;
    } else if (geoCountryCode != null && geoCountryCode != "") {
      countryCode = CountryCode.fromCountryCode(geoCountryCode!).dialCode;
    } else {
      countryCode = CountryCode.fromCountryCode("US").dialCode;
    }

    if (user?.phone != '' && user?.phone != null) {
      provider.setPhoneClickText();
      mobileController.text = user?.phone ?? '';
    }
    if (user?.name?.isNotEmpty == true) nameController.text = user?.name ?? "";
    if (user?.email?.isNotEmpty == true) {
      emailController.text = user?.email ?? "";
      mobileController.text = user?.phone ?? "";
    }
    if (user?.displayName?.isNotEmpty == true) {
      displayController.text = user?.displayName ?? "";
    }
  }

  void _onTap() async {
    UserProvider provider = context.read<UserProvider>();

    closeKeyboard();
    if (isEmpty(nameController.text)) {
      popUpAlert(
          message: "Please enter valid name.",
          title: "Alert",
          icon: Images.alertPopGIF);
      return;
    }
    if (isEmpty(displayController.text)) {
      popUpAlert(
          message: "Please enter display name.",
          title: "Alert",
          icon: Images.alertPopGIF);
      return;
    }
    // if (!isEmail(emailController.text)) {
    //   popUpAlert(
    //       message: "Please enter valid email address.",
    //       title: "Alert",
    //       icon: Images.alertPopGIF);
    //   return;
    // }
    // if (mobileController.text.isEmpty || mobileController.text.length < 10) {
    //   popUpAlert(
    //     message: "Please enter a valid phone number.",
    //     title: "Alert",
    //     icon: Images.alertPopGIF,
    //   );
    //   return;
    // }
    // if (provider.user?.phone != mobileController.text.trim()) {
    //   Utils().showLog("mobile not exist ${provider.user?.phone}");
    // phoneOTP(
    //   phone: mobileController.text.trim(),
    //   name: nameController.text.trim(),
    //   displayName: displayController.text.trim(),
    //   email: nameController.text.trim(),
    // );
    //   return;
    // }
    {
      try {
        ApiResponse res = await context.read<UserProvider>().updateProfile(
              token: context.read<UserProvider>().user?.token ?? "",
              name: nameController.text,
              displayName: displayController.text,
              email: "",
            );
        Utils().showLog('!~~~~${res.status}');
        if (res.status) {
          // if (emailController.text != provider.user?.email) {
          //   Utils().showLog('!!~~~~!!');

          //   _sendOTP(otp: res.data["otp"].toString());
          // } else {
          //   Utils().showLog('~~~~~~~~~~~`');

          // }
          popUpAlert(
            message: res.message ?? "",
            title: "Profile Updated",
            iconWidget: Image.asset(
              Images.receiveGIF,
              height: 80,
              width: 80,
            ),
          );

          provider.updateUser(
            name: nameController.text,
            displayName: displayController.text,
          );
        }
      } catch (e) {
        //
      }
    }
  }

  void _sendOTP({String? otp}) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(6.sp),
            topRight: Radius.circular(6.sp),
          ),
        ),
        backgroundColor: ThemeColors.background,
        builder: (context) {
          return Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: MyAccountOTP(
              otp: otp,
              name: nameController.text,
              email: emailController.text,
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    UserProvider provider = context.watch<UserProvider>();
    HomeProvider homeProvider = context.watch<HomeProvider>();

    // if (provider.user?.phoneCode != null && provider.user?.phoneCode != "") {
    //   countryCode =
    //       CountryCode.fromDialCode(provider.user?.phoneCode ?? "").dialCode;
    // } else if (geoCountryCode != null && geoCountryCode != "") {
    //   countryCode = CountryCode.fromCountryCode(geoCountryCode!).dialCode;
    // } else {
    //   countryCode = CountryCode.fromCountryCode("US").dialCode;
    // }

    // final String locale = Intl.getCurrentLocale().split('_').last;

    // UserRes? user = context.read<UserProvider>().user;
    // HomeProvider provider = context.watch<HomeProvider>();

    // final String locale = user?.phoneCode == null || user?.phoneCode == ""
    //     ? Intl.getCurrentLocale().split('_').last
    //     : CountryCode.fromDialCode(user?.phoneCode ?? " ")
    //             .code
    //             ?.split('_')
    //             .last ??
    //         "";

    // String? locale;
    // if (user?.phoneCode != null && user?.phoneCode != "") {
    //   locale = CountryCode.fromDialCode(user!.phoneCode!).code?.split('_').last;
    // } else if (geoCountryCode != null && geoCountryCode != "") {
    //   locale = geoCountryCode;
    // } else {
    //   locale = "US";
    // }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const MyAccountHeader(),
        const SpacerVertical(height: 13),
        showAsteriskText(text: "Real Name", bold: true),
        const SpacerVertical(height: 5),
        ThemeInputField(
          cursorColor: Colors.white,
          fillColor: ThemeColors.primaryLight,
          borderColor: ThemeColors.primaryLight,
          controller: nameController,
          placeholder: "Enter your name",
          keyboardType: TextInputType.text,
          inputFormatters: [AlphabetInputFormatter()],
          textCapitalization: TextCapitalization.words,
          style: stylePTSansRegular(color: Colors.white),
        ),
        const SpacerVertical(height: 13),
        showAsteriskText(text: "Display Name", bold: true),
        const SpacerVertical(height: 5),
        ThemeInputField(
          cursorColor: Colors.white,
          style: stylePTSansRegular(color: Colors.white),
          fillColor: ThemeColors.primaryLight,
          borderColor: ThemeColors.primaryLight,
          controller: displayController,
          placeholder: "Enter your display name",
          keyboardType: TextInputType.text,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9 ]')),
            LengthLimitingTextInputFormatter(20)
          ],
          textCapitalization: TextCapitalization.words,
        ),
        const SpacerVertical(height: 13),
        Text(
          "Email Address",
          style: stylePTSansBold(color: Colors.white, fontSize: 14),
        ),
        const SpacerVertical(height: 5),
        IntrinsicHeight(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    ThemeInputField(
                      onChanged: (value) => provider.onChangeEmail(value),
                      cursorColor: Colors.white,
                      style: stylePTSansRegular(color: Colors.white),
                      fillColor: ThemeColors.primaryLight,
                      borderColor: ThemeColors.primaryLight,
                      controller: emailController,
                      maxLines: 1,
                      placeholder: "Enter your email address",
                      keyboardType: TextInputType.emailAddress,
                      inputFormatters: [emailFormatter],
                      textCapitalization: TextCapitalization.none,
                      contentPadding: EdgeInsets.only(right: 90, left: 10),
                      borderRadiusOnly: const BorderRadius.only(
                        bottomLeft: Radius.circular(4),
                        topLeft: Radius.circular(4),
                      ),
                    ),
                    Positioned(
                      right: 10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 0),
                        decoration: BoxDecoration(
                          color: provider.emailVerified
                              ? ThemeColors.greyBorder
                              : ThemeColors.accent,
                          borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(20),
                            bottomRight: Radius.circular(20),
                            bottomLeft: Radius.circular(20),
                            topLeft: Radius.circular(20),
                          ),
                        ),
                        child: GestureDetector(
                          onTap: provider.emailVerified
                              ? null
                              : () => _onEmailUpdateClick(
                                  emailController.text.trim()),
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(
                                provider.emailVerified ? 0 : 5, 5, 5, 5),
                            child: Row(
                              children: [
                                Visibility(
                                  visible: provider.emailVerified,
                                  child: const Padding(
                                    padding: EdgeInsets.only(right: 5),
                                    child: Icon(
                                      Icons.check,
                                      size: 15,
                                      color: ThemeColors.accent,
                                    ),
                                  ),
                                ),
                                Text(
                                  provider.emailVerified
                                      ? "Verified"
                                      : "Verify",
                                  style: stylePTSansBold(
                                    color: provider.emailVerified
                                        ? ThemeColors.accent
                                        : Colors.white,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
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
        const SpacerVertical(height: 13),
        Text(
          "Phone Number  ",
          style: stylePTSansBold(color: Colors.white, fontSize: 14),
        ),
        const SpacerVertical(height: 5),
        IntrinsicHeight(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: ThemeColors.primaryLight),
                  ),
                  color: ThemeColors.primaryLight,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(4),
                    bottomLeft: Radius.circular(4),
                  ),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                        decoration: const BoxDecoration(
                          border: Border(
                            bottom: BorderSide(color: ThemeColors.primaryLight),
                          ),
                          color: ThemeColors.primaryLight,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(4),
                            bottomLeft: Radius.circular(4),
                          ),
                        ),
                        child: CountryPickerWidget(
                          onChanged: (CountryCode value) {
                            countryCode = value.dialCode;
                            // provider.onChangeCountryCode("$value");
                            provider.onChangePhoneAndCode(
                              phone: mobileController.text,
                              countryCode: "$countryCode",
                            );
                          },
                          textColor: Colors.white,
                        )),
                  ],
                ),
              ),
              Expanded(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    ThemeInputField(
                      onChanged: (value) {
                        provider.onChangePhoneAndCode(
                          phone: value,
                          countryCode: "$countryCode",
                        );
                      },
                      cursorColor: Colors.white,
                      style:
                          stylePTSansRegular(color: Colors.white, height: 1.5),
                      fillColor: ThemeColors.primaryLight,
                      borderColor: ThemeColors.primaryLight,
                      borderRadiusOnly: BorderRadius.zero,
                      borderRadius: 0,
                      controller: mobileController,
                      placeholder: "Enter your phone number",
                      keyboardType: TextInputType.phone,
                      inputFormatters: [
                        _formatter,
                        LengthLimitingTextInputFormatter(15)
                      ],
                      textCapitalization: TextCapitalization.none,
                    ),
                    Positioned(
                      right: 10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 0),
                        decoration: BoxDecoration(
                          color: provider.phoneVerified
                              ? ThemeColors.greyBorder
                              : ThemeColors.accent,
                          borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(20),
                            bottomRight: Radius.circular(20),
                            bottomLeft: Radius.circular(20),
                            topLeft: Radius.circular(20),
                          ),
                        ),
                        child: GestureDetector(
                          onTap: provider.phoneVerified
                              ? null
                              : () => _onPhoneUpdateClick(
                                  mobileController.text.trim()),
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(
                                provider.phoneVerified ? 0 : 5, 5, 5, 5),
                            child: Row(
                              children: [
                                Visibility(
                                  visible: provider.phoneVerified,
                                  child: const Padding(
                                    padding: EdgeInsets.only(right: 5),
                                    child: Icon(
                                      Icons.check,
                                      size: 15,
                                      color: ThemeColors.accent,
                                    ),
                                  ),
                                ),
                                Text(
                                  provider.phoneVerified
                                      ? "Verified"
                                      : "Verify",
                                  style: stylePTSansBold(
                                    color: provider.phoneVerified
                                        ? ThemeColors.accent
                                        : Colors.white,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
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
        Visibility(
          visible:
              (provider.user?.phone != null && provider.user?.phone != '') &&
                  (provider.user?.phoneCode == null ||
                      provider.user?.phoneCode == '') &&
                  (homeProvider.extra?.phoneCodeError != null &&
                      homeProvider.extra?.phoneCodeError != ''),
          child: Text(
            "*${homeProvider.extra?.phoneCodeError ?? "*Please update your country code"}",
            style: stylePTSansRegular(color: ThemeColors.sos),
          ),
        ),
        const SpacerVertical(height: 20),
        ThemeButton(
          onPressed: _onTap,
          text: "Update Profile",
          textUppercase: true,
        ),
        const SpacerVertical(height: 20),
        const Divider(color: ThemeColors.divider, thickness: 1),
        const SpacerVertical(height: 16),
      ],
    );
  }

  Future _onEmailUpdateClick(String email) async {
    UserProvider provider = context.read<UserProvider>();

    if (!isEmail(emailController.text)) {
      popUpAlert(
          message: "Please enter valid email address.",
          title: "Alert",
          icon: Images.alertPopGIF);
      return;
    }
    Map request = {
      "token": provider.user?.token ?? "",
      "email": email.toLowerCase(),
    };

    try {
      ApiResponse response = await provider.emailUpdateOtp(request,
          resendButtonClick: false, email: email);

      if (response.status) {}
    } catch (e) {
      //
    }
  }

  Future _onPhoneUpdateClick(String phone) async {
    closeKeyboard();
    // UserProvider provider = context.read<UserProvider>();

    if (mobileController.text.isEmpty || mobileController.text.length < 6) {
      popUpAlert(
        message: "Please enter a valid phone number.",
        title: "Alert",
        icon: Images.alertPopGIF,
      );
      return;
    }
    if (countryCode == null) {
      popUpAlert(
        message: "Please select a valid country code.",
        title: "Alert",
        icon: Images.alertPopGIF,
      );
      return;
    }
    UserProvider provider = context.read<UserProvider>();

    ApiResponse response = await provider.checkPhoneExist(
      countryCode: countryCode ?? '+1',
      phone: phone,
    );
    if (response.status) {
      if (kDebugMode) {
        String mobile = phone;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BaseVerifyOTP(
              countryCode: countryCode ?? '+1',
              phone: mobile,
              verificationId: '',
            ),
          ),
        );
        return;
      }

      showGlobalProgressDialog();
      log("PHONE => $countryCode $phone");
      await FirebaseAuth.instance.verifyPhoneNumber(
        // phoneNumber: kDebugMode ? "+91 $phone" : "+1$phone",
        phoneNumber: "$countryCode $phone",
        verificationCompleted: (PhoneAuthCredential credential) {
          closeGlobalProgressDialog();
        },
        verificationFailed: (FirebaseAuthException e) {
          log("Error message ** => ${e.code} ${e.message} ${e.stackTrace}");
          closeGlobalProgressDialog();
          // log("Error message => ${e.code} ${e.message} ${e.stackTrace}");
          popUpAlert(
            message: e.code == "invalid-phone-number"
                ? "The format of the phone number provided is incorrect."
                : e.code == "too-many-requests"
                    ? "We have blocked all requests from this device due to unusual activity. Please try again after 24 hours."
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
            MaterialPageRoute(
              builder: (context) => BaseVerifyOTP(
                countryCode: countryCode ?? '+1',
                phone: phone,
                verificationId: verificationId,
              ),
            ),
          );
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    } else {
      //
    }
  }
}
