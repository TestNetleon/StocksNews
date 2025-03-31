import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/ui/base/app_bar.dart';
import 'package:stocks_news_new/ui/base/common_tab.dart';
import 'package:stocks_news_new/ui/base/scaffold.dart';
import 'package:stocks_news_new/ui/tabs/tools/league/managers/tournament.dart';
import 'package:stocks_news_new/ui/tabs/tools/league/screens/allTrades/all_trade_index.dart';
import 'package:stocks_news_new/ui/tabs/tools/league/screens/tournaments/leaderboard/index.dart';
import 'package:stocks_news_new/ui/tabs/tools/league/screens/tournaments/tournaments_index.dart';
import 'package:stocks_news_new/ui/tabs/tools/scanner/manager/scanner.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/cache_network_image.dart';
import 'package:stocks_news_new/widgets/custom/base_loader_container.dart';
import 'package:stocks_news_new/widgets/custom/card.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import 'package:svg_flutter/svg_flutter.dart';

class TradingLeagueIndex extends StatefulWidget {
  final int? initialIndex;
  static const path = 'TradingLeagueIndex';
  const TradingLeagueIndex({super.key, this.initialIndex});

  @override
  State<TradingLeagueIndex> createState() => _TradingLeagueIndexState();
}

class _TradingLeagueIndexState extends State<TradingLeagueIndex> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ScannerManager>().getScannerPorts(reset: false);
      context.read<LeagueManager>().getTabs(initialIndex: widget.initialIndex);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LeagueManager>(builder: (context, lManager, child) {
      return BaseScaffold(
        appBar: BaseAppBar(
          showBack: true,
          title: !lManager.isLoading ? lManager.tabData?.title ?? "" : "",
          showNotification: true,
        ),
        body: BaseLoaderContainer(
          isLoading: lManager.isLoading,
          hasData: lManager.tabData != null && !lManager.isLoading,
          showPreparingText: true,
          error: lManager.error,
          onRefresh: () {
            lManager.getTabs(initialIndex: widget.initialIndex);
          },
          child: Column(
            children: [
              if (lManager.selectedScreen == 0)
                Visibility(
                  visible: lManager.tabData?.myPosition != null,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: Pad.pad10),
                    child: Row(
                      children: [
                        Expanded(
                          child: CommonCard(
                              onTap: () async {
                                lManager.profileRedirection(
                                    userId:
                                        "${lManager.tabData?.myPosition?.userId ?? ""}");
                              },
                              padding: EdgeInsets.symmetric(
                                  horizontal: Pad.pad8, vertical: Pad.pad20),
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(Pad.pad2),
                                    width: 45,
                                    height: 45,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                            color: ThemeColors.secondary100)),
                                    child: lManager.tabData?.myPosition
                                                ?.imageType ==
                                            "svg"
                                        ? ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(45),
                                            child: SvgPicture.network(
                                              fit: BoxFit.cover,
                                              lManager.tabData?.myPosition
                                                      ?.userImage ??
                                                  "",
                                              placeholderBuilder:
                                                  (BuildContext context) =>
                                                      Container(
                                                padding:
                                                    const EdgeInsets.all(30.0),
                                                child:
                                                    const CircularProgressIndicator(
                                                  color: ThemeColors.accent,
                                                ),
                                              ),
                                            ),
                                          )
                                        : ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(45),
                                            child: CachedNetworkImagesWidget(
                                                lManager.tabData?.myPosition
                                                    ?.userImage),
                                          ),
                                  ),
                                  SpacerHorizontal(width: Pad.pad8),
                                  Flexible(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Welcome",
                                          style: styleBaseRegular(
                                              fontSize: 10,
                                              color: ThemeColors.secondary120),
                                        ),
                                        SpacerVertical(height: Pad.pad5),
                                        Text(
                                          lManager.tabData?.myPosition
                                                  ?.userName ??
                                              "",
                                          style: styleBaseBold(fontSize: 16),
                                        ),
                                        SpacerVertical(height: Pad.pad5),
                                        Text(
                                            lManager.tabData?.myPosition
                                                    ?.rank ??
                                                "",
                                            style: styleBaseRegular(
                                                fontSize: 14,
                                                color: ThemeColors.neutral40))
                                      ],
                                    ),
                                  )
                                ],
                              )),
                        ),
                        SpacerHorizontal(width: Pad.pad10),
                        Expanded(
                            child: Column(
                          children: [
                            CommonCard(
                              padding: EdgeInsets.symmetric(
                                  horizontal: Pad.pad8, vertical: Pad.pad14),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Performance",
                                    style: styleBaseRegular(
                                        fontSize: 12,
                                        color: ThemeColors.neutral80),
                                  ),
                                  Text(
                                      "${lManager.tabData?.myPosition?.performance?.toCurrency() ?? "0"}%",
                                      style: styleBaseBold(
                                          fontSize: 14,
                                          color: (lManager.tabData?.myPosition
                                                          ?.performance ??
                                                      0) >
                                                  0
                                              ? ThemeColors.accent
                                              : lManager.tabData?.myPosition
                                                          ?.performance ==
                                                      0
                                                  ? ThemeColors.black
                                                  : ThemeColors.sos)),
                                ],
                              ),
                            ),
                            SpacerVertical(height: Pad.pad8),
                            CommonCard(
                              padding: EdgeInsets.symmetric(
                                  horizontal: Pad.pad8, vertical: Pad.pad14),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Total Points",
                                    style: styleBaseRegular(
                                        fontSize: 12,
                                        color: ThemeColors.neutral80),
                                  ),
                                  SpacerHorizontal(width: Pad.pad3),
                                  Text(
                                      "${((lManager.tabData?.myPosition?.totalPoints ?? 0) + (lManager.tabData?.myPosition?.performancePoint ?? 0))}",
                                      style: styleBaseBold(fontSize: 14)),
                                ],
                              ),
                            ),
                          ],
                        ))
                      ],
                    ),
                  ),
                ),
              SpacerVertical(height: Pad.pad10),
              BaseTabs(
                data: lManager.tabData?.tab ?? [],
                onTap: lManager.onScreenChange,
                isScrollable: lManager.tabData?.tab?.length == 2 ? false : true,
                showDivider: true,
                selectedIndex: widget.initialIndex ?? 0,
              ),
              SpacerVertical(height: Pad.pad10),
              if (lManager.selectedScreen == 0) Expanded(child: LeagueIndex()),
              if (lManager.selectedScreen == 1)
                Expanded(child: LeagueLeaderboard()),
              if (lManager.selectedScreen == 2) Expanded(child: LeagueTrades())
            ],
          ),
        ),
      );
    });
  }
}
