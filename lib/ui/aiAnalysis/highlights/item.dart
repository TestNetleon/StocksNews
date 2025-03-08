import 'package:flutter/material.dart';
import 'package:stocks_news_new/ui/base/border_container.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/cache_network_image.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import '../../../models/stockDetail/overview.dart';

class AIHighlightsItem extends StatelessWidget {
  final BaseKeyValueRes data;
  const AIHighlightsItem({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
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
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Visibility(
                  visible: data.icon!=null,
                  child: BaseBorderContainer(
                    padding: EdgeInsets.zero,
                    innerPadding: EdgeInsets.all(Pad.pad5),
                    child:CachedNetworkImagesWidget(
                      data.icon?? '',
                      height: 24,
                      width: 24,
                      placeHolder: Images.userPlaceholderNew,
                      showLoading: true,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                SpacerHorizontal(width: 8),
                Flexible(
                  child: Visibility(
                    child: Text(
                      data.title ?? '',
                      style: styleBaseBold(fontSize: 14),
                    ),
                  ),
                ),
              ],
            ),
            Visibility(
              visible: data.value != null && data.value != '',
              child: Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Text(
                  data.value is num ? '${data.value}%' : '${data.value}',
                  style: styleBaseBold(
                    fontSize: 18,
                    color: data.color == 'red'
                        ? ThemeColors.error120
                        : data.color == 'orange'
                            ? ThemeColors.orange120
                            : data.color == 'green'
                                ? ThemeColors.success120
                                : data.value is num
                                    ? (data.value ?? 0) > 0
                                        ? ThemeColors.success120
                                        : ThemeColors.error120
                                    : ThemeColors.success120,
                  ),
                ),
              ),
            ),
            SpacerVertical(height: 5),
            Text(
              data.subTitle ?? '',
              style: styleBaseRegular(
                fontSize: 13,
                color: ThemeColors.neutral40,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
