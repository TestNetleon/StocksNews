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
    return const BaseContainer(
      appBar: AppBarHome(
        isPopback: true,
        showTrailing: false,
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(
          Dimen.padding,
          Dimen.padding,
          Dimen.padding,
          0,
        ),
        child: CustomTabContainerNEW(
          tabsPadding: EdgeInsets.only(bottom: 10),
          scrollable: false,
          tabs: ['Refer and Earn', 'Leaderboard'],
          widgets: [
            AffiliateReferFriend(),
            AffiliateLeaderBoard(),
          ],
        ),
      ),
    );
  }
}
