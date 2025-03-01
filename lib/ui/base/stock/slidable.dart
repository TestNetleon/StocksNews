import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
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

  const BaseSlidableStockItem({
    super.key,
    required this.child,
    this.index,
    this.addToAlert,
    this.addToWatchlist,
    this.edit,
    this.delete,
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

    if ((widget.index ?? 1) == 0) {
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
    return Slidable(
      controller: controller,
      key: const ValueKey(0),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        extentRatio: 0.9,
        children: [
          Expanded(
            child: Row(
              children: [
                if (widget.addToAlert != null)
                  BaseSlidableActionItem(
                    label: 'Add to Alerts',
                    image: Images.alerts,
                    onTap: widget.addToAlert,
                  ),
                if (widget.addToWatchlist != null) ...[
                  const SpacerHorizontal(width: 1),
                  BaseSlidableActionItem(
                    label: 'Add to Watchlist',
                    image: Images.watchlist,
                    onTap: widget.addToWatchlist,
                  ),
                ],
                if (widget.edit != null) ...[
                  const SpacerHorizontal(width: 1),
                  BaseSlidableActionItem(
                    label: 'Edit',
                    image: Images.edit,
                    onTap: widget.edit,
                  ),
                ],
                if (widget.delete != null) ...[
                  const SpacerHorizontal(width: 1),
                  BaseSlidableActionItem(
                    label: 'Delete',
                    image: Images.edit,
                    onTap: widget.delete,
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

  const BaseSlidableActionItem({
    super.key,
    required this.label,
    required this.image,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          color: ThemeColors.secondary100,
          padding: const EdgeInsets.all(5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(image, width: 32, height: 32),
              const SpacerVertical(height: 5),
              Text(
                label,
                textAlign: TextAlign.center,
                style: stylePTSansBold(fontSize: 14, color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
