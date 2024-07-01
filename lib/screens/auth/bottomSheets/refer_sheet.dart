// ignore_for_file: avoid_print, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/providers/home_provider.dart';
// import 'package:stocks_news_new/screens/auth/otp/otp_login.dart';

import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';

import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/custom/alert_popup.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import 'package:stocks_news_new/widgets/theme_button.dart';

import '../../../route/my_app.dart';
import '../../../utils/utils.dart';
import '../../../utils/validations.dart';
import '../../../widgets/theme_input_field.dart';

referSheet({
  String? state,
  String? dontPop,
  required Function(String? code) onReferral,
}) async {
  await showModalBottomSheet(
    useSafeArea: true,
    backgroundColor: ThemeColors.transparent,
    isScrollControlled: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(5.sp),
        topRight: Radius.circular(5.sp),
      ),
    ),
    context: navigatorKey.currentContext!,
    builder: (context) {
      return Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: ReferBottomSheet(
          state: state,
          dntPop: dontPop,
          onReferral: onReferral,
        ),
      );
    },
    isDismissible: false,
    enableDrag: false,
  );
}

class ReferBottomSheet extends StatefulWidget {
  final String? dntPop;
  final String? state;
  final Function(String? code) onReferral;

  const ReferBottomSheet({
    super.key,
    this.dntPop,
    this.state,
    required this.onReferral,
  });

  @override
  State<ReferBottomSheet> createState() => _ReferBottomSheetState();
}

class _ReferBottomSheetState extends State<ReferBottomSheet> {
  final TextEditingController _controller = TextEditingController();

  void _onContinueClick() {
    closeKeyboard();

    if (isEmpty(_controller.text) || _controller.text.length != 6) {
      popUpAlert(
        message: "Please enter valid referral code",
        title: "Alert",
        icon: Images.alertPopGIF,
      );
      return;
    }
    Navigator.pop(context);
    widget.onReferral(_controller.text.toUpperCase());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String? text = context.read<HomeProvider>().extra?.referText;

    return GestureDetector(
      onTap: () {
        closeKeyboard();
      },
      child: Container(
        constraints: BoxConstraints(maxHeight: ScreenUtil().screenHeight - 30),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10.sp),
              topRight: Radius.circular(10.sp)),
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
          mainAxisSize: MainAxisSize.min,
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
            Padding(
              padding: const EdgeInsets.all(Dimen.authScreenPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // const SpacerVertical(height: 16),
                  Text(
                    "Referral Code",
                    style: stylePTSansBold(fontSize: 24),
                  ),
                  const SpacerVertical(height: 10),
                  if (text != null)
                    Column(
                      children: [
                        Text(
                          text,
                          style: stylePTSansRegular(fontSize: 13),
                        ),
                        const SpacerVertical(height: 15),
                      ],
                    ),
                  // ThemeButton(
                  //   onPressed: () {
                  //     // Navigator.push(context, CreateAccount.path);
                  //     createAccountSheet();
                  //   },
                  //   child: SizedBox(
                  //     width: double.infinity,
                  //     child: Stack(
                  //       alignment: Alignment.center,
                  //       children: [
                  //         const Positioned(left: 0, child: Icon(Icons.person)),
                  //         Text(
                  //           "Sign Up with Email Address",
                  //           style: stylePTSansRegular(fontSize: 14),
                  //           textAlign: TextAlign.center,
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                  // ),
                  // Text(
                  //   "Email Address",
                  //   style: stylePTSansRegular(fontSize: 14),
                  // ),
                  // const SpacerVertical(height: 5),
                  ThemeInputField(
                    controller: _controller,
                    placeholder: "Enter referral code",
                    inputFormatters: [allSpecialSymbolsRemove],
                    textCapitalization: TextCapitalization.characters,
                    maxLength: 6,
                  ),
                  const SpacerVertical(height: Dimen.itemSpacing),
                  ThemeButton(
                    text: "Continue",
                    onPressed: _onContinueClick,
                  ),
                  const SpacerVertical(),
                  Align(
                    alignment: Alignment.center,
                    child: TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        widget.onReferral(null);
                      },
                      child: Text(
                        "Skip and continue",
                        style: stylePTSansBold().copyWith(
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
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
