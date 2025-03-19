import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/models/ticker.dart';
import 'package:stocks_news_new/ui/base/bottom_sheet.dart';
import 'package:stocks_news_new/ui/tabs/home/scanner/extra/action_in_nbs.dart';
import 'package:stocks_news_new/ui/theme/manager.dart';

import '../../../../utils/colors.dart';
import '../../../../utils/constants.dart';
import '../../../../utils/theme.dart';
import '../../tools/scanner/models/offline.dart';

class HomeScannerItem extends StatelessWidget {
  final OfflineScannerRes data;

  const HomeScannerItem({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    bool preMarket = data.ext?.extendedHoursType == "PreMarket";
    bool postMarket = data.ext?.extendedHoursType == "PostMarket";

    bool? prePost = preMarket || postMarket;

    num lastTrade = data.price ?? 0;
    num netChange = data.change ?? 0;
    num perChange = data.changesPercentage ?? 0;

    num postMarketPrice = data.ext?.extendedHoursPrice ?? 0;
    num postMarketChange = data.ext?.extendedHoursChange ?? 0;
    num postMarketChangePer = data.ext?.extendedHoursPercentChange ?? 0;
    return InkWell(
      onTap: () {
        if (data.identifier == null || data.identifier == '') {
          return;
        }
        BaseBottomSheet().bottomSheet(
          barrierColor: ThemeColors.neutral5.withValues(alpha: 0.7),
          child: ActionInNbs(
            symbol: data.identifier ?? '',
            item: BaseTickerRes(
              id: data.bid.toString(),
              symbol: data.identifier ?? '',
              name: data.name ?? '',
              image: data.image ?? '',
            ),
          ),
        );
      },
      child: Consumer<ThemeManager>(
        builder: (context, value, child) {
          bool isDark = value.isDarkMode;
          return Container(
            margin: EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
              color: isDark ? null : ThemeColors.white,
              gradient: isDark
                  ? LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        ThemeColors.gradientGreen,
                        ThemeColors.blackShade,
                      ],
                      stops: [0.0025, 0.5518],
                    )
                  : null,
              borderRadius: BorderRadius.circular(8),
              border: isDark ? Border.all(color: ThemeColors.neutral5) : null,
              boxShadow: [
                BoxShadow(
                  color: ThemeColors.boxShadow,
                  blurRadius: 60,
                  offset: Offset(0, 20),
                ),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.all(Pad.pad16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        margin: EdgeInsets.only(right: Pad.pad16),
                        child: CachedNetworkImage(
                          imageUrl: data.image ?? '',
                          height: 30,
                          width: 44,
                        ),
                      ),
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Visibility(
                              child: Text(
                                data.identifier ?? '',
                                // style: styleBaseBold(),
                                style: Theme.of(context).textTheme.displayLarge,
                              ),
                            ),
                            Text(
                              data.name ?? '',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: styleBaseRegular(
                                fontSize: 13,
                                color: ThemeColors.neutral40,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Visibility(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 12, bottom: 4),
                      child: Text(
                        prePost ? '\$$postMarketPrice' : '\$$lastTrade',
                        // style: styleBaseBold(fontSize: 19),
                        style: Theme.of(context).textTheme.displayLarge,
                      ),
                    ),
                  ),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text:
                              prePost ? '\$$postMarketChange' : '\$$netChange',
                          style: styleBaseSemiBold(
                            fontSize: 13,
                            color: prePost
                                ? postMarketChangePer >= 0
                                    ? ThemeColors.accent
                                    : ThemeColors.sos
                                : perChange >= 0
                                    ? ThemeColors.accent
                                    : ThemeColors.sos,
                          ),
                        ),
                        TextSpan(
                          text: prePost
                              ? ' ($postMarketChangePer%)'
                              : ' ($perChange%)',
                          style: styleBaseSemiBold(
                            fontSize: 13,
                            color: prePost
                                ? postMarketChangePer >= 0
                                    ? ThemeColors.accent
                                    : ThemeColors.sos
                                : perChange >= 0
                                    ? ThemeColors.accent
                                    : ThemeColors.sos,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
