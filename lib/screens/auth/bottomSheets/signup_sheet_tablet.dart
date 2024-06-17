// ignore_for_file: avoid_print, use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:stocks_news_new/providers/user_provider.dart';
import 'package:stocks_news_new/screens/auth/bottomSheets/login_sheet.dart';
import 'package:stocks_news_new/screens/auth/bottomSheets/login_sheet_tablet.dart';
// import 'package:stocks_news_new/screens/auth/otp/otp_login.dart';

import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';

import 'package:stocks_news_new/utils/preference.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/custom/alert_popup.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import 'package:stocks_news_new/widgets/theme_button.dart';
import 'package:validators/validators.dart';

import '../../../route/my_app.dart';
import '../../../utils/utils.dart';
import '../../../utils/validations.dart';
import '../../../widgets/theme_input_field.dart';
import 'aggree_conditions.dart';

signupSheetTablet({
  String? state,
  String? dontPop,
}) async {
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
      return SignUpBottom(
        state: state,
        dntPop: dontPop,
      );
    },
  );
}

class SignUpBottom extends StatefulWidget {
  final String? dntPop;
  final String? state;

  const SignUpBottom({super.key, this.dntPop, this.state});

  @override
  State<SignUpBottom> createState() => _SignUpBottomState();
}

class _SignUpBottomState extends State<SignUpBottom> {
  final TextEditingController _controller = TextEditingController();
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  @override
  void initState() {
    super.initState();

    Utils().showLog(
        "---State is--- ${widget.state}, ---Don't pop up is${widget.dntPop}---");
  }

  void _onLoginClick() {
    closeKeyboard();

    if (!isEmail(_controller.text)) {
      popUpAlert(
        message: "Please enter valid email address.",
        title: "Alert",
        icon: Images.alertPopGIF,
      );
      return;
    }

    UserProvider provider = context.read<UserProvider>();

    Map request = {"username": _controller.text.toLowerCase()};

    provider.signup(request);
  }

  void _handleSignIn() async {
    if (await _googleSignIn.isSignedIn()) {
      await _googleSignIn.signOut();
    }

    try {
      String? fcmToken = await Preference.getFcmToken();
      String? address = await Preference.getLocation();

      GoogleSignInAccount? account = await _googleSignIn.signIn();
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
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
          // "serverAuthCode": account?.serverAuthCode,
        };
        provider.googleLogin(request, dontPop: 'true', state: widget.state);
      }
    } catch (error) {
      print("Error in Signed In *******");
      popUpAlert(message: "$error", title: "Alert", icon: Images.alertPopGIF);
      print(error);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleSignInApple(id, displayName, email) async {
    try {
      String? fcmToken = await Preference.getFcmToken();
      String? address = await Preference.getLocation();
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
      };
      provider.appleLogin(request, dontPop: 'true', state: widget.state);
      // GoogleSignInAccount:{displayName: Netleon Family, email: testnetleon@gmail.com, id: 110041963646228833065, photoUrl: https://lh3.googleusercontent.com/a/ACg8ocJocVZ9k-umOKg7MEzLfpG4d_GBrUFYY8o84_r3Am95dA, serverAuthCode: null}
    } catch (error) {
      popUpAlert(message: "$error", title: "Alert", icon: Images.alertPopGIF);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxHeight: ScreenUtil().screenHeight - 30),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10.sp), topRight: Radius.circular(10.sp)),
        gradient: const RadialGradient(
          center: Alignment.bottomCenter,
          radius: 0.6,
          // transform: GradientRotation(radians),
          // tileMode: TileMode.decal,
          stops: [
            0.0,
            0.9,
          ],
          colors: [
            Color.fromARGB(255, 0, 93, 12),
            // ThemeColors.accent.withOpacity(0.1),
            Colors.black,
          ],
        ),
        color: ThemeColors.background,
        border: const Border(
          top: BorderSide(color: ThemeColors.greyBorder),
        ),
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
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // SpacerVertical(height: 20.sp),
                SizedBox(
                  width: MediaQuery.of(context).size.width * .45,
                  // constraints:
                  //     BoxConstraints(maxHeight: kTextTabBarHeight - 2.sp),
                  child: Image.asset(
                    Images.logo,
                    fit: BoxFit.contain,
                  ),
                ),
                const SpacerVertical(height: 10),

                // Container(
                //   padding: EdgeInsets.symmetric(vertical: 12.sp),
                //   width: MediaQuery.of(context).size.width * .45,
                //   child: Image.asset(Images.logo),
                // ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.7,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SpacerVertical(height: Dimen.authScreenPadding),
                      Text(
                        "Welcome to Stocks.News",
                        style: stylePTSansBold(fontSize: 24),
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
                        onPressed: _onLoginClick,
                      ),
                      const SpacerVertical(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              Divider(
                                color: ThemeColors.dividerDark,
                                height: 1.sp,
                                thickness: 1.sp,
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
                                    // flutter: AuthorizationAppleID(000150.6a1410656f504cdcb3d81a2c25231878.1000, Netleon, Technologies, netleonweb@gmail.com, null)
                                    // if(Platform.isIOS && Platform.version)
                                    final AuthorizationCredentialAppleID
                                        credential = await SignInWithApple
                                            .getAppleIDCredential(
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
                          const SpacerVertical(),
                          const AgreeConditions(
                            fromLogin: false,
                          ),
                        ],
                      ),
                      const SpacerVertical(height: 15),
                      Align(
                        alignment: Alignment.center,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                            isPhone
                                ? loginSheet(
                                    dontPop: widget.dntPop,
                                    state: widget.state,
                                  )
                                : loginSheetTablet(
                                    dontPop: widget.dntPop,
                                    state: widget.state,
                                  );
                          },
                          child: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: "Already have an account? ",
                                  style: stylePTSansRegular(
                                    fontSize: 15,
                                  ),
                                ),
                                TextSpan(
                                  text: "Log in",
                                  style: stylePTSansRegular(
                                    fontSize: 15,
                                    color: ThemeColors.accent,
                                  ),
                                ),
                              ],
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
        ],
      ),
    );
  }
}
