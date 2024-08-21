import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/database/preference.dart';
import 'package:stocks_news_new/providers/home_provider.dart';
import 'package:stocks_news_new/providers/user_provider.dart';
import 'package:stocks_news_new/screens/tabs/home/widgets/app_bar_home.dart';
import 'package:stocks_news_new/utils/utils.dart';
import 'package:stocks_news_new/widgets/base_container.dart';
import 'package:stocks_news_new/widgets/custom/alert_popup.dart';
import 'package:stocks_news_new/widgets/theme_button.dart';

import '../../../../utils/constants.dart';
import '../../../../utils/theme.dart';
import '../../../../widgets/spacer_vertical.dart';
import '../../../../widgets/theme_input_field.dart';
import '../../contactUs/contact_us_item.dart';

class CompleteDetails extends StatefulWidget {
  const CompleteDetails({super.key});

  @override
  State<CompleteDetails> createState() => _CompleteDetailsState();
}

class _CompleteDetailsState extends State<CompleteDetails> {
  final TextEditingController name = TextEditingController(text: "");
  final TextEditingController displayName = TextEditingController(text: "");
  final TextEditingController email = TextEditingController(text: "");
  final TextEditingController referral = TextEditingController(text: "");

  @override
  void initState() {
    super.initState();
    _checkProfile();
  }

  _checkProfile() {
    UserProvider provider = context.read<UserProvider>();
    if (provider.user?.name != null && provider.user?.name != '') {
      name.text = provider.user?.name ?? "";
    }
    if (provider.user?.displayName != null &&
        provider.user?.displayName != '') {
      displayName.text = provider.user?.displayName ?? "";
    }
  }

  Future _onVerifyClick() async {
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
    } else if (email.text.isEmpty) {
      popUpAlert(
        message: "Please enter a valid email.",
        title: "Alert",
        icon: Images.alertPopGIF,
      );
    } else if (referral.text.isEmpty) {
      popUpAlert(
        message: "Please select a valid country code.",
        title: "Alert",
        icon: Images.alertPopGIF,
      );
    } else {
      // showGlobalProgressDialog();
      UserProvider provider = context.read<UserProvider>();

      String? fcmToken = await Preference.getFcmToken();
      String? address = await Preference.getLocation();
      // String? referralCode = await Preference.getReferral();
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      String versionName = packageInfo.version;
      String buildNumber = packageInfo.buildNumber;
      bool granted = await Permission.notification.isGranted;

      Map request = {
        "token": provider.user?.token ?? "",
        "name": name.text,
        "display_name": displayName.text,
        "email": displayName.text,
        "platform": Platform.operatingSystem,
        "fcm_token": fcmToken ?? "",
        "address": address ?? "",
        "build_version": versionName,
        "build_code": buildNumber,
        "fcm_permission": "$granted",
        "referral_code": "$referral",
      };

      await provider.completeRegistration(request);

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

    return GestureDetector(
      onTap: () {
        closeKeyboard();
      },
      child: BaseContainer(
        appBar: const AppBarHome(
          isPopback: true,
          canSearch: false,
          showTrailing: false,
          title: "",
        ),
        body: ListView(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
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
                            color: Colors.black,
                            fontSize: 18,
                          ),
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
                      Padding(
                        padding: const EdgeInsets.only(bottom: 5),
                        child: showAsteriskText(text: "Display Name"),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 15),
                        child: ThemeInputField(
                          style: stylePTSansBold(
                            color: Colors.black,
                            fontSize: 18,
                          ),
                          controller: displayName,
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
                        child: showAsteriskText(
                          text: "Email",
                          showAsterisk: false,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 15),
                        child: ThemeInputField(
                          style: stylePTSansBold(
                            color: Colors.black,
                            fontSize: 18,
                          ),
                          controller: name,
                          placeholder: "Enter your email",
                          keyboardType: TextInputType.name,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(60)
                          ],
                          textCapitalization: TextCapitalization.words,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 5),
                        child: showAsteriskText(
                          text: "Referral Code",
                          showAsterisk: false,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 15),
                        child: ThemeInputField(
                          style: stylePTSansBold(
                            color: Colors.black,
                            fontSize: 18,
                          ),
                          controller: name,
                          placeholder: "Enter referral code (optional)",
                          keyboardType: TextInputType.name,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(60)
                          ],
                          textCapitalization: TextCapitalization.words,
                        ),
                      ),
                      const SpacerVertical(height: Dimen.itemSpacing),
                      ThemeButton(
                        text: "Complete",
                        onPressed: _onVerifyClick,
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
