import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/providers/leaderboard.dart';
import 'package:stocks_news_new/screens/tabs/home/widgets/app_bar_home.dart';
import 'package:stocks_news_new/widgets/base_container.dart';

import 'container.dart';

class ClaimHistoryIndex extends StatefulWidget {
  final String type;
  final String? appbarHeading;
  final dynamic id;
  const ClaimHistoryIndex({
    super.key,
    required this.type,
    this.appbarHeading,
    this.id,
  });

  @override
  State<ClaimHistoryIndex> createState() => _ClaimHistoryIndexState();
}

class _ClaimHistoryIndexState extends State<ClaimHistoryIndex> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context
          .read<LeaderBoardProvider>()
          .getUnclaimedData(type: widget.type, id: widget.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BaseContainer(
      appBar: AppBarHome(
        isPopBack: true,
        title: widget.appbarHeading,
      ),
      body: ClaimHistoryContainer(type: widget.type, id: widget.id),
    );
  }
}
