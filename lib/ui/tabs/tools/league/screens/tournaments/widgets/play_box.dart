import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:stocks_news_new/ui/base/button.dart';
import 'package:stocks_news_new/ui/base/heading.dart';
import 'package:stocks_news_new/ui/tabs/tools/league/models/league_detail.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/cache_network_image.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';


class PlayBoxLeague extends StatelessWidget {
  final String title;
  final String? imageUrl;
  final String? description;
  final String? pointText;
  final String points;
  final VoidCallback onButtonTap;
  final String buttonText;
  final Color gradientStartColor;
  final Color gradientEndColor;
  final Color? buttonColor;
  final bool buttonVisibility;
  final List<LeaguePointRes>? tournamentPoints;

  const PlayBoxLeague({
    super.key,
    required this.title,
    this.imageUrl,
    this.description,
    this.pointText,
    required this.points,
    required this.onButtonTap,
    required this.buttonText,
    this.gradientStartColor = Colors.purple,
    this.gradientEndColor = Colors.lightBlue,
    this.buttonColor,
    this.buttonVisibility = true,
    this.tournamentPoints,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: Pad.pad16, vertical: Pad.pad20),
      margin: const EdgeInsets.symmetric(horizontal: Pad.pad16),
      decoration: BoxDecoration(
        color: ThemeColors.colour29.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: ThemeColors.neutral5)
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (pointText != null)
                Text(
                  pointText ?? '',
                  textAlign: TextAlign.start,
                  style: styleBaseRegular(
                      fontSize: 16,
                      color: ThemeColors.neutral80
                  ),
                ),
              SpacerHorizontal(width: Pad.pad16),
              Container(
                padding: const EdgeInsets.symmetric(horizontal:Pad.pad10, vertical:Pad.pad5),
                decoration: BoxDecoration(
                  color: ThemeColors.colour37.withValues(alpha: 0.2),
                  border: Border.all(color: ThemeColors.colour37),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      Images.pointIcon2,
                      height: 25,
                      width: 25,
                    ),
                    SpacerHorizontal(width: Pad.pad5),
                    Text(
                      points,
                      textAlign: TextAlign.start,
                      style: styleBaseBold(
                          fontSize: 22,
                          color: ThemeColors.colour37
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SpacerVertical(),
          if (imageUrl != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(Pad.pad16),
              child: SizedBox(
                child: CachedNetworkImagesWidget(
                  imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          SpacerVertical(),
          BaseHeading(
            crossAxisAlignment: CrossAxisAlignment.start,
            textAlign: TextAlign.start,
            title: title,
            titleStyle:  styleBaseBold(
              fontSize: 25,
              color: ThemeColors.black
            ),
            margin: EdgeInsets.zero,
          ),
          SpacerVertical(height: 5),
          Visibility(
            visible: description != null && description != '',
            child: HtmlWidget(
              description ?? '',
              textStyle: styleBaseRegular(
                fontSize: 14,
                  color: ThemeColors.black
              ),
            ),
          ),
          SpacerVertical(height:10),
          Visibility(
            visible: tournamentPoints!=null,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: List.generate(tournamentPoints?.length??0, (index) {
                  final price = tournamentPoints![index];
                  Color bgColor;
                  if (price.points == 500) {
                    bgColor = ThemeColors.gold;
                  } else if (price.points == 300) {
                    bgColor = ThemeColors.silver;
                  } else {
                    bgColor = ThemeColors.bronze;
                  }

                  Color bgInnerColor;
                  if (price.points == 500) {
                    bgInnerColor = ThemeColors.darkGold;
                  } else if (price.points == 300) {
                    bgInnerColor = ThemeColors.greyBorder;
                  } else {
                    bgInnerColor = ThemeColors.brown;
                  }

                  return Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal:Pad.pad24,vertical:8),
                        decoration: BoxDecoration(
                          color: bgColor,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              padding: EdgeInsets.all(Pad.pad5),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(Pad.pad5),
                                color:bgInnerColor,
                              ),
                              child: Text(
                                '#${index + 1}',
                                style:styleBaseBold(
                                  fontSize:10,
                                    color: Colors.white
                                ),
                              ),
                            ),
                            const SpacerHorizontal(width: Pad.pad5),
                            Text(
                              '${price.points??""}',
                              style: styleBaseBold(
                                fontSize:18,
                                  color: ThemeColors.black
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                }),
          )
          ),
          SpacerVertical(height: Pad.pad10),
          Visibility(
            visible: buttonVisibility,
            child: BaseButton(
              color: buttonColor,
              text: buttonText,
              fontBold: true,
              onPressed: onButtonTap,
              textColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
