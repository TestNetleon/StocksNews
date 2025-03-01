import 'package:flutter/material.dart';

import '../../../models/news.dart';
import '../../../utils/constants.dart';
import '../../base/base_list_divider.dart';
import '../../base/news_item.dart';
import '../../tabs/more/news/detail.dart';

class SDLatestNewsWidget extends StatelessWidget {
  final List<BaseNewsRes>? news;
  const SDLatestNewsWidget({super.key, this.news});

  @override
  Widget build(BuildContext context) {
    if (news == null || news?.isEmpty == true) {
      return SizedBox();
    }
    return ListView.separated(
      shrinkWrap: true,
      padding: EdgeInsets.all(Pad.pad16),
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        BaseNewsRes? data = news?[index];
        if (data == null) {
          return SizedBox();
        }

        return BaseNewsItem(
          data: data,
          onTap: (news) {
            if (data.slug == null || data.slug == '') return;
            Navigator.pushNamed(context, NewsDetailIndex.path, arguments: {
              'slug': data.slug,
            });
          },
        );
      },
      separatorBuilder: (context, index) {
        return BaseListDivider();
      },
      itemCount: news?.length ?? 0,
    );
  }
}
