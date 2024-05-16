import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/providers/featured_ticker.dart';
import 'package:stocks_news_new/screens/allFeatured/container.dart';
import 'package:stocks_news_new/screens/tabs/home/widgets/app_bar_home.dart';
import 'package:stocks_news_new/widgets/base_container.dart';
import 'package:stocks_news_new/widgets/base_ui_container.dart';

class AllFeaturedIndex extends StatefulWidget {
  const AllFeaturedIndex({super.key});

  @override
  State<AllFeaturedIndex> createState() => _AllFeaturedIndexState();
}

class _AllFeaturedIndexState extends State<AllFeaturedIndex> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context
          .read<FeaturedTickerProvider>()
          .getFeaturedTicker(showProgress: true);
    });
  }

  @override
  Widget build(BuildContext context) {
    FeaturedTickerProvider provider = context.watch<FeaturedTickerProvider>();
    return BaseContainer(
      appBar: const AppBarHome(
        isPopback: true,
        canSearch: true,
        showTrailing: true,
      ),
      body: BaseUiContainer(
        error: provider.error,
        hasData: provider.data?.isNotEmpty == true && !provider.isLoading,
        isLoading: provider.isLoading,
        child: const AllFeaturedContainer(),
      ),
    );
  }
}
