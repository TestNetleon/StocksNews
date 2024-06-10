import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/providers/plaid.dart';
import 'package:stocks_news_new/providers/user_provider.dart';
import 'package:stocks_news_new/route/my_app.dart';
import 'package:stocks_news_new/screens/auth/bottomSheets/login_sheet.dart';
import 'package:stocks_news_new/screens/auth/bottomSheets/login_sheet_tablet.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import 'package:stocks_news_new/widgets/theme_button_small.dart';

class PortfolioUserNotLoggedIn extends StatelessWidget {
  final Function() onTap;
  const PortfolioUserNotLoggedIn({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: [
              Text(
                textAlign: TextAlign.center,
                "Log in to continue using your portfolio account.",
                style: stylePTSansRegular(fontSize: 18),
              ),
              const SpacerVertical(height: 10),
              ThemeButtonSmall(
                onPressed: onTap,
                text: "Log in",
                showArrow: false,
                // fullWidth: false,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
