import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:stocks_news_new/models/tools.dart';
import 'package:stocks_news_new/ui/base/button.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

class ToolsItem extends StatelessWidget {
  final ToolsCardsRes? card;
  final Function()? onTap;
  const ToolsItem({super.key, this.card, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(Pad.pad16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: ThemeColors.neutral10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Visibility(
            visible: card?.image != null && card?.image != '',
            child: Container(
              height: 48,
              width: 48,
              margin: const EdgeInsets.only(top: 40),
              decoration: BoxDecoration(
                color: ThemeColors.neutral5,
                borderRadius: BorderRadius.circular(8),
              ),
              padding: EdgeInsets.all(12),
              child: CachedNetworkImage(imageUrl: card?.image ?? ''),
            ),
          ),
          Visibility(
            visible: card?.title != null && card?.title != '',
            child: Padding(
              padding: const EdgeInsets.only(top: 40),
              child: Text(
                textAlign: TextAlign.center,
                card?.title ?? '',
                style: styleBaseBold(fontSize: 22),
              ),
            ),
          ),
          Visibility(
            visible: card?.subTitle != null && card?.subTitle != '',
            child: Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                textAlign: TextAlign.center,
                card?.subTitle ?? '',
                style: styleBaseRegular(
                  fontSize: 16,
                  color: ThemeColors.neutral80,
                ),
              ),
            ),
          ),
          SpacerVertical(height: 40),
          BaseButton(
            text: card?.buttonText ?? '',
            onPressed: onTap,
            color: ThemeColors.white,
            textColor: ThemeColors.secondary100,
            side: BorderSide(color: ThemeColors.secondary120),
          ),
        ],
      ),
    );
  }
}
