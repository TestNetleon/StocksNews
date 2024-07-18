import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/screens/tabs/news/typeData/index.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/utils.dart';
import 'package:stocks_news_new/widgets/base_container.dart';
import 'package:stocks_news_new/widgets/custom_tab_container.dart';
import 'package:stocks_news_new/widgets/error_display_common.dart';
import '../../../providers/news_provider.dart';
import 'aiNews/container.dart';

class News extends StatelessWidget {
  const News({super.key});

  @override
  Widget build(BuildContext context) {
    NewsCategoryProvider provider = context.watch<NewsCategoryProvider>();
    Utils().showLog("----${provider.extra?.aiTitle}");
    Utils().showLog("${provider.tabs?.length}");

    if (provider.tabLoading) {
      return const SizedBox();
    }

    if (!provider.tabLoading && provider.tabs == null) {
      return ErrorDisplayWidget(
        error: provider.error,
        onRefresh: () {
          provider.getTabsData(showProgress: true);
        },
      );
    }

    return BaseContainer(
      body: Padding(
        padding: EdgeInsets.fromLTRB(
          Dimen.padding.sp,
          0,
          Dimen.padding.sp,
          0,
        ),
        child: CommonTabContainer(
          tabPaddingNew: false,
          onChange: (index) {
            provider.tabChange(index, provider.tabs?[index].id);
          },
          scrollable: (provider.extra?.aiTitle != null &&
                      provider.extra?.aiTitle != '' &&
                      provider.tabs?.length == 1) ||
                  (provider.tabs?.length == 2)
              ? false
              : true,
          padding: EdgeInsets.only(bottom: 10.sp),
          tabs: provider.extra?.aiTitle == null || provider.extra?.aiTitle == ""
              ? [
                  ...(provider.tabs?.map((tab) => tab.name) ?? []),
                ]
              : [
                  ...(provider.tabs?.map((tab) => tab.name) ?? []),
                  provider.extra?.aiTitle ?? "N/A"
                ],
          widgets:
              provider.extra?.aiTitle == null || provider.extra?.aiTitle == ""
                  ? [
                      ...(provider.tabs?.map((tab) {
                            return NewsTypeData(id: tab.id);
                          }).toList() ??
                          []),
                    ]
                  : [
                      ...(provider.tabs?.map((tab) {
                            return NewsTypeData(id: tab.id);
                          }).toList() ??
                          []),
                      const AINewsIndex(),
                    ],
        ),
      ),
    );
  }
}
