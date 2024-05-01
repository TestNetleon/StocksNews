import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/providers/stock_detail_provider.dart';
import 'package:stocks_news_new/providers/top_trending_provider.dart';
import 'package:stocks_news_new/providers/trending_provider.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import 'package:stocks_news_new/widgets/theme_button.dart';
import 'package:stocks_news_new/widgets/theme_input_field.dart';

import '../setupAlert/setup_alert.dart';

//
class AlertPopup extends StatefulWidget {
  final String symbol;
  final bool up;
  final bool fromTrending;
  final bool fromTopStock;
  final bool fromStockDetail;
  final int index;

  final EdgeInsets? insetPadding;
  const AlertPopup({
    super.key,
    required this.symbol,
    this.up = false,
    this.fromTrending = false,
    this.fromTopStock = false,
    this.fromStockDetail = false,
    this.index = 0,
    this.insetPadding,
  });

  @override
  State<AlertPopup> createState() => _AlertPopupState();
}

class _AlertPopupState extends State<AlertPopup> {
  bool selectedOne = false;
  bool selectedTwo = false;
  TextEditingController controller = TextEditingController();
  TextEditingController symbolController = TextEditingController();

  @override
  void initState() {
    super.initState();
    controller.text = "New ${widget.symbol} alert";
    symbolController.text = widget.symbol;
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
    return Container(
      padding: EdgeInsets.all(18.sp),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        // insetPadding: widget.insetPadding,
        children: [
          _header(context),
          const SpacerVertical(height: 5),
          Text(
            "Select an alert type",
            style: stylePTSansBold(),
          ),
          Divider(
            color: ThemeColors.border.withOpacity(0.4),
            thickness: 1,
            height: 30.sp,
          ),
          _typeSelect(
            heading: "${widget.symbol} Sentiment Spike",
            description:
                "Alert if ${widget.symbol} news sentiment changes significantly.",
            onTap: () => selectType(index: 0),
            isSelected: selectedOne,
          ),
          Divider(
            color: ThemeColors.border.withOpacity(0.4),
            thickness: 1,
            height: 30.sp,
          ),
          _typeSelect(
            heading: "${widget.symbol} Mentions Spike",
            description: "Alert if ${widget.symbol} has a surge in mentions.",
            onTap: () => selectType(index: 1),
            isSelected: selectedTwo,
          ),
          Divider(
            color: ThemeColors.border.withOpacity(0.4),
            thickness: 1,
            height: 30.sp,
          ),
          Text(
            "Choose sentiment spike or mentions spike or both to receive email alerts and app notification for the selected stock.",
            style: stylePTSansRegular(fontSize: 12),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 10.sp),
            padding: EdgeInsets.symmetric(vertical: 5.sp, horizontal: 5.sp),
            decoration: const BoxDecoration(
                color: ThemeColors.greyBorder,
                border: Border(
                    left: BorderSide(color: ThemeColors.white, width: 3))),
            child: Text(
              "Note: Please be aware that you will receive an email and app notification only once a day, around 8:00 AM (EST), in the event of any spike.",
              style: stylePTSansRegular(fontSize: 12),
            ),
          ),
          Text(
            "In future if you don't want to receive any email and notification then remove stock added into alert section.",
            style: stylePTSansRegular(fontSize: 12),
          ),
          Divider(
            color: ThemeColors.border.withOpacity(0.4),
            thickness: 1,
            height: 30.sp,
          ),
          ThemeButton(
            color: ThemeColors.accent,
            onPressed: selectedOne == false && selectedTwo == false
                ? null
                : () => _showAlertPopup(context),
            text: "Continue",
            textColor: selectedOne == false && selectedTwo == false
                ? ThemeColors.background
                : ThemeColors.border,
          ),
          const SpacerVertical(height: 10),
        ],
      ),
    );
    // return ThemeAlertDialog(
    //   insetPadding: widget.insetPadding,
    //   children: [
    //     _header(context),
    //     const SpacerVertical(height: 3),
    //     Text(
    //       "Select an alert type",
    //       style: stylePTSansBold(),
    //     ),
    //     Divider(
    //       color: ThemeColors.border.withOpacity(0.4),
    //       thickness: 1,
    //       height: 30.sp,
    //     ),
    //     _typeSelect(
    //       heading: "${widget.symbol} Sentiment Spike",
    //       description:
    //           "Alert if ${widget.symbol} news sentiment changes significantly.",
    //       onTap: () => selectType(index: 0),
    //       isSelected: selectedOne,
    //     ),
    //     Divider(
    //       color: ThemeColors.border.withOpacity(0.4),
    //       thickness: 1,
    //       height: 30.sp,
    //     ),
    //     _typeSelect(
    //       heading: "${widget.symbol} Mentions Spike",
    //       description: "Alert if ${widget.symbol} has a surge in mentions.",
    //       onTap: () => selectType(index: 1),
    //       isSelected: selectedTwo,
    //     ),
    //     Divider(
    //       color: ThemeColors.border.withOpacity(0.4),
    //       thickness: 1,
    //       height: 30.sp,
    //     ),
    //     Text(
    //       "Choose sentiment spike or mentions spike or both to receive email alerts and app notification for the selected stock.",
    //       style: stylePTSansRegular(fontSize: 12),
    //     ),
    //     Container(
    //       margin: EdgeInsets.symmetric(vertical: 10.sp),
    //       padding: EdgeInsets.symmetric(vertical: 5.sp, horizontal: 5.sp),
    //       decoration: const BoxDecoration(
    //           color: ThemeColors.greyBorder,
    //           border:
    //               Border(left: BorderSide(color: ThemeColors.white, width: 3))),
    //       child: Text(
    //         "Note: Please be aware that you will receive an email only once a day, around 8:00 AM (EST), in the event of any spike.",
    //         style: stylePTSansRegular(fontSize: 12),
    //       ),
    //     ),
    //     Text(
    //       "In future if you don't want to receive any email then delete stocks added into alert section.",
    //       style: stylePTSansRegular(fontSize: 12),
    //     ),
    //     Divider(
    //       color: ThemeColors.border.withOpacity(0.4),
    //       thickness: 1,
    //       height: 30.sp,
    //     ),
    //     ThemeButton(
    //       color: ThemeColors.accent,
    //       onPressed: selectedOne == false && selectedTwo == false
    //           ? null
    //           : () => _showAlertPopup(context),
    //       text: "Continue",
    //       textColor: selectedOne == false && selectedTwo == false
    //           ? ThemeColors.background
    //           : ThemeColors.border,
    //     ),
    //     const SpacerVertical(height: 10),
    //   ],
    // );
  }

  void _showAlertPopup(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return SetupPopup(
            onCreateAlert: _onCreateAlert,
            topTextField: ThemeInputField(
              controller: controller,
              placeholder: "Enter alert",
              // keyboardType: TextInputType.phone,
              inputFormatters: const [],
            ),
            bottomTextField: Text(
              symbolController.text,
              style: stylePTSansBold(),
            ),
            //  ThemeInputField(

            //   controller: symbolController,
            //   editable: false,
            // ),
            selectedOne: selectedOne,
            selectedTwo: selectedTwo,
          );
        });
  }

  void _onCreateAlert() {
    TrendingProvider trendingProvider = context.read<TrendingProvider>();
    StockDetailProvider stockDetailProvider =
        context.read<StockDetailProvider>();
    TopTrendingProvider topTrendingProvider =
        context.read<TopTrendingProvider>();

    widget.fromTrending
        ? trendingProvider.createAlertSend(
            index: widget.index,
            up: widget.up,
            symbol: widget.symbol,
            alertName: controller.text,
            selectedOne: selectedOne,
            selectedTwo: selectedTwo,
          )
        : widget.fromStockDetail
            ? stockDetailProvider.createAlertSend(
                selectedOne: selectedOne,
                selectedTwo: selectedTwo,
                alertName: controller.text,
              )
            : widget.fromTopStock
                ? topTrendingProvider.createAlertSend(
                    alertName: controller.text,
                    symbol: widget.symbol,
                    index: widget.index,
                  )
                : null;
  }

  Widget _typeSelect({
    void Function()? onTap,
    bool isSelected = false,
    required String description,
    required String heading,
  }) {
    return InkWell(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            heading,
            style: stylePTSansBold(fontSize: 13),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 5.sp),
            child: Row(
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  isSelected
                      ? Icons.check_box
                      : Icons.check_box_outline_blank_rounded,
                  size: 22.sp,
                  color: isSelected ? ThemeColors.accent : ThemeColors.border,
                ),
                const SpacerHorizontal(width: 8),
                Expanded(
                  child: Text(
                    description,
                    style: stylePTSansRegular(fontSize: 13),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _header(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Row(
            children: [
              Icon(
                Icons.notifications,
                size: 15.sp,
                color: ThemeColors.accent,
              ),
              Text(
                "New Alert",
                style: stylePTSansBold(color: ThemeColors.accent, fontSize: 12),
              ),
            ],
          ),
        ),
        // InkWell(
        //   onTap: () => Navigator.pop(context),
        //   child: Icon(Icons.close, size: 20.sp),
        // )
      ],
    );
  }
}
