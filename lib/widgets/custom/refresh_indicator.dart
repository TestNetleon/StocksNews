import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:stocks_news_new/utils/colors.dart';

import '../../utils/constants.dart';

class CommonRefreshIndicator extends StatelessWidget {
  final Future<void> Function() onRefresh;
  final Widget child;

  const CommonRefreshIndicator({
    super.key,
    required this.onRefresh,
    required this.child,
  });

  Future<void> _handleRefresh() async {
    try {
      final player = AudioPlayer();
      player.play(AssetSource(AudioFiles.refresh), volume: 0.18);
    } catch (e) {
      debugPrint("$e");
    }
    await onRefresh();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _handleRefresh,
      backgroundColor: ThemeColors.black,
      color: ThemeColors.white,
      child: child,
    );
  }
}
