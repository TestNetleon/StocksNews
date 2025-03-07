import 'package:flutter/material.dart';
import 'package:stocks_news_new/models/market/industries_view_res.dart';
import 'package:stocks_news_new/ui/base/border_container.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

class HeaderItem extends StatelessWidget {
  final HeaderRes? header;
  const HeaderItem({super.key,this.header});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal:Pad.pad10),
      child: BaseBorderContainer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              header?.title ?? "",
              style: stylePTSansRegular(fontSize: 16,color: ThemeColors.splashBG),
            ),
            SpacerVertical(height: Pad.pad10),
            Text(
              header?.totalMentions?.title ?? "",
              style: stylePTSansBold(fontSize:28,color: header?.totalMentions?.colour == 1
              ? ThemeColors.success
                  : ThemeColors.error120,),
            ),
            SpacerVertical(height: Pad.pad16),
            Visibility(
              visible: header?.mentions!=null || header?.mentions?.isNotEmpty == true,
              child: SingleChildScrollView(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    header!.mentions!.length,
                        (index) {
                          TotalMentions items= header!.mentions![index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: Pad.pad8),
                        child: Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  color: items.colour == 1
                                      ? ThemeColors.success:
                                  items.colour == 0
                                      ? ThemeColors.category100:
                                       ThemeColors.error120,
                                  borderRadius: BorderRadius.circular(Pad.pad2)
                              ),
                              padding: EdgeInsets.all(Pad.pad8),

                            ),
                            SpacerHorizontal(width: Pad.pad8),
                            Text(
                              items.title ?? "",
                              style: stylePTSansRegular(fontSize: 14,color: ThemeColors.splashBG),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
