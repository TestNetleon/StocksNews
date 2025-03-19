import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/managers/market/alerts_watchlist_action.dart';
import 'package:stocks_news_new/models/market/check_alert_lock.dart';
import 'package:stocks_news_new/ui/base/button.dart';
import 'package:stocks_news_new/ui/base/text_field.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import '../../../../../utils/constants.dart';

class AddToAlertSheet extends StatefulWidget {
  final String symbol;
  final dynamic manager;
  final int index;

  const AddToAlertSheet({
    super.key,
    required this.symbol,
    required this.manager,
    this.index = 0,
  });

  @override
  State<AddToAlertSheet> createState() => _AddToAlertSheetState();
}

class _AddToAlertSheetState extends State<AddToAlertSheet> {
  bool selectedOne = false;
  bool selectedTwo = false;
  TextEditingController controller = TextEditingController();
  TextEditingController symbolController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      AlertsWatchlistManager manager = context.read<AlertsWatchlistManager>();
      controller.text = manager.checkAlertLock?.alertData?.defaultValue ??
          "New ${widget.symbol} alert";
      symbolController.text = widget.symbol;
    });
  }

  void selectType({int index = 0}) {
    if (index == 0) {
      selectedOne = !selectedOne;
    } else if (index == 1) {
      selectedTwo = !selectedTwo;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    AlertsWatchlistManager manager = context.read<AlertsWatchlistManager>();
    AlertData? alertData = manager.checkAlertLock?.alertData;

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(color: ThemeColors.white),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                alertData?.title ?? "Set Alert for ${widget.symbol}",
                style: styleBaseBold(color: ThemeColors.black, fontSize: 25),
              ),
            ),
            SpacerVertical(height: 16),
            Center(
              child: Text(
                alertData?.subTitle ??
                    "Choose your preferred alert type to receive email alerts and app notifications for the selected stock",
                style: styleBaseRegular(color: ThemeColors.black, fontSize: 14),
                textAlign: TextAlign.center,
              ),
            ),
            SpacerVertical(height: 20),
            BaseTextField(
              controller: controller,
              placeholder: "Alert Name (optional)",
            ),
            SpacerVertical(height: 24),
            _typeSelect(
              heading: alertData?.sentiment?.title ??
                  "${widget.symbol} Sentiment Spike",
              description: alertData?.sentiment?.subTitle ??
                  "Alert if ${widget.symbol} news sentiment changes significantly.",
              onTap: () => selectType(index: 0),
              isSelected: selectedOne,
            ),
            SpacerVertical(height: 20),
            _typeSelect(
              heading: alertData?.mention?.title ??
                  "${widget.symbol} Mentions Spike",
              description: alertData?.mention?.subTitle ??
                  "Alert if ${widget.symbol} has a surge in mentions.",
              onTap: () => selectType(index: 1),
              isSelected: selectedTwo,
            ),
            SpacerVertical(height: 24),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              itemBuilder: (context, index) {
                return Text(
                  alertData?.notes?[index] ?? "",
                  style: styleBaseRegular(fontSize: 14),
                );
              },
              separatorBuilder: (context, index) {
                return SpacerVertical(height: 8);
              },
              itemCount: alertData?.notes?.length ?? 0,
            ),
            SpacerVertical(height: 24),
            BaseButton(
              onPressed: selectedOne == false && selectedTwo == false
                  ? null
                  : _requestAddToAlert,
              text: "Add to Alert",
              textUppercase: true,
              textColor: selectedOne == false && selectedTwo == false
                  ? ThemeColors.background
                  : ThemeColors.white,
            ),
            const SpacerVertical(height: 10),
          ],
        ),
      ),
    );
  }

  void _requestAddToAlert() async {
    AlertsWatchlistManager manager = context.read<AlertsWatchlistManager>();

    final Map request = {
      "symbol": widget.symbol,
      "alert_name": controller.text.trim(),
      "sentiment_spike": selectedOne ? "yes" : "no",
      "mention_spike": selectedTwo ? "yes" : "no",
    };

    final result = await manager.requestAddToAlert(
      symbol: widget.symbol,
      request: request,
    );

    if (result == true) {
      widget.manager.updateTickerInfo(symbol: widget.symbol, alertAdded: 1);
      Navigator.pop(context);
    }
  }

  Widget _typeSelect({
    void Function()? onTap,
    bool isSelected = false,
    required String description,
    required String heading,
  }) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: isSelected ? ThemeColors.secondary120 : ThemeColors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color:
                    isSelected ? ThemeColors.secondary120 : ThemeColors.border,
                width: 2,
              ),
            ),
            padding: EdgeInsets.all(6),
            child: isSelected
                ? Image.asset(Images.check, width: 14, height: 14)
                : null,
          ),
          const SpacerHorizontal(width: 10),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(heading, style: styleBaseBold(fontSize: 16)),
                Text(
                  description,
                  style: styleBaseRegular(
                    fontSize: 14,
                    color: ThemeColors.black,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
