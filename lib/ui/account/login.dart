import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:stocks_news_new/ui/base/scaffold.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/utils/utils.dart';
import 'package:stocks_news_new/utils/validations.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import '../base/button.dart';
import '../base/country_code.dart';
import '../base/text_field.dart';
import 'verify.dart';

class AccountLoginIndex extends StatefulWidget {
  static const path = 'AccountLoginIndex';
  const AccountLoginIndex({super.key});

  @override
  State<AccountLoginIndex> createState() => _AccountLoginIndexState();
}

class _AccountLoginIndexState extends State<AccountLoginIndex> {
  final TextEditingController _phone = TextEditingController();
  String? countryCode;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _setCountryCode();
    });
  }

  _setCountryCode() {
    countryCode = CountryCode.fromCountryCode("US").dialCode;
    setState(() {});
  }

  _verification() {
    if (isEmpty(_phone.text)) {
    } else {
      if (kDebugMode) {
        Navigator.pushNamed(context, AccountVerificationIndex.path, arguments: {
          'phone': _phone.text,
          'countryCode': countryCode,
          'verificationId': '1',
        });
        return;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: Pad.pad16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.close,
                  color: ThemeColors.black,
                  size: 30,
                ),
              ),
            ),
            Image.asset(
              Images.mainBlackLogo,
            ),
            SpacerVertical(height: 48),
            Text(
              'Welcome!',
              style: styleBaseBold(fontSize: 32),
            ),
            SpacerVertical(height: 8),
            Text(
              'Please enter your phone number to continue.',
              style: styleBaseBold(fontSize: 18),
            ),
            SpacerVertical(height: 40),
            Row(
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
                  child: BaseCountryCode(
                    onChanged: (CountryCode value) {
                      countryCode = value.dialCode;
                      setState(() {});
                    },
                  ),
                ),
                Expanded(
                  child: BaseTextField(
                    placeholder: 'Phone number',
                    controller: _phone,
                    keyboardType: TextInputType.phone,
                  ),
                ),
              ],
            ),
            SpacerVertical(height: 40),
            BaseButton(
              radius: 8,
              onPressed: _verification,
              color: ThemeColors.primary100,
              textColor: ThemeColors.black,
              text: 'Continue',
            ),
          ],
        ),
      ),
    );
  }
}
