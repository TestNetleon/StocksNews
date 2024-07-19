import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/modals/user_res.dart';
import 'package:stocks_news_new/providers/user_provider.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';

import '../../utils/theme.dart';

class CountryPickerWidget extends StatelessWidget {
  final Function(CountryCode value) onChanged;
  final bool enabled;
  final Color textColor;
  const CountryPickerWidget({
    super.key,
    required this.onChanged,
    this.enabled = true,
    this.textColor = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    UserRes? user = context.read<UserProvider>().user;
    String? locale;
    if (user?.phoneCode != null && user?.phoneCode != "") {
      locale = CountryCode.fromDialCode(user!.phoneCode!).code?.split('_').last;
    } else if (geoCountryCode != null && geoCountryCode != "") {
      locale = geoCountryCode;
    } else {
      locale = "US";
    }

    return CountryCodePicker(
      padding: EdgeInsets.zero,
      onChanged: onChanged,
      initialSelection: locale,
      showCountryOnly: false,
      enabled: enabled,
      closeIcon: const Icon(
        Icons.close_sharp,
        color: Colors.black,
      ),
      flagWidth: 24,
      showOnlyCountryWhenClosed: false,
      alignLeft: false,
      boxDecoration: BoxDecoration(
        color: ThemeColors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      dialogTextStyle: styleGeorgiaBold(color: Colors.black),
      textStyle: styleGeorgiaRegular(color: textColor),
      searchStyle: styleGeorgiaRegular(color: Colors.black),
      barrierColor: Colors.black26,
      searchDecoration: InputDecoration(
        iconColor: Colors.black,
        fillColor: ThemeColors.divider,
        contentPadding: EdgeInsets.zero,
        prefixIcon: const Icon(
          Icons.search,
          size: 22,
          color: Colors.black,
        ),
        filled: true,
        hintStyle: stylePTSansRegular(color: Colors.grey),
        hintText: "Search country",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4.0),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4.0),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4.0),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
