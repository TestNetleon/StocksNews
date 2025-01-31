import 'package:flutter/material.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

import '../../../../utils/theme.dart';

class InfoBox extends StatelessWidget {
  final String label;
  final String value;
  final num values;
  const InfoBox({super.key, required this.label, required this.value,required this.values});

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Column(
      children: [
        Text(
          label,
          style: styleGeorgiaRegular(fontSize: 13),
          maxLines: 2,
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
        ),
        const SpacerVertical(height:5),
        Text(
          value,
          style:
          label=="Exp."?
          styleGeorgiaBold(
              fontSize: 18,
          ):
          styleGeorgiaBold(
            fontSize: 18,
            color:(values ?? 0) > 0
              ? ThemeColors.themeGreen
              : (values ?? 0) == 0
              ? ThemeColors.white
              : ThemeColors.darkRed
          ),
          textAlign: TextAlign.center,
        ),
      ],
    ));
  }
}
