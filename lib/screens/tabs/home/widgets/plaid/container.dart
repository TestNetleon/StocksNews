import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:stocks_news_new/screens/tabs/home/widgets/plaid/widgets/get_started.dart';
import 'package:stocks_news_new/screens/tabs/home/widgets/plaid/widgets/overview.dart';
import 'package:stocks_news_new/utils/constants.dart';

class PlaidHomeContainer extends StatelessWidget {
  const PlaidHomeContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: Dimen.padding, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PlaidHomeGetStarted(),
          PlaidHomeInvestmentOverview(),
        ],
      ),
    );
  }
}
