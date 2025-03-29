import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/managers/signals/insiders.dart';
import 'package:stocks_news_new/models/stockDetail/overview.dart';
import 'package:stocks_news_new/ui/base/app_bar.dart';
import 'package:stocks_news_new/ui/base/base_filter_item.dart';
import 'package:stocks_news_new/ui/base/button.dart';
import 'package:stocks_news_new/ui/base/scaffold.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/custom/base_loader_container.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:table_calendar/table_calendar.dart';

class InsiderFilter extends StatefulWidget {
  const InsiderFilter({super.key});

  @override
  State<InsiderFilter> createState() => _InsiderFilterState();
}

class _InsiderFilterState extends State<InsiderFilter> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _callAPI();
    });
  }

  void _callAPI() {
    SignalsInsiderManager manager = context.read<SignalsInsiderManager>();
    if (manager.filter == null) {
      manager.getFilterData();
    }
  }

  @override
  Widget build(BuildContext context) {
    SignalsInsiderManager manager = context.watch<SignalsInsiderManager>();
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
                  if (manager.filter?.txnType != null)
                    FilterType(
                      title: "Transaction Type",
                      data: manager.filter?.txnType,
                      onItemClick: manager.selectTxnType,
                      filterParam: manager.filterParams?.txnType,
                    ),
                  if (manager.filter?.marketCap != null)
                    FilterType(
                      title: "Market Cap",
                      data: manager.filter?.marketCap,
                      onItemClick: manager.selectMarketCap,
                      filterParam: manager.filterParams?.marketCap,
                    ),
                  if (manager.filter?.sector != null)
                    FilterType(
                      title: "Sector",
                      data: manager.filter?.sector,
                      onItemClick: manager.selectSector,
                      filterParam: manager.filterParams?.sector,
                    ),
                  if (manager.filter?.exchange != null)
                    FilterType(
                      title: "Exchange",
                      data: manager.filter?.exchange,
                      onItemClick: manager.selectExchange,
                      filterParam: manager.filterParams?.exchange,
                    ),
                  if (manager.filter?.txnSize != null)
                    FilterType(
                      title: "Transaction Size",
                      data: manager.filter?.txnSize,
                      onItemClick: manager.selectTxnSize,
                      filterParam: manager.filterParams?.txnSize,
                    ),
                  // if (manager.filter?.exchange != null)
                  //   FilterType(
                  //     title: "Exchange",
                  //     data: manager.filter?.exchange,
                  //     onItemClick: manager.selectExchange,
                  //     filterParam: manager.filterParams?.exchange,
                  //   ),


                  if (manager.filter?.txnDate != null)
                  FilterDate(
                    title: "Transaction Date",
                    onItemClick: manager.selectTxnDate,
                    filterParam: manager.filterParams?.txnDate,
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
  final bool isDateFilter;

  const FilterType({
    super.key,
    required this.data,
    required this.title,
    required this.onItemClick,
    required this.filterParam,
    this.isRankFilter = false,
    this.isDateFilter = false,
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

class FilterDate extends StatefulWidget {
  final String title;
  final Function(String date) onItemClick;
  final dynamic filterParam;

  const FilterDate({
    super.key,
    required this.title,
    required this.onItemClick,
    required this.filterParam,
  });

  @override
  State<FilterDate> createState() => _FilterDateState();
}

class _FilterDateState extends State<FilterDate> {
  bool _isOpen = true;

  void _toggleOpen() {
    setState(() {
      _isOpen = !_isOpen;
    });
  }

  @override
  Widget build(BuildContext context) {
    SignalsInsiderManager manager = context.watch<SignalsInsiderManager>();
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
            child: Center(
                child: TableCalendar(
                  firstDay: DateTime.utc(2020, 1, 1),
                  lastDay: DateTime.now(),
                  focusedDay: manager.selectedDay??DateTime.now(),
                  selectedDayPredicate: (day) => isSameDay( manager.selectedDay, day),
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      //_selectedDay = selectedDay;
                      manager.selectDate(selectedDay);
                     // manager.selectedDay = selectedDay;
                      String formattedDate = DateFormat('yyyy-MM-dd').format(manager.selectedDay??DateTime.now());
                      widget.onItemClick(formattedDate);
                    });
                  },
                  calendarFormat: CalendarFormat.month,
                  daysOfWeekHeight: 40,
                  headerStyle: HeaderStyle(
                    formatButtonVisible: false,
                    titleCentered: true,
                    titleTextStyle: styleBaseSemiBold(
                      fontSize: 16,
                      color:
                      ThemeColors.black,
                    ),
                    leftChevronIcon: Container(
                        padding: EdgeInsets.all(Pad.pad5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: ThemeColors.neutral10),
                        ),
                        child: Icon(Icons.chevron_left, color: ThemeColors.black)),
                    rightChevronIcon: Container(
                      padding: EdgeInsets.all(Pad.pad5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: ThemeColors.neutral10),
                        ),
                        child: Icon(Icons.chevron_right, color: ThemeColors.black)),
                  ),
                  daysOfWeekStyle: DaysOfWeekStyle(
                    weekdayStyle:styleBaseRegular(
                      fontSize: 14,
                      color: ThemeColors.black,
                    ),
                    weekendStyle:styleBaseRegular(
                      fontSize: 14,
                      color: ThemeColors.neutral10,
                    ),
                  ),
                  calendarStyle: CalendarStyle(
                    cellPadding: EdgeInsets.zero,
                    todayDecoration: BoxDecoration(
                      color: ThemeColors.black,
                        shape: BoxShape.rectangle,
                    ),
                    selectedDecoration: BoxDecoration(
                        color: ThemeColors.primary120,
                        shape: BoxShape.rectangle,
                    ),
                    todayTextStyle: styleBaseBold(
                      fontSize: 14,
                      color: ThemeColors.white,
                    ),
                    selectedTextStyle: styleBaseBold(
                    fontSize: 14,
                    color: ThemeColors.white,
                    ),
                    outsideDaysVisible: true,
                    outsideTextStyle: styleBaseBold(
                      fontSize: 14,
                      color: ThemeColors.neutral10,
                    ),
                  ),
                )),
          ),
        ),

        Divider(color: ThemeColors.neutral5, height: 1, thickness: 1)
      ],
    );
  }
}

