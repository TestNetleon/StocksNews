import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/routes/my_app.dart';
import 'package:stocks_news_new/screens/tabs/home/widgets/app_bar_home.dart';
import 'package:stocks_news_new/tournament/provider/trades.dart';
import 'package:stocks_news_new/tradingSimulator/TradingWithTypes/widgets/buy_order_item.dart';
import 'package:stocks_news_new/tradingSimulator/manager/sse.dart';
import 'package:stocks_news_new/tradingSimulator/modals/trading_search_res.dart';
import 'package:stocks_news_new/tradingSimulator/providers/trade_provider.dart';
import 'package:stocks_news_new/tradingSimulator/providers/trading_search_provider.dart';
import 'package:stocks_news_new/tradingSimulator/screens/searchTradingTicker/index.dart';
import 'package:stocks_news_new/tradingSimulator/screens/tradeBuySell/index.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/utils/utils.dart';
import 'package:stocks_news_new/widgets/base_container.dart';
import 'package:stocks_news_new/widgets/cache_network_image.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

class TradOrderScreen extends StatefulWidget {
  final String? symbol;
  final bool doPop;
  final dynamic qty;
  final TradingSearchTickerRes? data;
  const TradOrderScreen({super.key, this.symbol, required this.doPop, this.data, this.qty});

  @override
  State<TradOrderScreen> createState() => _TradOrderScreenState();
}

class _TradOrderScreenState extends State<TradOrderScreen> {
  bool disposeSheet = true;
  List<dynamic> listOfORders=[];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    listOfORders.add({"title":"Recurring investments","description":'Invest in ${widget.symbol} on a recurring schedule.'});
    listOfORders.add({"title":"Limit order","description":'Buy ${widget.symbol} at a maximum price or lower.'});
    listOfORders.add({"title":"Trailing stop order","description":'If ${widget.symbol} rises above its lowest price by a specific amount, trigger a market buy.'});
    listOfORders.add({"title":"Stop order","description":'If ${widget.symbol} rises to a fixed stop price, trigger a market buy.'});
    listOfORders.add({"title":"Stop limit order","description":'If ${widget.symbol} rises to a fixed stop price, trigger a limit buy.'});

  }


  Future _onTap({String? symbol,StockType? selectedStock}) async {
    disposeSheet = false;
    setState(() {});
    try {
      TradingSearchProvider provider = navigatorKey.currentContext!.read<TradingSearchProvider>();
      if (symbol != null && symbol != '') {
        provider.stockHolding(symbol, selectedStock: selectedStock);
      }
    } catch (e) {
      //
    }
  }

  @override
  void dispose() {
    if (disposeSheet) {
      Utils().showLog('Disposing tradeSheet');
      SSEManager.instance.disconnectScreen(SimulatorEnum.detail);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TradeProviderNew provider = context.watch<TradeProviderNew>();
    StockDataManagerRes? stock = provider.tappedStock;
    return BaseContainer(
        appBar: AppBarHome(
          isPopBack: true,
          icon:  Icons.close,
          canSearch: false,
          showTrailing: false,
        ),
        body: Padding(
          padding: EdgeInsets.fromLTRB(Dimen.padding, Dimen.paddingTablet, Dimen.padding, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            /*  SizedBox(
                width:30,
                height:30,
                child: IconButton(
                    onPressed: (){
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.clear,color: ThemeColors.white,size: 24)
                ),
              ),
              SpacerVertical(height:14),*/
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 224, 225, 227),
                        shape: BoxShape.circle,
                      ),
                      width:50,
                      height:50,
                      child:
                      CachedNetworkImagesWidget(widget.data?.image ?? ""),
                    ),
                  ),
                  const SpacerHorizontal(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${widget.data?.symbol}',
                          style: styleGeorgiaBold(
                              color: ThemeColors.white, fontSize:18),
                        ),
                        Text(
                          '${widget.data?.name}',
                          style: styleGeorgiaRegular(
                              color: ThemeColors.white, fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                  const SpacerHorizontal(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Visibility(
                        visible: stock?.price != null,
                        child: Text(
                          '${stock?.price?.toFormattedPrice()}',
                          style: styleGeorgiaBold(
                              color: ThemeColors.white, fontSize: 22),
                        ),
                      ),
                      Visibility(
                        visible: stock?.change != null &&
                            stock?.changePercentage != null,
                        child: Text(
                          '${stock?.change?.toFormattedPrice()} (${stock?.changePercentage?.toCurrency()}%)',
                          style: styleGeorgiaRegular(
                            color: (stock?.change ?? 0) >= 0
                                ? ThemeColors.accent
                                : ThemeColors.sos,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SpacerVertical(height:10),
              Divider(
                color: ThemeColors.white,
                height: 20,
              ),
              SpacerVertical(height:5),
              Text(
                "Buy orders",
                style: stylePTSansBold(fontSize:18),
              ),
              SpacerVertical(height:5),
              BuyOrderItem(title: "Buy Order",subtitle: "Buy ${widget.symbol} at a maximum price or lower.",onTap: (){
                var selectedStock = StockType.buy;
                if (widget.symbol != null) {
                  _onTap(symbol: widget.symbol, selectedStock: selectedStock);
                } else {
                  Navigator.push(
                    context,
                    createRoute(SearchTradingTicker(selectedStock: selectedStock)),
                  );
                }
              }),
              BuyOrderItem(title: "Sell Order",subtitle: "Sell ${widget.symbol} at a maximum price or lower.",onTap: (){
                var selectedStock = StockType.sell;
                if (widget.symbol != null) {
                  _onTap(symbol: widget.symbol, selectedStock: selectedStock);
                } else {
                  Navigator.push(
                    context,
                    createRoute(SearchTradingTicker(selectedStock: selectedStock)),
                  );
                }
              }),
              BuyOrderItem(title: "Short Order",subtitle: "Short ${widget.symbol} at a maximum price or lower.",onTap: (){
                var selectedStock = StockType.short;
                if (widget.symbol != null) {
                  navigatorKey.currentContext!.read<TradingSearchProvider>().shortRedirection(widget.symbol??"");
                } else {
                  Navigator.push(
                    context,
                    createRoute(SearchTradingTicker(selectedStock: selectedStock)),
                  );
                }
              }),

              BuyOrderItem(title: "Buy To Cover Order",subtitle: "Buy To Cover ${widget.symbol} at a maximum price or lower.",onTap: (){
                var selectedStock = StockType.btc;
                if (widget.symbol != null) {
                  _onTap(symbol: widget.symbol, selectedStock: selectedStock);
                } else {
                  Navigator.push(
                    context,
                    createRoute(SearchTradingTicker(selectedStock: selectedStock)),
                  );
                }
              }),

              SpacerVertical(height:10),

              Text(
                "Conditional orders",
                style: stylePTSansBold(fontSize:18),
              ),
              SpacerVertical(height:5),
              Expanded(
                child: ListView.separated(
                  itemCount:listOfORders.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    //TradingSearchTickerRes data = provider.topSearch![index];
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      minTileHeight:60,
                      leading: Container(
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: ThemeColors.gradientLight,
                            shape: BoxShape.circle,
                          ),
                          child:
                          /* "data.imageType" == "svg"
                          ? SvgPicture.network(
                        fit: BoxFit.cover,
                       "",
                        placeholderBuilder: (BuildContext context) =>
                            Container(
                              padding: const EdgeInsets.all(30.0),
                              child: const CircularProgressIndicator(
                                color: ThemeColors.accent,
                              ),
                            ),
                      )
                          : CachedNetworkImagesWidget(
                        width: 26,
                        height: 26,
                        "data.userImage",
                      ),*/
                          Icon(Icons.auto_graph,color:  ThemeColors.white)
                      ),
                      title: Text(
                        listOfORders[index]['title']??"",
                        style: styleGeorgiaRegular(),
                      ),
                      subtitle: Text(
                        listOfORders[index]['description']??"",
                        style: styleGeorgiaRegular(fontSize:12,color: ThemeColors.greyText),
                      ),
                      trailing: Icon(
                        Icons.arrow_forward_ios_sharp,
                        color: ThemeColors.greyText,
                        size: 20,
                      ),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return const Divider(
                      color: ThemeColors.greyText,
                      thickness: 0.7,
                    );
                  },
                ),
              )
            ],
          ),
        )
    );
  }
}
