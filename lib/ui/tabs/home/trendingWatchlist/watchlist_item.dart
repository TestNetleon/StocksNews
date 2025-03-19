import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/ui/theme/manager.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/cache_network_image.dart';
import '../../../../models/ticker.dart';

class TickerBoxWatchListItem extends StatelessWidget {
  final BaseTickerRes data;
  final Function()? onTap;
  const TickerBoxWatchListItem({super.key, required this.data, this.onTap});

  @override
  Widget build(BuildContext context) {
    bool isDark = context.watch<ThemeManager>().isDarkMode;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          // color: Colors.white,
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(8),
          gradient: isDark
              ? LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF1D1C1C),
                    Color(0xFF5C5C5C),
                  ],
                )
              : null,
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
                  ClipRRect(
                    borderRadius: BorderRadius.circular(Pad.pad5),
                    child: Container(
                      margin: EdgeInsets.only(right: Pad.pad16),
                      padding: EdgeInsets.all(3.sp),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(Pad.pad5),
                        color:
                            isDark ? Colors.transparent : ThemeColors.neutral5,
                      ),
                      child: CachedNetworkImagesWidget(
                        data.image,
                        height: 41,
                        width: 41,
                      ),
                    ),
                  ),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Visibility(
                          child: Text(
                            data.symbol ?? '',
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
