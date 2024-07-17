import 'package:flutter/material.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';

class FeaturedWatchlistTitle extends StatelessWidget {
  final String? title;
  final Function()? onTap;
  const FeaturedWatchlistTitle({super.key, this.title, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Text(
            title ?? "",
            style: stylePTSansBold(),
          ),
        ),
        InkWell(
          onTap: onTap,
          child: Row(
            children: [
              Text(
                "View All",
                style: stylePTSansBold(fontSize: 12),
              ),
              const SpacerHorizontal(width: 5),
              const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 15,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
