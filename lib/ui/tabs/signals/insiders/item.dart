import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/models/my_home.dart';
import 'package:stocks_news_new/ui/base/app_bar.dart';
import 'package:stocks_news_new/ui/theme/manager.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/utils/utils.dart';

import 'company/from_company.dart';
import 'reporting/from_reporting.dart';

class BaseInsiderItem extends StatelessWidget {
  // final int index;
  final void Function()? onTap;
  final InsiderTradeRes data;
  final bool isOpen;
  const BaseInsiderItem({
    super.key,
    required this.data,
    this.onTap,
    this.isOpen = false,
  });

  @override
  Widget build(BuildContext context) {
    bool namePresent = data.reportingName != null && data.reportingName != '';
    bool typeOwnerPresent = data.typeOfOwner != null && data.typeOfOwner != '';
    bool companyNamePresent = data.name != null && data.name != '';
    bool securityTransactedPresent =
        data.securityTransacted != null && data.securityTransacted != '';
    return Container(
      padding: EdgeInsets.all(Pad.pad16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Visibility(
                visible: namePresent || typeOwnerPresent,
                child: Flexible(
                  child: InkWell(
                    onTap: () {
                      if (data.reportingCik == null ||
                          data.reportingCik == '') {
                        return;
                      }

                      Navigator.pushNamed(
                          context, SignalInsidersReportingIndex.path,
                          arguments: {'data': data});
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Visibility(
                          visible: namePresent,
                          child: Text(
                            data.reportingName ?? "",
                            // style: styleBaseBold(
                            //     fontSize: 14, color: Colors.white),
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
                ),
              ),
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    margin: EdgeInsets.only(left: Pad.pad8, right: Pad.pad8),
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
                  InkWell(
                    borderRadius: BorderRadius.circular(4),
                    onTap: onTap,
                    child: Consumer<ThemeManager>(
                      builder: (context, value, child) {
                        return Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(color: ThemeColors.neutral40),
                          ),
                          // child: Image.asset(
                          //   isOpen ? Images.arrowUP : Images.arrowDOWN,
                          //   height: 24,
                          //   width: 24,
                          //   color: value.isDarkMode
                          //       ? ThemeColors.white
                          //       : ThemeColors.black,
                          // ),
                          child: ActionButton(
                            icon: isOpen ? Images.arrowUP : Images.arrowDOWN,
                            size: 24,
                            color: ThemeColors.black,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              )
            ],
          ),
          Visibility(
            child: GestureDetector(
              onTap: () {
                if (data.companyCik == null || data.companyCik == '') return;
                Navigator.pushNamed(context, SignalInsidersCompanyIndex.path,
                    arguments: {'data': data});
              },
              child: Container(
                margin: EdgeInsets.only(top: Pad.pad8),
                child: Row(
                  children: [
                    Visibility(
                      visible: data.image != null && data.image != '',
                      child: Container(
                        margin: EdgeInsets.only(right: Pad.pad8),
                        child: CachedNetworkImage(
                          imageUrl: data.image ?? '',
                          height: 30,
                          width: 44,
                        ),
                      ),
                    ),
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Visibility(
                                visible:
                                    data.symbol != null && data.symbol != '',
                                child: Flexible(
                                  child: Text(
                                      // '${data.exchangeShortName ?? 'N/A'}: ${data.symbol ?? 'N/A'}',
                                      data.symbol ?? 'N/A',
                                      style: styleBaseBold()),
                                ),
                              ),
                              Visibility(
                                visible: data.totalTransaction != null &&
                                    data.totalTransaction != '',
                                child: Flexible(
                                  child: Container(
                                    margin: EdgeInsets.only(left: Pad.pad10),
                                    child: Text(
                                      data.totalTransaction ?? '',
                                      style: styleBaseBold(),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Visibility(
                            visible:
                                companyNamePresent || securityTransactedPresent,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Visibility(
                                  visible: data.name != null && data.name != '',
                                  child: Flexible(
                                    child: Text(
                                      data.name ?? '',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: styleBaseRegular(
                                        fontSize: 13,
                                        color: ThemeColors.neutral40,
                                      ),
                                    ),
                                  ),
                                ),
                                Visibility(
                                  visible: data.securityTransacted != null &&
                                      data.securityTransacted != '',
                                  child: Flexible(
                                    child: Container(
                                      margin: EdgeInsets.only(left: Pad.pad10),
                                      child: Text(
                                        textAlign: TextAlign.end,
                                        "${data.securityTransacted} Shares @ ${data.price}",
                                        // maxLines: 1,
                                        // overflow: TextOverflow.ellipsis,
                                        style: styleBaseRegular(fontSize: 13),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
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
                    label: 'Shares held after transaction',
                    value: data.securitiesOwned ?? 'N/A',
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
                          color: ThemeColors.secondary120,
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
