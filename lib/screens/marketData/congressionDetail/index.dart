import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:stocks_news_new/screens/marketData/congressionDetail/container.dart';

import 'package:stocks_news_new/screens/tabs/home/widgets/app_bar_home.dart';
import 'package:stocks_news_new/widgets/base_container.dart';

class CongressionalDetail extends StatelessWidget {
  static const path = "CongressionalDetail";
  const CongressionalDetail({required this.slug, super.key});

  final String slug;

  @override
  Widget build(BuildContext context) {
    return BaseContainer(
      appBar: const AppBarHome(isPopback: true, canSearch: true),
      body: CongressionalDetailContainer(slug: slug),
    );
  }
}
