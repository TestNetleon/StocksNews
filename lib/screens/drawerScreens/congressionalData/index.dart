import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:stocks_news_new/screens/drawerScreens/congressionalData/container.dart';
import 'package:stocks_news_new/screens/tabs/home/widgets/app_bar_home.dart';
import 'package:stocks_news_new/widgets/base_container.dart';

class CongressionalIndex extends StatefulWidget {
  static const path = "CongressionalIndex";
  const CongressionalIndex({super.key});

  @override
  State<CongressionalIndex> createState() => _CongressionalIndexState();
}

class _CongressionalIndexState extends State<CongressionalIndex> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {});
  }

  @override
  Widget build(BuildContext context) {
    return const BaseContainer(
      appBar: AppBarHome(isPopback: true, canSearch: true),
      body: CongressionalContainer(),
    );
  }
}
