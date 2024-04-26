import 'package:flutter/material.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/screen_title.dart';
import 'package:stocks_news_new/widgets/spacer_verticle.dart';

class TwitterSentiments extends StatelessWidget {
  const TwitterSentiments({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ScreenTitle(
          title: "X Sentiment/Activity",
          style: stylePTSansRegular(fontSize: 20),
        ),
        const SpacerVerticel(),
        ScreenTitle(
          title: "Recent Tweets",
          style: stylePTSansRegular(fontSize: 20),
        ),
      ],
    );
  }
}
