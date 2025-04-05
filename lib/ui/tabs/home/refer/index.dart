import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/ui/tabs/more/referral/index.dart';
import 'package:stocks_news_new/ui/theme/manager.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

class ReferAndEarnBox extends StatelessWidget {
  const ReferAndEarnBox({super.key});

  @override
  Widget build(BuildContext context) {
    bool isDark = context.watch<ThemeManager>().isDarkMode;
    return GestureDetector(
      onTap: () {
        // Navigator.pushNamed(navigatorKey.currentContext!, ReferralIndex.path);
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => ReferralIndex()));
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          gradient: RadialGradient(
            center: Alignment.bottomCenter,
            radius: 3,
            stops: [0.0, 0.2, 1.0],
            colors: isDark
                ? [
                    Color(0xFF149C0A),
                    Color(0xFF005D0C),
                    Color(0xFF042200),
                  ]
                : [
                    Color(0xFF3240D1),
                    Color(0xFF1F2A9B),
                    Color(0xFF0F155E),
                  ],
          ),
        ),
        child: Row(
          children: [
            Image.asset(
              Images.pointIcon2,
              height: 60,
              width: 60,
            ),
            const SpacerHorizontal(width: 10),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Refer and Earn',
                    style: styleBaseBold(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                  const SpacerVertical(height: 3),
                  AutoSizeText(
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    'Invite Your Friends and Earn Reward Points to UNLOCK Special Features and EARLY Alerts.',
                    style: styleBaseRegular(
                      fontSize: 14,
                      height: 1.4,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
