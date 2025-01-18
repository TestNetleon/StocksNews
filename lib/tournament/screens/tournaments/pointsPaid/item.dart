import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/cache_network_image.dart';

import '../../../../utils/colors.dart';
import '../../../../widgets/spacer_horizontal.dart';
import '../../../models/leaderboard.dart';

class PointsPaidItem extends StatelessWidget {
  final LeaderboardByDateRes? data;
  const PointsPaidItem({super.key, this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: ThemeColors.background,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            data?.tournamentName ?? '',
            style: styleGeorgiaBold(),
          ),
          Row(
            children: [
              Container(
                width: 43.sp,
                height: 43.sp,
                padding: EdgeInsets.all(5),
                child: CachedNetworkImagesWidget(data?.userImage),
              ),
              const SpacerHorizontal(width: 6),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'data?.symbol',
                      style: stylePTSansRegular(fontSize: 14),
                    ),
                    Text(
                      'data?.name',
                      style: stylePTSansRegular(
                          fontSize: 12, color: ThemeColors.greyText),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
