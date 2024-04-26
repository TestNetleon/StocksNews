import 'package:flutter/material.dart';
import 'package:stocks_news_new/screens/tabs/reddit_twitter/widgets/days.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_verticle.dart';

class RedditTwitterContent extends StatelessWidget {
  final Widget widget;
  final Widget? topWidget;
  const RedditTwitterContent({super.key, required this.widget, this.topWidget});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            topWidget ?? const SizedBox(),
            const SpacerVerticel(),
            // RedditTwitterButtons(constraints: constraints),
            // const SpacerVerticel(height: 8),
            Text(
              "SHOW THE LAST - ",
              style: stylePTSansBold(fontSize: 12),
            ),
            RedditTwitterDays(constraints: constraints),
            widget,
          ],
        );
      },
    );
  }
}
