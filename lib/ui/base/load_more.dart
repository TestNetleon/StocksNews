import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:stocks_news_new/ui/theme/manager.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';

class BaseLoadMore extends StatefulWidget {
  const BaseLoadMore({
    required this.onRefresh,
    required this.onLoadMore,
    required this.child,
    this.canLoadMore = true,
    super.key,
  });

  final Future Function() onRefresh;
  final Future Function() onLoadMore;
  final Widget child;
  final bool canLoadMore;

  @override
  State<BaseLoadMore> createState() => _RefreshControlState();
}

class _RefreshControlState extends State<BaseLoadMore> {
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  final AudioPlayer _audioPlayer = AudioPlayer();

  Future<void> _playRefreshSound() async {
    try {
      await _audioPlayer.play(AssetSource(AudioFiles.refresh), volume: 0.18);
    } catch (e) {
      debugPrint("Error playing refresh sound: $e");
    }
  }

  @override
  void dispose() {
    _refreshController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
      enablePullUp: widget.canLoadMore,
      controller: _refreshController,
      onRefresh: () async {
        await _playRefreshSound();
        await widget.onRefresh();
        if (mounted) _refreshController.refreshCompleted();
      },
      onLoading: widget.canLoadMore
          ? () async {
              await widget.onLoadMore();
              if (mounted) _refreshController.loadComplete();
            }
          : null,
      footer: widget.canLoadMore
          ? CustomFooter(
              height: 100,
              builder: (context, LoadStatus? mode) {
                if (mode == LoadStatus.loading ||
                    mode == LoadStatus.canLoading) {
                  return Center(
                    // child: CircularProgressIndicator(
                    //   strokeWidth: 4,
                    //   color: ThemeColors.black,
                    // ),
                    child: CupertinoActivityIndicator(
                        color:
                            //  value.isDarkMode
                            //     ? ThemeColors.white
                            //     :
                            ThemeColors.black),
                  );
                }
                return const SizedBox();
              },
            )
          : null,
      child: widget.child,
    );
  }
}
