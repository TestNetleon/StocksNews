import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/managers/home/home.dart';
import 'package:stocks_news_new/managers/user.dart';
import 'package:stocks_news_new/models/ticker.dart';
import 'package:stocks_news_new/ui/base/base_list_divider.dart';
import 'package:stocks_news_new/ui/tabs/tools/scanner/models/scanner_port.dart';
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
  num? price;
  num? change;
  num? changePercentage;
  String? showPrePost;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startStreaming();
    });
  }

  _startStreaming() {
    MyHomeManager homeManager = context.read<MyHomeManager>();
    UserManager userManager = context.read<UserManager>();
    bool isElitePlan = userManager.user?.membership?.isElitePlan ?? false;
    CheckMarketOpenRes? checkMarketOpenApi =
        homeManager.data?.scannerPort?.port?.checkMarketOpenApi;

    if (isElitePlan == true && checkMarketOpenApi?.startStreaming == true) {
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
            if (stockData.type == 'PreMarket' ||
                stockData.type == 'PostMarket') {
              showPrePost = stockData.type;
              setState(() {});
            } else {
              showPrePost = null;
              setState(() {});
            }

            price = stockData.price;
            change = stockData.change;
            changePercentage = stockData.changePercentage;
            setState(() {});
          },
          widget.type,
        );
      } catch (e) {
        //
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MyHomeManager>(
      builder: (context, value, child) {
        MyHomeManager homeManager = context.read<MyHomeManager>();

        UserManager userManager = context.read<UserManager>();
        bool isElitePlan = userManager.user?.membership?.isElitePlan ?? false;
        CheckMarketOpenRes? checkMarketOpenApi =
            homeManager.data?.scannerPort?.port?.checkMarketOpenApi;

        bool startStreaming = (checkMarketOpenApi?.startStreaming ?? false) &&
            (showPrePost == null || showPrePost == '') &&
            isElitePlan;

        String prePost = 'PreMarket';
        String formatted = prePost
            .replaceAll('PreMarket', 'Pre-Market')
            .replaceAll('PostMarket', 'Post-Market');

        return Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(
                  horizontal: Pad.pad16, vertical: Pad.pad8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          startStreaming
                              ? price?.toFormattedPrice() ??
                                  widget.data.displayPrice ??
                                  '\$0'
                              : widget.data.displayPrice ?? '\$0',
                          // style: styleBaseBold(fontSize: 28),
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        Visibility(
                          visible: widget.data.displayChange != null,
                          child: RichText(
                            text: TextSpan(
                              children: [
                                if (widget.data.changesPercentage != null)
                                  WidgetSpan(
                                    alignment: PlaceholderAlignment.middle,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 4),
                                      child: Image.asset(
                                        (widget.data.changesPercentage ?? 0) >=
                                                0
                                            ? Images.trendingUP
                                            : Images.trendingDOWN,
                                        height: 18,
                                        width: 18,
                                        color: (widget.data.changesPercentage ??
                                                    0) >=
                                                0
                                            ? ThemeColors.accent
                                            : ThemeColors.sos,
                                      ),
                                    ),
                                  ),
                                TextSpan(
                                  text: startStreaming
                                      ? change?.toFormattedPrice() ??
                                          widget.data.displayChange ??
                                          ''
                                      : widget.data.displayChange ?? '',
                                  style: styleBaseSemiBold(
                                    fontSize: 13,
                                    color:
                                        (widget.data.changesPercentage ?? 0) >=
                                                0
                                            ? ThemeColors.accent
                                            : ThemeColors.sos,
                                  ),
                                ),
                                if (widget.data.changesPercentage != null)
                                  TextSpan(
                                    text: startStreaming
                                        ? ' (${changePercentage ?? '${widget.data.changesPercentage ?? ''}'}%)'
                                        : ' (${widget.data.changesPercentage ?? ''}%)',
                                    style: styleBaseSemiBold(
                                      fontSize: 13,
                                      color: (widget.data.changesPercentage ??
                                                  0) >=
                                              0
                                          ? ThemeColors.accent
                                          : ThemeColors.sos,
                                    ),
                                  ),
                              ],
                            ),
                          ),
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
                          // style: styleBaseBold(fontSize: 28),
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
              ),
            ),
            if (showPrePost != null && showPrePost != '' && isElitePlan)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BaseListDivider(),
                  Container(
                    margin: EdgeInsets.only(left: Pad.pad16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '$formatted Price',
                          style: styleBaseRegular(fontSize: 12),
                        ),
                        Flexible(
                          child: Container(
                            margin: EdgeInsets.symmetric(
                              horizontal: Pad.pad16,
                              vertical: Pad.pad10,
                            ),
                            child: RichText(
                              textAlign: TextAlign.end,
                              text: TextSpan(
                                text: price?.toFormattedPrice() ?? '\$0',
                                style: styleBaseBold(),
                                children: [
                                  TextSpan(
                                    text:
                                        '  ${change?.toFormattedPrice() ?? '\$0'}',
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
              ),
          ],
        );
      },
    );
  }
}
