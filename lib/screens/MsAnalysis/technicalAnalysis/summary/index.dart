import 'package:flutter/cupertino.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import '../../overviewTabs/view/widgets/sliding_button.dart';

class MsMetricsSummary extends StatefulWidget {
  const MsMetricsSummary({
    super.key,
  });

  @override
  State<MsMetricsSummary> createState() => _MsMetricsSummaryState();
}

class _MsMetricsSummaryState extends State<MsMetricsSummary> {
  List<String> menus = [
    'Summary',
    'Details',
  ];

  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomSlidingSegmentedControl(
          menus: menus,
          onValueChanged: (index) {
            setState(() {
              selectedIndex = index;
            });
          },
          selectedIndex: selectedIndex,
        ),
        SpacerVertical(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _widgetText(
              title: "Open",
              subtitle: "33.33",
              crossAxisAlignment: CrossAxisAlignment.start,
            ),
            SpacerHorizontal(width: 5),
            _widgetText(title: "Low", subtitle: "33.33"),
            SpacerHorizontal(width: 5),
            _widgetText(
              title: "High",
              subtitle: "33.33",
              crossAxisAlignment: CrossAxisAlignment.end,
            ),
          ],
        ),
        SpacerVertical(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _widgetText(
              title: "Volume",
              subtitle: "33.33",
              crossAxisAlignment: CrossAxisAlignment.start,
            ),
            SpacerHorizontal(width: 5),
            _widgetText(title: "Avg. Volume", subtitle: "33.33"),
            SpacerHorizontal(width: 5),
            _widgetText(
              title: "Market Cap",
              subtitle: "33.33",
              crossAxisAlignment: CrossAxisAlignment.end,
            ),
          ],
        ),
        SpacerVertical(height: 5),
      ],
    );
  }

  Widget _widgetText(
      {String? title,
      String? subtitle,
      CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center}) {
    return Expanded(
      child: Column(
        crossAxisAlignment: crossAxisAlignment,
        children: [
          Text(
            "$title",
            style: styleGeorgiaBold(
              color: ThemeColors.background,
            ),
          ),
          Text(
            "$subtitle",
            style: stylePTSansRegular(
              color: ThemeColors.background,
            ),
          ),
        ],
      ),
    );
  }
}
