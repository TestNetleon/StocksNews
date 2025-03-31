import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stocks_news_new/models/my_home.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/cache_network_image.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import '../../signals/insiders/company/from_company.dart';
import '../../signals/insiders/reporting/from_reporting.dart';

class HomeInsiderTradeItem extends StatelessWidget {
  final InsiderTradeRes data;
  const HomeInsiderTradeItem({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    bool namePresent = data.reportingName != null && data.reportingName != '';
    bool typeOwnerPresent = data.typeOfOwner != null && data.typeOfOwner != '';
    return GestureDetector(
      onTap: () {
        if (data.reportingCik == null || data.reportingCik == '') {
          return;
        }

        Navigator.pushNamed(context, SignalInsidersReportingIndex.path,
            arguments: {'data': data});
      },
      child: Container(
        width: 200.sp,
        margin: EdgeInsets.only(bottom: Pad.pad24, right: Pad.pad24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Visibility(
              visible: data.reportingImage != null && data.reportingImage != '',
              child: Padding(
                padding: const EdgeInsets.only(bottom: Pad.pad10),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: CachedNetworkImagesWidget(
                    data.reportingImage,
                    height: 250,
                    width: 250,
                    showLoading: true,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Visibility(
              visible: namePresent || typeOwnerPresent,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Visibility(
                    visible: namePresent,
                    child: Text(
                      data.reportingName ?? "",
                      // style: styleBaseBold(fontSize: 14),
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                  Visibility(
                    visible: typeOwnerPresent,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Text(
                        data.typeOfOwner ?? "",
                        style: styleBaseRegular(
                          fontSize: 12,
                          color: ThemeColors.neutral40,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: Pad.pad5),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: GestureDetector(
                      onTap: () {
                        if (data.companyCik == null || data.companyCik == '') {
                          return;
                        }
                        Navigator.pushNamed(
                            context, SignalInsidersCompanyIndex.path,
                            arguments: {'data': data});
                      },
                      child: Row(
                        children: [
                          Container(
                            margin: EdgeInsets.only(right: Pad.pad8),
                            child: CachedNetworkImagesWidget(
                              data.image ?? '',
                              height: 44,
                              width: 44,
                            ),
                          ),
                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  data.symbol ?? '',
                                  // style: styleBaseBold(),
                                  style:
                                      Theme.of(context).textTheme.displayLarge,
                                ),
                                Text(
                                  data.name ?? '',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: styleBaseRegular(
                                    fontSize: 13,
                                    color: ThemeColors.neutral40,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SpacerHorizontal(width: 5),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: data.transactionType == 'Buy'
                          ? ThemeColors.success10
                          : ThemeColors.error10,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      data.transactionType ?? '',
                      style: styleBaseBold(
                        fontSize: 14,
                        color: data.transactionType == 'Buy'
                            ? ThemeColors.success120
                            : ThemeColors.error120,
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
