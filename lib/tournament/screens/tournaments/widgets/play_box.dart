import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:stocks_news_new/tournament/models/tournament_detail.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/cache_network_image.dart';
import 'package:stocks_news_new/widgets/screen_title.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import 'package:stocks_news_new/widgets/theme_button.dart';

class PlayBoxTournament extends StatelessWidget {
  final String title;
  final String? imageUrl;
  final String? description;
  final String? pointText;
  final String points;
  final VoidCallback onButtonTap;
  final String buttonText;
  final Color gradientStartColor;
  final Color gradientEndColor;
  final Color buttonColor;
  final bool buttonVisibility;
  final List<TournamentPointRes>? tournamentPoints;

  const PlayBoxTournament({
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
    this.buttonColor = Colors.lightBlue,
    this.buttonVisibility = true,
    this.tournamentPoints,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            gradientStartColor,
            gradientEndColor,
          ],
        ),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
        ),
        child: Column(
          children: [
            Stack(
              alignment: Alignment.bottomCenter,
              children: [
                if (imageUrl != null)
                  Opacity(
                    opacity: 0.8,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: SizedBox(
                        // height: 140.sp,
                        child: CachedNetworkImagesWidget(
                          imageUrl,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: ThemeColors.background,
                          border: Border.all(color: Colors.purple, width: 1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (pointText != null)
                              Text(
                                pointText ?? '',
                                textAlign: TextAlign.start,
                                style: styleGeorgiaBold(
                                  color: ThemeColors.greyText,
                                  fontSize: 13,
                                ),
                              ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Image.asset(
                                  Images.pointIcon2,
                                  height: 25,
                                  width: 25,
                                ),
                                SpacerHorizontal(width: 5),
                                Text(
                                  points,
                                  textAlign: TextAlign.start,
                                  style: styleGeorgiaBold(
                                    fontSize: 25,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
            SpacerVertical(height: 5),
            ScreenTitle(
              title: title,
              style:  styleGeorgiaBold(
                fontSize: 25,
                color: ThemeColors.primary,
              ),
              dividerPadding: EdgeInsets.zero,
            ),
           // SpacerVertical(height: 5),
            Visibility(
              visible: description != null && description != '',
              child: HtmlWidget(
                description ?? '',
                textStyle: styleGeorgiaRegular(
                  fontSize: 14,
                  color: ThemeColors.primaryLight,
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

                    return Row(
                      children: [
                        Container(

                          padding: EdgeInsets.symmetric(horizontal:20,vertical:8),
                          decoration: BoxDecoration(
                            color: bgColor,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                padding: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                ),
                                child: Text(
                                  '#${index + 1}',
                                  style:styleGeorgiaBold(
                                    fontSize:14,
                                    color: ThemeColors.primary,
                                  ),
                                ),
                              ),
                              const SpacerHorizontal(width: 5),
                              Text(
                                '${price.points??""}',
                                style: styleGeorgiaBold(
                                  fontSize:18,
                                  color: ThemeColors.primary,
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
            SpacerVertical(height:10),
            Visibility(
              visible: buttonVisibility,
              child: Align(
                alignment: Alignment.centerRight,
                child: ThemeButton(
                  radius: 30,
                  color: buttonColor,
                  text: buttonText,
                  fontBold: true,
                  onPressed: onButtonTap,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
