import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/models/ticker.dart';
import 'package:stocks_news_new/ui/tabs/tools/simulator/services/sse.dart';
import 'package:stocks_news_new/ui/tabs/tools/tournament/provider/search.dart';
import 'package:stocks_news_new/ui/tabs/tools/tournament/screens/tournaments/widgets/tour_trade_sheet.dart';
import 'package:stocks_news_new/ui/theme/manager.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/cache_network_image.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';


class TournamentDefaultItem extends StatelessWidget {
  final BaseTickerRes data;
  const TournamentDefaultItem({
    required this.data,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return
      Consumer<ThemeManager>(builder: (context, value, child) {
      bool isDark = value.isDarkMode;
      return InkWell(
      onTap: () {
        TournamentSearchProvider provider = context.read<TournamentSearchProvider>();
        provider.setTappedStock(
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
      },
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            decoration: BoxDecoration(
              color: isDark ? null : ThemeColors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: ThemeColors.boxShadow,
                  blurRadius: 60,
                  offset: Offset(0, 20),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color:ThemeColors.neutral5,
                  ),
                  padding: EdgeInsets.all(3),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(40.sp),
                    child: CachedNetworkImagesWidget(
                      data.image ?? '',
                      width: 40.sp,
                      height: 40.sp,
                    ),
                  ),
                ),
                const SpacerHorizontal(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data.symbol ?? "",
                        style: styleBaseBold(fontSize: 14),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        data.name ?? "",
                        style: styleBaseRegular(
                          fontSize: 12,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),

                    ],
                  ),
                ),
                const SpacerHorizontal(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${data.price?.toFormattedPrice()}',
                      style: styleBaseBold(fontSize: 18),
                    ),
                    const SpacerVertical(height: 5),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text:
                                "${data.change?.toFormattedPrice()} (${data.changesPercentage}%)",
                            style: styleBaseBold(
                              fontSize: 14,
                              color: (data.changesPercentage ?? 0) >= 0
                                  ? ThemeColors.success120
                                  : ThemeColors.error120,
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
        ],
      ),
    );
      });
  }
}
