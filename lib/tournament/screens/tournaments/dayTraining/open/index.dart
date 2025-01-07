import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/api/api_response.dart';
import 'package:stocks_news_new/tournament/provider/tournament.dart';
import 'package:stocks_news_new/tournament/provider/search.dart';
import 'package:stocks_news_new/providers/user_provider.dart';
import 'package:stocks_news_new/routes/my_app.dart';
import 'package:stocks_news_new/screens/tabs/home/widgets/app_bar_home.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/base_container.dart';
import 'package:stocks_news_new/widgets/base_ui_container.dart';
import 'package:stocks_news_new/widgets/custom/alert_popup.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import 'package:stocks_news_new/widgets/theme_button.dart';
import '../../../../../tradingSimulator/modals/trading_search_res.dart';
import '../../../../provider/trades.dart';
import '../../../myTrades/all_index.dart';
import 'stocks_list.dart';

class TournamentOpenIndex extends StatefulWidget {
  const TournamentOpenIndex({super.key});

  @override
  State<TournamentOpenIndex> createState() => _TournamentOpenIndexState();
}

class _TournamentOpenIndexState extends State<TournamentOpenIndex>
    with SingleTickerProviderStateMixin {
  // TradingSearchTickerRes? selectedStock;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      TournamentSearchProvider searchProvider =
          context.read<TournamentSearchProvider>();
      searchProvider.getSearchDefaults();
      if (searchProvider.topSearch != null &&
          searchProvider.topSearch?.isNotEmpty == true) {
        // _initializeTabController(searchProvider.topSearch);
      }
    });
  }

  _navigateToAllTrades() async {
    final stock = await Navigator.push(
      navigatorKey.currentContext!,
      MaterialPageRoute(
        builder: (context) => AllTradesOrdersIndex(),
      ),
    );

    if (stock != null) {
      TournamentTradesProvider provider =
          context.read<TournamentTradesProvider>();
      provider.setSelectedStock(stock: stock);
    }
  }

  // _add({StockType type = StockType.bull}) {
  //   if (selectedStock == null) {
  //     popUpAlert(title: 'Alert', message: 'Please select a ticker');
  //     return;
  //   }

  //   TradesProvider provider =
  //       navigatorKey.currentContext!.read<TradesProvider>();
  //   TradingSearchTickerRes? finalStock = TradingSearchTickerRes(
  //     symbol: selectedStock?.symbol ?? '',
  //     name: selectedStock?.name ?? '',
  //     image: selectedStock?.image ?? '',
  //     change: selectedStock?.change ?? 0,
  //     type: type,
  //     isOpen: true,
  //   );
  //   selectedStock?.isOpen = true;
  //   setState(() {});

  //   provider.addInTrade(finalStock);
  // }

  _trade({StockType type = StockType.buy}) async {
    TournamentTradesProvider provider =
        context.read<TournamentTradesProvider>();
    if (provider.selectedStock == null) {
      popUpAlert(title: 'Alert', message: 'Please select a ticker');
      return;
    }
    TournamentProvider tournamentProvider = context.read<TournamentProvider>();

    UserProvider userProvider = context.read<UserProvider>();

    // if (type == StockType.buy) {
    //   request['trade_type'] = 'buy';
    // } else {
    //   request['trade_type'] = 'sell';
    // }

    ApiResponse res = await provider.tradeBuySell(type: type);
    if (res.status) {}
  }

  _close() {
    TournamentTradesProvider provider =
        navigatorKey.currentContext!.read<TournamentTradesProvider>();

    // provider.tradeCancle();
  }

  _onChange(TradingSearchTickerRes? stock) {
    // TournamentTradesProvider provider = context.read<TournamentTradesProvider>();

    // TradingSearchTickerRes? existingStock = provider.data.firstWhere(
    //   (element) => element.symbol == stock?.symbol,
    //   orElse: () => TradingSearchTickerRes(
    //     symbol: "",
    //     name: "",
    //     image: "",
    //     change: 0,
    //     isOpen: false,
    //   ),
    // );

    // if (existingStock.isOpen == true) {
    //   provider.setSelectedStock(existingStock);
    // } else {
    //   provider.setSelectedStock(stock);
    // }

    // setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    TournamentTradesProvider provider =
        context.watch<TournamentTradesProvider>();
    TournamentSearchProvider searchProvider =
        context.watch<TournamentSearchProvider>();

    return BaseContainer(
      appBar: AppBarHome(
        isPopBack: true,
        title: 'My Position',
      ),
      body: BaseUiContainer(
        hasData: searchProvider.topSearch != null &&
            searchProvider.topSearch?.isNotEmpty == true,
        isLoading: searchProvider.isLoading,
        showPreparingText: true,
        child: Theme(
          data: lightTheme.copyWith(
            tabBarTheme: TabBarTheme(
              overlayColor: WidgetStateProperty.resolveWith<Color?>(
                (states) {
                  return Colors.transparent;
                },
              ),
              splashFactory: InkRipple.splashFactory,
            ),
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            splashFactory: NoSplash.splashFactory,
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              Dimen.padding,
              Dimen.padding,
              Dimen.padding,
              0,
            ),
            child: Column(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    GestureDetector(
                      onTap: _navigateToAllTrades,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Container(
                          decoration: BoxDecoration(
                            color: ThemeColors.greyText,
                          ),
                          child: Icon(
                            Icons.keyboard_double_arrow_down_rounded,
                          ),
                        ),
                      ),
                    ),
                    OpenTopStock(
                      selectedStockSymbol: provider.selectedStock?.symbol ?? '',
                      onTap: _onChange,
                    ),
                  ],
                ),
                Expanded(
                  child: BaseUiContainer(
                    hasData: provider.detail != null,
                    isLoading: provider.isLoading,
                    error: provider.error,
                    showPreparingText: true,
                    child: Column(
                      children: [
                        Expanded(child: SizedBox()),
                        if (provider.detail?.showButton?.alreadyTraded == false)
                          Row(
                            children: [
                              Expanded(
                                child: ThemeButton(
                                  radius: 10,
                                  text: 'Sell',
                                  onPressed: () => _trade(type: StockType.sell),
                                  color: ThemeColors.sos,
                                ),
                              ),
                              SpacerHorizontal(width: 10),
                              Expanded(
                                child: ThemeButton(
                                  radius: 10,
                                  text: 'Buy',
                                  onPressed: _trade,
                                ),
                              ),
                            ],
                          ),
                        if (provider.detail?.showButton?.alreadyTraded == true)
                          ThemeButton(
                            radius: 10,
                            text: 'Close',
                            onPressed: _close,
                            color: ThemeColors.white,
                            textColor: Colors.black,
                          ),
                        SpacerVertical(height: 10),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
