import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/managers/home/home.dart';
import 'package:stocks_news_new/models/ticker.dart';
import 'package:stocks_news_new/ui/base/base_list_divider.dart';
import 'package:stocks_news_new/ui/tabs/tools/simulator/services/sse.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/utils/utils.dart';
import '../../../utils/colors.dart';

class BaseStockDetailHeader extends StatefulWidget {
  final BaseTickerRes data;
  final SimulatorEnum type;

  const BaseStockDetailHeader({
    super.key,
    required this.data,
    this.type = SimulatorEnum.stockDetail,
  });

  @override
  State<BaseStockDetailHeader> createState() => _BaseStockDetailHeaderState();
}

class _BaseStockDetailHeaderState extends State<BaseStockDetailHeader> {
  num? price, change, changePercentage;
  String? showPrePost;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _startStreaming());
  }

  void _startStreaming() {
    final homeManager = context.read<MyHomeManager>();

    if (homeManager.isElitePlan == true && homeManager.shouldStream == true) {
      try {
        SSEManager.instance.disconnectScreen(widget.type);
        SSEManager.instance.connectStock(
          sendPort: homeManager.data?.scannerPort?.port?.other?.simulator,
          screen: widget.type,
          symbol: widget.data.symbol ?? '',
        );

        SSEManager.instance.addListener(
          widget.data.symbol ?? '',
          (StockDataManagerRes stockData) {
            Utils().showLog(
                'Stream data ${stockData.price}, ${stockData.change}, ${stockData.changePercentage}');

            setState(() {
              showPrePost = (stockData.type == 'PreMarket' ||
                      stockData.type == 'PostMarket')
                  ? stockData.type
                  : null;

              price = stockData.price;
              change = stockData.change;
              changePercentage = stockData.changePercentage;
            });
          },
          widget.type,
        );
      } catch (e) {
        Utils().showLog('Streaming error: $e');
      }
    }
  }

  String get _formattedPrePost => (showPrePost ?? '')
      .replaceAll('PreMarket', 'Pre-Market')
      .replaceAll('PostMarket', 'Post-Market');

  Widget _buildPriceChangeSection() {
    return Consumer<MyHomeManager>(
      builder: (context, value, child) {
        return RichText(
          text: TextSpan(
            children: [
              if (widget.data.changesPercentage != null)
                WidgetSpan(
                  alignment: PlaceholderAlignment.middle,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Image.asset(
                      (widget.data.changesPercentage ?? 0) >= 0
                          ? Images.trendingUP
                          : Images.trendingDOWN,
                      height: 18,
                      width: 18,
                      color: (widget.data.changesPercentage ?? 0) >= 0
                          ? ThemeColors.accent
                          : ThemeColors.sos,
                    ),
                  ),
                ),
              TextSpan(
                text: value.showLiveStreaming
                    ? change?.toFormattedPrice() ??
                        widget.data.displayChange ??
                        ''
                    : widget.data.displayChange ?? '',
                style: styleBaseSemiBold(
                  fontSize: 13,
                  color: value.showLiveStreaming
                      ? (changePercentage ?? 0) > 0
                          ? ThemeColors.accent
                          : ThemeColors.sos
                      : (widget.data.changesPercentage ?? 0) >= 0
                          ? ThemeColors.accent
                          : ThemeColors.sos,
                ),
              ),
              if (widget.data.changesPercentage != null)
                TextSpan(
                  text: value.showLiveStreaming
                      ? ' (${changePercentage ?? widget.data.changesPercentage ?? ''}%)'
                      : ' (${widget.data.changesPercentage ?? ''}%)',
                  style: styleBaseSemiBold(
                    fontSize: 13,
                    color: value.showLiveStreaming
                        ? (changePercentage ?? 0) > 0
                            ? ThemeColors.accent
                            : ThemeColors.sos
                        : (widget.data.changesPercentage ?? 0) >= 0
                            ? ThemeColors.accent
                            : ThemeColors.sos,
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMainPriceSection() {
    return Consumer<MyHomeManager>(
      builder: (context, value, child) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    value.showLiveStreaming
                        ? price?.toFormattedPrice() ??
                            widget.data.displayPrice ??
                            '\$0'
                        : widget.data.displayPrice ?? '\$0',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  Visibility(
                    visible: widget.data.displayChange != null,
                    child: _buildPriceChangeSection(),
                  ),
                  Text(
                    'Closed ${widget.data.closeDate ?? ''}',
                    style: styleBaseRegular(
                        fontSize: 13, color: ThemeColors.neutral40),
                  ),
                ],
              ),
            ),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    widget.data.mktCap ?? '',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  Text(
                    'MKT Cap',
                    style: styleBaseRegular(
                      fontSize: 14,
                      color: ThemeColors.neutral40,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildPrePostSection() {
    MyHomeManager manager = context.watch<MyHomeManager>();
    if (showPrePost == null || showPrePost!.isEmpty || !manager.isElitePlan) {
      return SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BaseListDivider(),
        Container(
          margin: EdgeInsets.only(left: Pad.pad16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('$_formattedPrePost Price',
                  style: styleBaseRegular(fontSize: 12)),
              Flexible(
                child: Container(
                  margin: EdgeInsets.symmetric(
                      horizontal: Pad.pad16, vertical: Pad.pad10),
                  child: RichText(
                    textAlign: TextAlign.end,
                    text: TextSpan(
                      text: price?.toFormattedPrice() ?? '\$0',
                      style: styleBaseBold(),
                      children: [
                        TextSpan(
                          text: '  ${change?.toFormattedPrice() ?? '\$0'}',
                          style: styleBaseSemiBold(
                            fontSize: 13,
                            color: (changePercentage ?? 0) >= 0
                                ? ThemeColors.accent
                                : ThemeColors.sos,
                          ),
                        ),
                        TextSpan(
                          text: ' (${changePercentage ?? '0'}%)',
                          style: styleBaseSemiBold(
                            fontSize: 13,
                            color: (changePercentage ?? 0) >= 0
                                ? ThemeColors.accent
                                : ThemeColors.sos,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MyHomeManager>(
      builder: (context, value, child) => Column(
        children: [
          Container(
            padding:
                EdgeInsets.symmetric(horizontal: Pad.pad16, vertical: Pad.pad8),
            child: _buildMainPriceSection(),
          ),
          _buildPrePostSection(),
        ],
      ),
    );
  }
}
