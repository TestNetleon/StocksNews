import 'package:flutter/material.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

import '../../../../utils/colors.dart';
import '../../../../utils/theme.dart';
import '../../../../widgets/cache_network_image.dart';

class CompareNewPopularItem extends StatelessWidget {
  const CompareNewPopularItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        InkWell(
          onTap: () {},
          child: Row(
            children: List.generate(2, (index) {
              return Expanded(
                child: Ink(
                  padding: const EdgeInsets.fromLTRB(5, 5, 5, 10),
                  decoration: BoxDecoration(
                      border: Border(
                    bottom: BorderSide(
                      color: ThemeColors.greyBorder.withOpacity(0.3),
                    ),
                    top: BorderSide(
                      color: ThemeColors.greyBorder.withOpacity(0.3),
                    ),
                    right: BorderSide(
                      color: ThemeColors.greyBorder.withOpacity(0.3),
                    ),
                    left: index == 0
                        ? BorderSide(
                            color: ThemeColors.greyBorder.withOpacity(0.3),
                          )
                        : BorderSide.none,
                  )),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SpacerVertical(height: 10),
                      const SizedBox(
                        height: 35,
                        width: 35,
                        child: CachedNetworkImagesWidget(
                            "https://financialmodelingprep.com/image-stock/AAPL.png"),
                      ),
                      const SpacerVertical(height: 5),
                      Text(
                        "SYMBOL",
                        maxLines: 1,
                        textAlign: TextAlign.center,
                        style: stylePTSansRegular(),
                      ),
                      const SpacerVertical(height: 5),
                      Text(
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        "ticker name",
                        style: stylePTSansRegular(
                            fontSize: 11, color: ThemeColors.greyText),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
        Container(
          padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Color.fromARGB(255, 44, 44, 44),
          ),
          child: Text(
            "VS",
            style: stylePTSansRegular(color: ThemeColors.sos, fontSize: 8),
          ),
        ),
      ],
    );
  }
}
