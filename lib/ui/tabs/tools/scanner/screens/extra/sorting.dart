import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/ui/tabs/tools/scanner/manager/scanner.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';

class MarketSortingHeader extends StatefulWidget {
  const MarketSortingHeader({
    super.key,
  });

  @override
  State<MarketSortingHeader> createState() => _MarketSortingHeaderState();
}

class _MarketSortingHeaderState extends State<MarketSortingHeader> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ScannerManager>(
      builder: (context, value, child) {
        return Column(
          children: [
            Container(
              margin: EdgeInsets.symmetric(
                  horizontal: Pad.pad16, vertical: Pad.pad10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: RichText(
                      text: TextSpan(
                        text: 'No. of Results: ',
                        style: styleBaseRegular(
                          color: ThemeColors.neutral20,
                          fontSize: 13,
                        ),
                        children: [
                          TextSpan(
                            text: '${value.totalResult ?? 0}',
                            style: styleBaseSemiBold(
                              color: ThemeColors.neutral40,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SpacerHorizontal(width: 20),
                  InkWell(
                    onTap: () {
                      ScannerManager manager = context.read<ScannerManager>();
                      manager.sorting();
                    },
                    child: Image.asset(
                      Images.marketFilter,
                      height: 19,
                      width: 19,
                      color: value.sortingApplied
                          ? ThemeColors.accent
                          : ThemeColors.neutral40,
                    ),
                  ),
                ],
              ),
            ),
            Divider(
              color: ThemeColors.neutral5,
              height: 0,
              thickness: 1,
            ),
          ],
        );
      },
    );
  }
}
