import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/models/search.dart';
import 'package:stocks_news_new/models/ticker.dart';
import 'package:stocks_news_new/ui/tabs/tools/league/managers/search.dart';
import 'package:stocks_news_new/ui/tabs/tools/league/managers/trades.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/cache_network_image.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';


class OpenTopStock extends StatefulWidget {
  const OpenTopStock({
    super.key,
  });

  @override
  State<OpenTopStock> createState() => _OpenTopStockState();
}

class _OpenTopStockState extends State<OpenTopStock> with SingleTickerProviderStateMixin {
  int selectedIndex = 0;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    LeagueSearchManager searchManager = context.read<LeagueSearchManager>();
    TradesManger manger = context.read<TradesManger>();

    if (searchManager.tickersData?.symbols?.data != null && manger.selectedStock != null) {
      selectedIndex = searchManager.tickersData!.symbols!.data!.indexWhere(
        (element) => element.symbol == manger.selectedStock?.symbol,
      );
      if (selectedIndex == -1) {
        selectedIndex = 0;
      }
    }
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
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
    TradesManger manger = context.read<TradesManger>();
    manger.setSelectedStock(stock: data);
  }

  @override
  Widget build(BuildContext context) {
    LeagueSearchManager searchManager = context.watch<LeagueSearchManager>();
    SearchSymbolRes? symbols= searchManager.tickersData?.symbols;

    return Align(
    alignment: Alignment.centerLeft,
    child: SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      controller: _scrollController,
      child: Padding(
          padding: EdgeInsets.only(left: 16, right: 16),
          child: Row(
              children: List.generate(
                symbols?.data?.length ?? 0,
                    (index) {
                  BaseTickerRes? data = symbols?.data?[index];
                  return InkWell(
                    onTap: (){
                      if (selectedIndex != index) {
                        selectedIndex = index;
                        setState(() {});
                        onChange(data: symbols?.data?[index]);
                        _scrollToSelectedIndex(index);
                      }
                    },
                    child: Padding(
                      padding: EdgeInsets.only(right:Pad.pad16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            padding: EdgeInsets.all(Pad.pad5),
                            decoration: BoxDecoration(
                              color:ThemeColors.neutral5,
                              borderRadius: BorderRadius.circular(Pad.pad5)
                            ),
                            child: CachedNetworkImagesWidget(
                              data?.image ?? '',
                              height: 45,
                              width: 45,
                            ),
                          ),
                          SpacerVertical(height: Pad.pad10),
                          Text(
                            data?.symbol ??'',
                            style: styleBaseSemiBold(fontSize: 12),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              )
          )
      ),
    ),
        );
  }
}
