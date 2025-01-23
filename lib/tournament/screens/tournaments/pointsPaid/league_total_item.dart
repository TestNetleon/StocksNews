import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/tournament/provider/tournament.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';

import 'package:stocks_news_new/widgets/cache_network_image.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import 'package:svg_flutter/svg_flutter.dart';
import '../../../../utils/colors.dart';
import '../../../../widgets/spacer_horizontal.dart';
import '../../../models/leaderboard.dart';

class LeagueTotalItem extends StatelessWidget {
  final LeaderboardByDateRes? data;
  const LeagueTotalItem({super.key, this.data});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        context.read<TournamentProvider>().leagueToLeaderboard(selectedDate: data?.date ?? "");
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          color: ThemeColors.background,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(40),
                  child: Container(
                    width: 40.sp,
                    height: 40.sp,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: ThemeColors.greyBorder)),
                    child:CachedNetworkImagesWidget(
                      data?.tournamentImage,
                    ),
                  ),
                ),
                const SpacerHorizontal(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data?.tournamentName ?? '',
                        style: styleGeorgiaBold(),
                      ),
                      const SpacerVertical(height: 3),
                      Visibility(
                        visible: data?.status != null,
                        child: Text(
                          data?.status==1?"Live":"Closed",
                          style: stylePTSansRegular(fontSize: 14,color: data?.status==1?Colors.green : Colors.red),
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  '${data?.joinUsers??0}',
                  style: styleGeorgiaBold(
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            Visibility(
              visible: data?.date!=null,
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  data?.date ?? "",
                  style: stylePTSansRegular(fontSize: 12,color:ThemeColors.greyText),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
