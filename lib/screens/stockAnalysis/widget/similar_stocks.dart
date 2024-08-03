import 'package:flutter/material.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

class SimilarWidget extends StatelessWidget {
  const SimilarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Silimilar ',
            style: stylePTSansBold(fontSize: 16.0, color: Colors.white)),
        SpacerVertical(
          height: 10,
        ),
      ],
    );
  }
}
