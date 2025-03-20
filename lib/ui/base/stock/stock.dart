import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stocks_news_new/models/stockDetail/overview.dart';
import 'package:stocks_news_new/models/ticker.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/cache_network_image.dart';
import 'package:stocks_news_new/widgets/optional_parent.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

class BaseStockItem extends StatefulWidget {
  final BaseTickerRes data;
  final int index;
  final List<BaseKeyValueRes>? expandable;
  const BaseStockItem({
    super.key,
    required this.data,
    required this.index,
    this.expandable,
  });

  @override
  State<BaseStockItem> createState() => _BaseStockItemState();
}

class _BaseStockItemState extends State<BaseStockItem> {
  int _openIndex = -1;

  void _toggleOpen(int index) {
    setState(() {
      _openIndex = (_openIndex == index) ? -1 : index;
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isOpen = _openIndex == widget.index;
    return Container(
      padding: EdgeInsets.all(Pad.pad16),
      color: ThemeColors.itemBack,
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(Pad.pad5),
                child: Container(
                  padding: EdgeInsets.all(3.sp),
                  color: ThemeColors.neutral5,
                  child: CachedNetworkImagesWidget(
                    widget.data.image,
                    height: 41,
                    width: 41,
                  ),
                ),
              ),
              const SpacerHorizontal(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    OptionalParent(
                      addParent:
                          widget.data.type != null && widget.data.type != '',
                      parentBuilder: (child) {
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Flexible(child: child),
                            Container(
                              margin: EdgeInsets.only(left: Pad.pad8),
                              padding: EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: ThemeColors.secondary10,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                widget.data.type ?? '',
                                style: styleBaseSemiBold(
                                  fontSize: 12,
                                  color: widget.data.type == 'EQUITY'
                                      ? ThemeColors.success120
                                      : ThemeColors.secondary120,
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                      child: Text(
                        widget.data.symbol ?? '',
                        // style: styleBaseBold(fontSize: 16),
                        style: Theme.of(context).textTheme.displayLarge,

                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SpacerVertical(height: 2),
                    Text(
                      widget.data.name ?? '',
                      style: styleBaseRegular(
                        fontSize: 14,
                        color: ThemeColors.neutral40,
                      ),
                    ),
                    const SpacerVertical(height: 2),
                    if (widget.data.mentions != null &&
                        widget.data.rank != null)
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: styleBaseSemiBold(fontSize: 14),
                          children: [
                            TextSpan(text: "Mentions: ${widget.data.mentions}"),
                            TextSpan(text: " ("),
                            WidgetSpan(
                              child: Icon(
                                Icons.arrow_drop_up_rounded,
                                size: 18,
                                color: ThemeColors.accent,
                              ),
                            ),
                            TextSpan(text: "${widget.data.rank} )"),
                          ],
                        ),
                      )
                  ],
                ),
              ),
              const SpacerHorizontal(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Visibility(
                    visible: widget.data.displayPrice != null &&
                        widget.data.displayPrice != '',
                    child: Text(
                      widget.data.displayPrice ?? '',
                      // style: styleBaseBold(fontSize: 16),
                      style: Theme.of(context).textTheme.displayLarge,
                    ),
                  ),
                  Visibility(
                    visible: widget.data.mentionCount != null,
                    child: Text(
                      '${widget.data.mentionCount}',
                      style: styleBaseBold(fontSize: 16),
                    ),
                  ),
                  Visibility(
                    visible: widget.data.mentionDate != null,
                    child: Text(
                      widget.data.mentionDate ?? '',
                      style: styleBaseRegular(
                        fontSize: 13,
                        color: ThemeColors.neutral40,
                      ),
                    ),
                  ),
                  Visibility(
                    visible: widget.data.displayChange != null &&
                        widget.data.displayChange != '',
                    child: Container(
                      margin: EdgeInsets.only(top: 2),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            widget.data.displayChange ?? '',
                            style: styleBaseSemiBold(
                              fontSize: 13,
                              color: (widget.data.changesPercentage ?? 0) < 0
                                  ? ThemeColors.darkRed
                                  : ThemeColors.darkGreen,
                            ),
                          ),
                          const SpacerHorizontal(width: 5),
                          Visibility(
                            visible: widget.data.changesPercentage != null,
                            child: Text(
                              "(${widget.data.changesPercentage ?? ''}%)",
                              style: styleBaseSemiBold(
                                fontSize: 13,
                                color: num.parse(
                                            "${widget.data.changesPercentage ?? 0}") <
                                        0
                                    ? ThemeColors.darkRed
                                    : ThemeColors.darkGreen,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Visibility(
                visible: widget.expandable != null,
                child: Container(
                  margin: EdgeInsets.only(left: 8),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(4),
                    onTap: () => _toggleOpen(widget.index),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: ThemeColors.neutral40),
                      ),
                      child: Image.asset(
                        _openIndex == widget.index
                            ? Images.arrowUP
                            : Images.arrowDOWN,
                        height: 24,
                        width: 24,
                        color:
                            // value.isDarkMode
                            //     ? ThemeColors.white
                            //     :
                            ThemeColors.black,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          _bottomWidget(label: 'QTY', slug: widget.data.quantity),
          _bottomWidget(
            label: 'Current Value(QTY X Close price)',
            slug: widget.data.investmentValue,
          ),
          if (widget.data.additionalInfo != null &&
              widget.data.additionalInfo?.isNotEmpty == true)
            Container(
              margin: EdgeInsets.only(top: Pad.pad8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(
                  widget.data.additionalInfo?.length ?? 0,
                  (index) {
                    AdditionalInfoRes? info =
                        widget.data.additionalInfo?[index];
                    if (info == null) {
                      return SizedBox();
                    }
                    return Flexible(
                      child: Column(
                        children: [
                          Text(
                            info.title ?? '',
                            style: styleBaseRegular(),
                          ),
                          Text(
                            info.value ?? '',
                            style: styleBaseSemiBold(
                              color: info.title == 'Bullish'
                                  ? ThemeColors.success120
                                  : info.title == 'Bearish'
                                      ? ThemeColors.error120
                                      : ThemeColors.black,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          Visibility(
            visible: widget.expandable != null,
            child: AnimatedSize(
              duration: const Duration(milliseconds: 150),
              child: Container(
                  height: isOpen ? null : 0,
                  margin: EdgeInsets.only(
                    top: isOpen ? 10 : 0,
                    bottom: isOpen ? 10 : 0,
                  ),
                  child: ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return _dropBox(
                        label: widget.expandable?[index].title ?? "",
                        value: widget.expandable?[index].value ?? 'N/A',
                        color: widget.expandable?[index].color,
                      );
                    },
                    separatorBuilder: (context, index) {
                      return SizedBox();
                    },
                    itemCount: widget.expandable?.length ?? 0,
                  )
                  // Column(
                  //   crossAxisAlignment: CrossAxisAlignment.end,
                  //   children: [
                  //     _dropBox(
                  //       label: 'Market Cap',
                  //       value: widget.data.mktCap ?? 'N/A',
                  //     ),
                  //     _dropBox(
                  //       label: 'PE Ratio',
                  //       value: widget.data.pe ?? 'N/A',
                  //     ),
                  //     _dropBox(
                  //       label: 'Employee Count',
                  //       value: widget.data.employeeCount ?? 'N/A',
                  //     ),
                  //     _dropBox(
                  //       label: 'Revenue',
                  //       value: widget.data.revenue ?? 'N/A',
                  //     ),
                  //   ],
                  // ),
                  ),
            ),
          ),
          Visibility(
            visible: widget.data.purchaseDate != null &&
                widget.data.purchaseDate != '',
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                widget.data.purchaseDate ?? '',
                style: styleBaseRegular(
                  color: ThemeColors.neutral80,
                  fontSize: 13,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _dropBox({required String label, dynamic value, color}) {
    return Container(
      margin: EdgeInsets.only(bottom: Pad.pad10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Text(
              label,
              style: styleBaseRegular(
                color: ThemeColors.neutral40,
                fontSize: 13,
              ),
            ),
          ),
          Flexible(
            child: Text(
              "$value",
              style: styleBaseSemiBold(
                fontSize: 13,
                color: color != null && color == 1
                    ? ThemeColors.accent
                    : color != null && color == -1
                        ? ThemeColors.darkRed
                        : null,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _bottomWidget({String? label, slug}) {
    if (label == null || label == '' || slug == null || slug == '') {
      return SizedBox();
    }
    return Container(
      padding: EdgeInsets.only(top: Pad.pad8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Text(
              label,
              style: styleBaseRegular(
                color: ThemeColors.neutral40,
                fontSize: 13,
              ),
            ),
          ),
          Flexible(
            child: Text(
              '$slug',
              style: styleBaseSemiBold(
                color: ThemeColors.black,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
