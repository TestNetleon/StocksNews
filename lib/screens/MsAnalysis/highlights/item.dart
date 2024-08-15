import 'package:flutter/material.dart';

import '../../../utils/colors.dart';
import '../../../utils/theme.dart';
import '../../../widgets/spacer_horizontal.dart';
import '../../../widgets/spacer_vertical.dart';

class MsOurHighlightsItem extends StatelessWidget {
  const MsOurHighlightsItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 200),
      decoration: BoxDecoration(
        border: Border.all(color: ThemeColors.accent.withOpacity(0.5)),
        borderRadius: BorderRadius.circular(12),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: [0.4, 0.9],
          colors: [
            Color.fromARGB(255, 0, 0, 0),
            Color.fromARGB(255, 2, 58, 9),
          ],
        ),
      ),
      margin: const EdgeInsets.only(right: 10),
      padding: const EdgeInsets.symmetric(
        vertical: 12,
        horizontal: 13,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Stock Sentiment',
                style: stylePTSansRegular(
                  fontSize: 18.0,
                  color: Colors.grey,
                ),
              ),
              const SpacerHorizontal(width: 8.0),
              const Icon(Icons.ac_unit_rounded, size: 18)
            ],
          ),
          const SpacerVertical(height: 8.0),
          Text(
            'Bullish',
            style: stylePTSansBold(
              fontSize: 18.0,
              color: Colors.green,
            ),
          ),
          const SpacerVertical(height: 8.0),
          Text(
            'Buyers are optimized about the price rise, Stock is up trend',
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: stylePTSansRegular(
              fontSize: 14.0,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
