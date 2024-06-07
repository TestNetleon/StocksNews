import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/providers/blog_provider_new.dart';
import 'package:stocks_news_new/screens/blogNew/blogsNew/container.dart';
import 'package:stocks_news_new/screens/tabs/home/widgets/app_bar_home.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/widgets/base_container.dart';
import 'package:stocks_news_new/widgets/base_ui_container.dart';
import 'package:stocks_news_new/widgets/custom_tab_container.dart';

class BlogIndexNew extends StatefulWidget {
  static const path = "BlogIndexNew";
  final String? inAppMsgId;
  final String? notificationId;
  const BlogIndexNew({super.key, this.inAppMsgId, this.notificationId});

  @override
  State<BlogIndexNew> createState() => _BlogIndexNewState();
}

class _BlogIndexNewState extends State<BlogIndexNew> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<BlogProviderNew>().getTabsData();
    });
  }

  @override
  Widget build(BuildContext context) {
    BlogProviderNew provider = context.watch<BlogProviderNew>();

    return BaseContainer(
      appBar: const AppBarHome(
        canSearch: true,
        showTrailing: true,
        isPopback: true,
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(
          Dimen.padding,
          Dimen.padding,
          Dimen.padding,
          0,
        ),
        child: BaseUiContainer(
          hasData: !provider.tabLoading && provider.tabs?.isNotEmpty == true,
          isLoading: provider.tabLoading,
          error: provider.error,
          showPreparingText: true,
          onRefresh: () => provider.getTabsData(),
          child: _getWidget(provider),
        ),
      ),
    );
  }

  Widget _getWidget(BlogProviderNew provider) {
    return CustomTabContainerNEW(
      onChange: (index) {
        provider.tabChange(index, provider.tabs![index].id);
      },
      scrollable: provider.tabs?.length == 2 ? false : true,
      tabsPadding: const EdgeInsets.only(bottom: 10),
      tabs: List.generate(
        provider.tabs?.length ?? 0,
        (index) => "${provider.tabs?[index].name}",
      ),
      widgets: List.generate(
        provider.tabs?.length ?? 0,
        (index) => BlogTypeData(
          id: provider.tabs![index].id,
        ),
      ),
    );
  }
}
