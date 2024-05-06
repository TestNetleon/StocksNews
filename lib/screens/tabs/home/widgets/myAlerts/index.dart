import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/modals/home_alert_res.dart';
import 'package:stocks_news_new/providers/home_provider.dart';
import 'package:stocks_news_new/screens/alerts/alerts.dart';
import 'package:stocks_news_new/screens/stockDetails/stock_details.dart';
import 'package:stocks_news_new/screens/tabs/home/widgets/myAlerts/item.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

class HomeMyAlerts extends StatelessWidget {
  const HomeMyAlerts({super.key});

  @override
  Widget build(BuildContext context) {
    List<HomeAlertsRes>? homeAlert =
        context.watch<HomeProvider>().homeAlertData;
    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SpacerVertical(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    "My Stock Alerts",
                    style: stylePTSansBold(),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, Alerts.path);
                  },
                  child: Row(
                    children: [
                      Text(
                        "View All",
                        style: stylePTSansBold(fontSize: 12),
                      ),
                      const SpacerHorizontal(width: 5),
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 15.sp,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SpacerVertical(height: 10),
            SizedBox(
              height: constraints.maxWidth * 0.6,
              child: ListView.separated(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  HomeAlertsRes? data = homeAlert?[index];
                  if (data == null) {
                    return const SizedBox();
                  }
                  return FittedBox(
                      alignment: Alignment.topCenter,
                      fit: BoxFit.scaleDown,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, StockDetails.path,
                              arguments: data.symbol);
                        },
                        child: HomeMyAlertItem(
                          data: data,
                        ),
                      ));
                },
                separatorBuilder: (context, index) {
                  return const SpacerHorizontal(width: 12);
                },
                itemCount: homeAlert?.length ?? 0,
              ),
            ),
          ],
        );
      },
    );
  }
}
