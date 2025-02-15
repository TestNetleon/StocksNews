import 'package:flutter/material.dart';
import 'package:stocks_news_new/ui/base/app_bar.dart';
import 'package:stocks_news_new/ui/base/scaffold.dart';

class ToolsCompareSearch extends StatefulWidget {
  const ToolsCompareSearch({super.key});

  @override
  State<ToolsCompareSearch> createState() => _ToolsCompareSearchState();
}

class _ToolsCompareSearchState extends State<ToolsCompareSearch> {
  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      appBar: BaseAppBar(
        showBack: true,
        title: 'Search',
      ),
      body: Container(),
    );
  }
}
