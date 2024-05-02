import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/modals/trending_res.dart';
import 'package:stocks_news_new/providers/trending_provider.dart';
import 'package:stocks_news_new/screens/tabs/trending/widgets/trending_sectors_item.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

class TrendingSectors extends StatelessWidget {
  const TrendingSectors({super.key});

  @override
  Widget build(BuildContext context) {
    TrendingRes? data = context.read<TrendingProvider>().trendingStories;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ColoredText(
        //   text: "Trending Sectors",
        //   coloredLetters: const ["S"],
        //   style: stylePTSansBold(),
        // ),
        // Text(
        //   "Trending Sectors",
        //   style: stylePTSansBold(fontSize: 14),
        // ),
        // const SpacerVertical(height: 5),
        // Text(
        //   "Top trending sectors in online chatter, Past 7 days",
        //   style: stylePTSansRegular(fontSize: 12),
        // ),
        // const ScreenTitle(
        //   title: "Trending Sectors",
        //   subTitle: "Top trending sectors in online chatter, Past 7 days",
        // ),
        Text(
          "Top trending sectors in online chatter, Past 7 days",
          style: stylePTSansRegular(fontSize: 13, color: ThemeColors.greyText),
        ),
        const SpacerVertical(),
        ListView.separated(
          itemCount: data?.sectors?.length ?? 0,
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, index) {
            Sector sectorData = (data?.sectors![index])!;
            if (index == 0) {
              return Column(
                children: [
                  const TrendingSectorItemHeader(),
                  const SpacerVertical(height: 10),
                  TrendingSectorItem(data: sectorData),
                ],
              );
            }
            return TrendingSectorItem(data: sectorData);
          },
          separatorBuilder: (BuildContext context, int index) {
            // return const SpacerVertical(height: 8);
            return const Divider(
              color: ThemeColors.greyBorder,
              height: 15,
            );
          },
        ),
        // const SpacerVertical(height: Dimen.itemSpacing),
        // Align(
        //   alignment: Alignment.centerLeft,
        //   child: ThemeButtonSmall(
        //     onPressed: () {},
        //     text: "View All",
        //   ),
        // )
      ],
    );
  }
}

class TrendingSectorItemHeader extends StatelessWidget {
  const TrendingSectorItemHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, cnts) {
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 0.sp),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: cnts.maxWidth * .5,
                child: Container(
                  margin: EdgeInsets.only(left: 37.sp),
                  child: Text(
                    "Sectors",
                    style: stylePTSansBold(
                      fontSize: 14,
                      color: ThemeColors.greyText,
                    ),
                  ),
                ),
              ),
              const SpacerHorizontal(width: 10),
              Expanded(
                flex: 2,
                child: Text(
                  "Type",
                  style: stylePTSansBold(
                    fontSize: 14,
                    color: ThemeColors.greyText,
                  ),
                  // textAlign: TextAlign.center,
                ),
              ),
              const SpacerHorizontal(),
              Text(
                "Mentions",
                style: stylePTSansBold(
                  fontSize: 14,
                  color: ThemeColors.greyText,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        );
      },
    );
  }
}
