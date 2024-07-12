import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/modals/stockDetailRes/morningstar_purchase_res.dart';
import 'package:stocks_news_new/providers/morningstar_txn_provider.dart';

import 'package:stocks_news_new/screens/morningstarTranscations/morningstar_txn_item.dart';
import 'package:stocks_news_new/widgets/base_ui_container.dart';
import 'package:stocks_news_new/widgets/disclaimer_widget.dart';
import 'package:stocks_news_new/widgets/helpdesk_error.dart';
import 'package:stocks_news_new/widgets/refresh_controll.dart';
import 'package:stocks_news_new/widgets/screen_title.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

import '../../../utils/constants.dart';

class MorningStarTxnList extends StatefulWidget {
  const MorningStarTxnList({super.key});

  @override
  State<MorningStarTxnList> createState() => _MorningStarTxnListState();
}

class _MorningStarTxnListState extends State<MorningStarTxnList> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      MorningstarTxnProvider provider = context.read<MorningstarTxnProvider>();
      if (provider.data != null) {
        return;
      }
      provider.getData();
    });
  }

  @override
  Widget build(BuildContext context) {
    MorningstarTxnProvider provider = context.watch<MorningstarTxnProvider>();
    List<MorningStarPurchase>? data = provider.data;

    return Padding(
      padding: const EdgeInsets.only(
          left: Dimen.padding, right: Dimen.padding, bottom: 40),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ScreenTitle(
            title: provider.extra?.title.toString(),
            subTitle: provider.extra?.subTitle.toString(),
          ),
          Expanded(
            child: CommonEmptyError(
              hasData: data == null || data.isEmpty == true,
              isLoading: provider.isLoading,
              title: "Morningstar Reports",
              subTitle: provider.error,
              onClick: () async {
                provider.onRefresh();
              },
              child: BaseUiContainer(
                error: provider.error,
                hasData: data != null && data.isNotEmpty,
                isLoading: provider.isLoading,
                errorDispCommon: true,
                showPreparingText: true,
                onRefresh: () => provider.getData(),
                child: RefreshControl(
                  onRefresh: () async => provider.getData(),
                  canLoadMore: false, // provider.canLoadMore,
                  onLoadMore: () async => provider.getData(),
                  child: ListView.separated(
                    // padding: const EdgeInsets.only(top: Dimen.padding),
                    itemBuilder: (context, index) {
                      if (data == null || data.isEmpty) {
                        return const SizedBox();
                      }
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          MorningStarTxnItem(data: data[index]),
                          if (index == data.length - 1)
                            DisclaimerWidget(data: provider.extra!.disclaimer!)
                        ],
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return const SpacerVertical(height: 12);
                    },
                    itemCount: data?.length ?? 0,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
