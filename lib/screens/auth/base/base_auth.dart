import 'package:country_code_picker/country_code_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:stocks_news_new/modals/user_res.dart';
import 'package:stocks_news_new/providers/home_provider.dart';
import 'package:stocks_news_new/routes/my_app.dart';
import 'dart:io';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:stocks_news_new/providers/user_provider.dart';
import 'package:stocks_news_new/screens/auth/base/base_verify.dart';
import 'package:stocks_news_new/screens/auth/bottomSheets/aggree_conditions.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:stocks_news_new/database/preference.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/utils/utils.dart';
import 'package:stocks_news_new/utils/validations.dart';
import 'package:stocks_news_new/widgets/custom/country_code_picker_widget.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import 'package:stocks_news_new/widgets/theme_button.dart';
import 'package:stocks_news_new/widgets/theme_input_field.dart';
import '../../../widgets/custom/alert_popup.dart';

loginFirstSheet() async {
  await showModalBottomSheet(
    useSafeArea: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(5.sp),
        topRight: Radius.circular(5.sp),
      ),
    ),
    backgroundColor: ThemeColors.transparent,
    isScrollControlled: true,
    context: navigatorKey.currentContext!,
    builder: (context) {
      return const LoginFirst();
    },
  );
}

class LoginFirst extends StatefulWidget {
  const LoginFirst({super.key, this.onLogin});

  final Function()? onLogin;

  @override
  State<LoginFirst> createState() => _LoginFirstState();
}

class _LoginFirstState extends State<LoginFirst> {
  final TextEditingController _controller = TextEditingController();
  String? countryCode;
  bool verifying = false;
  String? _verificationId;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  bool isChecked = false;
  bool useCheckboxCondition = true;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getCode();
    });
  }

//GET COUNTRY CODE
  _getCode() {
    UserRes? user = context.read<UserProvider>().user;
    if (user?.phone != null && user?.phone != '') {
      _controller.text = user?.phone ?? '';
    } else {
      _controller.text = '';
    }
    if (user?.phoneCode != null && user?.phoneCode != "") {
      countryCode = CountryCode.fromDialCode(user?.phoneCode ?? "").dialCode;
    } else if (geoCountryCode != null && geoCountryCode != "") {
      countryCode = CountryCode.fromCountryCode(geoCountryCode!).dialCode;
    } else {
      countryCode = CountryCode.fromCountryCode("US").dialCode;
    }

    //CHECKBOX Condition
    UserProvider provider = context.read<UserProvider>();
    useCheckboxCondition = provider.advertiserRes != null;
    setState(() {});
  }

//LOADING
  setVerify(status) {
    verifying = status;
    if (mounted) {
      setState(() {});
    }
  }

//ON LOGIN
  void _onLoginClick() async {
    closeKeyboard();
    if (!isChecked && useCheckboxCondition) {
      return popUpAlert(
        message:
            "To proceed, please confirm your agreement with the terms and conditions by checking the box.",
        title: "Alert",
        icon: Images.alertPopGIF,
      );
    } else if (isEmpty(_controller.text)) {
      popUpAlert(
        icon: Images.alertPopGIF,
        title: 'Alert',
        message: 'Please enter a valid phone number',
      );
      return;
    }

    if (kDebugMode) {
      //DEBUG
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BaseVerifyOTP(
            countryCode: countryCode ?? '+1',
            phone: _controller.text,
            verificationId: '',
          ),
        ),
      );
      return;
    }
    setVerify(true);
    Utils().showLog('${countryCode ?? '+1'} ${_controller.text}');
    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: '${countryCode ?? '+1'} ${_controller.text}',
        verificationCompleted: (PhoneAuthCredential credential) async {
          // Auto-resolve on Android (not iOS)
          await FirebaseAuth.instance.signInWithCredential(credential);
          Utils().showLog(
              'Phone number automatically verified and user signed in: ${FirebaseAuth.instance.currentUser}');
          setVerify(false);
          _finalVerifyOTP();
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
          setVerify(false);
          Utils().showLog('$e');
        },
        codeSent: (String verificationId, int? resendToken) {
          setVerify(false);
          setState(() {
            _verificationId = verificationId;
          });

          // otpLoginFirstSheet(
          //   mobile: _controller.text,
          //   countryCode: countryCode ?? '+1',
          //   verificationId: _verificationId ?? '',
          // );
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BaseVerifyOTP(
                countryCode: countryCode ?? '+1',
                phone: _controller.text,
                verificationId: _verificationId ?? verificationId,
              ),
            ),
          );

          Utils().showLog('Verification code sent.');
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          Utils().showLog('Time Out');

          setVerify(false);

          setState(() {
            _verificationId = verificationId;
          });
        },
        timeout: const Duration(seconds: 60),
      );
    } catch (e) {
      setVerify(false);

      Utils().showLog('Firebase error $e');
    } finally {}
  }

//FINAL VERIFY OTP
  _finalVerifyOTP() async {
    UserProvider provider = context.read<UserProvider>();
    String? fcmToken = await Preference.getFcmToken();
    String? address = await Preference.getLocation();
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String versionName = packageInfo.version;
    String buildNumber = packageInfo.buildNumber;
    bool granted = await Permission.notification.isGranted;
    String? referralCode = await Preference.getReferral();

    Map request = {
      "phone": _controller.text,
      "phone_code": countryCode ?? '+1',
      "fcm_token": fcmToken ?? "",
      "platform": Platform.operatingSystem,
      "address": address ?? "",
      "build_version": versionName,
      "build_code": buildNumber,
      "fcm_permission": "$granted",
      "referral_code": referralCode ?? "",
    };
    if (memCODE != null && memCODE != '') {
      request['distributor_code'] = memCODE;
    }

    provider.finalVerifyOTP(request, doublePop: false);
  }

//GOOGLE SIGN IN
  void _handleSignIn() async {
    UserProvider provider = context.read<UserProvider>();
    if (await _googleSignIn.isSignedIn()) {
      await _googleSignIn.signOut();
    }

    try {
      String? fcmToken = await Preference.getFcmToken();
      String? address = await Preference.getLocation();

      GoogleSignInAccount? account = await _googleSignIn.signIn();
      Utils().showLog(account.toString());
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      String versionName = packageInfo.version;
      String buildNumber = packageInfo.buildNumber;
      String? referralCode = await Preference.getReferral();

      if (account != null) {
        bool granted = await Permission.notification.isGranted;
        Map request = {
          "displayName": account.displayName ?? "",
          "email": account.email,
          "id": account.id,
          "photoUrl": account.photoUrl ?? "",
          "fcm_token": fcmToken ?? "",
          "platform": Platform.operatingSystem,
          "address": address ?? "",
          "build_version": versionName,
          "build_code": buildNumber,
          "fcm_permission": "$granted",
          "referral_code": referralCode ?? "",
        };
        if (memCODE != null && memCODE != '') {
          request['distributor_code'] = memCODE;
        }

        provider.googleLogin(
          request,
          alreadySubmitted: false,
          direct: true,
        );
      }
    } catch (error) {
      popUpAlert(message: "$error", title: "Alert", icon: Images.alertPopGIF);
      Utils().showLog("$error");
    }
  }

//APPLE SIGN IN
  void _handleSignInApple(id, displayName, email) async {
    try {
      String? fcmToken = await Preference.getFcmToken();
      String? address = await Preference.getLocation();
      bool granted = await Permission.notification.isGranted;

      UserProvider provider = context.read<UserProvider>();
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      String versionName = packageInfo.version;
      String buildNumber = packageInfo.buildNumber;

      Map request = {
        "displayName": displayName ?? "",
        "email": email ?? "",
        "id": id ?? "",
        "platform": Platform.operatingSystem,
        "address": address ?? "",
        "build_version": versionName,
        "build_code": buildNumber,
        "fcm_token": fcmToken ?? "",
        "fcm_permission": "$granted",
      };
      if (memCODE != null && memCODE != '') {
        request['distributor_code'] = memCODE;
      }
      provider.appleLogin(
        request,
        id: id,
        direct: true,
      );
    } catch (error) {
      popUpAlert(message: "$error", title: "Alert", icon: Images.alertPopGIF);
      Utils().showLog("$error");
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    HomeProvider provider = context.watch<HomeProvider>();
    UserProvider userProvider = context.watch<UserProvider>();

    if (userProvider.user?.phoneCode != null &&
        userProvider.user?.phoneCode != "") {
      countryCode =
          CountryCode.fromDialCode(userProvider.user?.phoneCode ?? "").dialCode;
    } else if (geoCountryCode != null && geoCountryCode != "") {
      countryCode =
          CountryCode.fromCountryCode(geoCountryCode ?? 'US').dialCode;
    } else {
      countryCode = CountryCode.fromCountryCode("US").dialCode;
    }
    // Utils().showLog('COUNTRY CODE $countryCode');
    return GestureDetector(
      onTap: () {
        closeKeyboard();
      },
      child: Container(
        constraints: BoxConstraints(maxHeight: ScreenUtil().screenHeight - 30),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [ThemeColors.bottomsheetGradient, Colors.black],
          ),
          color: ThemeColors.background,
          border: const Border(
            top: BorderSide(color: ThemeColors.greyBorder),
          ),
        ),
        child: GestureDetector(
          onTap: () {
            closeKeyboard();
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(left: 5, top: 5),
                child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.cancel,
                    size: 30,
                    color: ThemeColors.greyText,
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(Dimen.padding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // const SpacerVertical(height: 30),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Text(
                          //   provider.homeTrendingRes?.loginTitle ??
                          //       "Get Started With Your Stocks Journey",
                          //   style: stylePTSansBold(fontSize: 28),
                          //   textAlign: TextAlign.center,
                          // ),
                          HtmlWidget(
                            provider.homeTrendingRes?.loginTitle ??
                                "Get Started With Your Stocks Journey",
                            textStyle: stylePTSansBold(fontSize: 28),

                            // textAlign: TextAlign.center,
                          ),
                          const SpacerVertical(height: 5),
                          Text(
                            provider.homeTrendingRes?.loginText ??
                                "Log in or Sign up",
                            style: stylePTSansRegular(
                              fontSize: 16,
                              color: ThemeColors.greyText,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                      const SpacerVertical(height: 30),
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
                                      onChanged: (CountryCode value) {
                                        countryCode = value.dialCode;
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              Flexible(
                                child: ThemeInputField(
                                  style: stylePTSansRegular(
                                    color: Colors.black,
                                    fontSize: 18,
                                  ),
                                  borderRadiusOnly: const BorderRadius.only(
                                    topRight: Radius.circular(4),
                                    bottomRight: Radius.circular(4),
                                  ),
                                  controller: _controller,
                                  placeholder: "Enter your phone number",
                                  keyboardType: TextInputType.phone,
                                  inputFormatters: [
                                    // _formatter,
                                    LengthLimitingTextInputFormatter(15)
                                  ],
                                  textCapitalization: TextCapitalization.none,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Checkbox(
                            side: BorderSide(color: Colors.white),
                            value: isChecked,
                            onChanged: (value) {
                              setState(() {
                                isChecked = value!;
                              });
                            },
                            activeColor: ThemeColors.accent,
                          ),
                          Expanded(
                              child: LoginSignupID(
                            defaultLength: 280,
                          )),
                        ],
                      ),

                      const SpacerVertical(height: Dimen.itemSpacing),
                      ThemeButton(
                        text: verifying
                            ? provider.extra?.updateYourPhone?.verifyButton ??
                                'Verifying your phone number...'
                            : provider.extra?.updateYourPhone?.updateButton ??
                                'Send OTP',
                        onPressed: verifying ? null : _onLoginClick,
                      ),
                      const SpacerVertical(),
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Divider(
                            color: ThemeColors.dividerDark,
                            height: 1,
                            thickness: 1,
                          ),
                          Container(
                            color: ThemeColors.background,
                            padding: EdgeInsets.symmetric(horizontal: 8.sp),
                            child: Text(
                              "or continue with",
                              style: stylePTSansRegular(
                                fontSize: 12,
                                color: ThemeColors.greyText,
                              ),
                            ),
                          )
                        ],
                      ),
                      const SpacerVertical(),
                      ThemeButton(
                        onPressed: () async {
                          _handleSignIn();
                        },
                        color: ThemeColors.primaryLight,
                        child: SizedBox(
                          width: double.infinity,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Positioned(
                                left: 0,
                                child: Image.asset(
                                  Images.google,
                                  width: 16,
                                  height: 16,
                                  fit: BoxFit.contain,
                                ),
                              ),
                              Text(
                                "Continue with Google",
                                style: stylePTSansRegular(fontSize: 15),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Visibility(
                        visible: Platform.isIOS,
                        child: Padding(
                          padding:
                              const EdgeInsets.only(top: Dimen.itemSpacing),
                          child: ThemeButton(
                            onPressed: () async {
                              closeKeyboard();
                              try {
                                final AuthorizationCredentialAppleID
                                    credential =
                                    await SignInWithApple.getAppleIDCredential(
                                  scopes: [
                                    AppleIDAuthorizationScopes.email,
                                    AppleIDAuthorizationScopes.fullName,
                                  ],
                                );

                                _handleSignInApple(
                                  credential.userIdentifier,
                                  credential.givenName != null
                                      ? "${credential.givenName} ${credential.familyName}"
                                      : null,
                                  credential.email,
                                );
                              } catch (e) {
                                if (e.toString().contains(
                                    "SignInWithAppleNotSupportedException")) {
                                  // showErrorMessage(
                                  //   message:
                                  //       "Sign in with Apple not supported in this device",
                                  // );
                                }
                              }
                            },
                            color: ThemeColors.white,
                            child: SizedBox(
                              width: double.infinity,
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Positioned(
                                    left: 0,
                                    child: Image.asset(
                                      Images.apple,
                                      width: 18,
                                      height: 18,
                                      fit: BoxFit.contain,
                                      color: ThemeColors.background,
                                    ),
                                  ),
                                  Text(
                                    "Continue with Apple",
                                    style: stylePTSansRegular(
                                        fontSize: 15,
                                        color: ThemeColors.background),
                                    textAlign: TextAlign.center,
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
              ),
              Visibility(
                visible: !useCheckboxCondition,
                child: Padding(
                  padding: const EdgeInsets.all(Dimen.authScreenPadding),
                  child: NewAgreeConditions(
                    text: provider.homeTrendingRes?.loginAgree,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
