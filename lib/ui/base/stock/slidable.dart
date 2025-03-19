import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/ui/theme/manager.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

class BaseSlidableStockItem extends StatefulWidget {
  final Widget child;
  final int? index;
  final VoidCallback? addToAlert;
  final VoidCallback? addToWatchlist;
  final VoidCallback? edit;
  final VoidCallback? delete;
  final dynamic isAlertAdded;
  final dynamic isWatchlistAdded;
  final String? deleteLabel;

  const BaseSlidableStockItem({
    super.key,
    required this.child,
    this.index,
    this.addToAlert,
    this.addToWatchlist,
    this.edit,
    this.delete,
    this.isAlertAdded,
    this.isWatchlistAdded,
    this.deleteLabel,
  });

  @override
  State<BaseSlidableStockItem> createState() => _BaseSlidableStockItemState();
}

class _BaseSlidableStockItemState extends State<BaseSlidableStockItem>
    with SingleTickerProviderStateMixin {
  SlidableController? controller;

  @override
  void initState() {
    super.initState();
    controller = SlidableController(this);

    if ((widget.index ?? 1) == 0 && itemAutoSwipeAvailable) {
      controller?.openTo(
        BorderSide.strokeAlignInside,
        curve: Curves.linear,
        duration: const Duration(milliseconds: 1000),
      );
      Timer(const Duration(milliseconds: 1000), () {
        if (mounted) {
          controller?.close(
            curve: Curves.linear,
            duration: const Duration(milliseconds: 2000),
          );
          itemAutoSwipeAvailable = false;
        }
      });
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ThemeManager manager = context.watch<ThemeManager>();

    bool isDark = manager.isDarkMode;

    return Slidable(
      controller: controller,
      key: const ValueKey(0),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        extentRatio: 0.75,
        children: [
          Expanded(
            child: Row(
              children: [
                if (widget.addToAlert != null)
                  BaseSlidableActionItem(
                    label: widget.isAlertAdded == 1
                        ? 'Alert Added'
                        : 'Add to Alerts',
                    image: Images.alerts,
                    onTap: () {
                      controller?.close();
                      widget.addToAlert!();
                    },
                    bgColor: isDark ? ThemeColors.warning : null,
                  ),
                if (widget.addToWatchlist != null) ...[
                  const SpacerHorizontal(width: 1),
                  BaseSlidableActionItem(
                    label: widget.isWatchlistAdded == 1
                        ? 'Watchlist Added'
                        : 'Add to Watchlist',
                    image: Images.watchlist,
                    onTap: () {
                      controller?.close();
                      widget.addToWatchlist!();
                    },
                    bgColor: isDark ? ThemeColors.accent : null,
                  ),
                ],
                if (widget.edit != null) ...[
                  const SpacerHorizontal(width: 1),
                  BaseSlidableActionItem(
                    label: 'Edit',
                    image: Images.write,
                    onTap: widget.edit,
                  ),
                ],
                if (widget.delete != null) ...[
                  const SpacerHorizontal(width: 1),
                  BaseSlidableActionItem(
                    label: widget.deleteLabel ?? 'Stop Alert',
                    image: Images.delete,
                    onTap: widget.delete,
                    bgColor: ThemeColors.error120,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
      child: widget.child,
    );
  }
}

//Slidable Item
class BaseSlidableActionItem extends StatelessWidget {
  final String label;
  final String image;
  final VoidCallback? onTap;
  final Color? bgColor;

  const BaseSlidableActionItem({
    super.key,
    required this.label,
    required this.image,
    required this.onTap,
    this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          color: bgColor ?? ThemeColors.secondary120,
          padding: const EdgeInsets.all(5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                image,
                width: 24,
                height: 24,
                color: ThemeColors.white,
              ),
              const SpacerVertical(height: 8),
              Text(
                label,
                textAlign: TextAlign.center,
                style: styleBaseBold(fontSize: 14, color: ThemeColors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
