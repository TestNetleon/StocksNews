import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stocks_news_new/modals/highlow_pe_res.dart';
import 'package:stocks_news_new/screens/tabs/insider/insiderDetails/insider_details_item.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';

import '../../../utils/colors.dart';
import '../../../utils/theme.dart';
import '../../../widgets/spacer_vertical.dart';
import '../../../widgets/theme_image_view.dart';

class HighLowPEItem extends StatelessWidget {
  final HIghLowPeRes? data;
  const HighLowPEItem({super.key, this.data});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {},
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(0),
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    width: 43,
                    height: 43,
                    child: ThemeImageView(url: ""),
                  ),
                ),
              ),
              const SpacerHorizontal(width: 12),
              Expanded(
                child: GestureDetector(
                  onTap: () {},
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "data.symbol",
                        style: stylePTSansBold(fontSize: 14),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SpacerVertical(height: 5),
                      Text(
                        "data.name",
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
                    "data.price" ?? "",
                    style: stylePTSansBold(fontSize: 14),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SpacerVertical(height: 5),
                  Text(
                    "${"data.changesPercentage?.toCurrency()"}%",
                    style: stylePTSansRegular(
                      fontSize: 12,
                      // color: (data.changesPercentage ?? 0) > 0
                      //     ? ThemeColors.accent
                      //     : Colors.red,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
              const SpacerHorizontal(width: 10),
              InkWell(
                onTap: () {
                  // if (losers) {
                  //   provider.setOpenIndexLosers(
                  //     provider.openIndexLosers == index ? -1 : index,
                  //   );
                  // } else {
                  //   provider.setOpenIndex(
                  //     provider.openIndex == index ? -1 : index,
                  //   );
                  // }
                },
                child: Container(
                  decoration: const BoxDecoration(
                    color: ThemeColors.accent,
                  ),
                  margin: EdgeInsets.only(left: 8.sp),
                  padding: const EdgeInsets.all(3),
                  child: Icon(
                    // losers
                    //     ? provider.openIndexLosers == index
                    //         ? Icons.arrow_upward_rounded
                    //         : Icons.arrow_downward_rounded
                    //     : provider.openIndex == index
                    //         ? Icons.arrow_upward_rounded
                    //         : Icons.arrow_downward_rounded,
                    Icons.arrow_downward_rounded,
                    size: 16,
                  ),
                ),
              )
            ],
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 150),
            child: Container(
              // height: losers
              //     ? provider.openIndexLosers == index
              //         ? null
              //         : 0
              //     : provider.openIndex == index
              //         ? null
              //         : 0,
              height: 0,
              margin: EdgeInsets.only(
                  // top: losers
                  //     ? provider.openIndexLosers == index
                  //         ? 10.sp
                  //         : 0
                  //     : provider.openIndex == index
                  //         ? 10.sp
                  //         : 0,
                  top: 0,
                  // bottom: losers
                  //     ? provider.openIndexLosers == index
                  //         ? 10.sp
                  //         : 0
                  //     : provider.openIndex == index
                  //         ? 10.sp
                  //         : 0,
                  bottom: 0),
              child: Column(
                children: [
                  InnerRowItem(
                    lable: "Previous Close",
                    value: " data.previousClose",
                  ),
                  InnerRowItem(
                    lable: "Range",
                    value: "data.range",
                  ),
                  InnerRowItem(
                    lable: "Volume",
                    value: "${"data.volume"}",
                  ),
                  InnerRowItem(
                    lable: "Average Volume",
                    value: "${"data.avgVolume"}",
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
