import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/api/api_response.dart';
import 'package:stocks_news_new/modals/trending_res.dart';
import 'package:stocks_news_new/providers/stock_detail_new.dart';
import 'package:stocks_news_new/providers/trending_provider.dart';
import 'package:stocks_news_new/providers/user_provider.dart';
import 'package:stocks_news_new/routes/my_app.dart';
import 'package:stocks_news_new/screens/alerts/alerts.dart';
import 'package:stocks_news_new/screens/stockDetail/index.dart';
import 'package:stocks_news_new/screens/stockDetail/widgets/AlertWatchlist/alert_popup.dart';
import 'package:stocks_news_new/screens/tabs/trending/menuButton/slidable_menu.dart';
import 'package:stocks_news_new/screens/watchlist/watchlist.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/utils/utils.dart';
import 'package:stocks_news_new/widgets/cache_network_image.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import 'package:vibration/vibration.dart';
import '../../../../utils/dialogs.dart';

class MostBullishItem extends StatefulWidget {
  final bool up;
  final MostBullishData data;
  final int index;
  final int alertForBullish;
  final bool alertAdded;
  final bool watchlistAdded;
  final int alertForBearish;
  final int watlistForBullish;
  final int watlistForBearish;
  final bool visiableMenuIcon;
  const MostBullishItem({
    required this.data,
    this.up = true,
    super.key,
    this.alertAdded = false,
    this.watchlistAdded = false,
    this.visiableMenuIcon = true,
    required this.index,
    this.alertForBullish = 0,
    this.alertForBearish = 0,
    this.watlistForBullish = 0,
    this.watlistForBearish = 0,
  });

  @override
  State<MostBullishItem> createState() => _MostBullishItemState();
}

class _MostBullishItemState extends State<MostBullishItem> {
  bool userPresent = false;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      userPresent = context.read<UserProvider>().user != null;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (BuildContext ctx, BoxConstraints ctrt) {
      return SlidableMenuWidget(
        index: widget.index,
        alertForBearish: widget.alertForBearish,
        alertForBullish: widget.alertForBullish,
        up: widget.up,
        watlistForBearish: widget.watlistForBearish,
        watlistForBullish: widget.watlistForBullish,
        onClickAlert: () => _alertElse(),
        onClickWatchlist: () => _watchlistElse(),
        child: InkWell(
          onTap: () {
            Navigator.push(
              navigatorKey.currentContext!,
              MaterialPageRoute(
                builder: (_) => StockDetail(symbol: widget.data.symbol),
              ),
            );
          },
          child: Stack(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                decoration: BoxDecoration(
                  color: ThemeColors.background,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(0.sp),
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        width: 48,
                        height: 48,
                        child:
                            CachedNetworkImagesWidget(widget.data.image ?? ""),
                      ),
                    ),
                    const SpacerHorizontal(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.data.symbol,
                            style: styleGeorgiaBold(fontSize: 18),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SpacerVertical(height: 5),
                          Visibility(
                            visible: widget.data.name != null &&
                                widget.data.name != '',
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 5),
                              child: Text(
                                widget.data.name ?? "",
                                style: styleGeorgiaRegular(
                                  color: ThemeColors.greyText,
                                  fontSize: 12,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text:
                                          "Mentions: ${widget.data.mention?.toInt()} ",
                                      style: stylePTSansRegular(fontSize: 12),
                                    ),
                                  ],
                                ),
                              ),
                              Flexible(
                                child: RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text:
                                            "(${widget.data.mentionChange.toCurrency()}%)",
                                        style: stylePTSansRegular(
                                          fontSize: 12,
                                          color: widget.data.mentionChange >= 0
                                              ? ThemeColors.accent
                                              : ThemeColors.sos,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SpacerHorizontal(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(widget.data.price ?? "",
                            style: stylePTSansBold(fontSize: 18)),
                        const SpacerVertical(height: 5),
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text:
                                    "${widget.data.displayChange} (${widget.data.changesPercentage.toCurrency()}%)",
                                style: stylePTSansRegular(
                                  fontSize: 14,
                                  color: widget.data.changesPercentage > 0
                                      ? Colors.green
                                      : Colors.red,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    // const SpacerHorizontal(width: 5),
                    // PopUpMenuButtonCommon(
                    //   symbol: widget.data.symbol,
                    //   onClickAlert: () => _alertElse(),
                    //   onClickWatchlist: () => _watchlistElse(),
                    //   watchlistString: widget.up
                    //       ? widget.watlistForBullish == 1
                    //           ? 'Watchlist Added'
                    //           : 'Add to Watchlist'
                    //       : widget.watlistForBearish == 1
                    //           ? 'Watchlist Added'
                    //           : 'Add to Watchlist',
                    //   alertString: widget.up
                    //       ? widget.alertForBullish == 1
                    //           ? 'Alert Added'
                    //           : 'Add to Alert'
                    //       : widget.alertForBearish == 1
                    //           ? 'Alert Added'
                    //           : 'Add to Alert',
                    // ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  void _vibrate() async {
    if (Platform.isAndroid) {
      bool isVibe = await Vibration.hasVibrator();
      if (isVibe) {
        // Vibration.vibrate(pattern: [0, 500], intensities: [255, 255]);
        Vibration.vibrate(pattern: [50, 50, 79, 55], intensities: [1, 10]);
      } else {
        Utils().showLog("$isVibe");
      }
    } else {
      HapticFeedback.lightImpact();
    }
  }

  void _showAlertPopup({required BuildContext context, String? symbol}) {
    showPlatformBottomSheet(
      backgroundColor: const Color.fromARGB(255, 23, 23, 23),
      context: context,
      showClose: false,
      content: AlertPopup(
        insetPadding: EdgeInsets.symmetric(horizontal: 15.sp, vertical: 10.sp),
        symbol: widget.data.symbol,
        companyName: widget.data.name ?? '',
        up: widget.up,
        index: widget.index,
        fromTrending: true,
      ),
    );
    // Navigator.push(
    //   context,
    //   createRoute(
    //     AlertPopUpDialog(
    //       content: AlertPopup(
    //         insetPadding:
    //             EdgeInsets.symmetric(horizontal: 15.sp, vertical: 10.sp),
    //         symbol: data.symbol,
    //         up: up,
    //         index: index,
    //         fromTrending: true,
    //       ),
    //     ),
    //   ),
    // );
    // showDialog(
    //     context: context,
    //     builder: (context) {
    //       return AlertPopup(
    //         insetPadding:
    //             EdgeInsets.symmetric(horizontal: 15.sp, vertical: 10.sp),
    //         symbol: data.symbol,
    //         up: up,
    //         index: index,
    //         fromTrending: true,
    //       );
    //     });
  }

  Future _addToWatchlist() async {
    await navigatorKey.currentContext!.read<TrendingProvider>().addToWishList(
          symbol: widget.data.symbol,
          companyName: widget.data.name ?? '',
          index: widget.index,
          up: widget.up,
        );
  }

  void _navigateToAlert() {
    Navigator.push(
      navigatorKey.currentContext!,
      MaterialPageRoute(builder: (_) => const Alerts()),
    );
  }

  void _navigateToWatchlist() {
    Navigator.push(
      navigatorKey.currentContext!,
      MaterialPageRoute(builder: (_) => const WatchList()),
    );
  }

  Future<void> _alertElse() async {
    StockDetailProviderNew provider = context.read<StockDetailProviderNew>();
    String symbol = provider.tabRes?.keyStats?.symbol ?? "";

    if (widget.up) {
      if (widget.alertForBullish == 1) {
        _navigateToAlert();
      } else {
        if (userPresent) {
          log("set HERE");
          _showAlertPopup(
            context: navigatorKey.currentContext!,
            symbol: symbol,
          );
          return;
        }
        try {
          Utils().showLog("calling api..");
          ApiResponse res =
              await context.read<TrendingProvider>().getMostBullish();
          if (res.status) {
            num alertOn = navigatorKey.currentContext!
                    .read<TrendingProvider>()
                    .mostBullish
                    ?.mostBullish?[widget.index]
                    .isAlertAdded ??
                0;
            if (alertOn == 0) {
              _showAlertPopup(
                  context: navigatorKey.currentContext!, symbol: symbol);
            } else {
              Navigator.push(
                navigatorKey.currentContext!,
                MaterialPageRoute(builder: (_) => const Alerts()),
              );
            }
          }
        } catch (e) {
          log("ERROR -> $e");
        }
      }
    } else {
      if (widget.alertForBearish == 1) {
        _navigateToAlert();
      } else {
        if (userPresent) {
          log("set HERE");
          _showAlertPopup(
              context: navigatorKey.currentContext!, symbol: symbol);
          return;
        }
        try {
          Utils().showLog("calling api..");
          ApiResponse res =
              await context.read<TrendingProvider>().getMostBearish();
          if (res.status) {
            num alertOn = navigatorKey.currentContext!
                    .read<TrendingProvider>()
                    .mostBearish
                    ?.mostBearish?[widget.index]
                    .isAlertAdded ??
                0;
            if (alertOn == 0) {
              _showAlertPopup(
                  context: navigatorKey.currentContext!, symbol: symbol);
            } else {
              Navigator.push(
                navigatorKey.currentContext!,
                MaterialPageRoute(builder: (_) => const Alerts()),
              );
            }
          }
        } catch (e) {
          log("ERROR -> $e");
        }
      }
    }
  }

  Future<void> _watchlistElse() async {
    if (widget.up) {
      if (widget.watlistForBullish == 1) {
        _navigateToWatchlist();
      } else {
        if (userPresent) {
          log("set HERE");
          _addToWatchlist();
          return;
        }
        try {
          Utils().showLog("calling api..");
          ApiResponse res = await navigatorKey.currentContext!
              .read<TrendingProvider>()
              .getMostBullish();
          if (res.status) {
            num alertOn = navigatorKey.currentContext!
                    .read<TrendingProvider>()
                    .mostBullish
                    ?.mostBullish?[widget.index]
                    .isWatchlistAdded ??
                0;
            if (alertOn == 0) {
              await _addToWatchlist();
            } else {
              Navigator.push(
                navigatorKey.currentContext!,
                MaterialPageRoute(builder: (_) => const WatchList()),
              );
            }
          }
        } catch (e) {
          log("ERROR -> $e");
        }
      }
    } else {
      if (widget.watlistForBearish == 1) {
        _navigateToWatchlist();
      } else {
        if (userPresent) {
          log("set HERE");
          _addToWatchlist();
          return;
        }
        try {
          Utils().showLog("calling api..");
          ApiResponse res = await navigatorKey.currentContext!
              .read<TrendingProvider>()
              .getMostBearish();
          if (res.status) {
            num alertOn = navigatorKey.currentContext!
                    .read<TrendingProvider>()
                    .mostBearish
                    ?.mostBearish?[widget.index]
                    .isWatchlistAdded ??
                0;
            if (alertOn == 0) {
              await _addToWatchlist();
            } else {
              Navigator.push(
                navigatorKey.currentContext!,
                MaterialPageRoute(builder: (_) => const WatchList()),
              );
            }
          }
        } catch (e) {
          log("ERROR -> $e");
        }
      }
    }
  }
}
