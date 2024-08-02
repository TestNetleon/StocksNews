import 'package:flutter/material.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

class SummaryErrorWidget extends StatelessWidget {
  final String title;
  final String? error;

  const SummaryErrorWidget({
    super.key,
    this.title = "Title",
    this.error,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Text(
              title,
              style: stylePTSansBold(fontSize: 20),
            ),
            const SpacerVertical(height: 15),
            Text(
              error ??
                  "Use the opportunity to trade on the world's major financial markets",
              style: stylePTSansRegular(),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
