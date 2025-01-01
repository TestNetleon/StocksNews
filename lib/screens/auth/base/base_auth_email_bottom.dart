import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/providers/home_provider.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/utils/utils.dart';
import 'package:stocks_news_new/widgets/custom/alert_popup.dart';
import 'package:stocks_news_new/widgets/screen_title.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import 'package:stocks_news_new/widgets/theme_button.dart';
import 'package:stocks_news_new/widgets/theme_input_field.dart';
import 'package:validators/validators.dart';
import '../../../providers/user_provider.dart';
import '../../../utils/constants.dart';

class BaseAuthEmail extends StatefulWidget {
  const BaseAuthEmail({super.key});

  @override
  State<BaseAuthEmail> createState() => _BaseAuthEmailState();
}

class _BaseAuthEmailState extends State<BaseAuthEmail> {
  TextEditingController email = TextEditingController();
  @override
  void initState() {
    super.initState();
    Utils().showLog('BASE AUTH INIT...');
    WidgetsBinding.instance.addPostFrameCallback((_) {});
    closeKeyboard();
  }

  @override
  void dispose() {
    email.dispose();
    super.dispose();
  }

  Future _verify() async {
    closeKeyboard();
    UserProvider provider = context.read<UserProvider>();

    if (!isEmail(email.text)) {
      popUpAlert(
          message: "Please enter valid email address.",
          title: "Alert",
          icon: Images.alertPopGIF);
      return;
    }
    Map request = {
      "token": provider.user?.token ?? "",
      "email": email.text.toLowerCase(),
    };

    try {
      await provider.emailUpdateOtp(request,
          resendButtonClick: false, email: email.text);
    } catch (e) {
      //
    }
  }

  @override
  Widget build(BuildContext context) {
    HomeProvider provider = context.watch<HomeProvider>();

    if (provider.extra?.updateYourEmail == null) {
      return SizedBox();
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(8),
          topRight: Radius.circular(8),
        ),
        border: Border(top: BorderSide(color: ThemeColors.greyBorder)),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: const [
            ThemeColors.bottomsheetGradient,
            ThemeColors.background,
          ],
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ScreenTitle(
              title: provider.extra?.updateYourEmail?.title,
              subTitle: provider.extra?.updateYourEmail?.text,
              subTitleHtml: true,
              dividerPadding: EdgeInsets.only(bottom: 15),
            ),
            Container(
              decoration: BoxDecoration(
                color: ThemeColors.white,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Row(
                children: [
                  Flexible(
                    child: Stack(
                      alignment: Alignment.centerRight,
                      children: [
                        ThemeInputField(
                          style: stylePTSansRegular(
                            color: Colors.black,
                            fontSize: 18,
                          ),
                          borderRadiusOnly: BorderRadius.circular(4),
                          controller: email,
                          onChanged: (p0) {
                            email.text = p0;
                            setState(() {});
                          },
                          placeholder: "Enter your email address",
                          keyboardType: TextInputType.emailAddress,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(50),
                          ],
                          textCapitalization: TextCapitalization.none,
                        ),
                        Visibility(
                          visible: email.text != '',
                          child: Positioned(
                            right: 10,
                            child: InkWell(
                              onTap: () {
                                email.clear();
                                closeKeyboard();
                                setState(() {});
                              },
                              child: Icon(
                                Icons.close,
                                color: ThemeColors.background,
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
            SpacerVertical(height: 15),
            _button(
              text: provider.extra?.updateYourEmail?.updateButton ??
                  'Update my email address',
              onTap: _verify,
              color: const Color.fromARGB(255, 194, 216, 51),
              textColor: ThemeColors.background,
            ),
            SpacerVertical(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _button({
    required String text,
    required void Function()? onTap,
    Color? color = ThemeColors.accent,
    Color textColor = Colors.white,
  }) {
    return ThemeButton(
      radius: 30,
      // showArrow: false,
      fontBold: true,
      onPressed: onTap,
      text: text,
      color: color,
      textColor: textColor,
    );
  }
}
