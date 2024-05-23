import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:stocks_news_new/screens/tabs/home/widgets/app_bar_home.dart';
import 'package:stocks_news_new/widgets/base_container.dart';

class CongressionalIndex extends StatelessWidget {
  const CongressionalIndex({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseContainer(
      appBar: AppBarHome(canSearch: true),
      body: Container(),
    );
  }
}
