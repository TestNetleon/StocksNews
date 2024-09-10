import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/providers/stockAnalysis/provider.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import '../../../utils/colors.dart';

class MsStockScore extends StatelessWidget {
  const MsStockScore({super.key});

  @override
  Widget build(BuildContext context) {
    MSAnalysisProvider provider = context.watch<MSAnalysisProvider>();
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: ThemeColors.greyBorder.withOpacity(0.5)),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Text(
                          "Stock Score",
                          style: stylePTSansBold(fontSize: 20),
                        ),
                        const SpacerHorizontal(width: 10),
                        const Icon(
                          Icons.info_rounded,
                          size: 20,
                          color: ThemeColors.greyBorder,
                        ),
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Row(
                      children: [
                        CircularPercentIndicator(
                          radius: 15,
                          lineWidth: 6,
                          animation: false,
                          percent: provider.stockScore.toDouble(),
                          rotateLinearGradient: true,
                          startAngle: 180,
                          circularStrokeCap: CircularStrokeCap.round,
                          linearGradient: const LinearGradient(
                            colors: [
                              Color(0xFFFF1100),
                              Colors.orange,
                              Colors.yellow,
                              Color(0xFF00FF08),
                            ],
                          ),
                          backgroundColor: Colors.transparent,
                        ),
                        const SpacerHorizontal(width: 5),
                        Text(
                          "${provider.stockScore}",
                          style: stylePTSansBold(fontSize: 30),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Divider(
              color: ThemeColors.greyBorder,
              height: 0,
            ),
            Container(
              decoration: BoxDecoration(
                color: ThemeColors.greyBorder.withOpacity(0.4),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Text(
                      "Short Term",
                      style: stylePTSansBold(
                        color: provider.scoreOn
                            ? ThemeColors.greyText
                            : ThemeColors.white,
                      ),
                    ),
                  ),
                  Switch(
                    value: provider.scoreOn,
                    inactiveThumbColor: ThemeColors.white,
                    inactiveTrackColor: ThemeColors.greyBorder,
                    activeColor: Colors.orange,
                    onChanged: provider.onChangeScore,
                  ),
                  Flexible(
                    child: Text(
                      "Long Term",
                      style: stylePTSansBold(
                        color: provider.scoreOn
                            ? ThemeColors.white
                            : ThemeColors.greyText,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
