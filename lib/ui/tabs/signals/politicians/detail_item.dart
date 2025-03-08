import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:stocks_news_new/models/my_home_premium.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';

import '../../../stockDetail/index.dart';

class BasePoliticianDetailItem extends StatelessWidget {
  // final int index;
  final void Function()? onTap;
  final PoliticianTradeRes data;
  final bool isOpen;
  const BasePoliticianDetailItem({
    super.key,
    required this.data,
    this.onTap,
    this.isOpen = false,
  });

  @override
  Widget build(BuildContext context) {
    bool companyNamePresent = data.name != null && data.name != '';

    return Container(
      padding: EdgeInsets.all(Pad.pad16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, SDIndex.path, arguments: {
                'symbol': data.symbol,
              });
            },
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
                        ],
                      ),
                      Visibility(
                        visible: companyNamePresent,
                        child: Visibility(
                          visible: data.symbol != null && data.symbol != '',
                          child: Text(
                            '${data.exchangeShortName ?? 'N/A'}: ${data.symbol ?? 'N/A'}',
                            style: styleBaseRegular(
                              fontSize: 13,
                              color: ThemeColors.neutral40,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          margin: EdgeInsets.only(
                            left: Pad.pad8,
                            right: Pad.pad8,
                          ),
                          decoration: BoxDecoration(
                            color: data.type == 'Purchase'
                                ? ThemeColors.success10
                                : ThemeColors.error10,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            data.type ?? '',
                            style: styleBaseBold(
                              fontSize: 14,
                              color: data.type == 'Purchase'
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
                              isOpen ? Images.arrowUP : Images.arrowDOWN,
                              height: 24,
                              width: 24,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Visibility(
                      visible: data.amount != null && data.amount != '',
                      child: Container(
                        margin: EdgeInsets.only(top: Pad.pad10),
                        child: Text(
                          data.amount ?? '',
                          style: styleBaseBold(),
                        ),
                      ),
                    ),
                  ],
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
                  _dropBox(
                    label: 'Transaction Date',
                    value: data.transactionDate ?? 'N/A',
                  ),
                  _dropBox(
                    label: 'Filed Date',
                    value: data.receivedDate ?? 'N/A',
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
