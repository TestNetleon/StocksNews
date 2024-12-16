// ignore_for_file: avoid_print, use_build_context_synchronously

import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:stocks_news_new/providers/user_provider.dart';
import 'package:stocks_news_new/screens/auth/bottomSheets/aggree_conditions.dart';
import 'package:stocks_news_new/screens/auth/bottomSheets/refer_sheet.dart';
// import 'package:stocks_news_new/screens/auth/otp/otp_login.dart';

import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';

import 'package:stocks_news_new/database/preference.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/custom/alert_popup.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import 'package:stocks_news_new/widgets/theme_button.dart';
import 'package:validators/validators.dart';

import '../../../routes/my_app.dart';
import '../../../utils/utils.dart';
import '../../../utils/validations.dart';
import '../../../widgets/theme_input_field.dart';
import '../base/base_auth.dart';

signupSheet({String? email}) async {
  await showModalBottomSheet(
    useSafeArea: true,
    backgroundColor: ThemeColors.transparent,
    // constraints: BoxConstraints(maxHeight: ScreenUtil().screenHeight - 100),
    isScrollControlled: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(5.sp),
        topRight: Radius.circular(5.sp),
      ),
    ),
    context: navigatorKey.currentContext!,
    builder: (context) {
      return SignUpBottom(email: email);
    },
  );
}

class SignUpBottom extends StatefulWidget {
  final String? email;
  const SignUpBottom({super.key, this.email});

  @override
  State<SignUpBottom> createState() => _SignUpBottomState();
}

class _SignUpBottomState extends State<SignUpBottom> {
  final TextEditingController _controller = TextEditingController(
    // text: kDebugMode ? "utkarshsinghdhakad@gmail.com" : "",
    text: kDebugMode ? "chetan@netleon.com" : "",
  );
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  @override
  void initState() {
    super.initState();
    if (widget.email != null && widget.email != '') {
      _controller.text = widget.email ?? "";
    }
    signUpVisible = true;
  }

  void _onSignUpClick() async {
    closeKeyboard();

    if (!isEmail(_controller.text)) {
      popUpAlert(
        message: "Please enter valid email address.",
        title: "Alert",
        icon: Images.alertPopGIF,
      );
      return;
    }

    String? referralCode = await Preference.getReferral();
    bool isReferInput = await Preference.isReferInput();

    if ((referralCode != null && referralCode != "") || !isReferInput) {
      UserProvider provider = context.read<UserProvider>();
      Map request = {"username": _controller.text.toLowerCase()};
      provider.signup(request);
    } else {
      referSheet(
        // email: _controller.text.toLowerCase(),
        onReferral: (code) {
          UserProvider provider = context.read<UserProvider>();
          Map request = {"username": _controller.text.toLowerCase()};
          provider.signup(request, referCode: code);
        },
      );
    }
  }

  void _handleSignIn() async {
    closeKeyboard();

    if (await _googleSignIn.isSignedIn()) {
      await _googleSignIn.signOut();
    }

    try {
      GoogleSignInAccount? account = await _googleSignIn.signIn();

      // String? referralCode = await Preference.getReferral();

      _handleGoogleLogin(account);
      // if (referralCode != null && referralCode != "") {
      //   _handleGoogleLogin(account);
      // } else {
      //   referSheet(
      //     onReferral: (code) {
      //       _handleGoogleLogin(account, code: code);
      //     },
      //   );
      // }
    } catch (error) {
      popUpAlert(message: "$error", title: "Alert", icon: Images.alertPopGIF);
      print(error);
    }
  }

  void _handleGoogleLogin(GoogleSignInAccount? account, {String? code}) async {
    try {
      String? fcmToken = await Preference.getFcmToken();
      String? address = await Preference.getLocation();

      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      String? referralCode = await Preference.getReferral();
      String versionName = packageInfo.version;
      String buildNumber = packageInfo.buildNumber;

      if (account != null) {
        UserProvider provider = context.read<UserProvider>();
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
          //  "referral_code": "$referralCode",
          "referral_code": referralCode ?? code ?? "",
          // "track_membership_link": memTrack ? "1" : "",
          // "referral_code": "8FELPC",
          // "serverAuthCode": account?.serverAuthCode,
        };
        if (memCODE != null && memCODE != '') {
          request['distributor_code'] = memCODE;
        }
        provider.googleLogin(request, alreadySubmitted: false);
      }
    } catch (error) {
      popUpAlert(message: "$error", title: "Alert", icon: Images.alertPopGIF);
      print(error);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    signUpVisible = false;
    super.dispose();
  }

  void _handleApple(id, displayName, email) async {
    closeKeyboard();

    String? referralCode = await Preference.getReferral();
    bool isReferInput = await Preference.isReferInput();

    if ((referralCode != null && referralCode != "") || !isReferInput) {
      // if (referralCode != null && referralCode != "") {
      _handleAppleSignIn(id, displayName, email);
    } else {
      // referSheet(
      //   // email: _controller.text.toLowerCase(),
      //   onReferral: (code) {
      //     _handleAppleSignIn(id, displayName, email, code: code);
      //   },
      // );
      _handleAppleSignIn(id, displayName, email);
    }
  }

  void _handleAppleSignIn(id, displayName, email, {String? code}) async {
    try {
      String? fcmToken = await Preference.getFcmToken();
      String? address = await Preference.getLocation();
      String? referralCode = await Preference.getReferral();
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      String versionName = packageInfo.version;
      String buildNumber = packageInfo.buildNumber;
      UserProvider provider = context.read<UserProvider>();
      bool granted = await Permission.notification.isGranted;

      Map request = {
        "displayName": displayName ?? "",
        "email": email ?? "",
        "id": id ?? "",
        "fcm_token": fcmToken ?? "",
        "platform": Platform.operatingSystem,
        "address": address ?? "",
        "build_version": versionName,
        "build_code": buildNumber,
        "fcm_permission": "$granted",
        // "referral_code": "$referralCode",
        "referral_code": referralCode ?? code ?? "",
        // "track_membership_link": memTrack ? "1" : "",
      };
      if (memCODE != null && memCODE != '') {
        request['distributor_code'] = memCODE;
      }
      provider.appleLogin(
        request,
        id: id,
        code: code,
        alreadySubmitted: true,
      );

      // GoogleSignInAccount:{displayName: Netleon Family, email: testnetleon@gmail.com, id: 110041963646228833065, photoUrl: https://lh3.googleusercontent.com/a/ACg8ocJocVZ9k-umOKg7MEzLfpG4d_GBrUFYY8o84_r3Am95dA, serverAuthCode: null}
    } catch (error) {
      popUpAlert(message: "$error", title: "Alert", icon: Images.alertPopGIF);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        closeKeyboard();
      },
      child: Container(
        constraints: BoxConstraints(maxHeight: ScreenUtil().screenHeight - 30),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10.sp),
            topRight: Radius.circular(10.sp),
          ),
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [ThemeColors.bottomsheetGradient, Colors.black],
          ),
          // gradient: const RadialGradient(
          //   center: Alignment.bottomCenter,
          //   radius: 0.6,
          //   stops: [0.0, 0.9],
          //   colors: [Color.fromARGB(255, 0, 93, 12), Colors.black],
          // ),
          border: const Border(top: BorderSide(color: ThemeColors.greyBorder)),
        ),
        child: Column(
          children: [
            Container(
              height: 6.sp,
              width: 50.sp,
              margin: EdgeInsets.only(top: 8.sp),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.sp),
                color: ThemeColors.greyBorder,
              ),
            ),
            const SpacerVertical(height: 10),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(Dimen.authScreenPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SpacerVertical(height: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          "Register new account",
                          style: stylePTSansBold(fontSize: 28),
                          textAlign: TextAlign.center,
                        ),
                        const SpacerVertical(height: 5),
                        Text(
                          "Sign up with an account to get started",
                          style: stylePTSansRegular(
                            fontSize: 16,
                            color: ThemeColors.greyText,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                    const SpacerVertical(height: 30),
                    ThemeInputField(
                      controller: _controller,
                      placeholder: "Enter email address to sign up",
                      keyboardType: TextInputType.emailAddress,
                      inputFormatters: [emailFormatter],
                      textCapitalization: TextCapitalization.none,
                    ),
                    const SpacerVertical(height: Dimen.itemSpacing),
                    ThemeButton(
                      text: "Create account",
                      onPressed: _onSignUpClick,
                    ),
                    const SpacerVertical(),
                    Column(
                      children: [
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
                              padding: EdgeInsets.symmetric(horizontal: 8),
                              child: Text(
                                "or continue with",
                                style: stylePTSansRegular(
                                  fontSize: 12,
                                  color: ThemeColors.greyText,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SpacerVertical(),
                        const SpacerVertical(height: 5),
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
                                  style: stylePTSansRegular(fontSize: 14),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                        // const SpacerVertical(),
                        Visibility(
                          visible: Platform.isIOS,
                          child: Padding(
                            padding:
                                const EdgeInsets.only(top: Dimen.itemSpacing),
                            child: ThemeButton(
                              onPressed: () async {
                                try {
                                  final AuthorizationCredentialAppleID
                                      credential = await SignInWithApple
                                          .getAppleIDCredential(
                                    scopes: [
                                      AppleIDAuthorizationScopes.email,
                                      AppleIDAuthorizationScopes.fullName,
                                    ],
                                  );
                                  // log("Apple ***** =>  ${credential.email}");
                                  // log("Apple ***** =>  ${credential.authorizationCode}");
                                  // log("Apple ***** =>  ${credential.familyName}");
                                  // log("Apple ***** =>  ${credential.givenName}");
                                  // log("Apple ***** =>  ${credential.identityToken}");
                                  // log("Apple ***** =>  ${credential.state}");
                                  // log("Apple ***** =>  ${credential.userIdentifier}");

                                  _handleApple(
                                    credential.userIdentifier,
                                    credential.givenName != null
                                        ? "${credential.givenName} ${credential.familyName}"
                                        : null,
                                    credential.email,
                                  );
                                  print(credential.userIdentifier);
                                } catch (e) {
                                  print("Error Apple Sign IN - $e");
                                  if (e.toString().contains(
                                      "SignInWithAppleNotSupportedException")) {
                                    // showErrorMessage(
                                    //   message:
                                    //       "Sign in with Apple not supported in this device",
                                    // );
                                  }
                                }
                                // Now send the credential (especially `credential.authorizationCode`) to your server to create a session
                                // after they have been validated with Apple (see `Integration` section for more information on how to do this)
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
                                        width: 16,
                                        height: 16,
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
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Align(
                            alignment: Alignment.center,
                            child: GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                  // isPhone ? loginSheet() : loginSheetTablet();
                                  loginFirstSheet();
                                },
                                child: Text(
                                  "Already have an account? Log in",
                                  style: stylePTSansRegular(
                                    fontSize: 18,
                                    color: ThemeColors.accent,
                                  ),
                                )

                                // RichText(
                                //   text: TextSpan(
                                //     children: [
                                //       TextSpan(
                                //         text: "Already have an account? ",
                                //         style: stylePTSansRegular(
                                //           fontSize: 18,
                                //         ),
                                //       ),
                                //       TextSpan(
                                //         text: "Log in",
                                //         style: stylePTSansRegular(
                                //           fontSize: 18,
                                //           color: ThemeColors.accent,
                                //         ),
                                //       ),
                                //     ],
                                //   ),
                                // ),
                                ),
                          ),
                          const SpacerVertical(),
                          const AgreeConditions(fromLogin: false),
                          const SpacerVertical(height: 15),
                        ],
                      ),
                    ),
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
