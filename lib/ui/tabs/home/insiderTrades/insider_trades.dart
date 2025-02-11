import 'package:flutter/material.dart';
import 'package:stocks_news_new/ui/base/news_item.dart';
import '../../../../models/my_home.dart';
import '../../../base/heading.dart';

class HomeInsiderTradesIndex extends StatelessWidget {
  final HomeNewsRes? newsData;
  const HomeInsiderTradesIndex({super.key, this.newsData});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BaseHeading(title: newsData?.title),
        Column(
          children: List.generate(
            newsData?.data?.length ?? 0,
            (index) {
              NewsItemRes? data = newsData?.data?[index];
              if (data == null) {
                return SizedBox();
              }
              return BaseNewsItem(data: data);
            },
          ),
        )
      ],
    );
  }
}
