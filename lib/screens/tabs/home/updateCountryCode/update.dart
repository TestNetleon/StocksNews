import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/screens/myAccount/my_account.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';

import '../../../../providers/home_provider.dart';

class HomeUpdateCountryCode extends StatelessWidget {
  const HomeUpdateCountryCode({super.key});

  @override
  Widget build(BuildContext context) {
    HomeProvider provider = context.watch<HomeProvider>();

    return GestureDetector(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => MyAccount()));
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(color: ThemeColors.sos),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Text(
                provider.extra?.phoneCodeError ??
                    'Please update your country code',
                style: stylePTSansRegular(),
              ),
            ),
            SpacerHorizontal(width: 5),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                  color: ThemeColors.background,
                  borderRadius: BorderRadius.circular(4)),
              child: Text(
                "Update",
                style: stylePTSansRegular(color: ThemeColors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
