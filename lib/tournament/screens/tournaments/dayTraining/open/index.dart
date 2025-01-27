// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:stocks_news_new/api/api_response.dart';
// import 'package:stocks_news_new/tournament/provider/search.dart';
// import 'package:stocks_news_new/routes/my_app.dart';
// import 'package:stocks_news_new/screens/tabs/home/widgets/app_bar_home.dart';
// import 'package:stocks_news_new/tradingSimulator/manager/sse.dart';
// import 'package:stocks_news_new/utils/colors.dart';
// import 'package:stocks_news_new/utils/constants.dart';
// import 'package:stocks_news_new/utils/theme.dart';
// import 'package:stocks_news_new/utils/utils.dart';
// import 'package:stocks_news_new/widgets/base_container.dart';
// import 'package:stocks_news_new/widgets/base_ui_container.dart';
// import 'package:stocks_news_new/widgets/custom/alert_popup.dart';
// import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
// import 'package:stocks_news_new/widgets/spacer_vertical.dart';
// import 'package:stocks_news_new/widgets/theme_button.dart';
// import '../../../../../tradingSimulator/modals/trading_search_res.dart';
// import '../../../../provider/trades.dart';
// import '../../../myTrades/all_index.dart';
// import 'details.dart';
// import 'stocks_list.dart';

// class TournamentOpenIndex extends StatefulWidget {
//   const TournamentOpenIndex({super.key});

//   @override
//   State<TournamentOpenIndex> createState() => _TournamentOpenIndexState();
// }

// class _TournamentOpenIndexState extends State<TournamentOpenIndex>
//     with SingleTickerProviderStateMixin {
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       TournamentSearchProvider searchProvider =
//           context.read<TournamentSearchProvider>();
//       searchProvider.getSearchDefaults();
//       if (searchProvider.topSearch != null &&
//           searchProvider.topSearch?.isNotEmpty == true) {}
//     });
//   }

//   _navigateToAllTrades() async {
//     await Navigator.push(
//       navigatorKey.currentContext!,
//       createRoute(AllTradesOrdersIndex()),
//     );
//     SSEManager.instance.disconnectAllScreens();
//     TournamentTradesProvider provider =
//         context.read<TournamentTradesProvider>();
//     provider.setSelectedStock(
//       stock: provider.selectedStock,
//       clearEverything: true,
//     );
//   }

//   _trade({StockType type = StockType.buy}) async {
//     TournamentTradesProvider provider =
//         context.read<TournamentTradesProvider>();
//     if (provider.selectedStock == null) {
//       popUpAlert(title: 'Alert', message: 'Please select a ticker');
//       return;
//     }

//     ApiResponse res = await provider.tradeBuySell(type: type);
//     if (res.status) {}
//   }

//   _close() {
//     TournamentTradesProvider provider =
//         navigatorKey.currentContext!.read<TournamentTradesProvider>();

//     provider.tradeCancle();
//   }

//   _onChange(TradingSearchTickerRes? stock) {}

//   @override
//   void dispose() {
//     SSEManager.instance.disconnectAllScreens();

//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     TournamentTradesProvider provider =
//         context.watch<TournamentTradesProvider>();
//     TournamentSearchProvider searchProvider =
//         context.watch<TournamentSearchProvider>();
//     TournamentTickerHolder? detailHolder =
//         provider.detail[provider.selectedStock?.symbol];
//     Utils().showLog('STOCKLIST! INDEX');
//     return BaseContainer(
//       appBar: AppBarHome(
//         isPopBack: true,
//         title: 'My Position',
//       ),
//       body: BaseUiContainer(
//         hasData: searchProvider.topSearch != null &&
//             searchProvider.topSearch?.isNotEmpty == true,
//         isLoading: searchProvider.isLoading,
//         showPreparingText: true,
//         child: Theme(
//           data: lightTheme.copyWith(
//             tabBarTheme: TabBarTheme(
//               overlayColor: WidgetStateProperty.resolveWith<Color?>(
//                 (states) {
//                   return Colors.transparent;
//                 },
//               ),
//               splashFactory: InkRipple.splashFactory,
//             ),
//             highlightColor: Colors.transparent,
//             splashColor: Colors.transparent,
//             splashFactory: NoSplash.splashFactory,
//           ),
//           child: Padding(
//             padding: const EdgeInsets.fromLTRB(
//               Dimen.padding,
//               Dimen.padding,
//               Dimen.padding,
//               0,
//             ),
//             child: Column(
//               children: [
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.stretch,
//                   children: [
//                     GestureDetector(
//                       onTap: _navigateToAllTrades,
//                       child: Align(
//                         alignment: Alignment.centerRight,
//                         child: Container(
//                           decoration: BoxDecoration(
//                             color: ThemeColors.greyText,
//                           ),
//                           child: Icon(
//                             Icons.keyboard_double_arrow_down_rounded,
//                           ),
//                         ),
//                       ),
//                     ),
//                     OpenTopStock(),
//                   ],
//                 ),
//                 Expanded(
//                   child: BaseUiContainer(
//                     hasData: detailHolder?.data != null,
//                     isLoading: detailHolder?.loading == true,
//                     error: detailHolder?.error,
//                     showPreparingText: true,
//                     child: Column(
//                       children: [
//                         Expanded(
//                           child: SingleChildScrollView(
//                             child: TournamentOpenDetail(
//                               data: detailHolder?.data?.ticker,
//                             ),
//                           ),
//                         ),
//                         if (detailHolder?.data?.showButton?.alreadyTraded ==
//                             false)
//                           Row(
//                             children: [
//                               Expanded(
//                                 child: ThemeButton(
//                                   radius: 10,
//                                   text: 'Sell',
//                                   onPressed: () => _trade(type: StockType.sell),
//                                   color: ThemeColors.sos,
//                                 ),
//                               ),
//                               SpacerHorizontal(width: 10),
//                               Expanded(
//                                 child: ThemeButton(
//                                   radius: 10,
//                                   text: 'Buy',
//                                   onPressed: _trade,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         if (detailHolder?.data?.showButton?.alreadyTraded ==
//                             true)
//                           ThemeButton(
//                             radius: 10,
//                             text: 'Close',
//                             onPressed: _close,
//                             color: ThemeColors.white,
//                             textColor: Colors.black,
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 Text(
//                                   'Close',
//                                   style: styleGeorgiaBold(color: Colors.black),
//                                 ),
//                                 SpacerHorizontal(width: 10),
//                                 Flexible(
//                                   child: Container(
//                                     padding:
//                                         EdgeInsets.symmetric(horizontal: 15),
//                                     decoration: BoxDecoration(
//                                       borderRadius: BorderRadius.circular(20),
//                                       color: (detailHolder?.data?.showButton
//                                                       ?.orderChange ??
//                                                   0) >=
//                                               0
//                                           ? ThemeColors.accent
//                                           : ThemeColors.sos,
//                                     ),
//                                     child: Text(
//                                       '${detailHolder?.data?.showButton?.orderChange?.toCurrency()}%',
//                                       style:
//                                           styleGeorgiaBold(color: Colors.white),
//                                     ),
//                                   ),
//                                 )
//                               ],
//                             ),
//                           ),
//                         SpacerVertical(height: 10),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/api/api_response.dart';
import 'package:stocks_news_new/tournament/provider/search.dart';
import 'package:stocks_news_new/routes/my_app.dart';
import 'package:stocks_news_new/screens/tabs/home/widgets/app_bar_home.dart';
import 'package:stocks_news_new/tournament/screens/tournaments/dayTraining/widgets/tradiding_view_chart.dart';
import 'package:stocks_news_new/tradingSimulator/manager/sse.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/utils/utils.dart';
import 'package:stocks_news_new/widgets/base_container.dart';
import 'package:stocks_news_new/widgets/base_ui_container.dart';
import 'package:stocks_news_new/widgets/custom/alert_popup.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import 'package:stocks_news_new/widgets/theme_button.dart';
import '../../../../../tradingSimulator/modals/trading_search_res.dart';
import '../../../../provider/trades.dart';
import '../../../myTrades/all_index.dart';
import 'details.dart';
import 'stocks_list.dart';

class TournamentOpenIndex extends StatefulWidget {
  const TournamentOpenIndex({super.key});

  @override
  State<TournamentOpenIndex> createState() => _TournamentOpenIndexState();
}

class _TournamentOpenIndexState extends State<TournamentOpenIndex>
    with SingleTickerProviderStateMixin {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Ensure the getSearchDefaults is called only once when dependencies change.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      TournamentSearchProvider searchProvider =
          context.read<TournamentSearchProvider>();

      searchProvider.getSearchDefaults();
    });
  }

  _navigateToAllTrades() async {
    SSEManager.instance.disconnectAllScreens();

    await Navigator.push(
      navigatorKey.currentContext!,
      createRoute(AllTradesOrdersIndex(typeOfTrade: "open")),
    );

    TournamentTradesProvider provider =
        context.read<TournamentTradesProvider>();
    provider.setSelectedStock(
      stock: provider.selectedStock,
      clearEverything: true,
    );
  }

  _trade({StockType type = StockType.buy}) async {
    TournamentTradesProvider provider =
        context.read<TournamentTradesProvider>();
    if (provider.selectedStock == null) {
      popUpAlert(title: 'Alert', message: 'Please select a ticker');
      return;
    }

    ApiResponse res = await provider.tradeBuySell(type: type);
    if (res.status) {
      // Handle successful trade response
    }
  }

  _close() {
    TournamentTradesProvider provider =
        navigatorKey.currentContext!.read<TournamentTradesProvider>();

    provider.tradeCancle();
  }

  _onChange(TradingSearchTickerRes? stock) {}

  @override
  void dispose() {
    SSEManager.instance.disconnectAllScreens();
    Utils().showLog('OPEN DISPOSE');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Utils().showLog('INDEX!');
    return Consumer<TournamentSearchProvider>(
      builder: (context, searchProvider, child) {
        return BaseContainer(
          appBar: AppBarHome(
            isPopBack: true,
            title: 'Place New Trade',
            canSearch: false,
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
                        /* Align(
                          alignment: Alignment.centerRight,
                          child: TextButton.icon(
                            iconAlignment: IconAlignment.end,
                            onPressed: (){
                              _navigateToAllTrades();
                            },
                            label: Text(
                              'My Trades',
                              style: styleGeorgiaBold(),
                            ),
                            icon:Container(
                              decoration: BoxDecoration(
                                color: ThemeColors.greyText,
                              ),
                              child: Icon(
                                Icons.keyboard_double_arrow_down_rounded,
                                color: ThemeColors.white,
                              ),
                            ),
                          ),
                        ),
                        */
                        OpenTopStock(),
                      ],
                    ),
                    Expanded(
                      child: Consumer<TournamentTradesProvider>(
                        builder: (context, provider, child) {
                          TournamentTickerHolder? detailHolder =
                              provider.detail[provider.selectedStock?.symbol];

                          return BaseUiContainer(
                            hasData: detailHolder?.data != null,
                            isLoading: detailHolder?.loading == true,
                            error: detailHolder?.error,
                            showPreparingText: true,
                            child: Column(
                              children: [
                                SpacerVertical(height: 15),
                                SingleChildScrollView(
                                  child: TournamentOpenDetail(
                                    data: detailHolder?.data?.ticker,
                                  ),
                                ),
                                //  Expanded(child: TradingWebview(symbol: detailHolder?.data?.ticker?.symbol ?? "")),

                                Expanded(
                                    child: TradingViewChart(
                                        symbol: detailHolder
                                                ?.data?.ticker?.symbol ??
                                            "")),

                                if (detailHolder
                                        ?.data?.showButton?.alreadyTraded ==
                                    false)
                                  Row(
                                    children: [
                                      Expanded(
                                        child: ThemeButton(
                                          radius: 10,
                                          text: 'Sell',
                                          onPressed: () =>
                                              _trade(type: StockType.sell),
                                          color: ThemeColors.sos,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                'Sell',
                                                style: styleGeorgiaBold(),
                                              ),
                                              SpacerHorizontal(width: 10),
                                              Visibility(
                                                visible: detailHolder
                                                        ?.data
                                                        ?.ticker
                                                        ?.currentPrice !=
                                                    null,
                                                child: Flexible(
                                                  child: Text(
                                                    "${detailHolder?.data?.ticker?.currentPrice?.toFormattedPrice()}",
                                                    style: styleGeorgiaBold(
                                                        color: Colors.white),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      SpacerHorizontal(width: 10),
                                      Expanded(
                                        child: ThemeButton(
                                          radius: 10,
                                          text: 'Buy',
                                          onPressed: _trade,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                'Buy',
                                                style: styleGeorgiaBold(),
                                              ),
                                              SpacerHorizontal(width: 10),
                                              Visibility(
                                                visible: detailHolder
                                                        ?.data
                                                        ?.ticker
                                                        ?.currentPrice !=
                                                    null,
                                                child: Flexible(
                                                  child: Text(
                                                    "${detailHolder?.data?.ticker?.currentPrice?.toFormattedPrice()}",
                                                    style: styleGeorgiaBold(
                                                        color: Colors.white),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                if (detailHolder
                                        ?.data?.showButton?.alreadyTraded ==
                                    true)
                                  Row(
                                    children: [
                                      Expanded(
                                        child: ThemeButton(
                                          radius: 10,
                                          text: 'Open Trades',
                                          onPressed: () {
                                            _navigateToAllTrades();
                                          },
                                          color: ThemeColors.themeGreen,
                                        ),
                                      ),
                                      SpacerHorizontal(width: 10),
                                      Expanded(
                                        child: ThemeButton(
                                          radius: 10,
                                          text: 'Close',
                                          onPressed: _close,
                                          color: ThemeColors.white,
                                          textColor: Colors.black,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                'Close',
                                                style: styleGeorgiaBold(
                                                    color: Colors.black),
                                              ),
                                              SpacerHorizontal(width: 10),
                                              Flexible(
                                                child: Text(
                                                  '${detailHolder?.data?.showButton?.orderChange?.toCurrency()}%',
                                                  style: styleGeorgiaBold(
                                                    color: (detailHolder
                                                                    ?.data
                                                                    ?.showButton
                                                                    ?.orderChange ??
                                                                0) >
                                                            0
                                                        ? Colors.green
                                                        : detailHolder
                                                                    ?.data
                                                                    ?.showButton
                                                                    ?.orderChange ==
                                                                0
                                                            ? Colors.black
                                                            : Colors.red,
                                                  ),
                                                ),
                                                /*Container(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 15),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                    BorderRadius.circular(20),
                                                    color: (detailHolder
                                                        ?.data
                                                        ?.showButton
                                                        ?.orderChange ??
                                                        0) >=
                                                        0
                                                        ? ThemeColors.accent
                                                        : ThemeColors.sos,
                                                  ),
                                                  child: Text(
                                                    '${detailHolder?.data?.showButton?.orderChange?.toCurrency()}%',
                                                    style: styleGeorgiaBold(
                                                        color: Colors.black),
                                                  ),
                                                ),*/
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),

                                SpacerVertical(height: 10),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
