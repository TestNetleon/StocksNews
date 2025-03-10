import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/modals/home_insider_res.dart';
import 'package:stocks_news_new/modals/msAnalysis/news.dart';
import 'package:stocks_news_new/providers/stockAnalysis/provider.dart';
import 'package:stocks_news_new/screens/tabs/news/news_item.dart';
import 'package:stocks_news_new/widgets/base_ui_container.dart';
import '../../../../utils/colors.dart';

class MsNews extends StatelessWidget {
  const MsNews({super.key});

  @override
  Widget build(BuildContext context) {
    MSAnalysisProvider provider = context.watch<MSAnalysisProvider>();
    return BaseUiContainer(
      hasData: provider.completeData?.latestNews != null &&
          provider.completeData?.latestNews?.isNotEmpty == true,
      isLoading: provider.isLoadingComplete &&
          (provider.completeData?.latestNews == null ||
              provider.completeData?.latestNews?.isEmpty == true),
      error: provider.errorComplete,
      showPreparingText: true,
      child: ListView.separated(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: provider.completeData?.latestNews?.length ?? 0,
        padding: EdgeInsets.only(bottom: 12, top: 10),
        itemBuilder: (context, index) {
          MsNewsRes? newsItemData = provider.completeData?.latestNews?[index];
          if (index == 0) {
            return NewsItemSeparated(
              fromAI: true,
              showCategory: true,
              news: News(
                slug: newsItemData?.slug,
                title: newsItemData?.title ?? "",
                image: newsItemData?.image ?? "",
                site: newsItemData?.site ?? '',
                postDateString: newsItemData?.publishedDateString,
                url: newsItemData?.url,
              ),
            );
          }
          return NewsItem(
            showCategory: true,
            fromAI: true,
            news: News(
              slug: newsItemData?.slug,
              title: newsItemData?.title ?? "",
              image: newsItemData?.image ?? "",
              site: newsItemData?.site ?? '',
              postDateString: newsItemData?.publishedDateString,
              url: newsItemData?.url,
            ),
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return Divider(color: ThemeColors.greyBorder, height: 20);
        },
      ),
    );
  }
}
