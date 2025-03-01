import 'package:flutter/material.dart';
import 'package:stocks_news_new/models/ticker.dart';
import 'package:stocks_news_new/ui/base/stock/slidable.dart';
import 'package:stocks_news_new/ui/base/stock/stock.dart';
import 'package:stocks_news_new/widgets/optional_parent.dart';

class BaseStockEditItem extends StatelessWidget {
  final BaseTickerRes data;
  final int index;
  final bool slidable;
  final Function(BaseTickerRes)? onTap;
  const BaseStockEditItem({
    super.key,
    this.slidable = true,
    required this.data,
    required this.index,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return OptionalParent(
      addParent: slidable,
      parentBuilder: (child) {
        return BaseSlidableStockItem(
          index: index,
          child: child,
          edit: () {},
          delete: () {},
        );
      },
      child: InkWell(
        onTap: onTap != null
            ? () {
                onTap!(data);
              }
            : null,
        child: BaseStockItem(data: data),
      ),
    );
  }
}
