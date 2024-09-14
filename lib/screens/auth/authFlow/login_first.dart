import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:stocks_news_new/route/my_app.dart';

import 'dart:io';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:stocks_news_new/providers/user_provider.dart';
import 'package:stocks_news_new/screens/auth/authFlow/otp_sheet_login.dart';
import 'package:stocks_news_new/screens/auth/bottomSheets/aggree_conditions.dart';
// import 'package:stocks_news_new/screens/auth/otp/otp_login.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:stocks_news_new/database/preference.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/utils/utils.dart';
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
  final TextEditingController _controller = TextEditingController(
      // text: kDebugMode ? "utkarshsinghdhakad@gmail.com" : "",
      // text: kDebugMode ? "chetan@netleon.com" : "",
      );
  String? countryCode;

  final GoogleSignIn _googleSignIn = GoogleSignIn();

  void _onLoginClick() {
    closeKeyboard();
    if (widget.onLogin != null) {
      widget.onLogin!();
    } else {
      Navigator.pop(context);
      otpLoginFirstSheet(mobile: "9782792190");
    }
    // if (!isEmail(_controller.text) && !isNumeric(_controller.text)) {
    //   // showErrorMessage(message: "Please enter valid email address");
    //   popUpAlert(
    //     message: "Please enter valid email address.",
    //     title: "Alert",
    //     icon: Images.alertPopGIF,
    //   );
    //   return;
    // }
    // UserProvider provider = context.read<UserProvider>();
    // Map request = {
    //   "username": _controller.text.toLowerCase(),
    //   "type": "email",
    // };
    // provider.login(request, email: _controller.text);
  }

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
          // "serverAuthCode": account?.serverAuthCode,
          "referral_code": referralCode ?? "",
          "track_membership_link": memTrack ? "1" : "",
        };
        provider.googleLogin(request, alreadySubmitted: false);
      }
    } catch (error) {
      popUpAlert(message: "$error", title: "Alert", icon: Images.alertPopGIF);
      Utils().showLog("$error");
    }
  }

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
        "track_membership_link": memTrack ? "1" : "",
      };

      provider.appleLogin(request, id: id);
      // GoogleSignInAccount:{displayName: Netleon Family, email: testnetleon@gmail.com, id: 110041963646228833065, photoUrl: https://lh3.googleusercontent.com/a/ACg8ocJocVZ9k-umOKg7MEzLfpG4d_GBrUFYY8o84_r3Am95dA, serverAuthCode: null}
    } catch (error) {
      popUpAlert(message: "$error", title: "Alert", icon: Images.alertPopGIF);
      // showErrorMessage(message: "$error");
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
    return GestureDetector(
      onTap: () {
        closeKeyboard();
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(left: 12),
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
              padding: const EdgeInsets.all(Dimen.authScreenPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // const SpacerVertical(height: 30),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        "Welcome back",
                        style: stylePTSansBold(fontSize: 28),
                        textAlign: TextAlign.center,
                      ),
                      const SpacerVertical(height: 5),
                      Text(
                        "Log in your account to get started",
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
                  const SpacerVertical(height: Dimen.itemSpacing),
                  ThemeButton(
                    text: "Log in",
                    onPressed: _onLoginClick,
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
                      padding: const EdgeInsets.only(top: Dimen.itemSpacing),
                      child: ThemeButton(
                        onPressed: () async {
                          try {
                            final AuthorizationCredentialAppleID credential =
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
          Padding(
            padding: const EdgeInsets.all(Dimen.authScreenPadding),
            child: const AgreeConditions(),
          ),
        ],
      ),
    );
  }
}
