import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/managers/aiAnalysis/ai.dart';
import 'package:stocks_news_new/utils/constants.dart';
import '../../../../models/news.dart';
import '../../../base/news_item.dart';
import '../../../tabs/more/news/detail.dart';

class AINews extends StatefulWidget {
  const AINews({super.key});

  @override
  State<AINews> createState() => _AINewsState();
}

class _AINewsState extends State<AINews> {
  @override
  Widget build(BuildContext context) {
    AIManager manager = context.watch<AIManager>();

    List<BaseNewsRes>? latestNews = manager.data?.latestNews;

    return Padding(
      padding: const EdgeInsets.only(
        top: 10,
        right: Pad.pad16,
        left: Pad.pad16,
      ),
      child: Column(
        children: List.generate(
          latestNews?.length ?? 0,
          (index) {
            BaseNewsRes? data = latestNews?[index];
            if (data == null) {
              return SizedBox();
            }
            return BaseNewsItem(
              data: data,
              onTap: (data) {
                if (data.slug == null || data.slug == '') return;
                // Navigator.pushNamed(context, NewsDetailIndex.path, arguments: {
                //   'slug': data.slug,
                // });
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => NewsDetailIndex(
                              slug: data.slug ?? '',
                            )));
              },
            );
          },
        ),
      ),
    );
  }
}
