import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stocks_news_new/models/market/industries_res.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/cache_network_image.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';

class BaseSectorItem extends StatelessWidget {
  final IndustriesData data;
  final int index;
  final Function(dynamic)? onTap;

  const BaseSectorItem({
    super.key,
    required this.data,
    required this.index,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // bool isOpen = _openIndex == widget.index;
    return Container(
      padding: EdgeInsets.all(Pad.pad16),
      child: LayoutBuilder(builder: (context, constraints) {
        double titleSpace = constraints.maxWidth * .5;
        double type = constraints.maxWidth * .32;
        double value = constraints.maxWidth * .18;
        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              // color: Colors.amber[100],
              width: titleSpace,
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(Pad.pad5),
                    child: Container(
                      padding: EdgeInsets.all(3.sp),
                      // color: ThemeColors.neutral5,
                      child: CachedNetworkImagesWidget(
                        data.image,
                        height: 20,
                        width: 20,
                      ),
                    ),
                  ),
                  const SpacerHorizontal(width: 16),
                  Flexible(
                    child: Text(
                      data.industry ?? "",
                      style: styleBaseRegular(
                        fontSize: 14,
                        color: ThemeColors.splashBG,
                        height: 1.4,
                      ),
                    ),
                  ),
                  const SpacerHorizontal(width: 16),
                ],
              ),
            ),
            SizedBox(
              // color: Colors.green[100],
              width: type,
              child: AutoSizeText(
                data.sentiment ?? "",
                style: styleBaseBold(
                  fontSize: 14,
                  color: data.sentimentColor == 1
                      ? ThemeColors.success
                      : ThemeColors.error120,
                ),
              ),
            ),
            SizedBox(
              // color: Colors.red[100],
              width: value,
              child: AutoSizeText(
                "${data.totalMentions}",
                style: styleBaseBold(
                  fontSize: 14,
                  color: ThemeColors.splashBG,
                ),
                // textAlign: TextAlign.end,
              ),
            ),
          ],
        );
      }),
    );
  }
}
