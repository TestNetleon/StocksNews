import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/utils/utils.dart';
import 'package:stocks_news_new/utils/validations.dart';
import 'package:stocks_news_new/widgets/custom/alert_popup.dart';
import 'package:stocks_news_new/widgets/custom/country_code_picker_widget.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import 'package:stocks_news_new/widgets/theme_button_small.dart';
import 'package:stocks_news_new/widgets/theme_input_field.dart';

import 'base_verify.dart';

class BaseAuth extends StatefulWidget {
  const BaseAuth({super.key});

  @override
  State<BaseAuth> createState() => _BaseAuthState();
}

class _BaseAuthState extends State<BaseAuth> {
  String? countryCode;
  TextEditingController phone = TextEditingController();

  @override
  void initState() {
    super.initState();
    Utils().showLog('BASE AUTH INIT...');
    closeKeyboard();
  }

  void _onChanged(CountryCode value) {
    countryCode = value.dialCode;
    Utils().showLog("COUNTRY CODE => $countryCode");
    setState(() {});
  }

  _gotoVerify() {
    closeKeyboard();
    if (isEmpty(phone.text)) {
      return popUpAlert(
        message: "Please enter a valid phone number.",
        title: "Alert",
        icon: Images.alertPopGIF,
      );
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BaseVerifyOTP(
          countryCode: countryCode ?? '+1',
          phone: phone.text,
        ),
      ),
    );
  }

  @override
  void dispose() {
    phone.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      color: ThemeColors.background,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
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
                        child: CountryPickerWidget(
                          onChanged: _onChanged,
                        ),
                      ),
                    ],
                  ),
                  Flexible(
                    child: Stack(
                      alignment: Alignment.centerRight,
                      children: [
                        ThemeInputField(
                          style: stylePTSansRegular(
                            color: Colors.black,
                            fontSize: 18,
                          ),
                          borderRadiusOnly: const BorderRadius.only(
                            topRight: Radius.circular(4),
                            bottomRight: Radius.circular(4),
                          ),
                          controller: phone,
                          placeholder: "Enter your phone number",
                          keyboardType: TextInputType.phone,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(15),
                          ],
                          textCapitalization: TextCapitalization.none,
                        ),
                        Positioned(
                          right: 10,
                          child: InkWell(
                            onTap: closeKeyboard,
                            child: Icon(
                              Icons.close,
                              color: ThemeColors.background,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SpacerVertical(height: 10),
          Row(
            children: [
              _button(
                  text: 'Log in',
                  onTap: _gotoVerify,
                  color: const Color.fromARGB(255, 194, 216, 51),
                  textColor: ThemeColors.background),
              SpacerHorizontal(width: 10),
              _button(
                text: 'Sign up',
                onTap: _gotoVerify,
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _button({
    required String text,
    required void Function() onTap,
    Color? color = ThemeColors.accent,
    Color textColor = Colors.white,
  }) {
    return Expanded(
      child: ThemeButtonSmall(
        radius: 30,
        showArrow: false,
        fontBold: true,
        onPressed: onTap,
        text: text,
        color: color,
        textColor: textColor,
      ),
    );
  }
}
