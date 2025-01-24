import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/tournament/models/leaderboard.dart';
import 'package:stocks_news_new/tournament/provider/tournament.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/cache_network_image.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:svg_flutter/svg_flutter.dart';


class PlayTraderItem extends StatelessWidget {
  final LeaderboardByDateRes? data;
  const PlayTraderItem({super.key, this.data});

  @override
  Widget build(BuildContext context) {

    return InkWell(
      onTap: (){
        context.read<TournamentProvider>().profileRedirection(userId:"${ data?.userId ?? ""}");
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
                Visibility(
                  visible: data?.position != null,
                  child: Container(
                    margin: EdgeInsets.only(right: 5),
                    padding: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: ThemeColors.greyBorder,
                    ),
                    child: Text(
                      '${data?.position}',
                      style: styleGeorgiaBold(fontSize: 11),
                    ),
                  ),
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(40),
                  child: Container(
                    width: 40.sp,
                    height: 40.sp,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: ThemeColors.greyBorder)),
                    child: data?.imageType == "svg"
                        ? SvgPicture.network(
                      fit: BoxFit.cover,
                      data?.userImage ?? "",
                      placeholderBuilder: (BuildContext context) =>
                          Container(
                            padding: const EdgeInsets.all(30.0),
                            child: const CircularProgressIndicator(
                              color: ThemeColors.accent,
                            ),
                          ),
                    )
                        : CachedNetworkImagesWidget(
                      data?.userImage,
                    ),
                  ),
                ),
                const SpacerHorizontal(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Visibility(
                        visible: data?.userName != null,
                        child: Text(
                          data?.userName ?? "",
                          style: stylePTSansRegular(fontSize: 14),
                        ),
                      ),
                      Visibility(
                        visible: data?.rank != null,
                        child: Text(
                          data?.rank ?? 'N/A',
                          style: styleGeorgiaRegular(
                              color: ThemeColors.greyText, fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                ),
                Visibility(
                  visible: data?.totalPoints != null,
                  child: Text(
                    '${data?.totalPoints}',
                    style: styleGeorgiaBold(
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            Visibility(
              visible: data?.performance!=null,
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  "${data?.performance??"0"}%",
                  style: stylePTSansRegular(fontSize: 12, color: (data?.performance ?? 0) > 0 ? Colors.green : Colors.red,),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
