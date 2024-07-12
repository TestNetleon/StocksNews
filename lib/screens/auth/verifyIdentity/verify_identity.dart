import 'dart:developer';
import 'dart:io';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:provider/provider.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:stocks_news_new/modals/user_res.dart';
import 'package:stocks_news_new/providers/home_provider.dart';
import 'package:stocks_news_new/providers/user_provider.dart';
import 'package:stocks_news_new/route/my_app.dart';
import 'package:stocks_news_new/screens/auth/refer/refer_otp.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/dialogs.dart';
import 'package:stocks_news_new/utils/utils.dart';
import 'package:stocks_news_new/widgets/custom/alert_popup.dart';
import 'package:stocks_news_new/widgets/theme_button.dart';

import '../../../../utils/constants.dart';
import '../../../../utils/theme.dart';
import '../../../../widgets/spacer_vertical.dart';
import '../../../../widgets/theme_input_field.dart';
import '../../contactUs/contact_us_item.dart';

verifyIdentitySheet() async {
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
        builder: (context, scrollController) => VerifyIdentity(
          scrollController: scrollController,
        ),
      );
    },
  );
}

class VerifyIdentity extends StatefulWidget {
  final ScrollController scrollController;

  const VerifyIdentity({super.key, required this.scrollController});

  @override
  State<VerifyIdentity> createState() => _VerifyIdentityState();
}

class _VerifyIdentityState extends State<VerifyIdentity> {
  TextEditingController mobile = TextEditingController(text: "");
  TextEditingController name = TextEditingController(text: "");
  TextEditingController displayName = TextEditingController(text: "");
  String? countryCode;

  String appSignature = "";
  final TextInputFormatter _formatter = FilteringTextInputFormatter.digitsOnly;

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) _getAppSignature();
    _checkProfile();
  }

  _checkProfile() {
    UserProvider provider = context.read<UserProvider>();

    if (provider.user?.phoneCode != null && provider.user?.phoneCode != "") {
      countryCode =
          CountryCode.fromDialCode(provider.user?.phoneCode ?? "").dialCode;
    } else if (geoCountryCode != null && geoCountryCode != "") {
      countryCode = CountryCode.fromCountryCode(geoCountryCode!).dialCode;
    } else {
      countryCode = CountryCode.fromCountryCode("US").dialCode;
    }
    log("Country Code => $countryCode");

    if (provider.user?.name != null && provider.user?.name != '') {
      name.text = provider.user?.name ?? "";
    }
    if (provider.user?.displayName != null &&
        provider.user?.displayName != '') {
      displayName.text = provider.user?.displayName ?? "";
    }
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

  Future _onVerifyClick() async {
    if (name.text.isEmpty) {
      popUpAlert(
        message: "Please enter a valid name.",
        title: "Alert",
        icon: Images.alertPopGIF,
      );
      // } else if (displayName.text.isEmpty) {
      //   popUpAlert(
      //     message: "Please enter a valid display name.",
      //     title: "Alert",
      //     icon: Images.alertPopGIF,
      //   );
    } else if (mobile.text.isEmpty || mobile.text.length < 10) {
      popUpAlert(
        message: "Please enter a valid phone number.",
        title: "Alert",
        icon: Images.alertPopGIF,
      );
    } else if (countryCode == null) {
      popUpAlert(
        message: "Please select a valid country code.",
        title: "Alert",
        icon: Images.alertPopGIF,
      );
    } else {
      showGlobalProgressDialog();
      await FirebaseAuth.instance.verifyPhoneNumber(
        // phoneNumber: kDebugMode ? "+91 ${mobile.text}" : "+1${mobile.text}",
        phoneNumber: "$countryCode ${mobile.text}",
        verificationCompleted: (PhoneAuthCredential credential) {
          closeGlobalProgressDialog();
        },
        verificationFailed: (FirebaseAuthException e) {
          closeGlobalProgressDialog();
          // log("Error message => ${e.code} ${e.message} ${e.stackTrace}");
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
        },
        codeSent: (String verificationId, int? resendToken) {
          closeGlobalProgressDialog();
          referOTP(
            name: name.text,
            displayName: displayName.text,
            phone: mobile.text,
            appSignature: appSignature,
            verificationId: verificationId,
            isVerifyIdentity: true,
            countryCode: countryCode!,
          );
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
      // UserProvider provider = context.read<UserProvider>();
      // Map request = {
      //   "token": provider.user?.token ?? "",
      //   "phone": mobile.text,
      //   "name": name.text,
      //   "display_name": displayName.text,
      //   "phone_hash": appSignature,
      //   "platform": Platform.operatingSystem,
      // };
      // try {
      //   ApiResponse response = await provider.referLoginApi(request);
      //   if (response.status) {
      //     provider.updateUser(name: name.text, displayName: displayName.text);
      //     Navigator.pop(navigatorKey.currentContext!);
      //     referOTP(
      //       phone: mobile.text,
      //       appSignature: appSignature,
      //       verificationId: "",
      //       displayName: "",
      //       isVerifyIdentity: true,
      //     );
      //   }
      // } catch (e) {
      //   //
      // }
    }
  }

  @override
  Widget build(BuildContext context) {
    HomeProvider provider = context.watch<HomeProvider>();
    // final String locale = Intl.getCurrentLocale().split('_').last;
    UserRes? user = context.read<UserProvider>().user;

    String? locale;
    if (user?.phoneCode != null && user?.phoneCode != "") {
      locale = CountryCode.fromDialCode(user!.phoneCode!).code?.split('_').last;
    } else if (geoCountryCode != null && geoCountryCode != "") {
      locale = geoCountryCode;
    } else {
      locale = "US";
    }

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
                      Text(
                        provider.extra?.referLogin?.title ?? "Verify Identity",
                        style: stylePTSansBold(fontSize: 24),
                      ),
                      const SpacerVertical(height: 4),
                      Text(
                        // provider.extra?.referLogin?.subTitle ??
                        'In order to verify your identity, please enter the following details.',
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
                          // fillColor: user?.name == '' || user?.name == null
                          //     ? ThemeColors.white
                          //     : const Color.fromARGB(255, 133, 133, 133),
                          // editable: user?.name == '' || user?.name == null,
                          placeholder: "Enter your name",
                          keyboardType: TextInputType.name,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(60)
                          ],
                          textCapitalization: TextCapitalization.words,
                        ),
                      ),
                      // Padding(
                      //   padding: const EdgeInsets.only(bottom: 5),
                      //   child: showAsteriskText(text: "Display Name"),
                      // ),
                      // Padding(
                      //   padding: const EdgeInsets.only(bottom: 15),
                      //   child: ThemeInputField(
                      //     style: stylePTSansBold(
                      //         color: Colors.black, fontSize: 18),
                      //     // editable: user?.displayName == '' ||
                      //     //     user?.displayName == null,
                      //     controller: displayName,
                      //     // fillColor: user?.displayName == '' ||
                      //     //         user?.displayName == null
                      //     //     ? ThemeColors.white
                      //     //     : const Color.fromARGB(255, 133, 133, 133),
                      //     placeholder: "Enter your display name",
                      //     keyboardType: TextInputType.name,
                      //     inputFormatters: [
                      //       LengthLimitingTextInputFormatter(20)
                      //     ],
                      //     textCapitalization: TextCapitalization.words,
                      //   ),
                      // ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 5),
                        child: showAsteriskText(text: "Phone Number"),
                      ),
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
                                      // padding: const EdgeInsets.symmetric(
                                      //     // horizontal: 12,
                                      //     // horizontal: 20,
                                      //     ),
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
                                      child: CountryCodePicker(
                                        padding: EdgeInsets.zero,
                                        onChanged: (CountryCode value) {
                                          countryCode = value.dialCode;
                                          // log("Selected Log => ${value.dialCode}");
                                        },
                                        initialSelection: locale,
                                        showCountryOnly: false,
                                        flagWidth: 24,
                                        showOnlyCountryWhenClosed: false,
                                        alignLeft: false,
                                        boxDecoration: const BoxDecoration(
                                          color: ThemeColors.tabBack,
                                        ),
                                        // builder: (CountryCode? country) {
                                        //   log("Selected Log => ${country?.code}");
                                        // },
                                        dialogTextStyle: styleGeorgiaBold(),
                                        barrierColor: Colors.black26,
                                        searchDecoration: InputDecoration(
                                          iconColor: Colors.white,
                                          fillColor: Colors.white,
                                          prefixIcon: const Icon(
                                            Icons.search,
                                            size: 22,
                                          ),
                                          filled: true,
                                          hintStyle: stylePTSansRegular(
                                            color: Colors.grey,
                                          ),
                                          hintText: "Search country",
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(4.0),
                                            borderSide: BorderSide.none,
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(4.0),
                                            borderSide: BorderSide.none,
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(4.0),
                                            borderSide: BorderSide.none,
                                          ),
                                        ),
                                      )
                                      // Text(
                                      //   "+1",
                                      //   style: stylePTSansBold(
                                      //     color: user?.phone == '' ||
                                      //             user?.phone == null
                                      //         ? ThemeColors.greyText
                                      //         : ThemeColors.greyBorder,
                                      //     fontSize: 18,
                                      //   ),
                                      // ),
                                      ),
                                  // Text(
                                  //   "+1",
                                  //   style: stylePTSansBold(
                                  //     color: user?.phone == '' ||
                                  //             user?.phone == null
                                  //         ? ThemeColors.greyText
                                  //         : ThemeColors.greyBorder,
                                  //     fontSize: 18,
                                  //   ),
                                  // ),
                                ],
                              ),
                              // Stack(
                              //   alignment: Alignment.center,
                              //   children: [
                              //     Container(
                              //       padding: const EdgeInsets.symmetric(
                              //           horizontal: 20),
                              //       decoration: const BoxDecoration(
                              //         border: Border(
                              //           bottom: BorderSide(
                              //             color: ThemeColors.white,
                              //           ),
                              //         ),
                              //         color: ThemeColors.white,
                              //         borderRadius: BorderRadius.only(
                              //           topLeft: Radius.circular(4),
                              //           bottomLeft: Radius.circular(4),
                              //         ),
                              //       ),
                              //       // child: Text(
                              //       //   "+1",
                              //       //   style: stylePTSansBold(
                              //       //       color: ThemeColors.greyText, fontSize: 18),
                              //       // ),
                              //     ),
                              //     Text(
                              //       "+1",
                              //       style: stylePTSansBold(
                              //           color: ThemeColors.greyText,
                              //           fontSize: 18),
                              //     ),
                              //   ],
                              // ),
                              // const SpacerHorizontal(width: 2),
                              Flexible(
                                child: ThemeInputField(
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
                                    LengthLimitingTextInputFormatter(15)
                                  ],
                                  textCapitalization: TextCapitalization.none,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // IntrinsicHeight(
                      //   child: Row(
                      //     children: [
                      //       Container(
                      //         // height: 40,
                      //         width: 30,
                      //         color: ThemeColors.accent,
                      //       ),
                      //       Flexible(child: TextInputField(controller: mobile)),
                      //     ],
                      //   ),
                      // ),
                      const SpacerVertical(height: Dimen.itemSpacing),
                      HtmlWidget(
                        provider.extra?.referLogin?.note ??
                            'Note: You will receive an OTP to verify mobile number.',
                        textStyle: stylePTSansRegular(color: Colors.grey),
                      ),
                      // const SpacerVertical(height: Dimen.itemSpacing),
                      // InkWell(
                      //   onTap: () {
                      //     checkBox = !checkBox;
                      //     setState(() {});
                      //   },
                      //   child: Row(
                      //     children: [
                      //       Icon(
                      //         checkBox
                      //             ? Icons.check_box
                      //             : Icons.check_box_outline_blank_outlined,
                      //         color: ThemeColors.accent,
                      //       ),
                      //       const SpacerHorizontal(width: 10),
                      //       Flexible(
                      //         child: HtmlWidget(
                      //           customStylesBuilder: (element) {
                      //             if (element.localName == 'a') {
                      //               return {
                      //                 'color': '#1bb449',
                      //                 'text-decoration': 'none'
                      //               };
                      //             }
                      //             return null;
                      //           },
                      //           onTapUrl: (url) async {
                      //             Navigator.push(
                      //               context,
                      //               createRoute(
                      //                 const TCandPolicy(
                      //                   policyType: PolicyType.referral,
                      //                   slug: "referral-terms",
                      //                 ),
                      //               ),
                      //             );
                      //             return true;
                      //           },
                      //           provider.extra?.verifyIdentity ?? "",
                      //           textStyle:
                      //               stylePTSansRegular(color: Colors.grey),
                      //         ),
                      //       ),
                      //     ],
                      //   ),
                      // ),
                      const SpacerVertical(height: Dimen.itemSpacing),
                      ThemeButton(
                        text: "Send OTP",
                        onPressed: _onVerifyClick,
                        textUppercase: true,
                      ),
                      const SpacerVertical(
                        height: 200,
                      ),
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
