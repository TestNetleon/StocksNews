import 'package:flutter/material.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

import '../../../../widgets/cache_network_image.dart';
import '../../../modals/affiliate/refer_friend_res.dart';

class AffiliateReferItem extends StatelessWidget {
  final AffiliateReferRes? data;
  final int index;
  const AffiliateReferItem({super.key, required this.index, this.data});

  @override
  Widget build(BuildContext context) {
    return Row(
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
          width: 43,
          height: 43,
          padding: const EdgeInsets.all(5),
          child: CachedNetworkImagesWidget(
            data?.image,
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
    );
  }
}
