import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:stocks_news_new/models/delete_data.dart';
import 'package:stocks_news_new/ui/base/button.dart';
import 'package:stocks_news_new/ui/base/button_outline.dart';
import 'package:stocks_news_new/ui/base/heading.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

class StockDeleteItem extends StatelessWidget {
  final DeleteBoxRes? deleteDataRes;
  final Function()? onTapKeep;
  final Function()? onTapRemove;
  const StockDeleteItem(
      {super.key, this.deleteDataRes, this.onTapKeep, this.onTapRemove});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.symmetric(horizontal: Pad.pad8, vertical: Pad.pad16),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(Pad.pad16),
            child: Container(
              padding: EdgeInsets.all(Pad.pad32),
              decoration: BoxDecoration(
                color: ThemeColors.neutral5,
                borderRadius: BorderRadius.circular(Pad.pad16),
              ),
              child: CachedNetworkImage(
                imageUrl: deleteDataRes?.icon ?? '',
                height: 33,
                width: 33,
                color: ThemeColors.neutral60,
              ),
            ),
          ),
          SpacerVertical(height: 16),
          BaseHeading(
            title: deleteDataRes?.title,
            subtitle: deleteDataRes?.subTitle,
            crossAxisAlignment: CrossAxisAlignment.center,
            textAlign: TextAlign.center,
            titleStyle:
                styleBaseBold(fontSize: 28, color: ThemeColors.splashBG),
            subtitleStyle:
                styleBaseRegular(fontSize: 14, color: ThemeColors.neutral80),
          ),
          SpacerVertical(height: 12),
          BaseButtonOutline(
            onPressed: onTapKeep,
            text: deleteDataRes?.btnCancelText ?? "",
            textColor: ThemeColors.neutral20,
            textSize: 16,
            borderColor: ThemeColors.neutral40,
          ),
          SpacerVertical(height: 16),
          BaseButton(
            onPressed: onTapRemove,
            text: deleteDataRes?.btnConfirmText ?? "",
            textColor: ThemeColors.white,
            color: ThemeColors.error120,
            textSize: 16,
          ),
        ],
      ),
    );
  }
}
