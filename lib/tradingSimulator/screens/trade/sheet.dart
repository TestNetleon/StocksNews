import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stocks_news_new/tradingSimulator/providers/trade_provider.dart';
import 'package:stocks_news_new/tradingSimulator/screens/dashboard/index.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/cache_network_image.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import 'package:stocks_news_new/widgets/theme_button.dart';

import '../../../utils/colors.dart';

class SuccessTradeSheet extends StatelessWidget {
  final SummaryOrderNew? order;
  final bool buy;
  final bool close;
  const SuccessTradeSheet(
      {super.key, this.order, required this.buy, this.close = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxHeight: ScreenUtil().screenHeight - 30),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10.sp),
          topRight: Radius.circular(10.sp),
        ),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            buy
                ? ThemeColors.bottomsheetGradient
                : const Color.fromARGB(255, 35, 0, 0),
            Colors.black,
          ],
        ),
        color: ThemeColors.background,
        border: const Border(
          top: BorderSide(color: ThemeColors.greyBorder),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          Dimen.padding,
          0,
          Dimen.padding,
          0,
        ),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: [
            SpacerVertical(height: 20),
            Column(
              children: [
                SizedBox(
                  height: 50,
                  width: 50,
                  child: CachedNetworkImagesWidget(order?.image),
                ),
                const SpacerVertical(height: 10),
                Text(
                  buy
                      ? "${order?.shares?.toCurrency()} ${order?.symbol} Purchased."
                      : "${order?.shares?.toCurrency()} ${order?.symbol} Sold.",
                  style: stylePTSansBold(
                    color: ThemeColors.white,
                    fontSize: 20,
                  ),
                ),
                const SpacerVertical(height: 10),
                Text(
                  "\$${order?.invested?.toCurrency()}",
                  style: stylePTSansBold(
                    color: ThemeColors.greyText,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
            const SpacerVertical(height: 40),
            ThemeButton(
              text: close ? "Close" : "My Orders",
              onPressed: () {
                Navigator.pop(context);
                if (!close) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const TsDashboard(),
                    ),
                  );
                }
              },
            ),
            const SpacerVertical(height: 100),
          ],
        ),
      ),
    );
  }
}
