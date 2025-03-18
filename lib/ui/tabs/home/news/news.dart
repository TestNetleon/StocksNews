import 'package:flutter/material.dart';
import 'package:stocks_news_new/ui/base/news_item.dart';
import 'package:stocks_news_new/utils/constants.dart';
import '../../../../models/my_home.dart';
import '../../../../models/news.dart';
import '../../../base/heading.dart';
import '../../more/news/detail.dart';

class HomeNewsIndex extends StatelessWidget {
  final HomeNewsRes? newsData;
  const HomeNewsIndex({super.key, this.newsData});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BaseHeading(
          title: newsData?.title,
          margin: EdgeInsets.only(
            top: Pad.pad16,
            bottom: Pad.pad16,
          ),
        ),
        Column(
          children: List.generate(
            newsData?.data?.length ?? 0,
            (index) {
              BaseNewsRes? data = newsData?.data?[index];
              if (data == null) {
                return SizedBox();
              }
              return BaseNewsItem(
                data: data,
                onTap: (data) {
                  if (data.slug == null || data.slug == '') return;
                  Navigator.pushNamed(context, NewsDetailIndex.path,
                      arguments: {
                        'slug': data.slug,
                      });
                },
              );
            },
          ),
        )
      ],
    );
  }
}
