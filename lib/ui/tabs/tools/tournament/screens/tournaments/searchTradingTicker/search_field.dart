import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/managers/user.dart';
import 'package:stocks_news_new/modals/search_res.dart';
import 'package:stocks_news_new/models/ticker.dart';
import 'package:stocks_news_new/routes/my_app.dart';
import 'package:stocks_news_new/ui/base/base_list_divider.dart';
import 'package:stocks_news_new/ui/base/search/base_search.dart';
import 'package:stocks_news_new/ui/tabs/tools/simulator/services/sse.dart';
import 'package:stocks_news_new/ui/tabs/tools/tournament/provider/search.dart';
import 'package:stocks_news_new/ui/tabs/tools/tournament/provider/tournament.dart';
import 'package:stocks_news_new/ui/tabs/tools/tournament/provider/trades.dart';
import 'package:stocks_news_new/ui/tabs/tools/tournament/screens/tournaments/widgets/tour_trade_sheet.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/utils/utils.dart';
import 'package:stocks_news_new/widgets/cache_network_image.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';


class TournamentInputFieldSearch extends StatefulWidget {
  const TournamentInputFieldSearch({
    // required this.onChanged,
    this.maxLength = 40,
    this.minLines = 1,
    this.editable = false,
    this.shadow = true,
    this.borderColor,
    this.style,
    this.hintText,
    this.searching = false,
    super.key,
    this.radius,
    this.contentPadding,
    this.openConstraints = true,
    this.searchFocusNode,
    this.searchForNews = false,
  });

  // final TextEditingController controller;
  final int maxLength;
  final int minLines;
  final bool editable;
  final bool shadow;
  final TextStyle? style;
  final Color? borderColor;
  final String? hintText;
  // final Function(String) onChanged;
  final bool searching;
  final double? radius;
  final EdgeInsets? contentPadding;
  final bool openConstraints;
  final FocusNode? searchFocusNode;
  final bool searchForNews;

  @override
  State<TournamentInputFieldSearch> createState() =>
      _TournamentInputFieldSearchCommonState();
}

class _TournamentInputFieldSearchCommonState
    extends State<TournamentInputFieldSearch> {
  final TextEditingController controller = TextEditingController();
  Timer? _timer;
  bool firstTime = true;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _searchApiCall(String text) {
    firstTime = false;
    setState(() {});
    if (text.isEmpty) {
      context.read<TournamentSearchProvider>().clearSearch();
    } else {
      LeagueManager manager =
          navigatorKey.currentContext!.read<LeagueManager>();
      TournamentTradesProvider tradesProvider =
          navigatorKey.currentContext!.read<TournamentTradesProvider>();
      Map request = {
        "term": text,
        "tournament_battle_id":
            '${tradesProvider.myTrades?.tournamentBattleId ?? manager.detailRes?.tournamentBattleId ?? ''}',
      };
      context.read<TournamentSearchProvider>().searchSymbols(request);
    }
  }

  Future _onTap({String? symbol}) async {
    Navigator.pop(context, symbol);
  }

  @override
  Widget build(BuildContext context) {
    TournamentSearchProvider provider =
        context.watch<TournamentSearchProvider>();

    var outlineInputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(widget.radius?.r ?? Dimen.radius.r),
      borderSide: BorderSide(
        color: widget.borderColor ?? ThemeColors.primaryLight,
        width: 1,
      ),
    );

    return GestureDetector(
      onTap: () => widget.editable
          ? {}
          : Navigator.push(
              navigatorKey.currentContext!,
              MaterialPageRoute(builder: (_) => const BaseSearch()
              ),
            ),
      child: AnimatedSize(
        alignment: Alignment.topCenter,
        duration: const Duration(milliseconds: 300),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                children: [
                  TextField(
                    cursorColor: ThemeColors.black,
                    autocorrect: false,
                    controller: controller,
                    maxLength: widget.maxLength,
                    minLines: widget.minLines,
                    maxLines: widget.minLines,
                    enabled: widget.editable,
                    textCapitalization: TextCapitalization.sentences,
                    style: widget.style ??
                        styleBaseBold(fontSize: isPhone ? 14.sp : 7.sp),
                    decoration: InputDecoration(
                      hintText: widget.hintText,
                      hintStyle: styleBaseRegular(
                        fontSize: 14,
                        color: ThemeColors.black,
                      ),
                      constraints: widget.openConstraints
                          ? BoxConstraints(
                              minHeight: 0,
                              maxHeight: widget.minLines > 1 ? 150.sp : 50.sp,
                            )
                          : null,
                      contentPadding: widget.contentPadding ??
                          EdgeInsets.fromLTRB(
                            10.sp,
                            10.sp,
                            12.sp,
                            10.sp,
                          ),
                      filled: true,
                      fillColor: ThemeColors.white,
                      enabledBorder: outlineInputBorder,
                      border: outlineInputBorder,
                      focusedBorder: outlineInputBorder,
                      counterText: '',
                      prefixIcon: Icon(
                        Icons.search,
                        size: isPhone ? 22 : 16.sp,
                        color: ThemeColors.black,
                      ),
                    ),
                    onChanged: (value) {
                      if (_timer != null) {
                        _timer!.cancel();
                      }
                      _timer = Timer(
                        const Duration(milliseconds: 1000),
                        () {
                          _searchApiCall(value);
                        },
                      );
                    },
                  ),
                  Positioned(
                    right: 10.sp,
                    top: 10.sp,
                    child: Visibility(
                      visible: !firstTime && provider.isLoadingS,
                      child: SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 3.sp,
                          color: ThemeColors.black,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Visibility(
                visible: provider.dataNew != null,
                child: Container(
                  padding: EdgeInsets.all(Dimen.padding.sp),
                  margin: EdgeInsets.only(top: 5.sp),
                  decoration: BoxDecoration(
                    color: ThemeColors.white,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(Dimen.radius.r),
                      bottomRight: Radius.circular(Dimen.radius.r),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Visibility(
                        visible: provider.dataNew?.isNotEmpty == true,
                        child: Padding(
                          padding: EdgeInsets.only(bottom: 10.sp),
                          child: Text(
                            "Symbols",
                            style: styleBaseBold(color: ThemeColors.black),
                          ),
                        ),
                      ),
                      Visibility(
                        visible: provider.dataNew?.isNotEmpty == true,
                        child: ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (BuildContext context, int index) {
                            SearchRes? data = provider.dataNew?[index];
                            return InkWell(
                              onTap: () {
                                closeKeyboard();
                                TournamentSearchProvider provider =
                                    context.read<TournamentSearchProvider>();
                                provider.setTappedStock(
                                    StockDataManagerRes(
                                        symbol: data?.symbol ?? "",
                                        change: data?.change,
                                        price: data?.currentPrice,
                                        changePercentage:
                                            data?.changesPercentage),
                                    data?.showButton);
                                tournamentSheet(
                                  symbol: data?.symbol,
                                  doPop: false,
                                  data: BaseTickerRes(
                                      image: data?.image,
                                      name: data?.name,
                                      price: data?.currentPrice,
                                      symbol: data?.symbol,
                                      showButton: data?.showButton),
                                );
                              },
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical:5.sp),
                                child: Row(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color:ThemeColors.neutral5,
                                      ),
                                      padding: EdgeInsets.all(3),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(40.sp),

                                        child: CachedNetworkImagesWidget(
                                          data?.image ?? '',
                                          width: 40.sp,
                                          height: 40.sp,
                                        ),
                                      ),
                                    ),
                                    const SpacerHorizontal(width: Pad.pad10),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            data?.symbol ?? "",
                                            style: styleBaseBold(fontSize: 14,color: ThemeColors.black),
                                          ),
                                          Text(
                                            data?.name ?? "",
                                            style: styleBaseRegular(
                                                fontSize: 12,
                                                color: ThemeColors.black
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                          separatorBuilder: (BuildContext context, int index) {
                            return const BaseListDivider(height: 20);
                          },
                          itemCount: provider.dataNew?.length ?? 0,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Visibility(
                visible: provider.dataNew == null &&
                    provider.statusS == Status.loaded,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 6.sp),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        Const.errNoRecord,
                        style: styleBaseRegular(fontSize: 14),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
