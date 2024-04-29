import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:stocks_news_new/utils/colors.dart';

class RefreshControll extends StatefulWidget {
  const RefreshControll({
    required this.onRefresh,
    required this.onLoadMore,
    required this.child,
    this.canLoadmore = true,
    super.key,
  });
//
  final Future Function() onRefresh;
  final Future Function() onLoadMore;
  final Widget child;
  final bool canLoadmore;

  @override
  State<RefreshControll> createState() => _RefreshControllState();
}

class _RefreshControllState extends State<RefreshControll> {
  final RefreshController _refreshController = RefreshController(
    initialRefresh: false,
  );

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
      enablePullUp: true,
      footer: CustomFooter(
        height: widget.canLoadmore ? 55 : 0,
        builder: (BuildContext context, LoadStatus? mode) {
          Widget body;
          if (mode == LoadStatus.idle) {
            body = const CircularProgressIndicator();
          } else if (mode == LoadStatus.loading) {
            body = const CircularProgressIndicator(
              strokeWidth: 4,
              color: ThemeColors.accent,
            );
          } else if (mode == LoadStatus.failed) {
            body = const SizedBox();
          } else if (mode == LoadStatus.canLoading) {
            body = const CircularProgressIndicator(
              strokeWidth: 4,
              color: ThemeColors.accent,
            );
          } else {
            body = const SizedBox();
          }
          return Visibility(
            visible: widget.canLoadmore == true ? true : false,
            child: SizedBox(
              child: Center(child: body),
            ),
          );
        },
      ),
      controller: _refreshController,
      onRefresh: () async {
        await widget.onRefresh();
        _refreshController.refreshCompleted();
      },
      onLoading: () async {
        if (widget.canLoadmore) {
          await widget.onLoadMore();
        }
        _refreshController.loadComplete();
      },
      child: widget.child,
    );
  }
}
