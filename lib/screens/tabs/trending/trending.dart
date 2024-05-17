import 'package:flutter/material.dart';
import 'package:stocks_news_new/screens/tabs/trending/trending_view.dart';
import 'package:stocks_news_new/widgets/base_container.dart';

class Trending extends StatelessWidget {
  const Trending({super.key});
//
  @override
  Widget build(BuildContext context) {
    return const BaseContainer(
      // drawer: BaseDrawer(),
      // appBar: AppBarHome(canSearch: true),
      body: TrendingView(),
    );
  }
}
