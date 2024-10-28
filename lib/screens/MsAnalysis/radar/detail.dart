import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/theme.dart';

import '../../../widgets/spacer_vertical.dart';

class RadarChartDetail extends StatelessWidget {
  final String label;
  final String value;
  final String description;

  const RadarChartDetail({
    super.key,
    required this.label,
    required this.value,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [ThemeColors.bottomsheetGradient, Colors.black],
        ),
        color: ThemeColors.background,
        border: const Border(
          top: BorderSide(color: ThemeColors.greyBorder),
        ),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: styleGeorgiaBold(fontSize: 30),
          ),
          Divider(
            color: ThemeColors.greyBorder,
            thickness: 1,
          ),
          // Text(
          //   "Performance: $value%",
          //   style: styleGeorgiaRegular(fontSize: 18),
          // ),
          HtmlWidget(
            description,
            // textStyle: styleGeorgiaRegular(
            //   fontSize: 15,
            //   height: 1.5,
            // ),
          ),
          SpacerVertical(height: 30),
        ],
      ),
    );
  }
}
