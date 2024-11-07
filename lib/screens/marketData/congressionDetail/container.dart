import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/api/api_response.dart';
import 'package:stocks_news_new/modals/congress_member_res.dart';
import 'package:stocks_news_new/modals/stockDetailRes/earnings.dart';
import 'package:stocks_news_new/providers/congressional_detail_provider.dart';
import 'package:stocks_news_new/providers/user_provider.dart';
import 'package:stocks_news_new/route/my_app.dart';
import 'package:stocks_news_new/screens/alerts/alerts.dart';
import 'package:stocks_news_new/screens/marketData/congressionDetail/item.dart';
import 'package:stocks_news_new/screens/stockDetail/stockDetailTabs/sd_top.dart';
import 'package:stocks_news_new/screens/stockDetail/widgets/AlertWatchlist/alert_popup.dart';
import 'package:stocks_news_new/screens/tabs/trending/menuButton/slidable_menu.dart';
import 'package:stocks_news_new/screens/watchlist/watchlist.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/dialogs.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/base_ui_container.dart';
import 'package:stocks_news_new/widgets/refresh_controll.dart';
import 'package:stocks_news_new/widgets/screen_title.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import 'package:stocks_news_new/widgets/theme_image_view.dart';

class CongressionalDetailContainer extends StatefulWidget {
  const CongressionalDetailContainer({required this.slug, super.key});
  final String slug;

  @override
  State<CongressionalDetailContainer> createState() =>
      _CongressionalDetailContainerState();
}

class _CongressionalDetailContainerState
    extends State<CongressionalDetailContainer> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      CongressionalDetailProvider provider =
          context.read<CongressionalDetailProvider>();
      provider.reset();
      provider.getData(slug: widget.slug);
    });
  }

  @override
  Widget build(BuildContext context) {
    CongressionalDetailProvider provider =
        context.watch<CongressionalDetailProvider>();

    return Container(
      padding: const EdgeInsets.fromLTRB(
        Dimen.padding,
        // Dimen.padding,
        0,
        Dimen.padding,
        0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // if (provider.data != null || provider.extra != null ||)
          if (provider.extra != null &&
              (provider.extra?.subTitle != null &&
                  provider.extra?.subTitle != ""))
            ScreenTitle(
              // title: provider.extra?.title,
              subTitle: provider.extra?.subTitle,
              subTitleHtml: true,
            ),
          Expanded(
            child: BaseUiContainer(
              onRefresh: () => provider.getData(slug: widget.slug),
              error: provider.error,
              isLoading: provider.isLoading,
              showPreparingText: true,
              hasData: !provider.isLoading && provider.data != null,
              child: SlidableAutoCloseBehavior(
                child: RefreshControl(
                  onLoadMore: () async => provider.getData(
                    loadMore: true,
                    slug: widget.slug,
                  ),
                  onRefresh: () async => provider.getData(slug: widget.slug),
                  canLoadMore: false,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 150,
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: ThemeColors.greyBorder,
                                width: 1,
                              ),
                            ),
                            child: ThemeImageView(
                              url: provider.data?.profile.userImage ?? "",
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        const SpacerVertical(height: 12),
                        Column(
                          children: [
                            Text(
                              provider.data?.profile.name ?? "",
                              style: stylePTSansBold(),
                            ),
                            if (provider.data?.profile.memberType == "house")
                              Container(
                                margin: const EdgeInsets.only(top: 3),
                                child: Text(
                                  "House - ${provider.data?.profile.office}",
                                  style: stylePTSansBold(
                                    color: ThemeColors.greyText,
                                  ),
                                ),
                              ),
                            Visibility(
                              visible:
                                  provider.data?.profile.description != null,
                              child: Text(
                                provider.data?.profile.description ?? "",
                                style: styleGeorgiaBold(),
                              ),
                            ),
                          ],
                        ),
                        const SpacerVertical(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: SdTopCard(
                                top: SdTopRes(
                                  key: "Trades",
                                  value: provider.data?.profile.tradeCount,
                                ),
                              ),
                            ),
                            const SpacerHorizontal(width: 10),
                            Expanded(
                              child: SdTopCard(
                                top: SdTopRes(
                                  key: "COMPANIES",
                                  value: provider.data?.profile.companyCount,
                                ),
                              ),
                            ),
                            const SpacerHorizontal(width: 10),
                            Expanded(
                              child: SdTopCard(
                                top: SdTopRes(
                                  key: "VOLUME",
                                  value: provider.data?.profile.volume,
                                ),
                              ),
                            ),
                          ],
                        ),
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: const EdgeInsets.symmetric(
                            vertical: Dimen.padding,
                          ),
                          itemBuilder: (context, index) {
                            TradeList? data = provider.data?.tradeLists[index];
                            return SlidableMenuWidget(
                                index: index,
                                alertForBullish:
                                    data?.isAlertAdded?.toInt() ?? 0,
                                watlistForBullish:
                                    data?.isWatchlistAdded?.toInt() ?? 0,
                                onClickAlert: () => _onAlertClick(context,
                                    data?.symbol, data?.isAlertAdded, index),
                                onClickWatchlist: () => _onWatchListClick(
                                    context,
                                    data?.symbol,
                                    data?.company,
                                    data?.isWatchlistAdded,
                                    index),
                                child: CongressTradeItem(
                                  index: index,
                                  data: data,
                                ));
                            // return CongressTradeItem(
                            //   index: index,
                            //   data: data,
                            // );
                          },
                          separatorBuilder: (context, index) {
                            // return Divider(
                            //   color: ThemeColors.greyBorder,
                            //   height: 15.sp,
                            // );
                            return SpacerVertical(height: 15);
                          },
                          itemCount: provider.data?.tradeLists.length ?? 0,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onAlertClick(BuildContext context, String symbol, num? isAlertAdded,
      int? index) async {
    if ((isAlertAdded?.toInt() ?? 0) == 1) {
      Navigator.push(
        navigatorKey.currentContext!,
        MaterialPageRoute(builder: (_) => const Alerts()),
      );
    } else {
      if (context.read<UserProvider>().user != null) {
        showPlatformBottomSheet(
          backgroundColor: const Color.fromARGB(255, 23, 23, 23),
          context: context,
          showClose: false,
          content: AlertPopup(
            insetPadding:
                EdgeInsets.symmetric(horizontal: 15.sp, vertical: 10.sp),
            symbol: symbol,
            index: index ?? 0,
            congresionalImagesClick: true,
          ),
        );

        return;
      }
      try {
        ApiResponse res = await context
            .read<CongressionalDetailProvider>()
            .getData(slug: widget.slug);
        if (res.status) {
          num alertOn = navigatorKey.currentContext!
                  .read<CongressionalDetailProvider>()
                  .data
                  ?.tradeLists[index ?? 0]
                  .isAlertAdded ??
              0;
          if (alertOn == 0) {
            showPlatformBottomSheet(
              backgroundColor: const Color.fromARGB(255, 23, 23, 23),
              context: context,
              showClose: false,
              content: AlertPopup(
                insetPadding:
                    EdgeInsets.symmetric(horizontal: 15.sp, vertical: 10.sp),
                symbol: symbol,
                index: index ?? 0,
                congresionalImagesClick: true,
              ),
            );
          } else {
            Navigator.push(
              navigatorKey.currentContext!,
              MaterialPageRoute(builder: (_) => const Alerts()),
            );
          }
        }
        // ignore: empty_catches
      } catch (e) {}
    }
  }

  void _onWatchListClick(
    BuildContext context,
    String symbol,
    String companyName,
    num? isWatchlistAdded,
    int index,
  ) async {
    if (isWatchlistAdded == 1) {
      Navigator.push(
        navigatorKey.currentContext!,
        MaterialPageRoute(builder: (_) => const WatchList()),
      );
    } else {
      if (context.read<UserProvider>().user != null) {
        await navigatorKey.currentContext!
            .read<CongressionalDetailProvider>()
            .addToWishList(
              symbol: symbol,
              companyName: companyName,
              index: index,
              up: true,
            );
        return;
      }
      try {
        ApiResponse res = await navigatorKey.currentContext!
            .read<CongressionalDetailProvider>()
            .getData(slug: widget.slug);
        if (res.status) {
          num alertOn = navigatorKey.currentContext!
                  .read<CongressionalDetailProvider>()
                  .data
                  ?.tradeLists[index]
                  .isWatchlistAdded ??
              0;
          if (alertOn == 0) {
            await navigatorKey.currentContext!
                .read<CongressionalDetailProvider>()
                .addToWishList(
                  symbol: symbol,
                  companyName: companyName,
                  index: index,
                  up: true,
                );
          } else {
            Navigator.push(
              navigatorKey.currentContext!,
              MaterialPageRoute(builder: (_) => const WatchList()),
            );
          }
        }
      } catch (e) {
        //
      }
    }
  }
}
