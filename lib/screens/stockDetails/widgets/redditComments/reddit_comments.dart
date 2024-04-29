import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/modals/stock_details_mentions_res.dart';
import 'package:stocks_news_new/providers/stock_detail_provider.dart';
import 'package:stocks_news_new/widgets/spacer_verticle.dart';

import 'item.dart';

class RedditComments extends StatelessWidget {
  const RedditComments({super.key});
//
  @override
  Widget build(BuildContext context) {
    List<RedditPost>? data =
        context.watch<StockDetailProvider>().dataMentions?.redditPost;

    return ListView.separated(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (context, index) {
          if (data == null || data.isEmpty) {
            return const SizedBox();
          }
          return RedditCommentItem(
            index: index,
            redditPost: data[index],
          );
        },
        separatorBuilder: (context, index) {
          return const SpacerVerticel(height: 15);
        },
        itemCount: data?.length ?? 0);
  }
}
