import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/screens/affiliate/leaderboard/widgets/item.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/widgets/base_ui_container.dart';
import 'package:stocks_news_new/widgets/custom/refresh_indicator.dart';

import '../../../modals/affiliate/refer_friend_res.dart';
import '../../../providers/leaderboard.dart';

class AffiliateLeaderBoard extends StatefulWidget {
  const AffiliateLeaderBoard({super.key});

  @override
  State<AffiliateLeaderBoard> createState() => _AffiliateLeaderBoardState();
}

class _AffiliateLeaderBoardState extends State<AffiliateLeaderBoard> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _callAPI();
    });
  }

  _callAPI() {
    LeaderBoardProvider provider = context.read<LeaderBoardProvider>();
    if (provider.leaderBoard == null || provider.leaderBoard?.isEmpty == true) {
      context.read<LeaderBoardProvider>().getLeaderBoardData();
    }
  }

  @override
  Widget build(BuildContext context) {
    LeaderBoardProvider provider = context.watch<LeaderBoardProvider>();

    return BaseUiContainer(
      hasData: !provider.isLoadingL &&
          (provider.leaderBoard?.isNotEmpty == true &&
              provider.leaderBoard != null),
      isLoading: provider.isLoadingL,
      error: provider.errorL,
      showPreparingText: true,
      isFull: true,
      child: CommonRefreshIndicator(
        onRefresh: () async {
          provider.getLeaderBoardData();
        },
        child: ListView.separated(
          padding: const EdgeInsets.symmetric(vertical: 10),
          itemBuilder: (context, listIndex) {
            AffiliateReferRes? data = provider.leaderBoard?[listIndex];

            return AffiliateLeaderBoardItem(
              index: listIndex,
              data: data,
            );
          },
          separatorBuilder: (context, index) {
            return const Divider(
              color: ThemeColors.greyBorder,
              height: 16,
            );
          },
          itemCount: provider.leaderBoard?.length ?? 0,
        ),
      ),
    );
  }
}
