import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/providers/congressional_detail_provider.dart';
import 'package:stocks_news_new/screens/marketData/congressionDetail/container.dart';

import 'package:stocks_news_new/screens/tabs/home/widgets/app_bar_home.dart';
import 'package:stocks_news_new/widgets/base_container.dart';

class CongressionalDetail extends StatelessWidget {
  static const path = "CongressionalDetail";
  const CongressionalDetail({required this.slug, super.key});

  final String slug;

  @override
  Widget build(BuildContext context) {
    CongressionalDetailProvider provider =
        context.watch<CongressionalDetailProvider>();
    return BaseContainer(
      appBar: AppBarHome(isPopback: true, title: provider.extra?.title),
      body: CongressionalDetailContainer(slug: slug),
    );
  }
}
