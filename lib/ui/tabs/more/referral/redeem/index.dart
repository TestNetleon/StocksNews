import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/managers/referral/redeem_manager.dart';
import 'package:stocks_news_new/ui/base/app_bar.dart';
import 'package:stocks_news_new/ui/base/base_list_divider.dart';
import 'package:stocks_news_new/ui/base/base_scroll.dart';
import 'package:stocks_news_new/ui/base/scaffold.dart';
import 'package:stocks_news_new/ui/tabs/more/referral/leaderboard/leaderboard_item.dart';
import 'package:stocks_news_new/ui/tabs/more/referral/leaderboard/upper_rank_item.dart';
import 'package:stocks_news_new/ui/tabs/more/referral/pointsTransaction/index.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/custom/base_loader_container.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

class RedeemPoints extends StatefulWidget {
  static const String path = "RedeemPoints";
  const RedeemPoints({super.key});

  @override
  State<RedeemPoints> createState() => _RedeemPointsState();
}

class _RedeemPointsState extends State<RedeemPoints> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _callAPI();
    });
  }

  Future _callAPI() async {
    RedeemManager manager = context.read<RedeemManager>();
    manager.getData();
  }

  @override
  Widget build(BuildContext context) {
    RedeemManager manager = context.watch<RedeemManager>();
    return BaseScaffold(
      appBar: BaseAppBar(
        showBack: true,
        title: "Redeem Points",
        showActionNotification: true,
        showSearch: true,
      ),
      body: BaseLoaderContainer(
        hasData: manager.data != null,
        isLoading: manager.isLoading,
        error: manager.error,
        showPreparingText: true,
        child: BaseScroll(
          margin: EdgeInsets.zero,
          onRefresh: _callAPI,
          children: (manager.data?.data != null)
              ? [
                  SpacerVertical(height: Pad.pad20),
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(horizontal: Pad.pad16),
                  //   child: Column(
                  //     crossAxisAlignment: CrossAxisAlignment.start,
                  //     children: [
                  //       LayoutBuilder(
                  //         builder: (context, constraints) {
                  //           return Row(
                  //             crossAxisAlignment: CrossAxisAlignment.start,
                  //             children: [
                  //               UpperRankItem(
                  //                 index: 1,
                  //                 data: manager.data!.data![1],
                  //                 constraints: constraints,
                  //               ),
                  //               const SpacerHorizontal(width: 12),
                  //               UpperRankItem(
                  //                 index: 0,
                  //                 data: manager.data!.data![0],
                  //                 constraints: constraints,
                  //               ),
                  //               const SpacerHorizontal(width: 12),
                  //               UpperRankItem(
                  //                 index: 2,
                  //                 data: manager.data!.data![2],
                  //                 constraints: constraints,
                  //               ),
                  //             ],
                  //           );
                  //         },
                  //       ),
                  //       SpacerVertical(height: Pad.pad20),
                  //       Text(
                  //         "Ranking & Points",
                  //         style: styleBaseBold(fontSize: 24),
                  //       ),
                  //       SpacerVertical(height: Pad.pad5),
                  //     ],
                  //   ),
                  // ),
                  // ListView.separated(
                  //   shrinkWrap: true,
                  //   physics: NeverScrollableScrollPhysics(),
                  //   itemBuilder: (context, index) {
                  //     return LeaderboardItem(
                  //       data: manager.data!.data![index + 2],
                  //       index: index + 2,
                  //     );
                  //   },
                  //   separatorBuilder: (context, index) {
                  //     return BaseListDivider();
                  //   },
                  //   itemCount: ((manager.data!.data?.length ?? 0) > 3)
                  //       ? (((manager.data!.data?.length) ?? 0) - 3)
                  //       : 0,
                  // ),
                  // SpacerVertical(height: Pad.pad24),
                ]
              : [SizedBox()],
        ),
      ),
    );
  }
}
