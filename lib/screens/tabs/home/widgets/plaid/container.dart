import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/providers/home_provider.dart';
import 'package:stocks_news_new/screens/tabs/home/widgets/plaid/widgets/get_started.dart';
import 'package:stocks_news_new/screens/tabs/home/widgets/plaid/widgets/overview.dart';

class PlaidHomeContainer extends StatelessWidget {
  const PlaidHomeContainer({super.key});

  @override
  Widget build(BuildContext context) {
    HomeProvider provider = context.watch<HomeProvider>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //LIVE
        if (provider.homePortfolio?.top != null &&
            provider.homePortfolio?.bottom == null)
          const Padding(
            padding: EdgeInsets.only(bottom: 0),
            child: PlaidHomeGetStarted(),
          ),

        //LOCAL
        //  const Padding(
        //     padding: EdgeInsets.only(bottom: 15),
        //     child: PlaidHomeGetStarted(),
        //   ),

        if (provider.homePortfolio?.bottom != null)
          const PlaidHomeInvestmentOverview(),
      ],
    );
  }
}
