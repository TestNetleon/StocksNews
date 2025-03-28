import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/managers/market/market.dart';
import 'package:stocks_news_new/models/stockDetail/overview.dart';
import 'package:stocks_news_new/ui/base/app_bar.dart';
import 'package:stocks_news_new/ui/base/base_filter_item.dart';
import 'package:stocks_news_new/ui/base/base_list_divider.dart';
import 'package:stocks_news_new/ui/base/button.dart';
import 'package:stocks_news_new/ui/base/scaffold.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';

class MarketFilter extends StatelessWidget {
  const MarketFilter({
    super.key,
    required this.marketIndex,
    required this.marketInnerIndex,
  });

  final int marketIndex;
  final int marketInnerIndex;

  @override
  Widget build(BuildContext context) {
    MarketManager manager = context.watch<MarketManager>();
    return BaseScaffold(
      appBar: BaseAppBar(
        title: "Filter",
        showBack: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                if (manager.data?.filter?.sorting != null)
                  FilterType(
                    title: "Sort By",
                    data: manager.data?.filter?.sorting,
                    onItemClick: manager.selectSortBy,
                    filterParam: manager.filterParams?.sorting,
                  ),
                if (manager.data?.filter?.exchange != null)
                  FilterType(
                    title: "Exchange",
                    data: manager.data?.filter?.exchange,
                    onItemClick: manager.selectExchange,
                    filterParam: manager.filterParams?.exchange,
                  ),
                if (manager.data?.filter?.sectors != null)
                  FilterType(
                    title: "Sector",
                    data: manager.data?.filter?.sectors,
                    onItemClick: manager.selectSectors,
                    filterParam: manager.filterParams?.sectors,
                  ),
                if (manager.data?.filter?.industries != null)
                  FilterType(
                    title: "Industry",
                    data: manager.data?.filter?.industries,
                    onItemClick: manager.selectIndustries,
                    filterParam: manager.filterParams?.industries,
                  ),
                if (manager.data?.filter?.marketCap != null)
                  FilterType(
                    title: "Market Cap",
                    data: manager.data?.filter?.marketCap,
                    onItemClick: manager.selectMarketCap,
                    filterParam: manager.filterParams?.marketCap,
                  ),
                if (manager.data?.filter?.marketRank != null)
                  FilterType(
                    title: "Market Rank",
                    data: manager.data?.filter?.marketRank,
                    onItemClick: manager.selectMarketRank,
                    filterParam: manager.filterParams?.marketRank,
                    isRankFilter: true,
                  ),
                if (manager.data?.filter?.analystConsensus != null)
                  FilterType(
                    title: "Analyst Consensus",
                    data: manager.data?.filter?.analystConsensus,
                    onItemClick: manager.selectAnalystConsensus,
                    filterParam: manager.filterParams?.analystConsensus,
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: BaseButton(
                    text: 'Reset',
                    onPressed: () {
                      manager.resetFilter(
                        marketIndex: marketIndex,
                        marketInnerIndex: marketInnerIndex,
                      );
                      Navigator.pop(context);
                    },
                    color: ThemeColors.white,
                    side: BorderSide(color: ThemeColors.neutral20, width: 1),
                    textStyle: styleBaseSemiBold(
                      color: ThemeColors.neutral40,
                    ),
                  ),
                ),
                const SpacerHorizontal(width: 16),
                Expanded(
                  child: BaseButton(
                    text: "Apply",
                    onPressed: () {
                      manager.applyFilter(
                        marketIndex: marketIndex,
                        marketInnerIndex: marketInnerIndex,
                      );
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class FilterType extends StatefulWidget {
  final List<BaseKeyValueRes>? data;
  final String title;
  final Function(int index) onItemClick;
  final dynamic filterParam;
  final bool isRankFilter;

  const FilterType({
    super.key,
    required this.data,
    required this.title,
    required this.onItemClick,
    required this.filterParam,
    this.isRankFilter = false,
  });

  @override
  State<FilterType> createState() => _FilterTypeState();
}

class _FilterTypeState extends State<FilterType> {
  bool _isOpen = true;

  void _toggleOpen() {
    setState(() {
      _isOpen = !_isOpen;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          borderRadius: BorderRadius.circular(4),
          onTap: () => _toggleOpen(),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                Text(
                  widget.title,
                  style: styleBaseBold(fontSize: 20, color: ThemeColors.black),
                ),
                Spacer(),
                InkWell(
                  borderRadius: BorderRadius.circular(4),
                  onTap: () => _toggleOpen(),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: ThemeColors.neutral40),
                    ),
                    child: Image.asset(
                      _isOpen ? Images.arrowDOWN : Images.arrowUP,
                      height: 24,
                      width: 24,
                      color: ThemeColors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        AnimatedSize(
          duration: const Duration(milliseconds: 150),
          child: Container(
            height: _isOpen ? 36 : 0,
            margin: EdgeInsets.only(
              top: _isOpen ? 5 : 0,
              bottom: _isOpen ? 16 : 0,
            ),
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.only(left: Dimen.padding),
              itemBuilder: (context, index) {
                bool selected = widget.filterParam == null
                    ? false
                    : (widget.filterParam is String)
                        ? widget.filterParam == widget.data![index].value
                        : (widget.filterParam is List<String>)
                            ? (widget.filterParam as List<String>)
                                .contains(widget.data![index].value)
                            : false;

                return GestureDetector(
                  onTap: () => widget.onItemClick(index),
                  child: BaseFilterItem(
                      value: widget.data![index].title ?? "",
                      selected: selected,
                      child: widget.isRankFilter
                          ? StarRating(
                              rating:
                                  int.parse(widget.data![index].value ?? '0'),
                              selected: selected,
                            )
                          : null),
                );
              },
              separatorBuilder: (context, index) {
                return const SpacerHorizontal(width: Dimen.padding);
              },
              itemCount: widget.data?.length ?? 0,
            ),
          ),
        ),
        BaseListDivider()
      ],
    );
  }
}

class MarketFilterItem extends StatelessWidget {
  final BaseKeyValueRes data;
  final bool selected;
  final bool isRankFilter;

  const MarketFilterItem({
    super.key,
    required this.data,
    required this.selected,
    required this.isRankFilter,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: selected ? ThemeColors.black : ThemeColors.white,
        border: Border.all(color: ThemeColors.neutral10, width: 1),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: EdgeInsets.symmetric(vertical: 0, horizontal: 16),
      alignment: Alignment.center,
      child: isRankFilter
          ? StarRating(rating: int.parse(data.value ?? '0'), selected: selected)
          : Text(
              data.title ?? "",
              style: styleBaseRegular(
                fontSize: 14,
                color: selected ? ThemeColors.white : ThemeColors.black,
              ),
            ),
    );
  }
}

class StarRating extends StatelessWidget {
  final int rating;
  final bool selected;

  const StarRating({
    super.key,
    required this.rating,
    required this.selected,
  });

  @override
  Widget build(BuildContext context) {
    List<Widget> stars = [];

    for (int i = 1; i <= 5; i++) {
      if (i <= rating) {
        stars.add(
          Image.asset(
            Images.starSelected,
            width: 15,
            height: 15,
            color: selected ? ThemeColors.white : ThemeColors.selectedBG,
          ),
        );
      } else {
        stars.add(
          Image.asset(
            Images.starUnselected,
            width: 15,
            height: 15,
            color: selected ? ThemeColors.white : ThemeColors.neutral40,
          ),
        );
      }
      if (i < 5) {
        stars.add(SpacerHorizontal(width: 4));
      }
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: stars,
    );
  }
}
