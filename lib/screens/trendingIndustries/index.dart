import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/providers/trending_industries.dart';
import 'package:stocks_news_new/screens/trendingIndustries/container.dart';

class TrendingIndustries extends StatelessWidget {
  static const path = "TrendingIndustries";
  const TrendingIndustries({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: TrendingIndustriesProvider(),
      child: const TrendingIndustriesContainer(),
    );
  }
}
//