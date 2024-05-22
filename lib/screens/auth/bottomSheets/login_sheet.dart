// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:stocks_news_new/route/my_app.dart';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:stocks_news_new/providers/user_provider.dart';
// import 'package:stocks_news_new/screens/auth/otp/otp_login.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/dialogs.dart';
import 'package:stocks_news_new/utils/preference.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/utils/utils.dart';
import 'package:stocks_news_new/utils/validations.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import 'package:stocks_news_new/widgets/theme_button.dart';
import 'package:stocks_news_new/widgets/theme_input_field.dart';
import 'package:validators/validators.dart';

import '../../../widgets/custom/alert_popup.dart';
import 'aggree_conditions.dart';
import 'signup_sheet.dart';

loginSheet({
  String? state,
  String? dontPop,
}) async {
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
      return LoginBottom(
        dontPop: dontPop,
        state: state,
      );
    },
  );
}

class LoginBottom extends StatefulWidget {
  final String? state;
  final String? dontPop;
  const LoginBottom({super.key, this.state, this.dontPop});

  @override
  State<LoginBottom> createState() => _LoginBottomState();
}

class _LoginBottomState extends State<LoginBottom> {
  final TextEditingController _controller = TextEditingController(
    text: kDebugMode ? "utkarshsinghdhakad@gmail.com" : "",
  );
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  @override
  void initState() {
    super.initState();
    log("---State is ${widget.state}, ---Dont pop up is${widget.dontPop}---");
  }

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
    provider.login(request, state: widget.state, dontPop: widget.dontPop);
  }

  void _handleSignIn() async {
    if (await _googleSignIn.isSignedIn()) {
      await _googleSignIn.signOut();
    }

    try {
      String? fcmToken = await Preference.getFcmToken();
      String? address = await Preference.getLocation();

      GoogleSignInAccount? account = await _googleSignIn.signIn();
      log(account.toString());

      if (account != null) {
        UserProvider provider = context.read<UserProvider>();
        Map request = {
          "displayName": account.displayName ?? "",
          "email": account.email,
          "id": account.id,
          "photoUrl": account.photoUrl ?? "",
          "fcm_token": fcmToken ?? "",
          "platform": Platform.operatingSystem,
          "address": address ?? "",
          // "serverAuthCode": account?.serverAuthCode,
        };
        provider.googleLogin(request,
            state: widget.state, dontPop: widget.dontPop);
      }

      // GoogleSignInAccount:{displayName: Netleon Family, email: testnetleon@gmail.com, id: 110041963646228833065, photoUrl: https://lh3.googleusercontent.com/a/ACg8ocJocVZ9k-umOKg7MEzLfpG4d_GBrUFYY8o84_r3Am95dA, serverAuthCode: null}
    } catch (error) {
      popUpAlert(message: "$error", title: "Alert", icon: Images.alertPopGIF);
      log("$error");
    }
  }

  void _handleSignInApple(id, displayName, email) async {
    try {
      String? fcmToken = await Preference.getFcmToken();
      String? address = await Preference.getLocation();

      UserProvider provider = context.read<UserProvider>();

      Map request = {
        "displayName": displayName ?? "",
        "email": email ?? "",
        "id": id ?? "",
        "fcm_token": fcmToken ?? "",
        "platform": Platform.operatingSystem,
        "address": address ?? "",
      };
      provider.appleLogin(request,
          state: widget.state, dontPop: widget.dontPop);
      // GoogleSignInAccount:{displayName: Netleon Family, email: testnetleon@gmail.com, id: 110041963646228833065, photoUrl: https://lh3.googleusercontent.com/a/ACg8ocJocVZ9k-umOKg7MEzLfpG4d_GBrUFYY8o84_r3Am95dA, serverAuthCode: null}
    } catch (error) {
      popUpAlert(message: "$error", title: "Alert", icon: Images.alertPopGIF);
      // showErrorMessage(message: "$error");
      log("$error");
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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
          const SpacerVertical(height: 16),
          Container(
            width: MediaQuery.of(context).size.width * .45,
            constraints: BoxConstraints(maxHeight: kTextTabBarHeight - 2.sp),
            child: Image.asset(
              Images.logo,
              fit: BoxFit.contain,
            ),
          ),
          const SpacerVertical(height: 10),
          Padding(
            padding: const EdgeInsets.all(Dimen.authScreenPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "WELCOME BACK",
                  style: stylePTSansBold(fontSize: 24),
                ),
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

                // const SpacerVertical(),
                // Visibility(
                //     visible: Platform.isIOS,
                //     child: Container(
                //       margin: EdgeInsets.only(top: Dimen.itemSpacing.sp),
                //       child: SignInWithAppleButton(

                //         style: SignInWithAppleButtonStyle.whiteOutlined,
                //         iconAlignment: IconAlignment.left,
                //         onPressed: () async {
                //           try {
                //             // flutter: AuthorizationAppleID(000150.6a1410656f504cdcb3d81a2c25231878.1000, Netleon, Technologies, netleonweb@gmail.com, null)
                //             // if(Platform.isIOS && Platform.version)
                //             final AuthorizationCredentialAppleID credential =
                //                 await SignInWithApple.getAppleIDCredential(
                //               scopes: [
                //                 AppleIDAuthorizationScopes.email,
                //                 AppleIDAuthorizationScopes.fullName,
                //               ],
                //             );
                //             _handleSignInApple(
                //               credential.userIdentifier,
                //               credential.givenName != null
                //                   ? "${credential.givenName} ${credential.familyName}"
                //                   : null,
                //               credential.email,
                //             );
                //             print(credential.userIdentifier);
                //           } catch (e) {
                //             print("Error Apple Sign IN - $e");
                //             if (e.toString().contains(
                //                 "SignInWithAppleNotSupportedException")) {
                //               showErrorMessage(
                //                 message:
                //                     "Sign in with Apple not supported in this device",
                //               );
                //             }
                //           }
                //           // Now send the credential (especially `credential.authorizationCode`) to your server to create a session
                //           // after they have been validated with Apple (see `Integration` section for more information on how to do this)
                //         },
                //       ),
                //     )

                //     //  ThemeButton(
                //     //   margin: EdgeInsets.only(top: Dimen.itemSpacing.sp),
                //     //   onPressed: () async {
                //     //     _handleSignIn();
                //     //   },
                //     //   color: ThemeColors.primaryLight,
                //     //   child: SizedBox(
                //     //     width: double.infinity,
                //     //     child: Stack(
                //     //       alignment: Alignment.center,
                //     //       children: [
                //     //         Positioned(
                //     //           left: 0,
                //     //           child: Image.asset(
                //     //             Images.apple,
                //     //             width: 16.sp,
                //     //             height: 16.sp,
                //     //             fit: BoxFit.contain,
                //     //           ),
                //     //         ),
                //     //         Text(
                //     //           "Continue with Apple",
                //     //           style: stylePTSansRegular(fontSize: 14),
                //     //           textAlign: TextAlign.center,
                //     //         ),
                //     //       ],
                //     //     ),
                //     //   ),
                //     // ),
                //     ),

                // TextButton(
                //   onPressed: () {
                //     Navigator.pushNamed(context, SignUp.path);
                //   },
                //   child: Text(
                //     "Create a Stock News Account",
                //     style: stylePTSansRegular(
                //       fontSize: 12,
                //       color: ThemeColors.accent,
                //     ),
                //     textAlign: TextAlign.center,
                //   ),
                // ),

                Visibility(
                  visible: Platform.isIOS,
                  child: Padding(
                    padding: const EdgeInsets.only(top: Dimen.itemSpacing),
                    child: ThemeButton(
                      onPressed: () async {
                        try {
                          // flutter: AuthorizationAppleID(000150.6a1410656f504cdcb3d81a2c25231878.1000, Netleon, Technologies, netleonweb@gmail.com, null)
                          // if(Platform.isIOS && Platform.version)
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
                            showErrorMessage(
                              message:
                                  "Sign in with Apple not supported in this device",
                            );
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
                                width: 18,
                                height: 18,
                                fit: BoxFit.contain,
                                color: ThemeColors.background,
                              ),
                            ),
                            Text(
                              "Continue with Apple",
                              style: stylePTSansRegular(
                                  fontSize: 15, color: ThemeColors.background),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SpacerVertical(),
                const AgreeConditions(),

                Padding(
                  padding: EdgeInsets.all(15.sp),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account?",
                        style: stylePTSansRegular(
                          fontSize: 15,
                          color: ThemeColors.white,
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          Navigator.pop(context);
                          await signupSheet(
                            dontPop: widget.dontPop,
                            state: widget.state,
                          );
                          // Navigator.pushNamed(context, SignUp.path);
                          // if (widget.dontPop != null) {
                          //   // Navigator.pushReplacement(
                          //   //     context,
                          //   //     MaterialPageRoute(
                          //   //       builder: (context) => SignUp(
                          //   //         dntPop: widget.dontPop,
                          //   //         state: widget.state,
                          //   //       ),
                          //   //     ));
                          //   Navigator.pop(context);
                          //   signupSheet(
                          //     dontPop: widget.dontPop,
                          //     state: widget.state,
                          //   );
                          // } else {
                          //   Navigator.push(
                          //       context,
                          //       MaterialPageRoute(
                          //         builder: (context) => SignUp(
                          //           dntPop: widget.dontPop,
                          //           state: widget.state,
                          //         ),
                          //       ));
                          // }
                        },
                        child: Text(
                          " Sign up ",
                          style: stylePTSansRegular(
                            fontSize: 15,
                            color: ThemeColors.accent,
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
