import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/routes/my_app.dart';
import 'package:stocks_news_new/ui/base/base_list_divider.dart';
import 'package:stocks_news_new/ui/base/bottom_sheet.dart';
import 'package:stocks_news_new/ui/base/button.dart';
import 'package:stocks_news_new/ui/tabs/tools/simulator/managers/portpolio.dart';
import 'package:stocks_news_new/ui/tabs/tools/simulator/managers/s_recurring.dart';
import 'package:stocks_news_new/ui/tabs/tools/simulator/models/ts_recurring_list_res.dart';
import 'package:stocks_news_new/ui/tabs/tools/simulator/screens/ConditionalOrder/RecurringOrder/recurring_detail.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/cache_network_image.dart';
import 'package:stocks_news_new/widgets/custom/alert_popup.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';

class RecurringActions extends StatefulWidget {
  final String? symbol;
  final TsRecurringListRes? item;
  final int index;
  const RecurringActions(
      {super.key, this.symbol, required this.index, this.item});

  @override
  State<RecurringActions> createState() => _RecurringActionsState();
}

class _RecurringActionsState extends State<RecurringActions> {
  void _onEditClick() {
    popUpAlert(
      icon: Images.alertPopGIF,
      title: "Confirm",
      message: "Do you want to edit this order?",
      cancel: true,
      okText: "Edit",
      onTap: () {
        Navigator.pop(context);
        context.read<PortfolioManager>().getHolidays();
        SRecurringManager manager = context.read<SRecurringManager>();
        manager.recurringCondition(widget.symbol ?? "", index: widget.index);
      },
    );
  }

  void _onCancelClick() {
    popUpAlert(
      icon: Images.alertPopGIF,
      title: "Confirm",
      message: "Do you want to cancel this order?",
      cancel: true,
      cancelText: "No",
      okText: "Yes, cancel",
      onTap: () async {
        Navigator.pop(context);
        SRecurringManager manager = context.read<SRecurringManager>();
        manager.cancelOrder(widget.item?.id);
      },
    );
  }

  void viewRedirection() {
    Navigator.pop(navigatorKey.currentContext!);
    BaseBottomSheet().bottomSheet(
        barrierColor: ThemeColors.neutral5.withValues(alpha: 0.7),
        child: RecurringDetail(widget.item));
    /*showModalBottomSheet(
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
    );*/
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(Pad.pad5),
              child: Container(
                padding: EdgeInsets.all(3.sp),
                color: ThemeColors.neutral5,
                child: CachedNetworkImagesWidget(
                  widget.item?.image ?? "",
                  height: 41,
                  width: 41,
                ),
              ),
            ),
            const SpacerHorizontal(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${widget.item?.symbol}',
                    style: styleBaseBold(
                        color: ThemeColors.splashBG, fontSize: 16),
                  ),
                  Text(
                    '${widget.item?.company}',
                    style: styleBaseRegular(
                        color: ThemeColors.neutral40, fontSize: 14),
                  ),
                  Text(
                    '${widget.item?.frequencyString}',
                    style: styleBaseRegular(
                        color: ThemeColors.neutral40, fontSize: 14),
                  ),
                ],
              ),
            ),
            const SpacerHorizontal(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Visibility(
                  visible: widget.item?.recurringAmount != null,
                  child: Text(
                    '${widget.item?.recurringAmount?.toFormattedPrice()}',
                    style: styleBaseBold(
                        color: ThemeColors.splashBG, fontSize: 18),
                  ),
                ),
              ],
            ),
          ],
        ),
        BaseListDivider(
          height: 20,
        ),
        Row(
          children: [
            Visibility(
              visible: (widget.item?.transactionCount ?? 0) >= 1,
              child: Expanded(
                child: BaseButton(
                  text: "View",
                  color: ThemeColors.splashBG,
                  textColor: ThemeColors.white,
                  onPressed: viewRedirection,
                ),
              ),
            ),
            Visibility(
                visible: widget.item?.statusType == "RUNNING",
                child: const SpacerHorizontal(width: 10)),
            Visibility(
              visible: widget.item?.statusType == "RUNNING",
              child: Expanded(
                child: BaseButton(
                  text: "Edit",
                  color: ThemeColors.success120,
                  textColor: ThemeColors.white,
                  onPressed: _onEditClick,
                ),
              ),
            ),
            Visibility(
                visible: widget.item?.statusType == "RUNNING",
                child: const SpacerHorizontal(width: 10)),
            Visibility(
              visible: widget.item?.statusType == "RUNNING",
              child: Expanded(
                child: BaseButton(
                  text: "Close",
                  color: ThemeColors.error120,
                  textColor: ThemeColors.white,
                  onPressed: _onCancelClick,
                ),
              ),
            ),
          ],
        ),
        Visibility(
          visible: (widget.item?.statusTypeString == "Closed"),
          child: Text(
            '${widget.item?.statusTypeString}',
            style: styleBaseBold(color: ThemeColors.error120, fontSize: 18),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
