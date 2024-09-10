import 'package:flutter/material.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

class MsPerformanceFooter extends StatelessWidget {
  const MsPerformanceFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 36, 32, 32),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(10.0),
          bottomRight: Radius.circular(10.0),
        ),
      ),
      padding: const EdgeInsets.all(12.0),
      child: IntrinsicHeight(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _widget(
              label: 'Open Price',
              value: '341',
            ),
            SizedBox(
              height: 30,
              child: VerticalDivider(
                color: Colors.grey,
                thickness: 2,
              ),
            ),
            _widget(
              label: 'Prev. Close',
              value: '341.8',
            ),
            SizedBox(
              height: 30,
              child: VerticalDivider(
                color: Colors.grey,
                thickness: 2,
                // indent: 3/
              ),
            ),
            _widget(
              label: 'Volume',
              value: '42,390',
            ),
          ],
        ),
      ),
    );
  }

  Widget _widget({
    required String label,
    required String value,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
  }) {
    return Flexible(
      child: Column(
        crossAxisAlignment: crossAxisAlignment,
        children: [
          Text(
            label,
            style: stylePTSansRegular(
              fontSize: 14.0,
              color: Colors.grey,
            ),
          ),
          SpacerVertical(height: 8.0),
          Text(
            value,
            style: stylePTSansRegular(
              fontSize: 14.0,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
