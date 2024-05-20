import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/modals/home_alert_res.dart';
import 'package:stocks_news_new/modals/user_res.dart';
import 'package:stocks_news_new/providers/home_provider.dart';
import 'package:stocks_news_new/providers/user_provider.dart';
import 'package:stocks_news_new/screens/alerts/alerts.dart';
import 'package:stocks_news_new/screens/allFeatured/index.dart';
import 'package:stocks_news_new/screens/stockDetails/stock_details.dart';
import 'package:stocks_news_new/screens/tabs/home/widgets/myAlerts/item.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

class HomeMyAlerts extends StatelessWidget {
  const HomeMyAlerts({super.key});

  @override
  Widget build(BuildContext context) {
    HomeProvider provider = context.watch<HomeProvider>();
    List<HomeAlertsRes>? homeAlert = provider.homeAlertData;

    UserRes? userRes = context.watch<UserProvider>().user;
    log("$userRes");
    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Visibility(
              // visible: provider.userAlert != 0,
              child: Padding(
                padding: const EdgeInsets.only(top: 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        userRes != null && provider.totalAlerts != 0
                            ? provider.totalAlerts == 1
                                ? "Stock Alert"
                                : "Stock Alerts"
                            : "Featured Stocks",
                        style: stylePTSansBold(),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        userRes != null && provider.totalAlerts != 0
                            ? Navigator.pushNamed(context, Alerts.path)
                            : Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const AllFeaturedIndex(),
                                ));
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
              ),
            ),
            const SpacerVertical(height: 10),
            SizedBox(
              height: constraints.maxWidth * 0.62,
              child: ListView.separated(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
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
                    ),
                  );
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
