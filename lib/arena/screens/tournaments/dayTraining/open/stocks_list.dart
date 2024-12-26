import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/theme.dart';
import '../../../../../tradingSimulator/modals/trading_search_res.dart';
import '../../../../../widgets/cache_network_image.dart';
import '../../../../provider/arena.dart';

class OpenTopStock extends StatelessWidget {
  final Function(TradingSearchTickerRes?) onTap;
  final String? selectedStockSymbol;
  final TabController? tabController;

  const OpenTopStock({
    super.key,
    required this.onTap,
    this.tabController,
    this.selectedStockSymbol,
  });

  @override
  Widget build(BuildContext context) {
    ArenaProvider provider = context.watch<ArenaProvider>();
    if (tabController == null) {
      return Center(
        child: CircularProgressIndicator(
          color: ThemeColors.accent,
        ),
      );
    }

    return Container(
      margin: EdgeInsets.only(top: 15),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 60),
            child: TabBar(
              controller: tabController,
              isScrollable: true,
              labelPadding: EdgeInsets.only(left: 10),
              indicatorColor: Colors.transparent,
              onTap: (value) {
                TradingSearchTickerRes? data = provider.topSearch?[value];
                onTap(data);
              },
              tabs: List.generate(
                provider.topSearch?.length ?? 0,
                (index) {
                  TradingSearchTickerRes? data = provider.topSearch?[index];
                  bool isSelected = selectedStockSymbol == data?.symbol;
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
