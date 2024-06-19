import 'package:flutter/material.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

import '../../../../widgets/cache_network_image.dart';
import '../../../modals/affiliate/refer_friend_res.dart';
import '../../../utils/constants.dart';

class AffiliateReferItem extends StatelessWidget {
  final AffiliateReferRes? data;
  final int index;
  const AffiliateReferItem({super.key, required this.index, this.data});

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
          // Container(
          //   padding: const EdgeInsets.all(5),
          //   decoration: const BoxDecoration(
          //       color: ThemeColors.accent, shape: BoxShape.circle),
          //   alignment: Alignment.center,
          //   child: Text(
          //     "$index",
          //     style: stylePTSansBold(fontSize: 10),
          //   ),
          // ),
          // SpacerHorizontal(width: index < 10 ? 10 : 5),
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  (data?.displayName == '' || data?.displayName == null) &&
                          (data?.name == '' || data?.name == null)
                      ? "N/A"
                      : data?.displayName != '' || data?.displayName != null
                          ? "${data?.displayName}"
                          : "${data?.name}",
                  style: stylePTSansRegular(),
                ),
                const SpacerVertical(height: 5),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: data?.status == 1
                          ? ThemeColors.accent
                          : ThemeColors.sos),
                  child: Text(
                    data?.status == 1 ? " Verified" : "Unverified",
                    style: stylePTSansRegular(fontSize: 10),
                  ),
                ),
              ],
            ),
          ),
          Text(
            "${data?.points ?? 0}",
            style: stylePTSansRegular(),
          ),
        ],
      ),
    );
  }
}
