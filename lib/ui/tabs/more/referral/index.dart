import 'package:flutter/material.dart';
import 'package:stocks_news_new/models/stockDetail/overview.dart';
import 'package:stocks_news_new/ui/base/app_bar.dart';
import 'package:stocks_news_new/ui/base/common_tab.dart';
import 'package:stocks_news_new/ui/base/scaffold.dart';
import 'package:stocks_news_new/ui/tabs/more/referral/leaderboard/index.dart';
import 'package:stocks_news_new/ui/tabs/more/referral/referFriend/index.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

class ReferralIndex extends StatefulWidget {
  static const String path = "ReferralIndex";

  const ReferralIndex({super.key});

  @override
  State<ReferralIndex> createState() => _ReferralIndexState();
}

class _ReferralIndexState extends State<ReferralIndex> {
  dynamic tabs = [
    BaseKeyValueRes(title: "REFER A FRIEND"),
    BaseKeyValueRes(title: "LEADERBOARD"),
  ];
  int? _selectedScreen = 0;

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      appBar: BaseAppBar(
        showBack: true,
        title: tabs[_selectedScreen].title,
        showSearch: true,
        showActionNotification: true,
      ),
      body: Column(
        children: [
          BaseTabs(
            data: tabs,
            onTap: (index) {
              setState(() {
                _selectedScreen = index;
              });
            },
            isScrollable: false,
            showDivider: true,
          ),
          SpacerVertical(height: Pad.pad10),
          Expanded(
            child: _selectedScreen == 0 ? ReferAFriend() : LeaderBoard(),
          ),
        ],
      ),
    );
  }
}
