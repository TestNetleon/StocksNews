import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/route/my_app.dart';
import 'package:stocks_news_new/utils/constants.dart';

import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/utils/validations.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import 'package:stocks_news_new/widgets/theme_button.dart';
import 'package:stocks_news_new/widgets/theme_input_field.dart';

import '../providers/user_provider.dart';
import '../utils/dialogs.dart';

void showIosEmailError({
  String? state,
  String? dontPop,
  String? id,
}) {
  showPlatformBottomSheet(
    padding: EdgeInsets.symmetric(horizontal: 10.sp, vertical: 7.sp),
    context: navigatorKey.currentContext!,
    content: IOSemailError(state: state, dontPop: dontPop, id: id),
  );
}

class IOSemailError extends StatefulWidget {
  final Function()? onPress;
  final String? state;
  final String? dontPop;
  final String? id;
  const IOSemailError({
    super.key,
    this.onPress,
    this.state,
    this.dontPop,
    this.id,
  });

  @override
  State<IOSemailError> createState() => _IOSemailErrorState();
}

class _IOSemailErrorState extends State<IOSemailError> {
  TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.sp),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Enter Email Address",
            style: stylePTSansBold(fontSize: 18),
          ),
          const SpacerVertical(height: 3),
          Text(
            "Looks like there is some issue with registration, please enter your Apple ID using that you want to sign up. You will receive an OTP for verification on this email address.",
            style: stylePTSansRegular(fontSize: 14),
          ),
          const SpacerVertical(height: 3),
          Text(
            "After successful sign up you will be able to login with Apple ID.",
            style: stylePTSansRegular(fontSize: 14),
          ),
          const SpacerVertical(height: 5),
          ThemeInputField(
            controller: controller,
            placeholder: "Enter email address",
            keyboardType: TextInputType.emailAddress,
            inputFormatters: [emailFormatter],
            textCapitalization: TextCapitalization.none,
          ),
          const SpacerVertical(height: Dimen.itemSpacing),
          ThemeButton(
            text: "Next",
            onPressed: () {
              // UserProvider provider = context.read<UserProvider>();
              // Map request = {
              //   "username": controller.text.toLowerCase(),
              //   "type": "email",
              //   //------------
              //   "displayName": "",
              //   "email": controller.text.toLowerCase(),
              //   "id": id ?? "",
              //   "fcm_token": fcmToken ?? "",
              //   "platform": Platform.operatingSystem,
              //   "address": address ?? "",
              //   "build_version": versionName,
              //   "build_code": buildNumber,
              //   "fcm_permission": "$granted",
              // };
              // Navigator.pop(context);
              // provider.appleLogin(
              //   request,
              //   state: widget.state,
              //   dontPop: widget.dontPop,
              // );
              UserProvider provider = context.read<UserProvider>();
              Map request = {
                "email": controller.text.toLowerCase(),
                // "type": "email",
                // "id": widget.id,
              };
              Navigator.pop(context);
              provider.sendEmailOTP(
                request,
                state: widget.state,
                dontPop: widget.dontPop,
                id: widget.id,
                email: controller.text.toLowerCase(),
                showOtp: true,
              );
            },
          ),
          const SpacerVertical(height: Dimen.itemSpacing),
        ],
      ),
    );
  }
}
