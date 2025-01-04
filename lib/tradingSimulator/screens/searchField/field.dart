// import 'dart:async';

// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:stocks_news_new/providers/user_provider.dart';
// import 'package:stocks_news_new/tradingSimulator/providers/trade_provider.dart';
// import 'package:stocks_news_new/tradingSimulator/providers/trading_search_provider.dart';
// import 'package:stocks_news_new/tradingSimulator/screens/tradeBuySell/index.dart';
// import 'package:stocks_news_new/utils/colors.dart';

// import '../../../api/api_response.dart';
// import '../../../modals/search_res.dart';
// import '../../../providers/stock_detail_new.dart';
// import '../../../routes/my_app.dart';
// import '../../../utils/constants.dart';
// import '../../../utils/theme.dart';
// import '../../../utils/utils.dart';
// import '../../../widgets/cache_network_image.dart';
// import '../../../widgets/spacer_horizontal.dart';
// import '../dashboard/tradeSheet.dart';
// import '../trade/sheet.dart';

// class SdTradeSearchField extends StatefulWidget {
//   final bool buy;
//   const SdTradeSearchField({super.key, this.buy = true});

//   @override
//   State<SdTradeSearchField> createState() => _SdTradeSearchFieldState();
// }

// class _SdTradeSearchFieldState extends State<SdTradeSearchField> {
//   final FocusNode searchFocusNode = FocusNode();
//   TextEditingController controller = TextEditingController();

//   Timer? _timer;
//   @override
//   void dispose() {
//     _timer?.cancel();
//     super.dispose();
//   }

//   void _searchApiCall(String text) {
//     if (text.isEmpty) {
//       context.read<TradingSearchProvider>().clearSearch();
//     } else {
//       Map request = {
//         "term": text,
//         "token": context.read<UserProvider>().user?.token ?? ""
//       };
//       context.read<TradingSearchProvider>().searchSymbols(request);
//     }
//   }

//   // Future _onTap({String? symbol}) async {
//   //   try {
//   //     StockDetailProviderNew provider =
//   //         navigatorKey.currentContext!.read<StockDetailProviderNew>();

//   //     ApiResponse response = await provider.getTabData(
//   //       symbol: symbol,
//   //       showProgress: true,
//   //       startSSE: true,
//   //     );
//   //     if (response.status) {
//   //       SummaryOrderNew order = await Navigator.pushReplacement(
//   //         navigatorKey.currentContext!,
//   //         MaterialPageRoute(
//   //           builder: (context) => TradeBuySellIndex(buy: widget.buy),
//   //         ),
//   //       );
//   //       TradeProviderNew provider =
//   //           navigatorKey.currentContext!.read<TradeProviderNew>();

//   //       widget.buy
//   //           ? provider.addOrderData(order)
//   //           : provider.sellOrderData(order);
//   //       await _showSheet(order, widget.buy);
//   //     } else {}
//   //   } catch (e) {
//   //     //
//   //   }
//   // }

//   Future _onTap({String? symbol}) async {
//     tradeSheet(symbol: symbol);
//     // try {
//     //   TradingSearchProvider provider = context.read<TradingSearchProvider>();
//     //   if (symbol != null && symbol != '') {
//     //     provider.stockHolding(symbol);
//     //   }
//     // } catch (e) {
//     //   //
//     // }
//   }

//   Future _showSheet(SummaryOrderNew? order, bool buy) async {
//     await showModalBottomSheet(
//       useSafeArea: true,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.only(
//           topLeft: Radius.circular(5),
//           topRight: Radius.circular(5),
//         ),
//       ),
//       backgroundColor: ThemeColors.transparent,
//       isScrollControlled: false,
//       context: navigatorKey.currentContext!,
//       builder: (context) {
//         return SuccessTradeSheet(
//           order: order,
//           buy: buy,
//           close: true,
//         );
//       },
//     );
//   }

//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       // TradingSearchProvider provider = context.read<TradingSearchProvider>();
//       // provider.clearSearch();
//     });
//     // searchFocusNode.requestFocus();
//   }

//   @override
//   Widget build(BuildContext context) {
//     TradeProviderNew provider = context.watch<TradeProviderNew>();
//     var outlineInputBorder = OutlineInputBorder(
//       borderRadius: BorderRadius.circular(Dimen.radius),
//       borderSide: const BorderSide(
//         color: ThemeColors.primaryLight,
//         width: 1,
//       ),
//     );
//     return Column(
//       children: [
//         Stack(
//           children: [
//             TextField(
//               cursorColor: ThemeColors.white,
//               focusNode: searchFocusNode,
//               autocorrect: false,
//               controller: controller,
//               textCapitalization: TextCapitalization.sentences,
//               style: stylePTSansBold(fontSize: 14),
//               decoration: InputDecoration(
//                 hintText: "Search",
//                 hintStyle: stylePTSansRegular(
//                   fontSize: 14,
//                   color: ThemeColors.greyText,
//                 ),
//                 contentPadding: const EdgeInsets.fromLTRB(
//                   10,
//                   10,
//                   12,
//                   10,
//                 ),
//                 filled: true,
//                 fillColor: ThemeColors.primaryLight,
//                 enabledBorder: outlineInputBorder,
//                 border: outlineInputBorder,
//                 focusedBorder: outlineInputBorder,
//                 counterText: '',
//                 prefixIcon: const Icon(
//                   Icons.search,
//                   size: 22,
//                   color: ThemeColors.greyText,
//                 ),
//               ),
//               onChanged: (value) {
//                 if (_timer != null) {
//                   _timer!.cancel();
//                 }
//                 _timer = Timer(
//                   const Duration(milliseconds: 1000),
//                   () {
//                     _searchApiCall(value);
//                   },
//                 );
//               },
//             ),
//             Positioned(
//               right: 10,
//               top: 10,
//               child: Visibility(
//                 visible: provider.isLoadingS,
//                 child: const SizedBox(
//                   width: 20,
//                   height: 20,
//                   child: CircularProgressIndicator(
//                     strokeWidth: 3,
//                     color: Colors.white,
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//         Visibility(
//           visible: provider.dataNew != null,
//           child: Container(
//               padding: const EdgeInsets.all(Dimen.padding),
//               margin: const EdgeInsets.only(top: 5),
//               decoration: const BoxDecoration(
//                 color: ThemeColors.primaryLight,
//                 borderRadius: BorderRadius.only(
//                   bottomLeft: Radius.circular(Dimen.radius),
//                   bottomRight: Radius.circular(Dimen.radius),
//                 ),
//               ),
//               child:
//                   //  provider.dataNew != null
//                   //     ?

//                   Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Visibility(
//                     visible: provider.dataNew?.symbols?.isNotEmpty == true,
//                     child: Padding(
//                       padding: const EdgeInsets.only(bottom: 10),
//                       child: Text(
//                         "Symbols",
//                         style: stylePTSansBold(color: ThemeColors.accent),
//                       ),
//                     ),
//                   ),
//                   Visibility(
//                     visible: provider.dataNew?.symbols?.isNotEmpty == true,
//                     child: ListView.separated(
//                       shrinkWrap: true,
//                       physics: const NeverScrollableScrollPhysics(),
//                       itemBuilder: (BuildContext context, int index) {
//                         SearchRes? data = provider.dataNew?.symbols?[index];
//                         return InkWell(
//                           onTap: () {
//                             closeKeyboard();
//                             provider.clearSearch();
//                             _onTap(symbol: data?.symbol);
//                           },
//                           child: Padding(
//                             padding: const EdgeInsets.symmetric(vertical: 6),
//                             child: Row(
//                               children: [
//                                 Container(
//                                     width: 43,
//                                     height: 43,
//                                     padding: const EdgeInsets.all(5),
//                                     child:
//                                         CachedNetworkImagesWidget(data?.image)),
//                                 const SpacerHorizontal(width: 6),
//                                 Expanded(
//                                   child: Column(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     children: [
//                                       Text(
//                                         data?.symbol ?? '',
//                                         style: stylePTSansRegular(fontSize: 14),
//                                       ),
//                                       Text(
//                                         data?.name ?? '',
//                                         style: stylePTSansRegular(
//                                             fontSize: 12,
//                                             color: ThemeColors.greyText),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         );
//                       },
//                       separatorBuilder: (BuildContext context, int index) {
//                         return const Divider(color: ThemeColors.dividerDark);
//                       },
//                       itemCount: provider.dataNew?.symbols?.length ?? 0,
//                     ),
//                   ),
//                 ],
//               )
//               // : SizedBox(
//               //     width: double.infinity,
//               //     child: Text(
//               //       "${provider.errorS}",
//               //       textAlign: TextAlign.center,
//               //       style: stylePTSansRegular(),
//               //     ),
//               //   ),
//               ),
//         ),
//       ],
//     );
//   }
// }
