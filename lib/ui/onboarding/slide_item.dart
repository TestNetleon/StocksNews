import 'package:flutter/material.dart';
import 'package:stocks_news_new/models/onboarding.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/cache_network_image.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
//MARK: Slide Item

class OnboardingSlideItem extends StatelessWidget {
  final OnboardingListRes data;
  const OnboardingSlideItem({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            SpacerVertical(height: 10),
            Visibility(
              visible: data.title != null && data.title != '',
              child: Text(
                data.title ?? '',
                style: styleGeorgiaBold(
                  color: ThemeColors.black,
                  fontSize: 28,
                ),
              ),
            ),
            Visibility(
              visible: data.subTitle != null && data.subTitle != '',
              child: Text(
                data.subTitle ?? '',
                style: styleGeorgiaRegular(
                  color: ThemeColors.black,
                  fontSize: 18,
                ),
              ),
            ),
            SpacerVertical(height: 20),
            CachedNetworkImagesWidget(data.image),
          ],
        ),
      ),
    );
  }
}
