import 'package:flutter/material.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import '../../../models/stockDetail/ownership.dart';
import '../../../widgets/linear_bar.dart';

class OwnershipHistoryItem extends StatelessWidget {
  final void Function()? onTap;
  final OwnershipDataRes data;
  final bool isOpen;
  const OwnershipHistoryItem({
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Visibility(
                      visible:
                          data.investorName != null && data.investorName != '',
                      child: Text(
                        data.investorName ?? '-',
                        // maxLines: 1,
                        // overflow: TextOverflow.ellipsis,
                        style: styleBaseBold(fontSize: 14),
                      ),
                    ),
                    Visibility(
                      visible: data.reportingDate != null &&
                          data.reportingDate != '',
                      child: Text(
                        data.reportingDate ?? '-',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: styleBaseRegular(fontSize: 12,color: ThemeColors.neutral40),
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Visibility(
                        visible: data.sharesNumber != null,
                        child: Text(
                          data.sharesNumber ?? '-',
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
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: LinearBarCommon(
              value: data.ownership ?? 0,
            ),
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
                    label: 'Market Value',
                    value: data.marketValue ?? 'N/A',
                  ),
                  _dropBox(
                    label: 'Ownership',
                    value: '${data.ownership ?? '0'}%',
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
