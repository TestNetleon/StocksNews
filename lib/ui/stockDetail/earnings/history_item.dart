import 'package:flutter/material.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import '../../../models/stockDetail/earning.dart';

class EarningsHistoryItem extends StatelessWidget {
  final void Function()? onTap;
  final SDEarningHistoryDataRes data;
  final bool isOpen;
  const EarningsHistoryItem({
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
              Flexible(
                child: Visibility(
                  visible: data.quarter != null && data.quarter != '',
                  child: Text(
                    data.quarter ?? '-',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: styleBaseRegular(fontSize: 14),
                  ),
                ),
              ),
              Row(
                children: [
                  Visibility(
                    visible: data.reportedEps != null,
                    child: Text(
                      data.reportedEps ?? '-',
                      style: styleBaseBold(fontSize: 16),
                    ),
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
                    label: 'Date',
                    value: data.date ?? 'N/A',
                  ),
                  _dropBox(
                    label: 'Consensus Estimate',
                    value: data.consensusEstimate ?? 'N/A',
                  ),
                  _dropBox(
                    label: 'Revenue Estimate',
                    value: data.revenueEstimate ?? 'N/A',
                  ),
                  _dropBox(
                    label: 'Actual Estimate',
                    value: data.actualRevenue ?? 'N/A',
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
