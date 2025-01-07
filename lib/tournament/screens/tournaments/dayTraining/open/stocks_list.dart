import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/tournament/provider/search.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/theme.dart';
import '../../../../../tradingSimulator/modals/trading_search_res.dart';
import '../../../../../widgets/cache_network_image.dart';
import '../../../../provider/trades.dart';

class OpenTopStock extends StatefulWidget {
  final Function(TradingSearchTickerRes?) onTap;
  final String? selectedStockSymbol;

  const OpenTopStock({
    super.key,
    required this.onTap,
    this.selectedStockSymbol,
  });

  @override
  State<OpenTopStock> createState() => _OpenTopStockState();
}

class _OpenTopStockState extends State<OpenTopStock>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    TournamentSearchProvider searchProvider =
        context.read<TournamentSearchProvider>();
    _tabController = TabController(
      length: searchProvider.topSearch?.length ?? 0,
      vsync: this,
    );
    _initializeTabController();
  }

  void _initializeTabController() {
    TournamentTradesProvider provider =
        context.read<TournamentTradesProvider>();
    TournamentSearchProvider searchProvider =
        context.read<TournamentSearchProvider>();

    if (provider.selectedStock?.symbol != null) {
      final index = searchProvider.topSearch?.indexWhere(
        (ticker) => ticker.symbol == provider.selectedStock?.symbol,
      );
      if (index != null &&
          index >= 0 &&
          index < (_tabController?.length ?? 0)) {
        selectedIndex = index;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _tabController?.animateTo(selectedIndex);
        });
      }
      setState(() {});
    }
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  void onChange(index) {
    selectedIndex = index;
    setState(() {});
    TournamentSearchProvider searchProvider =
        context.read<TournamentSearchProvider>();

    TradingSearchTickerRes? data = searchProvider.topSearch?[index];
    TournamentTradesProvider provider =
        context.read<TournamentTradesProvider>();

    provider.setSelectedStock(stock: data);
  }

  @override
  Widget build(BuildContext context) {
    // TournamentProvider provider = context.watch<TournamentProvider>();
    TournamentSearchProvider searchProvider =
        context.watch<TournamentSearchProvider>();

    return Container(
      margin: EdgeInsets.only(top: 15),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 60),
            child: TabBar(
              controller: _tabController,
              isScrollable: true,
              labelPadding: EdgeInsets.only(left: 10),
              indicatorColor: Colors.transparent,
              onTap: onChange,
              tabs: List.generate(
                searchProvider.topSearch?.length ?? 0,
                (index) {
                  TradingSearchTickerRes? data =
                      searchProvider.topSearch?[index];
                  return Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color.fromARGB(255, 64, 64, 64),
                      border: selectedIndex == index
                          ? Border.all(
                              color: ThemeColors.accent,
                              width: 2,
                            )
                          : null,
                    ),
                    child: CachedNetworkImagesWidget(
                      data?.image ?? '',
                      height: 38,
                      width: 38,
                    ),
                  );
                },
              ),
            ),
          ),
          Container(
            height: 60,
            width: 60,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color.fromARGB(255, 37, 37, 37),
              boxShadow: [
                BoxShadow(
                  color: const Color.fromARGB(255, 0, 16, 3),
                  offset: Offset(4, 0),
                  blurRadius: 10,
                  spreadRadius: 15,
                ),
              ],
            ),
            child: Text(
              'All',
              style: styleGeorgiaBold(),
            ),
          ),
        ],
      ),
    );
  }
}
