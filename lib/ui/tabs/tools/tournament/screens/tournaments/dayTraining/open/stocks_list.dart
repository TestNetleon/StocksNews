import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/models/ticker.dart';
import 'package:stocks_news_new/ui/tabs/tools/tournament/provider/search.dart';
import 'package:stocks_news_new/ui/tabs/tools/tournament/provider/trades.dart';
import 'package:stocks_news_new/ui/tabs/tools/tournament/screens/tournaments/searchTradingTicker/index.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/utils.dart';
import 'package:stocks_news_new/widgets/cache_network_image.dart';


class OpenTopStock extends StatefulWidget {
  const OpenTopStock({
    super.key,
  });

  @override
  State<OpenTopStock> createState() => _OpenTopStockState();
}

class _OpenTopStockState extends State<OpenTopStock>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int selectedIndex = 0;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    Utils().showLog('Stock INIT');
    TournamentSearchProvider searchProvider =
        context.read<TournamentSearchProvider>();

    TournamentTradesProvider provider =
        context.read<TournamentTradesProvider>();

    if (searchProvider.topSearch != null && provider.selectedStock != null) {
      selectedIndex = searchProvider.topSearch!.indexWhere(
        (element) => element.symbol == provider.selectedStock?.symbol,
      );
      if (selectedIndex == -1) {
        selectedIndex = 0;
      }
    }

    _tabController = TabController(
        length: searchProvider.topSearch?.length ?? 0, vsync: this);
    _tabController.index = selectedIndex;
    _scrollController = ScrollController();
  }

  void _scrollToSelectedIndex(int index) {
    double screenWidth = MediaQuery.of(context).size.width;
    double itemWidth = 50.0;
    double scrollOffset = index * itemWidth - (screenWidth / 2) + (itemWidth / 2);

    _scrollController.animateTo(
      scrollOffset,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void onChange({BaseTickerRes? data}) {
    TournamentTradesProvider provider =
        context.read<TournamentTradesProvider>();

    provider.setSelectedStock(stock: data);
  }

  @override
  Widget build(BuildContext context) {
    TournamentSearchProvider provider =
        context.watch<TournamentSearchProvider>();

    return Container(
      margin: EdgeInsets.only(top: 5),
      child: Stack(
        alignment: Alignment.centerRight,
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            controller: _scrollController,
            child: Padding(
              padding: EdgeInsets.only(right:60,left: 16),
              child: TabBar(
                indicator: null,
                indicatorColor: Colors.transparent,
                isScrollable: true,
                controller: _tabController,
                labelPadding: EdgeInsets.only(right: 8),
                onTap: (index) {
                  if (selectedIndex != index) {
                    selectedIndex = index;
                    setState(() {});
                    onChange(data: provider.topSearch?[index]);
                    _scrollToSelectedIndex(index);
                  }
                },
                tabs: List.generate(
                  provider.topSearch?.length ?? 0,
                      (index) {
                        BaseTickerRes? data = provider.topSearch?[index];
                    return Container(
                      padding: EdgeInsets.all(9),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color:ThemeColors.neutral5,
                        border: selectedIndex == index
                            ? Border.all(
                          color: ThemeColors.success120,
                          width: 2,
                        )
                            : null,
                      ),
                      child: CachedNetworkImagesWidget(
                        data?.image ?? '',
                        height: 30,
                        width: 30,
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          Positioned(
            right: 16,
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  createRoute(TournamentSearch()),
                );
              },
              child: Container(
                height: 50,
                width: 50,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: ThemeColors.black,
                ),
                child: Icon(Icons.search,color: ThemeColors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
