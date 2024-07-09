import 'dart:developer';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:provider/provider.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:stocks_news_new/api/api_response.dart';
import 'package:stocks_news_new/modals/user_res.dart';
import 'package:stocks_news_new/providers/home_provider.dart';
import 'package:stocks_news_new/providers/user_provider.dart';
import 'package:stocks_news_new/route/my_app.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/dialogs.dart';
import 'package:stocks_news_new/utils/utils.dart';
import 'package:stocks_news_new/widgets/custom/alert_popup.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/theme_button.dart';

import '../../../../utils/constants.dart';
import '../../../../utils/theme.dart';
import '../../../../widgets/spacer_vertical.dart';
import '../../../../widgets/theme_input_field.dart';
import '../../contactUs/contact_us_item.dart';
import '../../t&cAndPolicy/tc_policy.dart';
import 'refer_otp.dart';

referLogin() async {
  await showModalBottomSheet(
    useSafeArea: true,
    enableDrag: false,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(5),
        topRight: Radius.circular(5),
      ),
    ),
    backgroundColor: ThemeColors.transparent,
    isScrollControlled: true,
    context: navigatorKey.currentContext!,
    builder: (context) {
      return DraggableScrollableSheet(
        maxChildSize: 1,
        initialChildSize: 1,
        builder: (context, scrollController) => ReferLogin(
          scrollController: scrollController,
        ),
      );
    },
  );
}

class ReferLogin extends StatefulWidget {
  final ScrollController scrollController;

  const ReferLogin({super.key, required this.scrollController});

  @override
  State<ReferLogin> createState() => _ReferLoginState();
}

class _ReferLoginState extends State<ReferLogin> {
  TextEditingController mobile = TextEditingController(text: "");
  TextEditingController name = TextEditingController(text: "");
  TextEditingController displayName = TextEditingController(text: "");
  int affiliateStatus = 0;
  bool numberVerified = true;

  String appSignature = "";
  final TextInputFormatter _formatter = FilteringTextInputFormatter.digitsOnly;

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) _getAppSignature();
    _checkProfile();
  }

  bool checkBox = false;

  _checkProfile() {
    UserProvider provider = context.read<UserProvider>();
    if (provider.user?.name != null && provider.user?.name != '') {
      name.text = provider.user?.name ?? "";
    }
    if (provider.user?.displayName != null &&
        provider.user?.displayName != '') {
      displayName.text = provider.user?.displayName ?? "";
    }
    if (provider.user?.phone != null && provider.user?.phone != '') {
      mobile.text = provider.user?.phone ?? "";
    }
    affiliateStatus = provider.user?.affiliateStatus ?? 1;
    numberVerified = provider.user?.phone != null &&
        provider.user?.phone != "" &&
        provider.user?.name != null &&
        provider.user?.name != "";
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

  Future _referLogin() async {
    if (name.text.isEmpty) {
      popUpAlert(
        message: "Please enter a valid name.",
        title: "Alert",
        icon: Images.alertPopGIF,
      );
    } else if (displayName.text.isEmpty) {
      popUpAlert(
        message: "Please enter a valid display name.",
        title: "Alert",
        icon: Images.alertPopGIF,
      );
    } else if (mobile.text.isEmpty || mobile.text.length < 10) {
      popUpAlert(
        message: "Please enter a valid phone number.",
        title: "Alert",
        icon: Images.alertPopGIF,
      );
    } else {
      if (!numberVerified) {
        showGlobalProgressDialog();
        await FirebaseAuth.instance.verifyPhoneNumber(
          phoneNumber: kDebugMode ? "+91 ${mobile.text}" : "+1${mobile.text}",
          verificationCompleted: (PhoneAuthCredential credential) {
            closeGlobalProgressDialog();
          },
          verificationFailed: (FirebaseAuthException e) {
            closeGlobalProgressDialog();
            log("Error message => ${e.code} ${e.message} ${e.stackTrace}");
            popUpAlert(
              message: e.message ?? Const.errSomethingWrong,
              title: "Alert",
              icon: Images.alertPopGIF,
            );
          },
          codeSent: (String verificationId, int? resendToken) {
            closeGlobalProgressDialog();
            referOTP(
              name: name.text,
              displayName: displayName.text,
              phone: mobile.text,
              appSignature: appSignature,
              verificationId: verificationId,
            );
          },
          codeAutoRetrievalTimeout: (String verificationId) {},
        );
      } else {
        UserProvider provider = context.read<UserProvider>();
        Map request = {
          "token": provider.user?.token ?? "",
          "display_name": displayName.text,
          "phone_hash": appSignature,
          "platform": Platform.operatingSystem,
        };

        try {
          ApiResponse response = await provider.referLoginApi(request);
          if (response.status) {
            provider.updateUser(name: name.text, displayName: displayName.text);
            Navigator.pop(navigatorKey.currentContext!);
            referOTP(
              phone: mobile.text,
              appSignature: appSignature,
              verificationId: "",
              displayName: "",
            );

            // Navigator.push(
            //     navigatorKey.currentContext!,
            //     MaterialPageRoute(
            //       builder: (_) => const ReferAFriend(),
            //     ),
            //   );
          }
        } catch (e) {
          //
        }
      }
      //   UserProvider provider = context.read<UserProvider>();
      //   Map request = !numberVerified
      //       ? {
      //           "token": provider.user?.token ?? "",
      //           "phone": mobile.text,
      //           "name": name.text,
      //           "display_name": displayName.text,
      //           "phone_hash": appSignature,
      //           "platform": Platform.operatingSystem,
      //         }
      //       : {
      //           "token": provider.user?.token ?? "",
      //           "display_name": displayName.text,
      //           "phone_hash": appSignature,
      //           "platform": Platform.operatingSystem,
      //         };

      //   try {
      //     ApiResponse response = await provider.referLoginApi(request);
      //     if (response.status) {
      //       provider.updateUser(name: name.text, displayName: displayName.text);
      //       Navigator.pop(navigatorKey.currentContext!);
      //       referOTP(
      //         phone: mobile.text,
      //         appSignature: appSignature,
      //         verificationId: "",
      //         displayName: "",
      //       );

      //       // Navigator.push(
      //       //     navigatorKey.currentContext!,
      //       //     MaterialPageRoute(
      //       //       builder: (_) => const ReferAFriend(),
      //       //     ),
      //       //   );
      //     }
      //   } catch (e) {
      //     //
      //   }
    }
  }

  @override
  Widget build(BuildContext context) {
    UserRes? user = context.read<UserProvider>().user;
    HomeProvider provider = context.watch<HomeProvider>();

    return GestureDetector(
      onTap: () {
        closeKeyboard();
      },
      child: Container(
        constraints: BoxConstraints(maxHeight: ScreenUtil().screenHeight - 30),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [ThemeColors.bottomsheetGradient, Colors.black],
          ),
          // gradient: RadialGradient(
          //   center: Alignment.bottomCenter,
          //   radius: 0.6,
          //   stops: [
          //     0.0,
          //     0.9,
          //   ],
          //   colors: [
          //     Color.fromARGB(255, 0, 93, 12),
          //     Colors.black,
          //   ],
          // ),
          color: ThemeColors.background,
          border: Border(
            top: BorderSide(color: ThemeColors.greyBorder),
          ),
        ),
        child: ListView(
          controller: widget.scrollController,
          // physics: const NeverScrollableScrollPhysics(),
          children: [
            Column(
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
                //   constraints:
                //       BoxConstraints(maxHeight: kTextTabBarHeight - 2.sp),
                //   child: Image.asset(
                //     Images.logo,
                //     fit: BoxFit.contain,
                //   ),
                // ),
                const SpacerVertical(height: 10),
                Padding(
                  padding: const EdgeInsets.all(Dimen.authScreenPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Text(
                      //   provider.extra?.referLogin?.title ?? "Verify Identity",
                      //   style: stylePTSansBold(fontSize: 24),
                      // ),
                      Text(
                        provider.extra?.referLogin?.title ?? "Action Required",
                        style: stylePTSansBold(fontSize: 24),
                      ),
                      const SpacerVertical(height: 4),
                      Text(
                        provider.extra?.referLogin?.subTitle ??
                            'In order to Join our Affiliate Program, please enter the following details.',
                        style: stylePTSansRegular(color: Colors.grey),
                      ),
                      const SpacerVertical(height: 30),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 5),
                        child: showAsteriskText(text: "Real Name"),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 15),
                        child: ThemeInputField(
                          style: stylePTSansBold(
                              color: Colors.black, fontSize: 18),
                          controller: name,
                          fillColor: user?.name == '' || user?.name == null
                              ? ThemeColors.white
                              : const Color.fromARGB(255, 188, 188, 188),
                          editable: user?.name == '' || user?.name == null,
                          placeholder: "Enter your name",
                          keyboardType: TextInputType.name,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(60)
                          ],
                          textCapitalization: TextCapitalization.words,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 5),
                        child: showAsteriskText(text: "Display Name"),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 15),
                        child: ThemeInputField(
                          style: stylePTSansBold(
                              color: Colors.black, fontSize: 18),
                          // editable: user?.displayName == '' ||
                          //     user?.displayName == null,
                          controller: displayName,
                          // fillColor: user?.displayName == '' ||
                          //         user?.displayName == null
                          //     ? ThemeColors.white
                          //     : const Color.fromARGB(255, 133, 133, 133),
                          placeholder: "Enter your display name",
                          keyboardType: TextInputType.name,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(20)
                          ],
                          textCapitalization: TextCapitalization.words,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 5),
                        child: showAsteriskText(text: "Phone Number"),
                      ),
                      IntrinsicHeight(
                        child: Container(
                          decoration: BoxDecoration(
                            color: user?.phone == '' || user?.phone == null
                                ? ThemeColors.white
                                : const Color.fromARGB(255, 188, 188, 188),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Row(
                            children: [
                              Stack(
                                alignment: Alignment.center,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                    ),
                                    decoration: BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(
                                          color: user?.phone == '' ||
                                                  user?.phone == null
                                              ? ThemeColors.white
                                              : const Color.fromARGB(
                                                  255, 188, 188, 188),
                                        ),
                                      ),
                                      color: user?.phone == '' ||
                                              user?.phone == null
                                          ? ThemeColors.white
                                          : const Color.fromARGB(
                                              255, 188, 188, 188),
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(4),
                                        bottomLeft: Radius.circular(4),
                                      ),
                                    ),
                                    // child: Text(
                                    //   "+1",
                                    //   style: stylePTSansBold(
                                    //       color: ThemeColors.greyText, fontSize: 18),
                                    // ),
                                  ),
                                  Text(
                                    "+1",
                                    style: stylePTSansBold(
                                      color: user?.phone == '' ||
                                              user?.phone == null
                                          ? ThemeColors.greyText
                                          : ThemeColors.greyBorder,
                                      fontSize: 18,
                                    ),
                                  ),
                                ],
                              ),
                              const SpacerHorizontal(width: 2),
                              Flexible(
                                child: ThemeInputField(
                                  fillColor:
                                      user?.phone == '' || user?.phone == null
                                          ? ThemeColors.white
                                          : const Color.fromARGB(
                                              255, 188, 188, 188),
                                  editable:
                                      user?.phone == '' || user?.phone == null,
                                  style: stylePTSansBold(
                                    color: Colors.black,
                                    fontSize: 18,
                                  ),
                                  borderRadiusOnly: const BorderRadius.only(
                                    topRight: Radius.circular(4),
                                    bottomRight: Radius.circular(4),
                                  ),
                                  controller: mobile,
                                  placeholder: "Enter your phone number",
                                  keyboardType: TextInputType.phone,
                                  inputFormatters: [
                                    _formatter,
                                    LengthLimitingTextInputFormatter(10)
                                  ],
                                  textCapitalization: TextCapitalization.none,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SpacerVertical(height: Dimen.itemSpacing),
                      HtmlWidget(
                        provider.extra?.referLogin?.note ??
                            'Note: You will receive an OTP to verify mobile number. Please enter USA phone number only. '
                                'Do not include +1 or an special character.',
                        textStyle: stylePTSansRegular(color: Colors.grey),
                      ),
                      const SpacerVertical(height: Dimen.itemSpacing),
                      InkWell(
                        onTap: () {
                          checkBox = !checkBox;
                          setState(() {});
                        },
                        child: Row(
                          children: [
                            Icon(
                              checkBox
                                  ? Icons.check_box
                                  : Icons.check_box_outline_blank_outlined,
                              color: ThemeColors.accent,
                            ),
                            const SpacerHorizontal(width: 10),
                            Flexible(
                              child: HtmlWidget(
                                customStylesBuilder: (element) {
                                  if (element.localName == 'a') {
                                    return {
                                      'color': '#1bb449',
                                      'text-decoration': 'none'
                                    };
                                  }
                                  return null;
                                },
                                onTapUrl: (url) async {
                                  Navigator.push(
                                    context,
                                    createRoute(
                                      const TCandPolicy(
                                        policyType: PolicyType.referral,
                                        slug: "referral-terms",
                                      ),
                                    ),
                                  );
                                  return true;
                                },
                                provider.extra?.verifyIdentity ?? "",
                                textStyle:
                                    stylePTSansRegular(color: Colors.grey),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SpacerVertical(height: Dimen.itemSpacing),
                      if (!numberVerified)
                        ThemeButton(
                          text: "Send OTP",
                          onPressed: checkBox ? _referLogin : null,
                          textUppercase: true,
                        ),
                      if (numberVerified)
                        ThemeButton(
                          text: "Join Affiliate Program",
                          onPressed: checkBox ? _referLogin : null,
                          textUppercase: true,
                        ),
                      const SpacerVertical(height: 200),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
