import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

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
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        // color: Colors.white,
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Color(0x1C96ABD1),
            blurRadius: 10,
            offset: Offset(0, 10),
          ),
          BoxShadow(
            color: Color(0x1C96ABD1),
            blurRadius: 10,
            offset: Offset(10, 10),
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
                    text: prePost ? '\$$postMarketChange' : '\$$netChange',
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
                    text:
                        prePost ? ' ($postMarketChangePer%)' : ' ($perChange%)',
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
  }
}
