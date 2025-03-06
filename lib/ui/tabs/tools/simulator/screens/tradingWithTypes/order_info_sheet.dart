import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/routes/my_app.dart';
import 'package:stocks_news_new/ui/base/button.dart';
import 'package:stocks_news_new/ui/tabs/tools/simulator/managers/portpolio.dart';
import 'package:stocks_news_new/ui/tabs/tools/simulator/managers/ticker_search.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/widgets/custom/base_loader_container.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

Future openInfoSheet(ConditionType? cType, StockType? selectedStock) async {
  showModalBottomSheet(
    enableDrag: true,
    isDismissible: true,
    context: navigatorKey.currentContext!,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(10),
        topRight: Radius.circular(10),
      ),
    ),
    isScrollControlled: false,
    builder: (context) {
      return Stack(
        alignment: Alignment.topRight,
        children: [
          OrderInfoSheet(
            cType: cType,
            selectedStock: selectedStock,
            buttonVisible: false,
          ),
          Container(
            width: 35,
            height: 35,
            margin: EdgeInsets.only(right: 10, top: 10),
            decoration: BoxDecoration(
                shape: BoxShape.circle, color: ThemeColors.primary),
            child: IconButton(
                onPressed: () {
                  Navigator.pop(navigatorKey.currentContext!);
                },
                icon: Icon(Icons.clear, color: ThemeColors.white, size: 18)),
          ),
        ],
      );
    },
  );
 /* await BaseBottomSheet().bottomSheet(
      child:Stack(
        alignment: Alignment.topRight,
        children: [
          OrderInfoSheet(
            cType: cType,
            selectedStock: selectedStock,
            buttonVisible: false,
          ),
          Container(
            width: 35,
            height: 35,
            margin: EdgeInsets.only(right: 10, top: 10),
            decoration: BoxDecoration(
                shape: BoxShape.circle, color: ThemeColors.primary),
            child: IconButton(
                onPressed: () {
                  Navigator.pop(navigatorKey.currentContext!);
                },
                icon: Icon(Icons.clear, color: ThemeColors.white, size: 18)),
          ),
        ],
      )
  );*/
}
class OrderInfoSheet extends StatefulWidget {
  final String? symbol;
  final dynamic qty;
  final int? tickerID;
  final ConditionType? cType;
  final StockType? selectedStock;
  final bool buttonVisible;
  const OrderInfoSheet(
      {super.key,
      this.symbol,
      this.qty,
      this.tickerID,
      this.cType,
      this.selectedStock,
      this.buttonVisible=true
      });

  @override
  State<OrderInfoSheet> createState() => _OrderInfoSheetState();
}

class _OrderInfoSheetState extends State<OrderInfoSheet> {
  @override
  void initState() {
    super.initState();
     WidgetsBinding.instance.addPostFrameCallback((_) {
       TickerSearchManager manager = context.read<TickerSearchManager>();
       manager.orderInfo(conditionalType: widget.cType,selectedStock: widget.selectedStock);

      if(widget.buttonVisible){
        context.read<PortfolioManager>().getHolidays();
      }
    });
  }

  void onProceed() {
    if (widget.symbol != null) {
      if(widget.cType==ConditionType.recurringOrder){
        context
            .read<TickerSearchManager>()
            .stockHoldingOfRecurringCondition(widget.symbol ?? "");
      }
      else{
        context
            .read<TickerSearchManager>()
            .conditionalRedirection(widget.symbol ?? "",
            tickerID: widget.tickerID,
            qty: widget.qty,
            conditionalType: widget.cType);
      }
    } else {
      //Navigator.pushNamed(context, SearchTickerIndex.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    TickerSearchManager manager = context.watch<TickerSearchManager>();
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: BaseLoaderContainer(
              hasData: manager.infoData != null,
              isLoading: manager.isInfoLoading,
              error: manager.error,
              showPreparingText: true,
              child: SingleChildScrollView(
                child: HtmlWidget(
                  manager.infoData?.html ?? "",
                ),
              ),
            ),
          ),
          Visibility(visible:widget.buttonVisible,child: SpacerVertical(height: 14)),
          Visibility(
            visible: widget.buttonVisible,
            child: BaseButton(
              disabledBackgroundColor: ThemeColors.greyBorder,
              text: "Proceed Order",
              color: ThemeColors.splashBG,
              textColor: ThemeColors.white,
              onPressed: onProceed,
            ),
          )
        ],
      ),
    );
  }
}
