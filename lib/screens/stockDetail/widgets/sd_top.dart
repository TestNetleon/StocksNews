import 'package:flutter/material.dart';
import 'package:stocks_news_new/modals/stockDetailRes/earnings.dart';

import '../../../utils/colors.dart';
import '../../../utils/theme.dart';

class SdTopCard extends StatelessWidget {
  final SdTopRes? top;
  const SdTopCard({super.key, this.top});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 4),
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: ThemeColors.greyBorder.withOpacity(0.1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Visibility(
                visible: top?.key != null,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Text(
                    "${top?.key?.toUpperCase()}",
                    textAlign: TextAlign.center,
                    style: stylePTSansRegular(fontSize: 12),
                  ),
                ),
              ),
              Visibility(
                visible: top?.value != null,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Text(
                    "${top?.value}",
                    style: styleGeorgiaBold(fontSize: 20),
                  ),
                ),
              ),
              Visibility(
                visible: top?.other != null,
                child: Text(
                  "${top?.other}",
                  style: stylePTSansRegular(fontSize: 12),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          left: 5,
          right: 5,
          bottom: 0,
          child: Container(
            height: 4,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(5),
                  bottomRight: Radius.circular(5)),
              color: ThemeColors.accent,
            ),
          ),
        ),
      ],
    );
  }
}
