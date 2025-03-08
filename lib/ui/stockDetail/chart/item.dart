import 'package:flutter/material.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import '../../../models/stockDetail/chart.dart';

class ChartHistoryItem extends StatelessWidget {
  final void Function()? onTap;
  final PriceHistoryDataRes data;
  final bool isOpen;
  const ChartHistoryItem({
    super.key,
    required this.data,
    this.onTap,
    this.isOpen = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(Pad.pad16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Visibility(
                  visible: data.date != null && data.date != '',
                  child: Text(
                    data.date ?? '-',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: styleBaseRegular(fontSize: 14),
                  ),
                ),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Visibility(
                    visible:
                        data.openingPrice != null && data.openingPrice != '',
                    child: Text(
                      data.openingPrice ?? '-',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: styleBaseBold(fontSize: 14),
                    ),
                  ),
                ),
              ),
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Visibility(
                        visible: data.closingPrice != null &&
                            data.closingPrice != '',
                        child: Text(
                          data.closingPrice ?? '-',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: styleBaseBold(fontSize: 14),
                        ),
                      ),
                      Visibility(
                        visible: data.changePercent != null,
                        child: Text(
                          '${data.changePercent ?? '0'}%',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: styleBaseSemiBold(
                              fontSize: 13,
                              color: (data.changePercent ?? 0) >= 0
                                  ? ThemeColors.success120
                                  : ThemeColors.error120),
                        ),
                      ),
                    ],
                  ),
                  SpacerHorizontal(width: 4),
                  Padding(
                    padding: EdgeInsets.only(left: 4),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(4),
                      onTap: onTap,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: ThemeColors.neutral5),
                        ),
                        child: Image.asset(

                          isOpen ? Images.arrowUP : Images.arrowDOWN,
                          height: 24,
                          width: 24,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 150),
            child: Container(
              height: isOpen ? null : 0,
              margin: EdgeInsets.only(
                top: isOpen ? 10 : 0,
                bottom: isOpen ? 10 : 0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _dropBox(
                    label: 'High',
                    value: data.high ?? 'N/A',
                  ),
                  _dropBox(
                    label: 'Low',
                    value: data.low ?? 'N/A',
                  ),
                  _dropBox(
                    label: 'Volume',
                    value: data.volume ?? 'N/A',
                  ),
                  _dropBox(
                    label: 'Market Cap',
                    value: data.marketCapitalization ?? 'N/A',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _dropBox({required String label, String? value}) {
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
              value ?? 'N/A',
              style: styleBaseSemiBold(fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}
