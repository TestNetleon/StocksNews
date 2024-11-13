import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/theme.dart';
import '../../../../../tradingSimulator/modals/trading_search_res.dart';
import '../../../../../widgets/cache_network_image.dart';
import '../../../../provider/arena.dart';

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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ArenaProvider provider = context.read<ArenaProvider>();
      var tickers = provider.topSearch;
      _tabController = TabController(
        length: tickers?.length ?? 0,
        vsync: this,
      );

      _initializeTabController(provider.topSearch);
    });
  }

  void _initializeTabController(List<TradingSearchTickerRes>? tickers) {
    if (widget.selectedStockSymbol != null) {
      final index = tickers?.indexWhere(
        (ticker) => ticker.symbol == widget.selectedStockSymbol,
      );

      if (index != null && index != -1 && mounted) {
        _tabController?.animateTo(
          index,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    ArenaProvider provider = context.watch<ArenaProvider>();
    if (_tabController == null) {
      return Center(
        child: CircularProgressIndicator(
          color: ThemeColors.accent,
        ),
      );
    }

    return Stack(
      children: [
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
                offset: Offset(-8, 0),
                blurRadius: 4,
                spreadRadius: 10,
              ),
            ],
          ),
          child: Text(
            'All',
            style: styleGeorgiaBold(),
          ),
        ),
        TabBar(
          padding: EdgeInsets.only(top: 10),
          controller: _tabController,
          isScrollable: true,
          indicatorColor: Colors.transparent,
          onTap: (value) {
            TradingSearchTickerRes? data = provider.topSearch?[value];
            widget.onTap(data);
          },
          tabs: List.generate(
            provider.topSearch?.length ?? 0,
            (index) {
              TradingSearchTickerRes? data = provider.topSearch?[index];
              bool isSelected = widget.selectedStockSymbol == data?.symbol;
              return Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color.fromARGB(255, 64, 64, 64),
                  border: isSelected
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
        // Text(
        //   'Leaderboard',
        //   style: styleGeorgiaBold(),
        // ),
        // ListView.separated(
        //   shrinkWrap: true,
        //   physics: NeverScrollableScrollPhysics(),
        //     itemBuilder: (context, index) {
        //       return Container( );
        //     },
        //     separatorBuilder: (context, index) {
        //       return SpacerVertical(height: 10);
        //     },
        //     itemCount: 10, ),
      ],
    );
  }

  @override
  void dispose() {
    // Dispose the TabController when the widget is unmounted
    _tabController?.dispose();
    super.dispose();
  }
}
