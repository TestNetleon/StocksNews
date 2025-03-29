import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/managers/signals/stocks.dart';
import 'package:stocks_news_new/models/stockDetail/overview.dart';
import 'package:stocks_news_new/ui/base/app_bar.dart';
import 'package:stocks_news_new/ui/base/base_filter_item.dart';
import 'package:stocks_news_new/ui/base/button.dart';
import 'package:stocks_news_new/ui/base/scaffold.dart';
import 'package:stocks_news_new/ui/tabs/signals/stocks/filter/text_field.dart';
import 'package:stocks_news_new/ui/tabs/tools/market/stocks/extra/filter.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/utils/utils.dart';
import 'package:stocks_news_new/widgets/custom/base_loader_container.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';

class StocksFilter extends StatefulWidget {
  const StocksFilter({super.key});

  @override
  State<StocksFilter> createState() => _StocksFilterState();
}

class _StocksFilterState extends State<StocksFilter> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _callAPI();
    });
  }

  void _callAPI() {
    SignalsStocksManager manager = context.read<SignalsStocksManager>();
    if (manager.filter == null) {
      manager.getFilterData();
    }
  }

  @override
  Widget build(BuildContext context) {
    SignalsStocksManager manager = context.watch<SignalsStocksManager>();
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
                  if (manager.filter?.priceRange != null)
                    FilterType(
                      title: "Price",
                      data: manager.filter?.priceRange,
                      onItemClick: manager.selectPriceRange,
                      filterParam: manager.filterParams?.priceRange,
                    ),
                  // if (manager.filter?.changePercentage != null)
                  //   FilterInputType(
                  //     title: "Percentage",
                  //   ),
                  // Column(
                  //   children: [
                  //     Text("data", style: styleBaseBold()),
                  //     TextFieldChangePercentage(
                  //       onChanged: (p0) {},
                  //       onIncrement: () {},
                  //       onDecrement: () {},
                  //     ),
                  //   ],
                  // ),
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

class FilterInputType extends StatefulWidget {
  // final List<BaseKeyValueRes>? data;
  final String title;
  // final Function(int index) onItemClick;
  // final dynamic filterParam;
  // final bool isRankFilter;

  const FilterInputType({
    super.key,
    required this.title,
    // required this.data,
    // required this.onItemClick,
    // required this.filterParam,
    // this.isRankFilter = false,
  });

  @override
  State<FilterInputType> createState() => _FilterInputTypeState();
}

class _FilterInputTypeState extends State<FilterInputType> {
  bool _isOpen = true;

  void _toggleOpen() {
    setState(() {
      _isOpen = !_isOpen;
    });
  }

  @override
  Widget build(BuildContext context) {
    SignalsStocksManager manager = context.watch<SignalsStocksManager>();
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
            height: _isOpen ? null : 0,
            margin: EdgeInsets.only(
              top: _isOpen ? 5 : 0,
              bottom: _isOpen ? 16 : 0,
            ),
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: TextFieldChangePercentage(
              // controller: manager.controller,
              onChanged: (value) {
                Utils().showLog("--- $value");
                manager.selectPercentage(value: value);
              },
              onIncrement: () {
                Utils().showLog("---");
                manager.selectPercentage(increment: true);
              },
              onDecrement: () {
                manager.selectPercentage(decrement: true);
              },
            ),
          ),
        ),
        Divider(color: ThemeColors.neutral5, height: 1, thickness: 1)
      ],
    );
  }
}
