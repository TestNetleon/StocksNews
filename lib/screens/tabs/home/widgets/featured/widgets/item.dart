import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:stocks_news_new/modals/featured_watchlist.dart';
import 'package:stocks_news_new/modals/home_alert_res.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

import '../../../../../../utils/colors.dart';
import '../../../../../../widgets/cache_network_image.dart';
import '../../../../../stockDetail/index.dart';

class FeaturedWatchlistItem extends StatelessWidget {
  final FeaturedTicker? data;
  const FeaturedWatchlistItem({
    super.key,
    this.data,
  });

  LineChartData avgData() {
    List<Chart> reversedData = data?.chart?.reversed.toList() ?? [];

    List<FlSpot> spots = [];

    // Extracting data for X and Y axes
    for (int i = 0; i < reversedData.length; i++) {
      spots.add(FlSpot(i.toDouble(), reversedData[i].close));
    }

    return LineChartData(
      lineTouchData: const LineTouchData(enabled: false),
      gridData: FlGridData(
        show: false,
        drawHorizontalLine: false,
        getDrawingVerticalLine: (value) {
          return const FlLine(
            color: ThemeColors.transparent,
            strokeWidth: 1,
          );
        },
      ),
      borderData: FlBorderData(show: false),
      titlesData: const FlTitlesData(show: false),
      minX: 0,
      maxX: reversedData.length.toDouble() - 1,
      minY: reversedData
          .map((data) => data.close)
          .reduce((a, b) => a < b ? a : b)
          .toDouble(),
      maxY: reversedData
          .map((data) => data.close)
          .reduce((a, b) => a > b ? a : b)
          .toDouble(),
      lineBarsData: [
        LineChartBarData(
          show: true,
          spots: spots,
          color: (data?.previousClose ?? 0) > (data?.chart?.first.close ?? 0)
              ? ThemeColors.sos
              : ThemeColors.accent,
          isCurved: true,
          barWidth: 2,
          isStrokeCapRound: false,
          dotData: const FlDotData(
            show: false, // hide dots
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                (data?.previousClose ?? 0) > (data?.chart?.first.close ?? 0)
                    ? ThemeColors.sos.withOpacity(0.1)
                    : ThemeColors.accent.withOpacity(0.1),
                const Color.fromARGB(255, 48, 48, 48),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => StockDetail(symbol: data?.symbol ?? ""),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(right: 10),
        // height: 150,
        width: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(255, 23, 23, 23),
              Color.fromARGB(255, 48, 48, 48),
            ],
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        child: SizedBox(
                          width: 43,
                          height: 43,
                          child: CachedNetworkImagesWidget(
                            data?.image,
                          ),
                        ),
                      ),
                      const SpacerHorizontal(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              data?.symbol ?? "",
                              style: stylePTSansBold(fontSize: 14),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              data?.name ?? "",
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
                  const SpacerVertical(height: 5),
                  Text(
                    data?.price ?? "",
                    style: stylePTSansBold(fontSize: 20),
                  ),
                  Row(
                    children: [
                      Text(
                        data?.change ?? "",
                        style: stylePTSansRegular(
                            fontSize: 13,
                            color: (data?.changesPercentage ?? 0) > 0
                                ? ThemeColors.accent
                                : (data?.changesPercentage ?? 0) == 0
                                    ? ThemeColors.white
                                    : ThemeColors.sos),
                      ),
                      Text(
                        "  (${data?.changesPercentage?.toCurrency()}%)",
                        style: stylePTSansRegular(
                            fontSize: 13,
                            color: (data?.changesPercentage ?? 0) > 0
                                ? ThemeColors.accent
                                : (data?.changesPercentage ?? 0) == 0
                                    ? ThemeColors.white
                                    : ThemeColors.sos),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: data?.chart == null || data?.chart?.isEmpty == true
                  ? ClipRRect(
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                      ),
                      child: Container(
                        width: isPhone
                            ? data?.chart?.isEmpty == true
                                ? 230
                                : 243
                            : data?.chart?.isEmpty == true
                                ? 243
                                : 243,
                        padding: isPhone
                            ? EdgeInsets.zero
                            : const EdgeInsets.only(bottom: 20),
                        // color: const Color.fromARGB(255, 35, 35, 35),
                        constraints: const BoxConstraints(
                          maxHeight: 92,
                          minHeight: 30,
                        ),
                        child: Image.asset(
                          Images.graphHolder,
                          fit: BoxFit.cover,
                        ),
                      ),
                    )
                  : ClipRRect(
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                      ),
                      child: Container(
                        padding: const EdgeInsets.only(top: 10, bottom: 15),
                        height: 80,
                        child: LineChart(avgData()),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class FeatureWatchListItem extends StatelessWidget {
  final FeaturedTicker? data;
  const FeatureWatchListItem({super.key, this.data});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(5),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => StockDetail(symbol: data?.symbol ?? ""),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(right: 10),
        padding: const EdgeInsets.all(10),
        // height: 150,
        width: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(255, 23, 23, 23),
              Color.fromARGB(255, 48, 48, 48),
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  child: SizedBox(
                    width: 43,
                    height: 43,
                    child: CachedNetworkImagesWidget(data?.image),
                  ),
                ),
                const SpacerHorizontal(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data?.symbol ?? '',
                        style: stylePTSansBold(fontSize: 14),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        data?.name ?? '',
                        style: stylePTSansRegular(
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
            // const SpacerVertical(height: 8),
            // Text(
            //   data?.name ?? '',
            //   style: stylePTSansRegular(
            //     color: ThemeColors.greyText,
            //     fontSize: 12,
            //   ),
            //   maxLines: 2,
            //   overflow: TextOverflow.ellipsis,
            // ),
            const SpacerVertical(height: 8),
            Text(
              data?.price ?? '',
              style: stylePTSansBold(fontSize: 18),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SpacerVertical(height: 5),
            Text(
              "${data?.change ?? ""} (${data?.changesPercentage ?? ""}%)",
              style: stylePTSansRegular(
                fontSize: 12,
                color: (data?.changesPercentage ?? 0) > 0
                    ? ThemeColors.accent
                    : Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
