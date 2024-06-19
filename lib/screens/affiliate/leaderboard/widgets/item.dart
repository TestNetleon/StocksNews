import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:stocks_news_new/utils/constants.dart';
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
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color.fromARGB(255, 23, 23, 23),
            // ThemeColors.greyBorder,
            Color.fromARGB(255, 39, 39, 39),
          ],
        ),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        children: [
          Text(
            "${index + 1}",
            style: stylePTSansBold(),
          ),
          SpacerHorizontal(width: index < 10 ? 10 : 5),
          Container(
            width: 60,
            height: 60,
            padding: const EdgeInsets.all(5),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: CachedNetworkImagesWidget(
                data?.image,
                placeHolder: Images.userPlaceholder,
              ),
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
