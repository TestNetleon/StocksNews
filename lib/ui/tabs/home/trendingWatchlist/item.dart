import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:stocks_news_new/ui/base/bottom_sheet.dart';
import 'package:stocks_news_new/ui/stockDetail/index.dart';
import 'package:stocks_news_new/ui/tabs/home/scanner/extra/action_in_nbs.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import '../../../../models/ticker.dart';

class TickerBoxItem extends StatelessWidget {
  final BaseTickerRes data;
  final Function()? onTap;
  const TickerBoxItem({super.key, required this.data,this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:onTap,
      child: Container(
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
                            data.symbol ?? '',
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
                visible: data.displayPrice != null && data.displayPrice != '',
                child: Padding(
                  padding: const EdgeInsets.only(top: 12, bottom: 3),
                  child: Text(
                    data.displayPrice ?? "",
                    // style: styleBaseBold(fontSize: 19),
                    style: Theme.of(context).textTheme.displayLarge,
                  ),
                ),
              ),
              Visibility(
                visible: data.displayChange != null,
                child: RichText(
                  text: TextSpan(
                    children: [
                      if (data.changesPercentage != null)
                        WidgetSpan(
                          alignment: PlaceholderAlignment.middle,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: Image.asset(
                              (data.changesPercentage ?? 0) >= 0
                                  ? Images.trendingUP
                                  : Images.trendingDOWN,
                              height: 18,
                              width: 18,
                              color: (data.changesPercentage ?? 0) >= 0
                                  ? ThemeColors.accent
                                  : ThemeColors.sos,
                            ),
                          ),
                        ),
                      TextSpan(
                        text: data.displayChange,
                        style: styleBaseSemiBold(
                          fontSize: 13,
                          color: (data.changesPercentage ?? 0) >= 0
                              ? ThemeColors.accent
                              : ThemeColors.sos,
                        ),
                      ),
                      if (data.changesPercentage != null)
                        TextSpan(
                          text: ' (${data.changesPercentage}%)',
                          style: styleBaseSemiBold(
                            fontSize: 13,
                            color: (data.changesPercentage ?? 0) >= 0
                                ? ThemeColors.accent
                                : ThemeColors.sos,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
