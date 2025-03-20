import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/routes/my_app.dart';
import 'package:stocks_news_new/ui/theme/manager.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import '../../../models/stockDetail/dividends.dart';

class DividendHistoryItem extends StatelessWidget {
  final void Function()? onTap;
  final DividendsDataRes data;
  final bool isOpen;
  const DividendHistoryItem({
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
                  visible: data.announced != null && data.announced != '',
                  child: Text(
                    data.announced ?? '-',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    // style: styleBaseRegular(fontSize: 14),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
              ),
              Row(
                children: [
                  Visibility(
                    visible: data.amount != null,
                    child: Text(
                      data.amount ?? '-',
                      // style: styleBaseBold(fontSize: 16),
                      style: Theme.of(context).textTheme.displayLarge,
                    ),
                  ),
                  SpacerHorizontal(width: 4),
                  Padding(
                    padding: EdgeInsets.only(left: 4),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(4),
                      onTap: onTap,
                      child: Consumer<ThemeManager>(
                        builder: (context, value, child) {
                          return Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(color: ThemeColors.neutral40),
                            ),
                            child: Image.asset(
                              isOpen ? Images.arrowUP : Images.arrowDOWN,
                              height: 24,
                              width: 24,
                              color: ThemeColors.black,
                            ),
                          );
                        },
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
                    label: 'Yield',
                    value: data.datumYield ?? 'N/A',
                  ),
                  _dropBox(
                    label: 'Ex-Dividend Date',
                    value: data.exDividendDate ?? 'N/A',
                  ),
                  _dropBox(
                    label: 'Record Date',
                    value: data.recordDate ?? 'N/A',
                  ),
                  _dropBox(
                    label: 'Payable Date',
                    value: data.payableDate ?? 'N/A',
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
              // style: styleBaseSemiBold(fontSize: 13),
              style:
                  Theme.of(navigatorKey.currentContext!).textTheme.labelMedium,
            ),
          ),
        ],
      ),
    );
  }
}
