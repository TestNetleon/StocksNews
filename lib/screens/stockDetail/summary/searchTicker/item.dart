import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/api/api_response.dart';
import 'package:stocks_news_new/modals/home_trending_res.dart';
import 'package:stocks_news_new/providers/stock_detail_new.dart';
import 'package:stocks_news_new/providers/trade_provider.dart';
import 'package:stocks_news_new/route/my_app.dart';
import 'package:stocks_news_new/screens/stockDetail/trade/sheet.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import 'package:stocks_news_new/widgets/theme_image_view.dart';

import '../../paperTrade/index.dart';

class SdTradeDefaultItem extends StatelessWidget {
  final Top top;
  final bool buy;
  const SdTradeDefaultItem({
    required this.top,
    super.key,
    this.buy = true,
  });

  Future _onTap({String? symbol}) async {
    try {
      StockDetailProviderNew provider =
          navigatorKey.currentContext!.read<StockDetailProviderNew>();

      ApiResponse response =
          await provider.getTabData(symbol: symbol, showProgress: true);
      if (response.status) {
        SummaryOrderNew order = await Navigator.pushReplacement(
          navigatorKey.currentContext!,
          MaterialPageRoute(
            builder: (context) => PaperTradeIndex(buy: buy),
          ),
        );
        TradeProviderNew provider =
            navigatorKey.currentContext!.read<TradeProviderNew>();

        buy ? provider.addOrderData(order) : provider.sellOrderData(order);
        await _showSheet(order, buy);
      } else {}
    } catch (e) {
      //
    }
  }

  Future _showSheet(SummaryOrderNew? order, bool buy) async {
    await showModalBottomSheet(
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(5),
          topRight: Radius.circular(5),
        ),
      ),
      backgroundColor: ThemeColors.transparent,
      isScrollControlled: false,
      context: navigatorKey.currentContext!,
      builder: (context) {
        return SuccessTradeSheet(
          order: order,
          buy: buy,
          close: true,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        _onTap(symbol: top.symbol);
      },
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(0.sp),
            child: Container(
              padding: const EdgeInsets.all(5),
              width: 43,
              height: 43,
              child: ThemeImageView(url: top.image ?? ""),
            ),
          ),
          const SpacerHorizontal(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  top.symbol,
                  style: styleGeorgiaBold(fontSize: 14),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SpacerVertical(height: 5),
                Text(
                  top.name,
                  style: styleGeorgiaRegular(
                    color: ThemeColors.greyText,
                    fontSize: 12,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
