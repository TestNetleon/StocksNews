import 'package:flutter/material.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';

import '../../../models/stockDetail/analyst_forecast.dart';
import '../../../utils/utils.dart';

class AnalystForecastItem extends StatelessWidget {
  final void Function()? onTap;
  final AnalystForecastRes data;
  final bool isOpen;
  const AnalystForecastItem({
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
                    Visibility(
                      visible:
                          data.analystName != null && data.analystName != '',
                      child: Text(
                        data.analystName ?? '',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: styleBaseBold(),
                      ),
                    ),
                    Visibility(
                      visible: data.brokerage != null && data.brokerage != '',
                      child: Text(
                        data.brokerage ?? 'N/A',
                        style: styleBaseRegular(
                          fontSize: 13,
                          color: ThemeColors.neutral40,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  Visibility(
                    visible: data.priceTarget != null && data.priceTarget != '',
                    child: Text(
                      data.priceTarget ?? '',
                      style: styleBaseBold(fontSize: 16),
                    ),
                  ),
                  Visibility(
                    visible: data.upDown != null,
                    child: Container(
                      margin: EdgeInsets.only(left: 4),
                      child: Text(
                        '${data.upDown ?? '-'}%',
                        style: styleBaseSemiBold(
                          fontSize: 13,
                          color: (data.upDown ?? 0) >= 0
                              ? ThemeColors.success120
                              : ThemeColors.error120,
                        ),
                      ),
                    ),
                  ),
                  SpacerHorizontal(width: 4),
                  Padding(
                    padding: EdgeInsets.only(left: 4),
                    child: InkWell(
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
                    label: 'Date',
                    value: data.date ?? 'N/A',
                  ),
                  _dropBox(
                    label: 'Price when Posted',
                    value: data.priceWhenPosted ?? 'N/A',
                  ),
                  Visibility(
                    visible: data.newsUrl != null && data.newsUrl != '',
                    child: InkWell(
                      onTap: () {
                        openUrl(data.newsUrl);
                      },
                      child: Text(
                        'View Details',
                        style: styleBaseSemiBold(
                          color: ThemeColors.primary120,
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
