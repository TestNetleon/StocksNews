import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/modals/affiliate/transaction.dart';
import 'package:stocks_news_new/providers/leaderboard.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/widgets/base_ui_container.dart';
import 'package:stocks_news_new/widgets/refresh_controll.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

import '../pointsTransaction/trasnsaction.dart';

class SeparatePointsContainer extends StatelessWidget {
  final String type;

  const SeparatePointsContainer({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    LeaderBoardProvider provider = context.watch<LeaderBoardProvider>();
    return BaseUiContainer(
      error: provider.errorDetail,
      hasData: provider.dataDetail != null &&
          provider.dataDetail?.isNotEmpty == true,
      isLoading: provider.isLoadingDetail,
      showPreparingText: true,
      onRefresh: () => provider.getData(type: type),
      child: RefreshControl(
        onRefresh: () async => await provider.getData(type: type),
        canLoadMore: provider.canLoadMore,
        onLoadMore: () async => provider.getData(loadMore: true, type: type),
        child: ListView.separated(
          padding: EdgeInsets.fromLTRB(
              Dimen.padding, 0, Dimen.padding, Dimen.padding),
          itemBuilder: (context, index) {
            AffiliateTransactionRes? data = provider.dataDetail?[index];
            return AffiliateTranItem(
              data: data,
            );
          },
          separatorBuilder: (context, index) {
            return SpacerVertical(height: 10);
          },
          itemCount: provider.dataDetail?.length ?? 0,
        ),
      ),
    );
  }
}
