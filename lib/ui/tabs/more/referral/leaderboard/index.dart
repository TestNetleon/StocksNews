import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/managers/referral/leader_board_manager.dart';
import 'package:stocks_news_new/ui/base/base_scroll.dart';
import 'package:stocks_news_new/ui/tabs/more/referral/pointsTransaction/index.dart';
import 'package:stocks_news_new/widgets/custom/base_loader_container.dart';

class LeaderBoard extends StatefulWidget {
  const LeaderBoard({super.key});

  @override
  State<LeaderBoard> createState() => _LeaderBoardState();
}

class _LeaderBoardState extends State<LeaderBoard> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _callAPI();
    });
  }

  Future _callAPI() async {
    LeaderBoardManager manager = context.read<LeaderBoardManager>();
    manager.getData();
  }

  void _navigateToTransactions() {
    Navigator.pushNamed(
      context,
      ReferPointsTransaction.path,
      arguments: {"type": "", "title": null},
    );
  }

  @override
  Widget build(BuildContext context) {
    LeaderBoardManager manager = context.watch<LeaderBoardManager>();
    return BaseLoaderContainer(
      hasData: manager.data != null,
      isLoading: manager.isLoading,
      error: manager.error,
      showPreparingText: true,
      child: BaseScroll(
        onRefresh: _callAPI,
        children: [
          // /
        ],
      ),
    );
  }
}
