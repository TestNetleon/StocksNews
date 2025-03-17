import 'package:flutter/material.dart';
import 'package:stocks_news_new/routes/my_app.dart';
import 'package:stocks_news_new/ui/base/base_list_divider.dart';
import 'package:stocks_news_new/ui/base/heading.dart';
import 'package:stocks_news_new/ui/stockDetail/analysis/technical/item_averages.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import '../../../../models/stockDetail/overview.dart';
import '../../../../models/stockDetail/technical_analysis.dart';
import '../../../base/gauge.dart';
import 'item_indicator.dart';

class TechnicalAnaContainer extends StatelessWidget {
  final String? title;
  final String? subTitle;
  final TechnicalAnalysisOverviewRes overview;
  final List<BaseKeyValueRes>? data;
  final bool onAverage;

  const TechnicalAnaContainer({
    super.key,
    this.title,
    this.subTitle,
    required this.overview,
    this.data,
    this.onAverage = false,
  });

  @override
  Widget build(BuildContext context) {
    double value = overview.indicator?.toDouble() ?? 0;
    bool hasData = data != null && data!.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BaseHeading(
          title: title,
          margin: EdgeInsets.only(
            left: Pad.pad16,
            right: Pad.pad16,
            top: Pad.pad16,
            bottom: Pad.pad8,
          ),
        ),
        _buildGaugeContainer(value),
        if (onAverage && hasData)
          _buildHeaderRow(['Name', 'Value', 'Action', 'Weighted']),
        if (!onAverage && hasData) _buildHeaderRow(['Name', 'Value', 'Action']),
        if (hasData) _buildDataList(),
      ],
    );
  }

  Widget _buildGaugeContainer(double value) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: Pad.pad16),
      padding: EdgeInsets.all(Pad.pad10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: ThemeColors.neutral5),
      ),
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          BaseGaugeItem(value: value),
          Positioned(top: 20, left: 0, right: 0, child: _buildGaugeLabel()),
          Positioned(bottom: 25, left: 0, right: 0, child: _buildGaugeFooter()),
        ],
      ),
    );
  }

  Widget _buildGaugeLabel() {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: _getOverviewColor(overview.type, light: true),
          ),
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          child: Text(
            overview.type,
            style: styleBaseBold(
              fontSize: 16,
              color: _getOverviewColor(overview.type, light: false),
            ),
          ),
        ),
        SpacerVertical(height: 15),
        Container(
          margin: EdgeInsets.symmetric(horizontal: Pad.pad32),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Neutral Low',
                // style: styleBaseRegular(fontSize: 15),
                style: Theme.of(navigatorKey.currentContext!)
                    .textTheme
                    .displaySmall
                    ?.copyWith(fontSize: 15),
              ),
              Text(
                'Neutral High',
                // style: styleBaseRegular(fontSize: 15),
                style: Theme.of(navigatorKey.currentContext!)
                    .textTheme
                    .displaySmall
                    ?.copyWith(fontSize: 15),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildGaugeFooter() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: Pad.pad10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildGaugeColumn('Strong Sell', 'Sell: ${overview.totalSell ?? 0}',
              ThemeColors.error120),
          _buildGaugeColumn('Strong Buy', 'Buy: ${overview.totalBuy ?? 0}',
              ThemeColors.success120,
              alignEnd: true),
        ],
      ),
    );
  }

  Widget _buildGaugeColumn(String title, String value, Color color,
      {bool alignEnd = false}) {
    return Column(
      crossAxisAlignment:
          alignEnd ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Text(
          title,
          // style: styleBaseRegular(fontSize: 15),
          style: Theme.of(navigatorKey.currentContext!)
              .textTheme
              .displaySmall
              ?.copyWith(fontSize: 15),
        ),
        SpacerVertical(height: 4),
        Text(value, style: styleBaseBold(fontSize: 15, color: color)),
      ],
    );
  }

  Widget _buildHeaderRow(List<String> headers) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.only(
            left: Pad.pad16,
            bottom: Pad.pad10,
            right: Pad.pad16,
            top: Pad.pad24,
          ),
          child: Row(
            children: headers
                .map(
                  (title) => Expanded(
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: title == 'Name' ? 0 : 12),
                      child: Text(
                        title,
                        // style: styleBaseBold(fontSize: 14),
                        style: Theme.of(navigatorKey.currentContext!)
                            .textTheme
                            .bodyLarge,
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ),
        SpacerVertical(height: 1),
        BaseListDivider(),
      ],
    );
  }

  Widget _buildDataList() {
    return ListView.separated(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        BaseKeyValueRes? keyValues = data?[index];
        if (keyValues == null) return SizedBox();
        return onAverage
            ? TechnicalAnaItemAverages(data: keyValues)
            : TechnicalAnaItemIndicator(data: keyValues);
      },
      separatorBuilder: (context, index) => BaseListDivider(),
      itemCount: data?.length ?? 0,
    );
  }

  Color _getOverviewColor(String type, {required bool light}) {
    if (type.contains('Sell')) {
      return light ? ThemeColors.error10 : ThemeColors.error120;
    }
    if (type.contains('Buy')) {
      return light ? ThemeColors.success10 : ThemeColors.success120;
    }
    return light ? ThemeColors.secondary10 : ThemeColors.secondary120;
  }
}
