import 'package:flutter/material.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';

import '../../../../modals/affiliate/refer_friend_res.dart';
import '../../../../widgets/cache_network_image.dart';

class AffiliateLeaderBoardItem extends StatelessWidget {
  final AffiliateReferRes? data;

  final int index;
  const AffiliateLeaderBoardItem({super.key, required this.index, this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(5),
            decoration: const BoxDecoration(
                color: ThemeColors.accent, shape: BoxShape.circle),
            alignment: Alignment.center,
            child: Text(
              "$index",
              style: stylePTSansBold(fontSize: 10),
            ),
          ),
          SpacerHorizontal(width: index < 10 ? 10 : 5),
          Container(
            width: 43,
            height: 43,
            padding: const EdgeInsets.all(5),
            child: CachedNetworkImagesWidget(
              data?.image,
            ),
          ),
          const SpacerHorizontal(width: 5),
          Expanded(
            child: Text(
              (data?.displayName == '' || data?.displayName == null) &&
                      (data?.name == '' || data?.name == null)
                  ? "N/A"
                  : data?.displayName != '' || data?.displayName != null
                      ? "${data?.displayName}"
                      : "${data?.name}",
              style: stylePTSansRegular(),
            ),
          ),
          const SpacerHorizontal(width: 5),
          Text(
            "${data?.points}",
            style: stylePTSansRegular(),
          ),
        ],
      ),
    );
  }
}
