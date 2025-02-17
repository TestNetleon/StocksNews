import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:stocks_news_new/models/my_home_premium.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/utils/utils.dart';

import '../company/from_company.dart';

class BaseInsiderReportingItem extends StatelessWidget {
  // final int index;
  final void Function()? onTap;
  final InsiderTradeRes data;
  final bool isOpen;
  const BaseInsiderReportingItem({
    super.key,
    required this.data,
    this.onTap,
    this.isOpen = false,
  });

  @override
  Widget build(BuildContext context) {
    bool companyNamePresent = data.name != null && data.name != '';
    bool securityTransactedPresent =
        data.securityTransacted != null && data.securityTransacted != '';
    return Container(
      padding: EdgeInsets.all(Pad.pad16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              if (data.companyCik == null || data.companyCik == '') return;
              Navigator.pushReplacementNamed(
                  context, SignalInsidersCompanyIndex.path,
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
                              visible: data.name != null && data.name != '',
                              child: Flexible(
                                child: Text(
                                  data.name ?? '',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: styleBaseBold(),
                                ),
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
                            children: [
                              Visibility(
                                visible:
                                    data.symbol != null && data.symbol != '',
                                child: Flexible(
                                  child: Text(
                                    '${data.exchangeShortName ?? 'N/A'}: ${data.symbol ?? 'N/A'}',
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
                                      "${data.securityTransacted} @ ${data.price}",
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
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
                  Row(
                    children: [
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        margin:
                            EdgeInsets.only(left: Pad.pad8, right: Pad.pad8),
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
                  )
                ],
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
