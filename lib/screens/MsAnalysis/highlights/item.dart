import 'package:flutter/material.dart';
import '../../../modals/msAnalysis/radar_chart.dart';
import '../../../utils/colors.dart';
import '../../../utils/theme.dart';
import '../../../widgets/spacer_vertical.dart';

class MsOurHighlightsItem extends StatelessWidget {
  final MsRadarChartRes? data;
  const MsOurHighlightsItem({super.key, this.data});

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
                data?.label ?? "N/A",
                style: stylePTSansRegular(
                  fontSize: 18.0,
                  color: Colors.grey,
                ),
              ),
              // const SpacerHorizontal(width: 8.0),
              // GestureDetector(
              //   onTap: () {
              //     msShowBottomSheet();
              //   },
              //   child: const Icon(
              //     Icons.info,
              //     size: 18,
              //     color: ThemeColors.greyText,
              //   ),
              // )
            ],
          ),
          const SpacerVertical(height: 8.0),
          Text(
            "${data?.value}",
            style: stylePTSansBold(
              fontSize: 18.0,
              color: data?.valueColor == 'red'
                  ? Colors.red
                  : data?.valueColor == 'orange'
                      ? Colors.orange
                      : data?.valueColor == 'green'
                          ? ThemeColors.accent
                          : data?.value is num
                              ? (data?.value ?? 0) > 0
                                  ? Colors.green
                                  : Colors.red
                              : ThemeColors.accent,
            ),
          ),
          const SpacerVertical(height: 8.0),
          Text(
            "${data?.description}",
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
