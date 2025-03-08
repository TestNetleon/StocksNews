import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/managers/referral/leader_board_manager.dart';
import 'package:stocks_news_new/ui/base/base_list_divider.dart';
import 'package:stocks_news_new/ui/base/base_scroll.dart';
import 'package:stocks_news_new/ui/tabs/more/referral/leaderboard/leaderboard_item.dart';
import 'package:stocks_news_new/ui/tabs/more/referral/leaderboard/upper_rank_item.dart';
import 'package:stocks_news_new/ui/tabs/more/referral/pointsTransaction/index.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/custom/base_loader_container.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

class LeaderBoard extends StatefulWidget {
  const LeaderBoard({super.key});

  @override
  State<LeaderBoard> createState() => _LeaderBoardState();
}

class _LeaderBoardState extends State<LeaderBoard> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _callAPI();
    });
  }

  Future _callAPI() async {
    LeaderBoardManager manager = context.read<LeaderBoardManager>();
    manager.getData();
  }

  void _navigateToTransactions() {
    Navigator.pushNamed(
      context,
      ReferPointsTransaction.path,
      arguments: {"type": "", "title": null},
    );
  }

  @override
  Widget build(BuildContext context) {
    LeaderBoardManager manager = context.watch<LeaderBoardManager>();
    return BaseLoaderContainer(
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
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: Pad.pad16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      LayoutBuilder(
                        builder: (context, constraints) {
                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              UpperRankItem(
                                index: 1,
                                data: manager.data!.data![1],
                                constraints: constraints,
                              ),
                              const SpacerHorizontal(width: 12),
                              UpperRankItem(
                                index: 0,
                                data: manager.data!.data![0],
                                constraints: constraints,
                              ),
                              const SpacerHorizontal(width: 12),
                              UpperRankItem(
                                index: 2,
                                data: manager.data!.data![2],
                                constraints: constraints,
                              ),
                            ],
                          );
                        },
                      ),
                      SpacerVertical(height: Pad.pad20),
                      Text(
                        "Ranking & Points",
                        style: styleBaseBold(fontSize: 24),
                      ),
                      SpacerVertical(height: Pad.pad5),
                    ],
                  ),
                ),
                ListView.separated(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return LeaderboardItem(
                      data: manager.data!.data![index + 2],
                      index: index + 2,
                    );
                  },
                  separatorBuilder: (context, index) {
                    return BaseListDivider();
                  },
                  itemCount: ((manager.data!.data?.length ?? 0) > 3)
                      ? (((manager.data!.data?.length) ?? 0) - 3)
                      : 0,
                ),
                SpacerVertical(height: Pad.pad24),
              ]
            : [SizedBox()],
      ),
    );
  }
}
