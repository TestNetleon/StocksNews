import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/ui/tabs/tools/tournament/models/tour_user_detail.dart';
import 'package:stocks_news_new/ui/tabs/tools/tournament/provider/tournament.dart';
import 'package:stocks_news_new/ui/theme/manager.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/cache_network_image.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

class TlItem extends StatelessWidget {
  final RecentBattlesRes? data;
  const TlItem({super.key, this.data});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeManager>(builder: (context, value, child) {
      bool isDark = value.isDarkMode;
      return InkWell(
        onTap: () {
          context
              .read<TournamentProvider>()
              .tradesRedirection("${data?.tournamentBattleId ?? ""}");
        },
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical:10),
              decoration: BoxDecoration(
                color: isDark ? null : ThemeColors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(3),
                        decoration: BoxDecoration(
                            border:
                            Border.all(color: ThemeColors.secondary100, width: 1),
                            shape: BoxShape.circle),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(45),
                          child: CachedNetworkImagesWidget(
                            data?.tournamentImage ?? "",
                            height: 45.sp,
                            width: 45.sp,
                            placeHolder: Images.userPlaceholderNew,
                            showLoading: true,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      const SpacerHorizontal(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              data?.tournamentName ?? '',
                              style: styleBaseBold(fontSize: 16),
                            ),
                            const SpacerVertical(height: Pad.pad5),
                            Visibility(
                              visible: data?.date != null,
                              child: Text(
                                data?.date ?? "",
                                style: styleBaseRegular(
                                    fontSize: 12, color: ThemeColors.neutral40),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SpacerHorizontal(width: Pad.pad10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Visibility(
                            visible: data?.points != 0,
                            child: Text('Reward Points',
                                style: styleBaseBold(
                                  fontSize: 12,
                                  color: ThemeColors.neutral40,
                                )),
                          ),
                          Visibility(
                            visible: data?.points != 0,
                            child: Text(
                              '${data?.points}',
                              style: styleBaseBold(
                                fontSize: 14,
                                color: ThemeColors.success120,
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              decoration: BoxDecoration(
                  color: isDark? ThemeColors.white:ThemeColors.lightGrey,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(5),
                    bottomRight: Radius.circular(5),
                  )
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                      child: _richPrices(
                          label: "Performance: ",
                          value: "${data?.performance ?? "0"}%")),
                  const SpacerHorizontal(width: 10),
                  Flexible(
                    child: _richPrices(
                        label: "Perf. Points: ",
                        value: "${data?.performancePoints}"),
                  ),
                ],
              ),
            ),
            Container(
              height: 1,
              margin: EdgeInsets.symmetric(horizontal: 3),
              decoration: BoxDecoration(
                color: data?.status == 1
                    ? ThemeColors.success120
                    : ThemeColors.error120,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(8),
                  bottomRight: Radius.circular(8),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _richPrices({String? label, String? value}) {
    if (value == null || value.isEmpty) return SizedBox();
    return RichText(
        text: TextSpan(
            text: label,
            style: styleBaseBold(
              fontSize: 14,
            ),
            children: [
          TextSpan(
              text: value,
              style: label == "Perf. Points: "
                  ? styleBaseRegular(fontSize: 14)
                  : styleBaseBold(
                      fontSize: 14,
                      color: (data?.performance ?? 0) > 0
                          ? ThemeColors.success120
                          : data?.performance == 0
                              ? ThemeColors.black
                              : ThemeColors.error120)
          )
        ]));
  }
}
