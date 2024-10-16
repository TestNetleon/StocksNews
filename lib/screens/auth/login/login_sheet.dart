import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:stocks_news_new/route/my_app.dart';

import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:stocks_news_new/providers/user_provider.dart';
import 'package:stocks_news_new/screens/auth/bottomSheets/aggree_conditions.dart';
import 'package:stocks_news_new/screens/auth/signup/signup_sheet_tablet.dart';
import 'package:stocks_news_new/screens/auth/signup/signup_sheet.dart';
// import 'package:stocks_news_new/screens/auth/otp/otp_login.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:stocks_news_new/database/preference.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/utils/utils.dart';
import 'package:stocks_news_new/utils/validations.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import 'package:stocks_news_new/widgets/theme_button.dart';
import 'package:stocks_news_new/widgets/theme_input_field.dart';
import 'package:validators/validators.dart';

import '../../../widgets/custom/alert_popup.dart';

loginSheet() async {
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
      return const LoginBottom();
    },
  );
}

class LoginBottom extends StatefulWidget {
  const LoginBottom({super.key});

  @override
  State<LoginBottom> createState() => _LoginBottomState();
}

class _LoginBottomState extends State<LoginBottom> {
  final TextEditingController _controller = TextEditingController(
    // text: kDebugMode ? "utkarshsinghdhakad@gmail.com" : "",
    text: kDebugMode ? "chetan@netleon.com" : "",
  );

  final GoogleSignIn _googleSignIn = GoogleSignIn();

  void _onLoginClick() {
    closeKeyboard();
    if (!isEmail(_controller.text) && !isNumeric(_controller.text)) {
      // showErrorMessage(message: "Please enter valid email address");
      popUpAlert(
        message: "Please enter valid email address.",
        title: "Alert",
        icon: Images.alertPopGIF,
      );

      return;
    }
    UserProvider provider = context.read<UserProvider>();
    Map request = {
      "username": _controller.text.toLowerCase(),
      "type": "email",
    };
    provider.login(request, email: _controller.text);
  }

  void _handleSignIn() async {
    closeKeyboard();

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
          // "track_membership_link": memTrack ? "1" : "",
        };
        if (memCODE != null && memCODE != '') {
          request['distributor_code'] = memCODE;
        }
        provider.googleLogin(request, alreadySubmitted: false);
      }
    } catch (error) {
      popUpAlert(message: "$error", title: "Alert", icon: Images.alertPopGIF);
      Utils().showLog("$error");
    }
  }

  void _handleSignInApple(id, displayName, email) async {
    closeKeyboard();

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
        // "track_membership_link": memTrack ? "1" : "",
      };

      if (memCODE != null && memCODE != '') {
        request['distributor_code'] = memCODE;
      }
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
          color: ThemeColors.background,
          border: const Border(
            top: BorderSide(color: ThemeColors.greyBorder),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
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
            // const SpacerVertical(height: 70),
            // Container(
            //   width: MediaQuery.of(context).size.width * .45,
            //   constraints: BoxConstraints(maxHeight: kTextTabBarHeight - 2.sp),
            //   child: Image.asset(
            //     Images.logo,
            //     fit: BoxFit.contain,
            //   ),
            // ),
            const SpacerVertical(height: 10),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(Dimen.authScreenPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SpacerVertical(height: 10),
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
                    // Text(
                    //   "WELCOME BACK",
                    //   style: stylePTSansBold(fontSize: 24),
                    // ),
                    const SpacerVertical(height: 30),
                    // Text(
                    //   "Email Address",
                    //   style: stylePTSansRegular(fontSize: 14),
                    // ),
                    // const SpacerVertical(height: 5),
                    ThemeInputField(
                      controller: _controller,
                      placeholder: "Enter email address to log in",
                      keyboardType: TextInputType.emailAddress,
                      inputFormatters: [emailFormatter],
                      textCapitalization: TextCapitalization.none,
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
                          padding: EdgeInsets.symmetric(horizontal: 8),
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
                            closeKeyboard();

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

                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Padding(
                            // padding: EdgeInsets.all(15.sp),
                            padding: EdgeInsets.all(0.sp),
                            child: Align(
                              alignment: Alignment.center,
                              child: GestureDetector(
                                  onTap: () async {
                                    Navigator.pop(context);
                                    isPhone
                                        ? await signupSheet()
                                        : await signupSheetTablet();
                                  },
                                  child: Text(
                                    "Don't have an account? Sign up ",
                                    style: stylePTSansRegular(
                                      fontSize: 18,
                                      color: ThemeColors.accent,
                                    ),
                                  )

                                  // Row(
                                  //   mainAxisAlignment: MainAxisAlignment.center,
                                  //   children: [
                                  //     Text(
                                  //       "Don't have an account?",
                                  //       style: stylePTSansRegular(
                                  //         fontSize: 15,
                                  //         color: ThemeColors.white,
                                  //       ),
                                  //     ),
                                  //     GestureDetector(
                                  //       onTap: () async {
                                  //         Navigator.pop(context);
                                  //         isPhone
                                  //             ? await signupSheet()
                                  //             : await signupSheetTablet();
                                  //       },
                                  //       child: Text(
                                  //         " Sign up ",
                                  //         style: stylePTSansRegular(
                                  //           fontSize: 15,
                                  //           color: ThemeColors.accent,
                                  //         ),
                                  //       ),
                                  //     ),
                                  //   ],
                                  // ),
                                  ),
                            ),
                          ),
                          const SpacerVertical(),
                          const AgreeConditions(),
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
