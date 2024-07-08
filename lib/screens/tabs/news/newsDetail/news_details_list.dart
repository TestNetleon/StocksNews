import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:stocks_news_new/modals/home_insider_res.dart';
import 'package:stocks_news_new/modals/news_datail_res.dart';
import 'package:stocks_news_new/screens/tabs/news/news_item.dart';

class NewsDetailList extends StatelessWidget {
  final PostDetail? moreNewsData;
  final bool fromAI;
  const NewsDetailList({super.key, this.moreNewsData, this.fromAI = false});
//
  @override
  Widget build(BuildContext context) {
    return NewsItem(
      fromMoreNews: true,
      fromAI: fromAI,
      showCategory: moreNewsData?.authors?.isEmpty == true,
      news: News(
        authors: moreNewsData?.authors,
        slug: moreNewsData?.slug,
        title: moreNewsData?.title ?? "",
        image: moreNewsData?.image ?? "",
        site: moreNewsData?.site ?? "",
        postDateString: moreNewsData?.postDateString ?? "",
        postDate: DateFormat("MMMM dd, yyyy")
            .format(moreNewsData?.publishedDate ?? DateTime.now()),
        //  "November 29, 2023",
      ),
    );
  }
}
