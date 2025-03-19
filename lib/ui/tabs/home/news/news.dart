import 'package:flutter/material.dart';
import 'package:stocks_news_new/ui/base/base_list_divider.dart';
import 'package:stocks_news_new/utils/constants.dart';
import '../../../../models/my_home.dart';
import '../../../../models/news.dart';
import '../../../base/heading.dart';
import 'item.dart';

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
          margin: EdgeInsets.only(top: Pad.pad32),
        ),
        ListView.separated(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            BaseNewsRes? data = newsData?.data?[index];
            if (data == null) {
              return SizedBox();
            }
            return HomeNewsItem(data: data);
          },
          separatorBuilder: (context, index) {
            return BaseListDivider(
              height: 10,
            );
          },
          itemCount: newsData?.data?.length ?? 0,
        ),
      ],
    );
  }
}
