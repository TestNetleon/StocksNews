import 'package:flutter/material.dart';
import 'package:stocks_news_new/screens/tabs/trending/trending_view.dart';
import 'package:stocks_news_new/widgets/base_container.dart';

class Trending extends StatelessWidget {
  const Trending({
    super.key,
    this.index = 0,
  });
  final int index;
//
  @override
  Widget build(BuildContext context) {
    return BaseContainer(
      body: TrendingView(index: index),
    );
  }
}
