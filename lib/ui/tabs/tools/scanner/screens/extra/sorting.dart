import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/service/events/service.dart';
import 'package:stocks_news_new/ui/base/base_list_divider.dart';
import 'package:stocks_news_new/ui/tabs/tools/scanner/manager/scanner.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/utils/utils.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';

import 'filters.dart';

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
                  Row(
                    children: [
                      Visibility(
                        visible: value.selectedIndex == 0,
                        child: InkWell(
                          onTap: () {
                            EventsService.instance.filterByScannerTabScannerPage();
                            value.setUsingFilter(true);
                            Navigator.push(
                                context, createRoute(ScannerFilters()));
                          },
                          child: Image.asset(
                            Images.filter,
                            height: 19,
                            width: 19,
                            // color: ThemeColors.neutral40,
                            color: ThemeColors.accent,
                          ),
                        ),
                      ),
                      SpacerHorizontal(width: 20),
                      InkWell(
                        onTap: () {
                          value.selectedIndex==0?
                          EventsService.instance.sortByScannerTabScannerPage():
                          value.selectedIndex==1?
                          EventsService.instance.sortByGainerTabChangePage(innerIndex: value.selectedSubIndex):
                          EventsService.instance.sortByLoserTabChangePage(innerIndex: value.selectedSubIndex);
                          value.sorting();
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
                ],
              ),
            ),
            BaseListDivider(
              height: 0,
            ),
          ],
        );
      },
    );
  }
}
