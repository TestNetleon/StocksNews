import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/models/ticker.dart';
import 'package:stocks_news_new/routes/my_app.dart';
import 'package:stocks_news_new/ui/tabs/tools/league/managers/search.dart';
import 'package:stocks_news_new/ui/tabs/tools/league/screens/tournaments/widgets/tour_trade_sheet.dart';
import 'package:stocks_news_new/ui/tabs/tools/simulator/services/sse.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/cache_network_image.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

class TickerItem extends StatelessWidget {
  final BaseTickerRes data;
  const TickerItem({
    required this.data,
    super.key,
  });

  Future _onTap({BaseTickerRes? item}) async {
    LeagueSearchManager manager = navigatorKey.currentContext!.read<LeagueSearchManager>();
    manager.setTappedStock(
        StockDataManagerRes(symbol: data.symbol??"",change: data.change,price: data.price,changePercentage: data.changesPercentage),
        data.showButton
    );
    tournamentSheet(
      symbol:data.symbol,
      doPop: false,
      data: BaseTickerRes(
        image: data.image,
        name: data.name,
        price: data.price,
        symbol: data.symbol,
        showButton: data.showButton,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          _onTap(item: data);
        },
        child: Container(
          padding: EdgeInsets.all(Pad.pad16),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(Pad.pad5),
                child: Container(
                  padding: EdgeInsets.all(3.sp),
                  color: ThemeColors.neutral5,
                  child: CachedNetworkImagesWidget(
                    data.image ?? "",
                    height: 41,
                    width: 41,
                  ),
                ),
              ),
              const SpacerHorizontal(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data.symbol ?? "",
                      style: styleBaseBold(
                          fontSize: 16, color: ThemeColors.splashBG),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SpacerVertical(height: Pad.pad5),
                    Text(
                      data.name ?? "",
                      style: styleBaseRegular(
                        fontSize: 14,
                        color: ThemeColors.neutral40,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SpacerVertical(height: Pad.pad5),
                  ],
                ),
              ),
              const SpacerHorizontal(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${data.price?.toFormattedPrice()}',
                    style:
                    styleBaseBold(fontSize: 16, color: ThemeColors.splashBG),
                  ),
                  const SpacerVertical(height: Pad.pad5),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text:
                          "${data.change?.toFormattedPrice()} (${data.changesPercentage}%)",
                          style: styleBaseRegular(
                            fontSize: 12,
                            color: (data.changesPercentage ?? 0) >= 0
                                ? ThemeColors.accent
                                : ThemeColors.sos,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
  }
}
