import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/managers/referral/points_claim_manager.dart';
import 'package:stocks_news_new/ui/base/app_bar.dart';
import 'package:stocks_news_new/ui/base/load_more.dart';
import 'package:stocks_news_new/ui/base/scaffold.dart';
import 'package:stocks_news_new/ui/tabs/more/referral/pointsTransaction/transaction_item.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/widgets/custom/base_loader_container.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

class PointsClaimLogs extends StatefulWidget {
  static const String path = "PointsClaimLogs";

  const PointsClaimLogs({
    super.key,
    required this.title,
    this.type,
    this.id,
  });

  final dynamic id;
  final String? type;
  final String? title;

  @override
  State<PointsClaimLogs> createState() => _PointsClaimLogsState();
}

class _PointsClaimLogsState extends State<PointsClaimLogs> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _callAPI();
    });
  }

  Future _callAPI({loadMore = false}) async {
    PointsClaimManager manager = context.read<PointsClaimManager>();
    await manager.getData(loadMore: loadMore, type: widget.type, id: widget.id);
  }

  @override
  Widget build(BuildContext context) {
    PointsClaimManager manager = context.watch<PointsClaimManager>();
    return BaseScaffold(
      appBar: BaseAppBar(
        showBack: true,
        title: widget.title ?? "Points Transactions",
        showNotification: true,
        showSearch: true,
      ),
      body: BaseLoaderContainer(
        isLoading: manager.isLoading,
        hasData: manager.data != null && !manager.isLoading,
        showPreparingText: true,
        error: manager.error,
        onRefresh: _callAPI,
        child: BaseLoadMore(
          onLoadMore: () => _callAPI(loadMore: true),
          onRefresh: _callAPI,
          canLoadMore: manager.canLoadMore,
          child: (manager.data == null || manager.data?.data == null)
              ? const SizedBox()
              : ListView.separated(
                  shrinkWrap: true,
                  padding: EdgeInsets.all(Dimen.padding),
                  itemBuilder: (context, index) {
                    return ReferPointTransactionItem(
                      data: manager.data!.data![index],
                    );
                  },
                  separatorBuilder: (context, index) {
                    return SpacerVertical(height: Dimen.padding);
                  },
                  itemCount: manager.data!.data?.length ?? 0,
                ),
        ),
      ),
    );
  }
}
