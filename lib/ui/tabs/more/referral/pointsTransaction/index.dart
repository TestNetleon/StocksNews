import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/managers/referral/referral_points_manager.dart';
import 'package:stocks_news_new/ui/base/app_bar.dart';
import 'package:stocks_news_new/ui/base/load_more.dart';
import 'package:stocks_news_new/ui/base/scaffold.dart';
import 'package:stocks_news_new/ui/tabs/more/referral/pointsTransaction/transaction_item.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/widgets/custom/base_loader_container.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

class ReferPointsTransaction extends StatefulWidget {
  static const String path = "ReferPointsTransaction";
  const ReferPointsTransaction({
    super.key,
    required this.type,
    required this.title,
  });
  final String? type;
  final String? title;

  @override
  State<ReferPointsTransaction> createState() => _ReferPointsTransactionState();
}

class _ReferPointsTransactionState extends State<ReferPointsTransaction> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _callAPI();
    });
  }

  Future _callAPI({loadMore = false}) async {
    ReferralPointsManager manager = context.read<ReferralPointsManager>();
    await manager.getData(loadMore: loadMore, type: widget.type);
  }

  @override
  Widget build(BuildContext context) {
    ReferralPointsManager manager = context.watch<ReferralPointsManager>();
    return BaseScaffold(
      appBar: BaseAppBar(
        showBack: true,
        title: widget.title ?? "Points Transactions",
        showActionNotification: true,
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
