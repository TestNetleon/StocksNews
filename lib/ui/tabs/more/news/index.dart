import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/managers/news.dart';
import 'package:stocks_news_new/ui/base/app_bar.dart';
import 'package:stocks_news_new/ui/base/scaffold.dart';
import 'package:stocks_news_new/widgets/custom/base_loader_container.dart';
import '../../../base/common_tab.dart';
import 'news.dart';

class CategoriesNewsIndex extends StatefulWidget {
  static const path = 'CategoriesNewsIndex';
  const CategoriesNewsIndex({super.key});

  @override
  State<CategoriesNewsIndex> createState() => _CategoriesNewsIndexState();
}

class _CategoriesNewsIndexState extends State<CategoriesNewsIndex> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      NewsManager manager = context.read<NewsManager>();
      if (manager.categoriesData == null) {
        manager.getNewsCategoriesData();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    NewsManager manager = context.watch<NewsManager>();

    return BaseScaffold(
      appBar: BaseAppBar(showBack: true),
      body: BaseLoaderContainer(
        hasData: manager.categoriesData?.data != null &&
            manager.categoriesData?.data?.isNotEmpty == true &&
            !manager.isLoading,
        isLoading: manager.isLoading,
        error: manager.error,
        onRefresh: manager.getNewsCategoriesData,
        showPreparingText: true,
        child:
            manager.categoriesData?.data != null && manager.selectedIndex != -1
                ? Column(
                    children: [
                      BaseTabs(
                        data: manager.categoriesData!.data!,
                        // textStyle: styleBaseBold(fontSize: 16),
                        onTap: manager.onChangeTab,
                        isScrollable: manager.categoriesData?.data?.length == 2
                            ? false
                            : true,
                      ),
                      Expanded(
                        child: NewsIndex(
                          id: manager.categoriesData
                                  ?.data?[manager.selectedIndex].slug ??
                              '',
                        ),
                      )
                    ],
                  )
                : SizedBox(),
      ),
    );
  }
}
