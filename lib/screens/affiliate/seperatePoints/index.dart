import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/providers/leaderboard.dart';
import 'package:stocks_news_new/screens/tabs/home/widgets/app_bar_home.dart';
import 'package:stocks_news_new/widgets/base_container.dart';

import 'container.dart';

class SeparatePointsIndex extends StatefulWidget {
  final String type;
  final String? appbarHeading;
  const SeparatePointsIndex({
    super.key,
    required this.type,
    this.appbarHeading,
  });

  @override
  State<SeparatePointsIndex> createState() => _SeparatePointsIndexState();
}

class _SeparatePointsIndexState extends State<SeparatePointsIndex> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<LeaderBoardProvider>().getData(type: widget.type);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BaseContainer(
      appBar: AppBarHome(
        isPopBack: true,
        title: widget.appbarHeading,
      ),
      body: SeparatePointsContainer(
        type: widget.type,
      ),
    );
  }
}
