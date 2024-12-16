import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/modals/highlow_pe_res.dart';
import 'package:stocks_news_new/providers/high_low_pe.dart';
import 'package:stocks_news_new/routes/my_app.dart';
import 'package:stocks_news_new/screens/tabs/insider/insiderDetails/insider_details_item.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';

import '../../../utils/colors.dart';
import '../../../utils/theme.dart';
import '../../../widgets/spacer_vertical.dart';
import '../../../widgets/theme_image_view.dart';
import '../../stockDetail/index.dart';

class HighLowPEItem extends StatelessWidget {
  final HIghLowPeRes? data;
  final int index;
  const HighLowPEItem({super.key, this.data, required this.index});
  void _onTap(context) {
    Navigator.push(
      navigatorKey.currentContext!,
      MaterialPageRoute(builder: (_) => StockDetail(symbol: data!.symbol!)),
    );
  }

  @override
  Widget build(BuildContext context) {
    HighLowPeProvider provider = context.watch<HighLowPeProvider>();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: ThemeColors.background,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: () => _onTap(context),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(0),
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    width: 48,
                    height: 48,
                    child: ThemeImageView(url: data?.image ?? ""),
                  ),
                ),
              ),
              const SpacerHorizontal(width: 12),
              Expanded(
                child: InkWell(
                  onTap: () => _onTap(context),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data?.symbol ?? "N?A",
                        style: stylePTSansBold(fontSize: 18),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SpacerVertical(height: 5),
                      Text(
                        data?.name ?? "N?A",
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
              ),
              const SpacerHorizontal(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    data?.price ?? "N?A",
                    style: stylePTSansBold(fontSize: 18),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SpacerVertical(height: 5),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      data?.change?.direction == "up"
                          ? const Icon(
                              Icons.arrow_upward,
                              size: 14,
                              color: Colors.green,
                            )
                          : const Icon(
                              Icons.arrow_downward_rounded,
                              size: 14,
                              color: Colors.red,
                            ),
                      Text(
                        "${data?.change?.value} (${data?.change?.percentage}%)",
                        style: stylePTSansRegular(
                          fontSize: 14,
                          color: data?.change?.direction == "up"
                              ? ThemeColors.accent
                              : Colors.red,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SpacerHorizontal(width: 10),
              InkWell(
                onTap: () {
                  provider.setOpenIndex(
                    provider.openIndex == index ? -1 : index,
                  );
                },
                child: Container(
                  decoration: const BoxDecoration(
                    color: ThemeColors.accent,
                  ),
                  margin: EdgeInsets.only(left: 8.sp),
                  padding: const EdgeInsets.all(3),
                  child: Icon(
                    provider.openIndex == index
                        ? Icons.arrow_upward_rounded
                        : Icons.arrow_downward_rounded,
                    size: 16,
                  ),
                ),
              )
            ],
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 150),
            child: Container(
              height: provider.openIndex == index ? null : 0,
              margin: EdgeInsets.only(
                top: provider.openIndex == index ? 10.sp : 0,
                bottom: provider.openIndex == index ? 10.sp : 0,
              ),
              child: Column(
                children: [
                  InnerRowItem(
                    label: "PE Ratio",
                    value: "${data?.pe ?? "N/A"}",
                  ),
                  Visibility(
                    visible: data?.pegRatio != null,
                    child: InnerRowItem(
                      label: "PEG Ratio",
                      value: "${data?.pegRatio ?? "N/A"}",
                    ),
                  ),
                  InnerRowItem(
                    label: "Market Cap",
                    value: data?.marketCap ?? "N/A",
                  ),
                  InnerRowItem(
                    label: "Volume",
                    value: data?.volume ?? "N/A",
                  ),
                  InnerRowItem(
                    label: "Average Volume",
                    value: data?.avgVolume ?? "N/A",
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
