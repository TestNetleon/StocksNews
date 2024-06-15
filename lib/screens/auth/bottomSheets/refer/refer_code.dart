import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:stocks_news_new/api/api_response.dart';
import 'package:stocks_news_new/providers/user_provider.dart';
import 'package:stocks_news_new/route/my_app.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/utils.dart';
import 'package:stocks_news_new/widgets/custom/alert_popup.dart';
import 'package:stocks_news_new/widgets/theme_button.dart';

import '../../../../utils/constants.dart';
import '../../../../utils/theme.dart';
import '../../../../widgets/spacer_vertical.dart';
import '../../../../widgets/theme_input_field.dart';
import 'refer_otp.dart';

referLogin() async {
  await showModalBottomSheet(
    useSafeArea: true,
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
      return const ReferLogin();
    },
  );
}

class ReferLogin extends StatefulWidget {
  const ReferLogin({super.key});

  @override
  State<ReferLogin> createState() => _ReferLoginState();
}

class _ReferLoginState extends State<ReferLogin> {
  TextEditingController mobile = TextEditingController(text: "");
  String appSignature = "";
  TextInputFormatter _formatter = FilteringTextInputFormatter.digitsOnly;

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) _getAppSignature();
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
    if (mobile.text.isEmpty || mobile.text.length < 10) {
      popUpAlert(
        message: "Please enter a valid phone number.",
        title: "Alert",
        icon: Images.alertPopGIF,
      );
    } else {
      UserProvider provider = context.read<UserProvider>();
      Map request = {
        "token": provider.user?.token ?? "",
        "phone": mobile.text,
        "phone_hash": appSignature,
        "platform": Platform.operatingSystem,
      };

      try {
        ApiResponse response = await provider.referLogin(request);
        if (response.status) {
          Navigator.pop(navigatorKey.currentContext!);
          referOTP(
            phone: mobile.text,
            appSignature: appSignature,
          );
        }
      } catch (e) {
        //
      }
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
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10), topRight: Radius.circular(10)),
          gradient: RadialGradient(
            center: Alignment.bottomCenter,
            radius: 0.6,
            stops: [
              0.0,
              0.9,
            ],
            colors: [
              Color.fromARGB(255, 0, 93, 12),
              Colors.black,
            ],
          ),
          color: ThemeColors.background,
          border: Border(
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
            const SpacerVertical(height: 70),
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
                    "Enter mobile number",
                    style: stylePTSansBold(fontSize: 24),
                  ),
                  const SpacerVertical(height: 4),
                  Text(
                    'We will send a confirmation code',
                    style: stylePTSansRegular(color: Colors.grey),
                  ),
                  const SpacerVertical(height: 30),
                  // Text(
                  //   "Email Address",
                  //   style: stylePTSansRegular(fontSize: 14),
                  // ),
                  // const SpacerVertical(height: 5),
                  IntrinsicHeight(
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 12.7),
                          decoration: const BoxDecoration(
                            color: ThemeColors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(4),
                              bottomLeft: Radius.circular(4),
                            ),
                          ),
                          child: Text(
                            "+1",
                            style: stylePTSansBold(
                                color: ThemeColors.greyText, fontSize: 18),
                          ),
                        ),
                        // const SpacerHorizontal(width: 2),
                        Expanded(
                          child: ThemeInputField(
                            style: stylePTSansBold(
                                color: Colors.black, fontSize: 18),
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
                  const SpacerVertical(height: Dimen.itemSpacing),
                  Text(
                    'Note: Please enter USA phone number only. '
                    'Do not include +1 or an special character.',
                    style: stylePTSansRegular(color: Colors.grey),
                  ),
                  const SpacerVertical(height: Dimen.itemSpacing),

                  ThemeButton(
                    text: "Send OTP",
                    onPressed: _referLogin,
                  ),
                  const SpacerVertical(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
