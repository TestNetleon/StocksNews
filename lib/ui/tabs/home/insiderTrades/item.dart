import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import '../../../../models/my_home_premium.dart';
import '../../../../widgets/spacer_vertical.dart';
import '../../signals/insiders/company/from_company.dart';
import '../../signals/insiders/reporting/from_reporting.dart';

class HomeInsiderTradeItem extends StatelessWidget {
  final InsiderTradeRes data;
  const HomeInsiderTradeItem({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    bool namePresent = data.reportingName != null && data.reportingName != '';
    bool typeOwnerPresent = data.typeOfOwner != null && data.typeOfOwner != '';
    return Container(
      width: 200.sp,
      margin: EdgeInsets.only(bottom: Pad.pad24, right: Pad.pad24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Visibility(
            visible: namePresent || typeOwnerPresent,
            child: InkWell(
              onTap: () {
                if (data.reportingCik == null || data.reportingCik == '') {
                  return;
                }

                Navigator.pushNamed(context, SignalInsidersReportingIndex.path,
                    arguments: {'data': data});
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Visibility(
                    visible: namePresent,
                    child: Text(
                      data.reportingName ?? "",
                      style: styleBaseBold(fontSize: 14),
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
          ),

          // Visibility(
          //   visible: data.reportingName != null && data.reportingName != '',
          //   child: Text(
          //     data.reportingName ?? '',
          //     style: styleBaseBold(fontSize: 16),
          //   ),
          // ),
          // Visibility(
          //   visible: data.typeOfOwner != null && data.typeOfOwner != '',
          //   child: Text(
          //     '${data.typeOfOwner}',
          //     style: styleBaseRegular(
          //       fontSize: 14,
          //       color: ThemeColors.neutral40,
          //     ),
          //   ),
          // ),
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
                          child: CachedNetworkImage(
                            imageUrl: data.image ?? '',
                            height: 30,
                            width: 44,
                          ),
                        ),
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                data.symbol ?? '',
                                style: styleBaseBold(),
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
                SpacerVertical(height: 12),
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
    );
  }
}
