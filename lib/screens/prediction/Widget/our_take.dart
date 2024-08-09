import 'package:flutter/material.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

class PredictionOurTake extends StatelessWidget {
  const PredictionOurTake({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GradientText(
          "Our Take",
          colors: const [
            Color.fromARGB(255, 5, 100, 8),
            Color.fromARGB(255, 5, 153, 10),
            Color.fromARGB(255, 89, 228, 93),
            Color.fromARGB(255, 133, 236, 137),
          ],
          style: styleSansBold(fontSize: 40),
        ),
        ListView.separated(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: CircleAvatar(
                    radius: 3,
                    backgroundColor: ThemeColors.white,
                  ),
                ),
                SpacerHorizontal(width: 10),
                Flexible(
                  child: Text(
                    "Revenue has significantly grown by 18.2% over same quarter last year.",
                    style: stylePTSansRegular(height: 1.5, fontSize: 17),
                  ),
                )
              ],
            );
          },
          separatorBuilder: (context, index) {
            return SpacerVertical(height: 10);
          },
          itemCount: 4,
        ),
      ],
    );
  }
}
