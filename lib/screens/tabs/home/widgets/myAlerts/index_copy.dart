import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/modals/home_alert_res.dart';
import 'package:stocks_news_new/modals/user_res.dart';
import 'package:stocks_news_new/providers/home_provider.dart';
import 'package:stocks_news_new/providers/user_provider.dart';
import 'package:stocks_news_new/routes/my_app.dart';
import 'package:stocks_news_new/screens/alerts/alerts.dart';
import 'package:stocks_news_new/screens/allFeatured/index.dart';
import 'package:stocks_news_new/screens/stocks/index.dart';
import 'package:stocks_news_new/screens/tabs/home/widgets/myAlerts/item_copy.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/utils/utils.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

import '../../../../stockDetail/index.dart';

class HomeMyAlerts extends StatelessWidget {
  const HomeMyAlerts({super.key});

  void onTap(BuildContext context) {
    HomeProvider provider = context.read<HomeProvider>();
    UserRes? userRes = context.read<UserProvider>().user;

    if (userRes != null && provider.totalAlerts != 0) {
      Navigator.push(
        navigatorKey.currentContext!,
        MaterialPageRoute(builder: (_) => const Alerts()),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const AllFeaturedIndex()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    HomeProvider provider = context.watch<HomeProvider>();
    List<HomeAlertsRes>? homeAlert = provider.homeAlertData;

    UserRes? userRes = context.watch<UserProvider>().user;
    Utils().showLog("$userRes");
    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Visibility(
              // visible: provider.userAlert != 0,
              child: Padding(
                padding: EdgeInsets.only(top: isPhone ? 0 : 10),
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
                      onTap: () => onTap(context),
                      child: Row(
                        children: [
                          Text(
                            "View All",
                            style: stylePTSansBold(fontSize: 12),
                          ),
                          const SpacerHorizontal(width: 5),
                          const Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 15,
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
              height: 160,
              child: ListView.separated(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  HomeAlertsRes? data = homeAlert?[index];
                  // if (data == null) {
                  //   return const Placeholder();
                  // }
                  // if (homeAlert?.length == 1 && userRes != null) {
                  //   return AddAlert(data: data);
                  // }
                  return AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    child: data == null
                        ? Placeholder(
                            height: isPhone
                                ? constraints.maxWidth * 0.60
                                : constraints.maxWidth * 0.25,
                          )
                        : (homeAlert?.length == 1 && userRes != null)
                            ? AddAlert(
                                data: data,
                                height: constraints.maxWidth * 0.60,
                              )
                            : FittedBox(
                                alignment: Alignment.topCenter,
                                fit: BoxFit.scaleDown,
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      navigatorKey.currentContext!,
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            StockDetail(symbol: data.symbol),
                                      ),
                                    );
                                  },
                                  child: HomeMyAlertItem(data: data),
                                ),
                              ),
                  );
                },
                separatorBuilder: (context, index) {
                  return const SpacerHorizontal(width: 10);
                },
                itemCount: homeAlert?.length ?? 5,
              ),
            ),
          ],
        );
      },
    );
  }
}

class AddAlert extends StatelessWidget {
  const AddAlert({
    super.key,
    required this.data,
    required this.height,
  });

  final HomeAlertsRes? data;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        FittedBox(
          alignment: Alignment.topCenter,
          fit: BoxFit.scaleDown,
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                navigatorKey.currentContext!,
                MaterialPageRoute(
                  builder: (_) => StockDetail(symbol: data!.symbol),
                ),
              );
            },
            child: HomeMyAlertItem(data: data!),
          ),
        ),
        const SpacerHorizontal(width: 10),
        GestureDetector(
          onTap: () {},
          child: Container(
            padding: const EdgeInsets.all(10),
            height: height,
            width: 220,
            decoration: BoxDecoration(
              // color: const Color.fromARGB(255, 48, 48, 48),
              // color: ThemeColors.greyBorder,
              borderRadius: BorderRadius.circular(10),
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color.fromARGB(255, 23, 23, 23),
                  // ThemeColors.greyBorder,
                  Color.fromARGB(255, 48, 48, 48),
                ],
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Add new alert",
                  style: stylePTSansBold(),
                ),
                const SpacerVertical(height: 10),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      navigatorKey.currentContext!,
                      MaterialPageRoute(builder: (_) => const StocksIndex()),
                    );
                  },
                  child: Container(
                      padding: const EdgeInsets.all(15),
                      decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 76, 76, 76),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.add)),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class Placeholder extends StatelessWidget {
  const Placeholder({super.key, this.height});

  final double? height;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      width: isPhone ? 198 : 200,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color.fromARGB(255, 23, 23, 23),
            Color.fromARGB(255, 48, 48, 48),
          ],
        ),
      ),
    );
  }
}
