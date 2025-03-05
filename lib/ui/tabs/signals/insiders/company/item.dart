import 'package:flutter/material.dart';
import 'package:stocks_news_new/models/my_home_premium.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';

import '../reporting/from_reporting.dart';

class BaseInsiderCompanyItem extends StatelessWidget {
  // final int index;
  final void Function()? onTap;
  final InsiderTradeRes data;
  final bool isOpen;
  const BaseInsiderCompanyItem({
    super.key,
    required this.data,
    this.onTap,
    this.isOpen = false,
  });

  @override
  Widget build(BuildContext context) {
    bool namePresent = data.reportingName != null && data.reportingName != '';
    bool typeOwnerPresent = data.typeOfOwner != null && data.typeOfOwner != '';

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
                  child: GestureDetector(
                    onTap: () {
                      if (data.reportingCik == null ||
                          data.reportingCik == '') {
                        return;
                      }
                      Navigator.pushReplacementNamed(
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
          Container(
            margin: EdgeInsets.only(top: Pad.pad8),
            alignment: Alignment.centerRight,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Visibility(
                  visible: data.totalTransaction != null &&
                      data.totalTransaction != '',
                  child: Container(
                    margin: EdgeInsets.only(left: Pad.pad10),
                    child: Text(
                      data.totalTransaction ?? '',
                      style: styleBaseBold(),
                    ),
                  ),
                ),
                Visibility(
                  visible: data.securityTransacted != null &&
                      data.securityTransacted != '',
                  child: Container(
                    margin: EdgeInsets.only(left: Pad.pad10),
                    child: Text(
                      "${data.securityTransacted} Shares @ ${data.price}",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: styleBaseRegular(fontSize: 13),
                    ),
                  ),
                ),
              ],
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
                  // _dropBox(s
                  //   label: 'Total Transaction',
                  //   value: data.totalTransaction ?? 'N/A',
                  // ),
                  _dropBox(
                    label: 'Shares held after transaction',
                    value: data.securitiesOwned ?? 'N/A',
                  ),
                  _dropBox(
                    label: 'Transaction Date',
                    value: data.transactionDate ?? 'N/A',
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
