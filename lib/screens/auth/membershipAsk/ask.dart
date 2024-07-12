import 'dart:developer';
import 'dart:io';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sms_autofill/sms_autofill.dart';
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
import '../refer/refer_otp.dart';

membershipLogin() async {
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
        builder: (context, scrollController) => MembershipLoginAsk(
          scrollController: scrollController,
        ),
      );

      // return const MembershipLoginAsk();
    },
  );
}

class MembershipLoginAsk extends StatefulWidget {
  final ScrollController scrollController;

  const MembershipLoginAsk({
    super.key,
    required this.scrollController,
  });

  @override
  State<MembershipLoginAsk> createState() => _MembershipLoginAskState();
}

class _MembershipLoginAskState extends State<MembershipLoginAsk> {
  TextEditingController mobile = TextEditingController(text: "");
  TextEditingController name = TextEditingController(text: "");
  // TextEditingController displayName = TextEditingController(text: "");
  // bool affiliateStatus = false;
  bool numberVerified = true;

  String? countryCode;
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
    UserRes? user = context.read<UserProvider>().user;

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
    log("Country Code => $countryCode");

    UserProvider provider = context.read<UserProvider>();

    // countryCode = provider.user?.phoneCode == null ||
    //         provider.user?.phoneCode == ""
    //     ? CountryCode.fromCountryCode(Intl.getCurrentLocale().split('_').last)
    //             .dialCode ??
    //         ""
    //     : CountryCode.fromDialCode(provider.user?.phoneCode ?? " ").dialCode ??
    //         "";

    if (provider.user?.name != null && provider.user?.name != '') {
      name.text = provider.user?.name ?? "";
    }
    // if (provider.user?.displayName != null &&
    //     provider.user?.displayName != '') {
    //   displayName.text = provider.user?.displayName ?? "";
    // }
    if (provider.user?.phone != null && provider.user?.phone != '') {
      mobile.text = provider.user?.phone ?? "";
    }
    // affiliateStatus = provider.user?.affiliateStatus == 1;
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
    }

    // else if (displayName.text.isEmpty) {
    //   popUpAlert(
    //     message: "Please enter a valid display name.",
    //     title: "Alert",
    //     icon: Images.alertPopGIF,
    //   );
    // }

    else if (mobile.text.isEmpty || mobile.text.length < 10) {
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
      try {
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
              message: e.message ?? Const.errSomethingWrong,
              title: "Alert",
              icon: Images.alertPopGIF,
            );
          },
          codeSent: (String verificationId, int? resendToken) {
            closeGlobalProgressDialog();
            referOTP(
              name: name.text,
              // displayName: displayName.text,
              phone: mobile.text,
              appSignature: appSignature,
              verificationId: verificationId,
              countryCode: countryCode!,
              isVerifyIdentity: true,
            );
          },
          codeAutoRetrievalTimeout: (String verificationId) {},
        );
      } catch (e) {
        Utils().showLog("$e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    UserRes? user = context.read<UserProvider>().user;
    HomeProvider provider = context.watch<HomeProvider>();

    String? locale;
    if (user?.phoneCode != null && user?.phoneCode != "") {
      locale = CountryCode.fromDialCode(user!.phoneCode!).code?.split('_').last;
    } else if (geoCountryCode != null && geoCountryCode != "") {
      locale = geoCountryCode;
    } else {
      locale = "US";
    }
    // final String locale = user?.phoneCode == null || user?.phoneCode == ""
    //     ? Intl.getCurrentLocale().split('_').last
    //     : CountryCode.fromDialCode(user?.phoneCode ?? " ")
    //             .code
    //             ?.split('_')
    //             .last ??
    //         "";

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
          color: ThemeColors.background,
          border: Border(
            top: BorderSide(color: ThemeColors.greyBorder),
          ),
        ),
        child: ListView(
          controller: widget.scrollController,
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
                const SpacerVertical(height: 10),
                Padding(
                  padding: const EdgeInsets.all(Dimen.authScreenPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        provider.extra?.referLogin?.title ?? "Action Required",
                        style: stylePTSansBold(fontSize: 24),
                      ),
                      const SpacerVertical(height: 4),
                      Text(
                        'In order to purchase our membership, please enter the following details.',
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
                                    child: CountryCodePicker(
                                      padding: EdgeInsets.zero,
                                      enabled: user?.phoneCode == null ||
                                          user?.phoneCode == "",
                                      // enabled: true,
                                      onChanged: (CountryCode value) {
                                        countryCode = value.dialCode;
                                        setState(() {});
                                      },
                                      initialSelection: locale,
                                      showCountryOnly: false,
                                      textStyle: stylePTSansBold(
                                        color: Colors.black,
                                        fontSize: 18,
                                      ),
                                      flagWidth: 24,
                                      showOnlyCountryWhenClosed: false,
                                      alignLeft: false,
                                      boxDecoration: const BoxDecoration(
                                        color: ThemeColors.tabBack,
                                      ),
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
                                    ),
                                  ),
                                ],
                              ),
                              Flexible(
                                child: ThemeInputField(
                                  fillColor:
                                      user?.phone == '' || user?.phone == null
                                          ? ThemeColors.white
                                          : const Color.fromARGB(
                                              255,
                                              188,
                                              188,
                                              188,
                                            ),
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
                            'Note: You will receive an OTP to verify mobile number. ',
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
                                      TCandPolicy(
                                        policyType: PolicyType.membership,
                                        slug: url,
                                      ),
                                    ),
                                  );
                                  return true;
                                },
                                provider.extra?.verifySubscription ?? "",
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
