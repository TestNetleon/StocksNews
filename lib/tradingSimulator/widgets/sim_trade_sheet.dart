import 'package:flutter/material.dart';
import 'package:stocks_news_new/routes/my_app.dart';

import '../TradingWithTypes/trad_order_screen.dart';
import '../modals/trading_search_res.dart';

simTradeSheet({
  String? symbol,
  dynamic qty,
  TradingSearchTickerRes? data,
  int? tickerID,
}) {
  showModalBottomSheet(
    // useSafeArea: true,
    enableDrag: true,
    // backgroundColor: Colors.transparent,
    isDismissible: true,
    context: navigatorKey.currentContext!,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(10),
        topRight: Radius.circular(10),
      ),
    ),
    isScrollControlled: true,
    builder: (context) {
      return TradOrderScreen(
        symbol: symbol,
        data: data,
        qty: qty,
          tickerID:tickerID
      );
    },
  );
}

// class SimTradeOption extends StatefulWidget {
//   final String? symbol;
//   final bool doPop;

//   const SimTradeOption({super.key, this.symbol, this.doPop = true});

//   @override
//   State<SimTradeOption> createState() => _SimTradeOptionState();
// }

// class _SimTradeOptionState extends State<SimTradeOption> {
//   bool disposeSheet = true;
//   List<dynamic> listOfORders = [];

//   @override
//   void dispose() {
//     super.dispose();
//   }

//   @override
//   void initState() {
//     super.initState();
//     listOfORders.add({
//       "title": "Recurring investments",
//       "description": 'Invest in ${widget.symbol} on a recurring schedule.'
//     });
//     listOfORders.add({
//       "title": "Limit order",
//       "description": 'Buy ${widget.symbol} at a maximum price or lower.'
//     });
//     listOfORders.add({
//       "title": "Trailing stop order",
//       "description":
//           'If ${widget.symbol} rises above its lowest price by a specific amount, trigger a market buy.'
//     });
//     listOfORders.add({
//       "title": "Stop order",
//       "description":
//           'If ${widget.symbol} rises to a fixed stop price, trigger a market buy.'
//     });
//     listOfORders.add({
//       "title": "Stop limit order",
//       "description":
//           'If ${widget.symbol} rises to a fixed stop price, trigger a limit buy.'
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       //constraints: BoxConstraints(maxHeight: ScreenUtil().screenHeight - 30),

//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.only(
//           topLeft: Radius.circular(10.sp),
//           topRight: Radius.circular(10.sp),
//         ),
//         gradient: const LinearGradient(
//           begin: Alignment.topCenter,
//           end: Alignment.bottomCenter,
//           colors: [ThemeColors.bottomsheetGradient, Colors.black],
//         ),
//         color: ThemeColors.background,
//         border: const Border(
//           top: BorderSide(color: ThemeColors.greyBorder),
//         ),
//       ),
//       padding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 "Buy orders",
//                 style: stylePTSansBold(fontSize: 18),
//               ),
//               SizedBox(
//                 width: 30,
//                 height: 30,
//                 child: IconButton(
//                     onPressed: () {
//                       Navigator.pop(context);
//                     },
//                     icon: Icon(Icons.clear, color: ThemeColors.white)),
//               )
//             ],
//           ),
//           SpacerVertical(height: 5),
//           ListTile(
//             contentPadding: EdgeInsets.zero,
//             minTileHeight: 60,
//             leading: Container(
//                 padding: EdgeInsets.all(5),
//                 decoration: BoxDecoration(
//                   color: ThemeColors.gradientLight,
//                   shape: BoxShape.circle,
//                 ),
//                 child: Icon(Icons.auto_graph, color: ThemeColors.white)),
//             title: Text(
//               "Short",
//               style: styleGeorgiaRegular(),
//             ),
//             subtitle: Text(
//               "Short ${widget.symbol} at a maximum price or lower.",
//               style: styleGeorgiaRegular(
//                   fontSize: 12, color: ThemeColors.greyText),
//             ),
//             trailing: Icon(
//               Icons.arrow_forward_ios_sharp,
//               color: ThemeColors.greyText,
//               size: 20,
//             ),
//             onTap: () {
//               //context.read<TradeProviderNew>().shortStatus(true);
//             },
//           ),
//           SpacerVertical(height: 15),
//           Text(
//             "Conditional orders",
//             style: stylePTSansBold(fontSize: 18),
//           ),
//           SpacerVertical(height: 5),
//           Expanded(
//             child: ListView.separated(
//               itemCount: listOfORders.length,
//               //physics: const NeverScrollableScrollPhysics(),
//               shrinkWrap: true,
//               itemBuilder: (context, index) {
//                 //TradingSearchTickerRes data = provider.topSearch![index];
//                 return ListTile(
//                   contentPadding: EdgeInsets.zero,
//                   minTileHeight: 60,
//                   leading: Container(
//                       padding: EdgeInsets.all(5),
//                       decoration: BoxDecoration(
//                         color: ThemeColors.gradientLight,
//                         shape: BoxShape.circle,
//                       ),
//                       child:
//                           /* "data.imageType" == "svg"
//                         ? SvgPicture.network(
//                       fit: BoxFit.cover,
//                      "",
//                       placeholderBuilder: (BuildContext context) =>
//                           Container(
//                             padding: const EdgeInsets.all(30.0),
//                             child: const CircularProgressIndicator(
//                               color: ThemeColors.accent,
//                             ),
//                           ),
//                     )
//                         : CachedNetworkImagesWidget(
//                       width: 26,
//                       height: 26,
//                       "data.userImage",
//                     ),*/
//                           Icon(Icons.auto_graph, color: ThemeColors.white)),
//                   title: Text(
//                     listOfORders[index]['title'] ?? "",
//                     style: styleGeorgiaRegular(),
//                   ),
//                   subtitle: Text(
//                     listOfORders[index]['description'] ?? "",
//                     style: styleGeorgiaRegular(
//                         fontSize: 12, color: ThemeColors.greyText),
//                   ),
//                   trailing: Icon(
//                     Icons.arrow_forward_ios_sharp,
//                     color: ThemeColors.greyText,
//                     size: 20,
//                   ),
//                 );
//               },
//               separatorBuilder: (BuildContext context, int index) {
//                 return const Divider(
//                   color: ThemeColors.greyText,
//                   thickness: 0.7,
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
