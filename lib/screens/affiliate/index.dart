import 'package:flutter/material.dart';
import 'package:stocks_news_new/screens/affiliate/leaderboard/leaderboard.dart';
import 'package:stocks_news_new/screens/tabs/home/widgets/app_bar_home.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/widgets/base_container.dart';
import 'package:stocks_news_new/widgets/custom_tab_container.dart';

import 'referFriend/refer_friend.dart';

class ReferAFriend extends StatelessWidget {
  static const path = "ReferAFriend";
  const ReferAFriend({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseContainer(
      appBar: const AppBarHome(
        isPopback: true,
        showTrailing: false,
      ),
      body: CustomTabContainer(
        padding: const EdgeInsets.symmetric(horizontal: Dimen.padding),
        tabs: [
          Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: const Text("Refer a friend")),
          Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: const Text("Leaderboard")),
        ],
        widgets: const [
          AffiliateReferFriend(),
          Padding(
            padding: EdgeInsets.fromLTRB(
              Dimen.padding,
              Dimen.padding,
              Dimen.padding,
              0,
            ),
            child: AffiliateLeaderBoard(),
          ),
        ],
      ),
    );
  }
}
