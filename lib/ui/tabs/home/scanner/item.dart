import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:stocks_news_new/models/ticker.dart';
import 'package:stocks_news_new/ui/base/bottom_sheet.dart';
import 'package:stocks_news_new/ui/tabs/home/scanner/extra/action_in_nbs.dart';

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
      onTap: (){
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
                ))
        );
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Color.fromARGB(28, 150, 171, 209),
              blurRadius: 10,
              offset: Offset(0, 10),
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
                            style: styleBaseBold(),
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
                    style: styleBaseBold(fontSize: 19),
                  ),
                ),
              ),
              RichText(
                text: TextSpan(
                  children: [
                    // WidgetSpan(
                    //   alignment: PlaceholderAlignment.middle,
                    //   child: Padding(
                    //     padding: const EdgeInsets.symmetric(horizontal: 4),
                    //     child: prePost
                    //         ? Image.asset(
                    //             postMarketChangePer > 0
                    //                 ? Images.trendingUP
                    //                 : Images.trendingDOWN,
                    //             height: 18,
                    //             width: 18,
                    //             color: postMarketChangePer >= 0
                    //                 ? ThemeColors.accent
                    //                 : ThemeColors.sos,
                    //           )
                    //         : Image.asset(
                    //             perChange > 0
                    //                 ? Images.trendingUP
                    //                 : Images.trendingDOWN,
                    //             height: 18,
                    //             width: 18,
                    //             color: perChange >= 0
                    //                 ? ThemeColors.accent
                    //                 : ThemeColors.sos,
                    //           ),
                    //   ),
                    // ),
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
      ),
    );
  }
}
