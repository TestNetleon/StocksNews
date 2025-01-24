import 'package:flutter/material.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

class GridBoxs extends StatelessWidget {
  const GridBoxs({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal:5, vertical:5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
       color: ThemeColors.gradientLight
       /* gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          transform: GradientRotation(0.9),
          colors: [
            ThemeColors.bottomsheetGradient,
            ThemeColors.accent,
          ],
        ),*/
      ),
      child:Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '18',
            style: styleGeorgiaBold(fontSize:16,color: ThemeColors.white),
            maxLines: 1,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
          ),
          const SpacerVertical(height:5),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Total Trades',
                style: styleGeorgiaRegular(fontSize:10),
              ),
              const SpacerHorizontal(width:3),
              Icon(Icons.info_rounded,size: 14)
            ],
          )

        ],
      )
    );
  }
}
