import 'package:flutter/cupertino.dart';
import 'package:stocks_news_new/utils/constants.dart';
import '../widgets/get_started.dart';

class PortfolioUserNotLoggedIn extends StatelessWidget {
  const PortfolioUserNotLoggedIn({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(
              Dimen.padding, Dimen.padding, Dimen.padding, Dimen.padding),
          child: Column(
            children: [
              // Text(
              //   textAlign: TextAlign.center,
              //   "Connect your account",
              //   style: stylePTSansRegular(fontSize: 18),
              // ),
              // const SpacerVertical(height: 30),
              // ThemeButtonSmall(
              //   onPressed: onTap,
              //   text: "Log in",
              //   showArrow: false,
              //   // fullWidth: false,
              // ),
              PlaidHomeGetStarted(fromDrawer: true),
            ],
          ),
        ),
      ),
    );
  }
}
