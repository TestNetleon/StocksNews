import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/tournament/models/tournament.dart';
import 'package:stocks_news_new/routes/my_app.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/widgets/cache_network_image.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/theme_button.dart';
import '../../../../utils/colors.dart';
import '../../../../utils/theme.dart';
import '../../../../widgets/spacer_vertical.dart';
import '../../../provider/tournament.dart';
import '../dayTraining/index.dart';

class TournamentGrids extends StatelessWidget {
  const TournamentGrids({super.key});

  _onTap(index, int? id) {
    if (index == 0) {
      Navigator.push(
        navigatorKey.currentContext!,
        MaterialPageRoute(
          builder: (context) => TournamentDayTrainingIndex(
            tournamentId: id,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    TournamentProvider provider = context.watch<TournamentProvider>();

    return ListView.separated(
      padding: EdgeInsets.only(top: 12),
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        TournamentDataRes? data = provider.data?.tournaments?[index];

        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.purple,
                Colors.lightBlue,
              ],
            ),
          ),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            margin: EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.white,
            ),
            child: Column(
              children: [
                Stack(
                  children: [
                    Opacity(
                      opacity: 0.8,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: SizedBox(
                          // height: 140.sp,
                          child: CachedNetworkImagesWidget(
                            data?.image,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 10,
                      bottom: 10,
                      child: Text(
                        data?.name ?? '',
                        textAlign: TextAlign.start,
                        style: styleGeorgiaBold(
                          fontSize: 25,
                          color: Colors.purple,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 10,
                      right: 10,
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: ThemeColors.background,
                          border: Border.all(color: Colors.purple, width: 1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              data?.pointText ?? '',
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
                                  '${data?.point ?? 0}',
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
                    ),
                  ],
                ),
                SpacerVertical(height: 5),
                Visibility(
                  visible: data?.description != null && data?.description != '',
                  child: HtmlWidget(
                    data?.description ?? '',
                    textStyle: styleGeorgiaBold(
                      fontSize: 14,
                      color: ThemeColors.blackShade,
                    ),
                  ),
                ),
                SpacerVertical(height: 5),
                Align(
                  alignment: Alignment.centerRight,
                  child: ThemeButton(
                    radius: 30,
                    color: Colors.lightBlue,
                    // showArrow: false,

                    text: 'Play Game',
                    fontBold: true,
                    onPressed: () {
                      _onTap(
                        index,
                        data?.tournamentId,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
      separatorBuilder: (context, index) {
        return SpacerVertical(height: 10);
      },
      itemCount: provider.data?.tournaments?.length ?? 0,
    );
  }
}
