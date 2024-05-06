import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:stocks_news_new/screens/tabs/home/widgets/myAlerts/item.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

class HomeMyAlerts extends StatelessWidget {
  const HomeMyAlerts({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SpacerVertical(height: 15),
            Text(
              "My Alerts",
              style: stylePTSansBold(),
            ),
            const SpacerVertical(height: 10),
            SizedBox(
              height: constraints.maxWidth * 0.45,
              child: ListView.separated(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return const FittedBox(
                      alignment: Alignment.topCenter,
                      fit: BoxFit.scaleDown,
                      child: HomeMyAlertItem());
                },
                separatorBuilder: (context, index) {
                  return const SpacerHorizontal(width: 12);
                },
                itemCount: 5,
              ),
            ),
          ],
        );
      },
    );
  }
}
