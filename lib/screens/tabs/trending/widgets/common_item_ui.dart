import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stocks_news_new/modals/top_trending_res.dart';
import 'package:stocks_news_new/routes/my_app.dart';
import 'package:stocks_news_new/screens/stockDetail/index.dart';

import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import 'package:stocks_news_new/widgets/theme_image_view.dart';

import '../../../../utils/utils.dart';

class CommonItemUi extends StatefulWidget {
  const CommonItemUi({
    super.key,
    this.data,
  });

  final TopTrendingDataRes? data;

  @override
  State<CommonItemUi> createState() => _CommonItemUiState();
}

class _CommonItemUiState extends State<CommonItemUi> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          decoration: BoxDecoration(
            color: ThemeColors.background,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () {
                    closeKeyboard();

                    Navigator.push(
                      navigatorKey.currentContext!,
                      MaterialPageRoute(
                        builder: (_) =>
                            StockDetail(symbol: widget.data?.symbol ?? ""),
                      ),
                    );
                  },
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(0.sp),
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          width: 48,
                          height: 48,
                          child: ThemeImageView(url: widget.data?.image ?? ""),
                        ),
                      ),
                      const SpacerHorizontal(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.data?.symbol ?? "",
                              style: stylePTSansBold(fontSize: 18),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SpacerVertical(height: 5),
                            Text(
                              widget.data?.name ?? "",
                              style: stylePTSansBold(
                                color: ThemeColors.greyText,
                                fontSize: 12,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SpacerVertical(height: 5),
                            Row(
                              children: [
                                widget.data?.lastSentiment == null
                                    ? const SizedBox()
                                    : Text(
                                        textAlign: TextAlign.end,
                                        "Mentions: ${widget.data?.lastSentiment}",
                                        style: stylePTSansBold(fontSize: 12),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                const SpacerHorizontal(width: 8),
                                widget.data?.rank == null
                                    ? const SizedBox()
                                    : RichText(
                                        text: TextSpan(
                                          children: [
                                            TextSpan(
                                              text: "(",
                                              style:
                                                  stylePTSansBold(fontSize: 12),
                                            ),
                                            WidgetSpan(
                                              child: Padding(
                                                padding: EdgeInsets.zero,
                                                child: (widget.data
                                                                ?.sentiment ??
                                                            0) >
                                                        (widget.data
                                                                ?.lastSentiment ??
                                                            0)
                                                    ? Icon(
                                                        Icons.arrow_drop_up,
                                                        color:
                                                            ThemeColors.accent,
                                                        size: 14.sp,
                                                      )
                                                    : Icon(
                                                        Icons.arrow_drop_down,
                                                        color: ThemeColors.sos,
                                                        size: 14.sp,
                                                      ),
                                              ),
                                            ),
                                            TextSpan(
                                              text: "${widget.data?.rank})",
                                              style:
                                                  stylePTSansBold(fontSize: 12),
                                            ),
                                          ],
                                        ),
                                      ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SpacerHorizontal(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    widget.data?.price ?? "",
                    style: stylePTSansBold(fontSize: 18),
                    maxLines: 2,
                    textAlign: TextAlign.end,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SpacerVertical(height: 5),
                  Text(
                    "${widget.data?.change} (${widget.data?.changePercentage?.toCurrency()}%)",
                    style: stylePTSansBold(
                      color: widget.data?.changePercentage == 0
                          ? ThemeColors.white
                          : (widget.data?.changePercentage ?? 0) > 0
                              ? ThemeColors.accent
                              : ThemeColors.sos,
                      fontSize: 14,
                    ),
                    maxLines: 2,
                    textAlign: TextAlign.end,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
