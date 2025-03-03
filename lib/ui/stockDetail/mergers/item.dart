import 'package:flutter/material.dart';
import 'package:stocks_news_new/models/stockDetail/mergers.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/utils/utils.dart';

import '../../../widgets/spacer_vertical.dart';

class SDMergersItem extends StatelessWidget {
  // final int index;
  final void Function()? onTap;
  final MergersDataRes data;
  final bool isOpen;
  const SDMergersItem({
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
                    Text(
                      data.symbol ?? '',
                      style: styleBaseBold(fontSize: 16),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SpacerVertical(height: 2),
                    Text(
                      data.targetedCompanyName ?? '',
                      style: styleBaseRegular(
                        fontSize: 14,
                        color: ThemeColors.neutral40,
                      ),
                    ),
                  ],
                ),
              ),
              InkWell(
                borderRadius: BorderRadius.circular(4),
                onTap: onTap,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: ThemeColors.neutral5),
                  ),
                  child: Image.asset(
                    isOpen ? Images.arrowDOWN : Images.arrowUP,
                    height: 24,
                    width: 24,
                  ),
                ),
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
                    label: 'Acceptance Time',
                    value: data.acceptanceTime ?? 'N/A',
                  ),
                  _dropBox(
                    label: 'Transaction Date',
                    value: data.transactionDate ?? 'N/A',
                  ),
                  Visibility(
                    visible: data.link != null && data.link != '',
                    child: InkWell(
                      onTap: () {
                        openUrl(data.link);
                      },
                      child: Text(
                        'View Details',
                        style: styleBaseSemiBold(
                          color: ThemeColors.secondary100,
                          fontSize: 13,
                        ),
                      ),
                    ),
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
