import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/arena/provider/arena.dart';
import 'package:stocks_news_new/routes/my_app.dart';
import 'package:stocks_news_new/screens/tabs/home/widgets/app_bar_home.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/widgets/base_container.dart';
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

class _TournamentOpenIndexState extends State<TournamentOpenIndex> {
  ArenaStockRes? selectedStock;
  bool setScroll = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ArenaProvider provider = context.read<ArenaProvider>();
      TradesProvider tradesProvider = context.read<TradesProvider>();
      tradesProvider.clearTrades();
      if (provider.topSearch != null &&
          provider.topSearch?.isNotEmpty == true) {
        selectedStock = ArenaStockRes(
          symbol: provider.topSearch?[0].symbol ?? '',
          company: provider.topSearch?[0].name ?? '',
          image: provider.topSearch?[0].image ?? '',
          change: provider.topSearch?[0].changesPercentage ?? 0,
        );
        setState(() {});
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
      setState(() {
        selectedStock = stock;
        setScroll = !setScroll;
      });
    }
  }

  _add({StockType type = StockType.bull}) {
    if (selectedStock == null) {
      popUpAlert(title: 'Alert', message: 'Please select a ticker');
      return;
    }

    TradesProvider provider =
        navigatorKey.currentContext!.read<TradesProvider>();
    ArenaStockRes? finalStock = ArenaStockRes(
      symbol: selectedStock?.symbol ?? '',
      company: selectedStock?.company ?? '',
      image: selectedStock?.image ?? '',
      change: selectedStock?.change ?? 0,
      type: type,
      isOpen: true,
    );
    selectedStock?.isOpen = true;
    setState(() {});

    provider.addInTrade(finalStock);
  }

  _close() {
    if (selectedStock == null) {
      popUpAlert(title: 'Alert', message: 'Please select a ticker');
      return;
    }
    selectedStock?.isOpen = false;
    setState(() {});

    TradesProvider provider =
        navigatorKey.currentContext!.read<TradesProvider>();
    provider.closeStock(selectedStock!);
  }

  _onChange(TradingSearchTickerRes? stock) {
    TradesProvider tradesProvider = context.read<TradesProvider>();

    ArenaStockRes? existingStock = tradesProvider.data.firstWhere(
      (element) => element.symbol == stock?.symbol,
      orElse: () => ArenaStockRes(
        symbol: "",
        company: "",
        image: "",
        change: 0,
        isOpen: false,
      ),
    );

    if (existingStock.isOpen) {
      selectedStock = ArenaStockRes(
        symbol: existingStock.symbol,
        company: existingStock.company,
        image: existingStock.image,
        change: existingStock.change,
        isOpen: true,
      );
    } else {
      selectedStock = ArenaStockRes(
        symbol: stock?.symbol ?? "",
        company: stock?.name ?? "",
        image: stock?.image ?? "",
        change: stock?.changesPercentage ?? 0,
        isOpen: false,
      );
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return BaseContainer(
      appBar: AppBarHome(
        isPopBack: true,
        title: 'My Position',
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(
          Dimen.padding,
          Dimen.padding,
          Dimen.padding,
          0,
        ),
        child: Column(
          children: [
            Expanded(
              child: Column(
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
                    key: ValueKey(setScroll),
                    selectedStockSymbol: selectedStock?.symbol ?? '',
                    onTap: _onChange,
                  ),
                ],
              ),
            ),
            if (selectedStock?.isOpen == false)
              Row(
                children: [
                  Expanded(
                    child: ThemeButton(
                      radius: 10,
                      text: 'Sell',
                      onPressed: () => _add(type: StockType.bear),
                      color: ThemeColors.sos,
                    ),
                  ),
                  SpacerHorizontal(width: 10),
                  Expanded(
                    child: ThemeButton(
                      radius: 10,
                      text: 'Buy',
                      onPressed: _add,
                    ),
                  ),
                ],
              ),
            if (selectedStock?.isOpen == true)
              if (selectedStock?.isOpen == true)
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
    );
  }
}
