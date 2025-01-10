import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/api/api_response.dart';
import 'package:stocks_news_new/tournament/provider/trades.dart';
import 'package:stocks_news_new/widgets/base_ui_container.dart';
import 'package:stocks_news_new/widgets/custom/refresh_indicator.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

import '../../../utils/colors.dart';
import '../../../utils/theme.dart';
import '../../../widgets/theme_button.dart';
import 'slidable.dart';
import 'trade_item.dart';

class TournamentAllTradeIndex extends StatefulWidget {
  const TournamentAllTradeIndex({super.key});

  @override
  State<TournamentAllTradeIndex> createState() =>
      _TournamentAllTradeIndexState();
}

class _TournamentAllTradeIndexState extends State<TournamentAllTradeIndex> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TournamentTradesProvider>().getTradesList(refresh: true);
    });
  }

  _close({
    cancleAll = false,
    int? id,
    String? ticker,
  }) async {
    TournamentTradesProvider provider =
        context.read<TournamentTradesProvider>();

    ApiResponse response = await provider.tradeCancle(
      cancleAll: cancleAll,
      tradeId: id,
      ticker: ticker,
    );
    if (response.status) {
      context.read<TournamentTradesProvider>().getTradesList(refresh: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    TournamentTradesProvider provider =
        context.watch<TournamentTradesProvider>();

    return BaseUiContainer(
      hasData: provider.myTrades != null,
      isLoading: provider.isLoadingTrades && provider.myTrades == null,
      error: provider.errorTrades,
      showPreparingText: true,
      onRefresh: () => provider.getTradesList(refresh: true),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Wrap(
              direction: Axis.horizontal,
              spacing: 10.0,
              runSpacing: 10.0,
              children: List.generate(
                provider.myTrades?.overview?.length ?? 0,
                (index) {
                  return GestureDetector(
                    onTap: () => provider.setSelectedOverview(
                      provider.myTrades?.overview?[index],
                      showProgress: true,
                    ),
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 6),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: ThemeColors.greyBorder.withOpacity(0.5),
                          border: provider.selectedOverview?.key ==
                                  provider.myTrades?.overview?[index].key
                              ? Border.all(color: ThemeColors.white)
                              : null),
                      child: Text(
                        '${provider.myTrades?.overview?[index].key} ${provider.myTrades?.overview?[index].value}',
                        style: styleGeorgiaBold(),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          Expanded(
            child: CommonRefreshIndicator(
              onRefresh: () async {
                provider.getTradesList();
              },
              child: ListView.separated(
                padding: EdgeInsets.only(top: 10),
                itemBuilder: (context, index) {
                  return provider.myTrades?.data?[index].status == 0
                      ? TournamentCloseSlidableMenu(
                          close: () => _close(
                            id: provider.myTrades?.data?[index].id,
                            ticker: provider.myTrades?.data?[index].symbol,
                          ),
                          index: index,
                          child: TournamentTradeItem(
                            data: provider.myTrades?.data?[index],
                          ),
                        )
                      : TournamentTradeItem(
                          data: provider.myTrades?.data?[index],
                        );
                },
                separatorBuilder: (context, index) {
                  return SpacerVertical(height: 10);
                },
                itemCount: provider.myTrades?.data?.length ?? 0,
              ),
            ),
          ),
          Visibility(
            visible: provider.myTrades?.overview?[1].value != 0,
            child: ThemeButton(
              radius: 10,
              text: 'Close All',
              onPressed: () => _close(cancleAll: true),
              color: ThemeColors.white,
              textColor: Colors.black,
            ),
          ),
          SpacerVertical(height: 10),
        ],
      ),
    );
  }
}
