import 'package:flutter/material.dart';
import 'package:stocks_news_new/widgets/optiona_parent.dart';

import '../../utils/constants.dart';
import '../../widgets/custom/refresh_indicator.dart';

class BaseScroll extends StatelessWidget {
  final Future<void> Function()? onRefresh;
  final List<Widget> children;
  final EdgeInsets? margin;
  final ScrollPhysics? physics;

  const BaseScroll({
    super.key,
    this.onRefresh,
    required this.children,
    this.margin,
    this.physics,
  });

  @override
  Widget build(BuildContext context) {
    return OptionalParent(
      addParent: onRefresh != null,
      parentBuilder: (child) {
        return CommonRefreshIndicator(
          onRefresh: onRefresh ?? () async {},
          child: child,
        );
      },
      child: Container(
        margin: margin ?? EdgeInsets.symmetric(horizontal: Pad.pad16),
        child: CustomScrollView(
          physics: physics,
          slivers: [
            SliverList(
              delegate: SliverChildBuilderDelegate(
                childCount: 1,
                (context, index) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: children,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
