import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/providers/home_provider.dart';
import 'package:stocks_news_new/providers/leaderboard.dart';
import 'package:stocks_news_new/providers/user_provider.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/widgets/custom/update_membership.dart';

class MembershipCoinsOption extends StatefulWidget {
  const MembershipCoinsOption({super.key});

  @override
  State<MembershipCoinsOption> createState() => _MembershipCoinsOptionState();
}

class _MembershipCoinsOptionState extends State<MembershipCoinsOption> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkForUserPoints();
    });
  }

  void _checkForUserPoints() {
    UserProvider provider = context.read<UserProvider>();
    if (provider.user?.membership?.purchased == 1) {
      LeaderBoardProvider leaderProvider = context.read<LeaderBoardProvider>();
      leaderProvider.getReferData();
    }
  }

  @override
  Widget build(BuildContext context) {
    HomeProvider provider = context.watch<HomeProvider>();
    UserProvider userProvider = context.watch<UserProvider>();
    LeaderBoardProvider leaderProvider = context.watch<LeaderBoardProvider>();

    return Visibility(
      visible: showMembership && provider.homeSliderRes != null,
      child: userProvider.user?.membership?.purchased != 1
          ? Container(
              margin: const EdgeInsets.fromLTRB(
                Dimen.padding,
                Dimen.homeSpacing,
                Dimen.padding,
                0,
              ),
              child: const UpdateMembershipCard(),
            )
          : leaderProvider.extra?.balance == null
              ? const SizedBox()
              : (leaderProvider.extra?.balance ?? 0) < 10
                  ? Container(
                      margin: const EdgeInsets.fromLTRB(
                        Dimen.padding,
                        Dimen.homeSpacing,
                        Dimen.padding,
                        0,
                      ),
                      child: const UpdateStoreCard(),
                    )
                  : const SizedBox(),
    );
  }
}
