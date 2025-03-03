import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/managers/alerts.dart';
import 'package:stocks_news_new/managers/watchlist.dart';
import 'package:stocks_news_new/models/delete_data.dart';
import 'package:stocks_news_new/models/ticker.dart';
import 'package:stocks_news_new/routes/my_app.dart';
import 'package:stocks_news_new/ui/base/bottom_sheet.dart';
import 'package:stocks_news_new/ui/base/stock/slidable.dart';
import 'package:stocks_news_new/ui/base/stock/stock.dart';
import 'package:stocks_news_new/ui/base/stock_delete_item.dart';
import 'package:stocks_news_new/widgets/optional_parent.dart';

class SlidableStockEditItem extends StatelessWidget {
  final BaseTickerRes data;
  final DeleteBoxRes? deleteDataRes;
  final int index;
  final bool slidable;
  final Function(BaseTickerRes)? onTap;
  const SlidableStockEditItem({
    super.key,
    this.slidable = true,
    required this.data,
    this.deleteDataRes,
    required this.index,
    this.onTap,
  });


  _stopAlertSheet() {
    BaseBottomSheet().bottomSheet(
      child: StockDeleteItem(
          deleteDataRes: deleteDataRes,
        onTapKeep: (){
            Navigator.pop(navigatorKey.currentContext!);
        },
        onTapRemove: (){
          navigatorKey.currentContext!.read<AlertsM>().deleteItem(
            data.symbol??""
          );
        },
      ),
    );
  }

  _removeWatchListSheet() {
    BaseBottomSheet().bottomSheet(
      child: StockDeleteItem(
        deleteDataRes: deleteDataRes,
        onTapKeep: (){
          Navigator.pop(navigatorKey.currentContext!);
        },
        onTapRemove: (){
          navigatorKey.currentContext!.read<WatchListManagers>().deleteItem(
              data.symbol??""
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return OptionalParent(
      addParent: slidable,
      parentBuilder: (child) {
        return BaseSlidableStockItem(
          index: index,
          //edit: () {},

          delete:deleteDataRes?.type=="watchlist"?_removeWatchListSheet:_stopAlertSheet,
          deleteLabel: deleteDataRes?.type=="watchlist"?"Remove":"Stop Alert",
          child: child,
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
