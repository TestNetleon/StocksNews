import 'package:flutter/material.dart';
import 'package:stocks_news_new/screens/stockDetails/widgets/redditComments/reddit_comments.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/screen_title.dart';

class RedditSentiments extends StatelessWidget {
  const RedditSentiments({super.key});
//
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // ScreenTitle(
        //   title: "Reddit Sentiment/Activity",
        //   style: stylePTSansRegular(fontSize: 20),
        // ),
        // const SpacerVerticel(),
        ScreenTitle(
          title: "Recent Reddit Comments",
          style: stylePTSansRegular(fontSize: 20),
        ),
        const RedditComments(),
      ],
    );
  }
}
