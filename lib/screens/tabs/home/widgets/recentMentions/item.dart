import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stocks_news_new/modals/home_insider_res.dart';
import 'package:stocks_news_new/screens/stockDetails/stock_details.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_verticle.dart';
import 'package:stocks_news_new/widgets/theme_image_view.dart';

class RecentMentionsItem extends StatelessWidget {
  final BoxConstraints constraints;
  final Function()? onJumpNext;
  final Function()? onJumpBack;

  final RecentMention data;
  const RecentMentionsItem(
      {super.key,
      required this.constraints,
      required this.data,
      this.onJumpNext,
      this.onJumpBack});
//
  @override
  Widget build(BuildContext context) {
    return FittedBox(
      alignment: Alignment.center,
      fit: BoxFit.fitWidth,
      child: Padding(
        padding: EdgeInsets.fromLTRB(10.sp, 5.sp, 15.sp, 5.sp),
        child: InkWell(
          borderRadius: BorderRadius.circular(10.sp),
          onTap: () => Navigator.pushNamed(context, StockDetails.path,
              arguments: data.symbol),
          child: Ink(
            padding: EdgeInsets.symmetric(vertical: 15.sp),
            width: constraints.maxWidth,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.sp),
                border: Border.all(color: ThemeColors.greyBorder),
                color: ThemeColors.primaryLight),
            child: Row(
              children: [
                InkWell(
                  onTap: onJumpNext,
                  borderRadius: BorderRadius.circular(30.sp),
                  child: Padding(
                    padding: EdgeInsets.all(10.sp),
                    child: const Icon(Icons.arrow_back_ios),
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(25.sp),
                                  child: Container(
                                    padding: EdgeInsets.all(5.sp),
                                    width: 43.sp,
                                    height: 43.sp,
                                    child:
                                        ThemeImageView(url: data.image ?? ""),
                                  ),
                                ),
                                Text(
                                  data.symbol,
                                  style: styleGeorgiaBold(),
                                ),
                              ],
                            ),
                          ),
                          Flexible(
                            child: Padding(
                              padding: EdgeInsets.only(right: 5.sp),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    maxLines: 1,
                                    "${data.price}",
                                    overflow: TextOverflow.ellipsis,
                                    style: stylePTSansRegular(
                                        fontSize: 12, color: ThemeColors.white),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Icon(
                                        (data.change ?? 0) > 0
                                            ? Icons.arrow_upward
                                            : Icons.arrow_downward,
                                        size: 15.sp,
                                        color: (data.change ?? 0) > 0
                                            ? ThemeColors.accent
                                            : Colors.red,
                                      ),
                                      Flexible(
                                        child: Text(
                                          maxLines: 1,
                                          "${data.change!.toCurrency()} (${data.changesPercentage!.toCurrency()}%)",
                                          style: stylePTSansRegular(
                                            fontSize: 12,
                                            color: (data.change ?? 0) > 0
                                                ? ThemeColors.accent
                                                : Colors.red,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SpacerVerticel(height: 18),
                      Padding(
                        padding: EdgeInsets.only(left: 5.sp, right: 5.sp),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              maxLines: 1,
                              "${data.name}",
                              overflow: TextOverflow.ellipsis,
                              style: styleGeorgiaRegular(
                                  fontSize: 15, color: ThemeColors.greyText),
                            ),
                            const SpacerVerticel(height: 3),
                            Text(
                              maxLines: 1,
                              (data.mentionCount ?? 1) == 1
                                  ? "Mention - ${data.mentionCount}"
                                  : "Mentions - ${data.mentionCount}",
                              overflow: TextOverflow.ellipsis,
                              style: stylePTSansRegular(
                                  fontSize: 14, color: ThemeColors.white),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                InkWell(
                  onTap: onJumpNext,
                  borderRadius: BorderRadius.circular(30.sp),
                  child: Padding(
                      padding: EdgeInsets.all(10.sp),
                      child: const Icon(Icons.arrow_forward_ios)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
