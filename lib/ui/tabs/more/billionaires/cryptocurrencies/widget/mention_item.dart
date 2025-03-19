import 'package:flutter/material.dart';
import 'package:stocks_news_new/models/billionaires_res.dart';
import 'package:stocks_news_new/ui/base/color_container.dart';
import 'package:stocks_news_new/ui/base/heading.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/cache_network_image.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

class MentionItem extends StatelessWidget {
  final CryptoTweetPost? item;
  final Function()? onTap;
  const MentionItem({super.key, this.item, this.onTap});

  @override
  Widget build(BuildContext context) {
    return BaseColorContainer(
      bgColor: ThemeColors.neutral5.withValues(alpha: 0.2),
      onTap: onTap,
      child: Row(
        children: [
          Visibility(
            visible: item?.image != null,
            child: Container(
              padding: EdgeInsets.all(Pad.pad5),
              decoration: BoxDecoration(
                  border: Border.all(color: ThemeColors.secondary120, width: 1),
                  shape: BoxShape.circle),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(60),
                child: CachedNetworkImagesWidget(
                  item?.image ?? '',
                  height: 60,
                  width: 60,
                  placeHolder: Images.userPlaceholderNew,
                  showLoading: true,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          SpacerHorizontal(width: Pad.pad16),
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Visibility(
                visible: item?.name != null,
                child: Text(
                  item?.name ?? "",
                  style:
                      styleBaseBold(fontSize: 20, color: ThemeColors.splashBG),
                ),
              ),
              SpacerVertical(height: Pad.pad8),
              BaseColorContainer(
                  padding: EdgeInsets.symmetric(
                      horizontal: Pad.pad8, vertical: Pad.pad5),
                  bgColor: ThemeColors.neutral5,
                  child: Text(
                    "Mentions - ${item?.totalMentions ?? ""}",
                    style:
                        styleBaseBold(fontSize: 14, color: ThemeColors.black),
                  ))
            ],
          )),
          Visibility(
            visible: item?.symbols != null || item?.symbols?.isNotEmpty == true,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(
                item!.symbols!.length,
                (index) {
                  Symbols items = item!.symbols![index];
                  return Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(24),
                        child: CachedNetworkImagesWidget(
                          items.image ?? '',
                          height: 24,
                          width: 24,
                          placeHolder: Images.userPlaceholderNew,
                          showLoading: true,
                          fit: BoxFit.contain,
                        ),
                      ),
                      SpacerHorizontal(width: Pad.pad3),
                      BaseHeading(
                        title: "${items.count ?? ""}",
                        titleStyle: styleBaseBold(
                            fontSize: 12, color: ThemeColors.neutral40),
                      )
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
