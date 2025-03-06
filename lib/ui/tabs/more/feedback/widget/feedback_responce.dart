import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:stocks_news_new/models/feedback_send_res.dart';
import 'package:stocks_news_new/ui/base/button.dart';
import 'package:stocks_news_new/ui/base/button_outline.dart';
import 'package:stocks_news_new/ui/base/heading.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

class FeedbackShowSheet extends StatelessWidget {
  final FeedbackSendRes? feedbackSendRes;
  final Function()? onTapKeep;
  final Function()? onTapSure;
  const FeedbackShowSheet({super.key,this.feedbackSendRes,this.onTapKeep,this.onTapSure});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Pad.pad8,vertical: Pad.pad16),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(Pad.pad16),
            child: Container(
              padding: EdgeInsets.all(Pad.pad32),
              decoration: BoxDecoration(
                color: ThemeColors.success10,
                borderRadius: BorderRadius.circular(Pad.pad16),
              ),
              child: CachedNetworkImage(
                imageUrl: feedbackSendRes?.image ?? '',
                height: 33,
                width: 33,
                color: ThemeColors.success120,
              ),
            ),
          ),
          SpacerVertical(height: 16),
          BaseHeading(
            title: feedbackSendRes?.title,
            subtitle: feedbackSendRes?.subTitle,
            crossAxisAlignment: CrossAxisAlignment.center,
            textAlign: TextAlign.center,
            titleStyle: styleBaseBold(fontSize: 28,color: ThemeColors.splashBG),
            subtitleStyle: styleBaseRegular(fontSize: 14,color: ThemeColors.neutral80),
          ),
          SpacerVertical(height: 12),
          Visibility(
            visible: feedbackSendRes?.firstButtonText!="",
            child: BaseButtonOutline(
              onPressed: onTapKeep,
              text: feedbackSendRes?.firstButtonText??"",
              textColor: ThemeColors.neutral80,
              textSize: 16,
              borderColor: ThemeColors.neutral20,
            ),
          ),
          Visibility(visible: feedbackSendRes?.firstButtonText!="",child: SpacerVertical(height:16)),
          BaseButton(
            onPressed: onTapSure,
            text: feedbackSendRes?.secondButtonText??"",
            textColor: ThemeColors.splashBG,
            color: ThemeColors.primary100,
            textSize: 16,
          ),
        ],
      ),
    );
  }
}
