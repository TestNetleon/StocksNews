import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/managers/signals/politicians.dart';
import 'package:stocks_news_new/models/stockDetail/overview.dart';
import 'package:stocks_news_new/ui/base/app_bar.dart';
import 'package:stocks_news_new/ui/base/base_filter_item.dart';
import 'package:stocks_news_new/ui/base/button.dart';
import 'package:stocks_news_new/ui/base/scaffold.dart';
import 'package:stocks_news_new/ui/tabs/tools/market/stocks/extra/filter.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/custom/base_loader_container.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';

class PoliticianFilter extends StatefulWidget {
  const PoliticianFilter({super.key});

  @override
  State<PoliticianFilter> createState() => _PoliticianFilterState();
}

class _PoliticianFilterState extends State<PoliticianFilter> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _callAPI();
    });
  }

  void _callAPI() {
    SignalsPoliticianManager manager = context.read<SignalsPoliticianManager>();
    if (manager.filter == null) {
      manager.getFilterData();
    }
  }

  @override
  Widget build(BuildContext context) {
    SignalsPoliticianManager manager =
        context.watch<SignalsPoliticianManager>();
    return BaseScaffold(
      appBar: BaseAppBar(title: "Filter", showBack: true),
      body: BaseLoaderContainer(
        hasData: manager.filter != null,
        isLoading: manager.isLoading,
        error: manager.errorFilter,
        onRefresh: _callAPI,
        showPreparingText: true,
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  if (manager.filter?.exchange != null)
                    FilterType(
                      title: "Exchange",
                      data: manager.filter?.exchange,
                      onItemClick: manager.selectExchange,
                      filterParam: manager.filterParams?.exchange,
                    ),
                  if (manager.filter?.sector != null)
                    FilterType(
                      title: "Sector",
                      data: manager.filter?.sector,
                      onItemClick: manager.selectSectors,
                      filterParam: manager.filterParams?.sectors,
                    ),
                  if (manager.filter?.sector != null)
                    FilterType(
                      title: "Industry",
                      data: manager.filter?.industry,
                      onItemClick: manager.selectIndustry,
                      filterParam: manager.filterParams?.industry,
                    ),
                  if (manager.filter?.marketCap != null)
                    FilterType(
                      title: "Market Cap",
                      data: manager.filter?.marketCap,
                      onItemClick: manager.selectMarketCap,
                      filterParam: manager.filterParams?.marketCap,
                    ),
                  if (manager.filter?.marketRank != null)
                    FilterType(
                      title: "Market Rank",
                      data: manager.filter?.marketRank,
                      onItemClick: manager.selectMarketRank,
                      filterParam: manager.filterParams?.marketRank,
                      isRankFilter: true,
                    ),
                  if (manager.filter?.marketRank != null)
                    FilterType(
                      title: "Analyst Consensus",
                      data: manager.filter?.analystConsensus,
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
                        manager.resetFilter();
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
                        manager.applyFilter();
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
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
                    value: widget.data?[index].title ?? "",
                    selected: selected,
                    child: widget.isRankFilter
                        ? StarRating(
                            rating: int.parse(widget.data![index].value ?? '0'),
                            selected: selected,
                          )
                        : null,
                  ),
                );
              },
              separatorBuilder: (context, index) {
                return const SpacerHorizontal(width: Dimen.padding);
              },
              itemCount: widget.data?.length ?? 0,
            ),
          ),
        ),
        Divider(color: ThemeColors.neutral5, height: 1, thickness: 1)
      ],
    );
  }
}
