import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:stocks_news_new/service/events/service.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/utils/utils.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';


class CustomDateSelector extends StatefulWidget {
  final Function(DateTime) onDateSelected;
  final DateTime? editedDate;
  final bool? gameValue;
  const CustomDateSelector({
    super.key,
    required this.onDateSelected,
    this.editedDate,
    this.gameValue,
  });

  @override
  State<CustomDateSelector> createState() => _CustomDateSelectorState();
}

class _CustomDateSelectorState extends State<CustomDateSelector> {
  late List<DateTime> fullDates;
  late List<DateTime> visibleDates;
  late DateTime selectedDate;
  @override
  void initState() {
    super.initState();
    _createdDates();
  }

  void _createdDates() {
    DateTime currentDate =
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    if (widget.gameValue == false) {
      currentDate = currentDate.subtract(Duration(days: 1));
    }

    selectedDate = widget.editedDate ?? currentDate;
    final DateTime startDate =
        DateTime(selectedDate.year, selectedDate.month - 2, selectedDate.day);
    fullDates = List.generate(
      currentDate.difference(startDate).inDays + 1,
      (index) => startDate.add(Duration(days: index)),
    );
    int selectedIndex = fullDates.indexWhere((date) =>
        date.year == selectedDate.year &&
        date.month == selectedDate.month &&
        date.day == selectedDate.day);
    if (selectedIndex >= 2) {
      visibleDates = fullDates.sublist(selectedIndex - 2, selectedIndex + 1);
    } else {
      visibleDates = fullDates.sublist(0, selectedIndex + 1);
    }
    widget.onDateSelected(selectedDate);
    setState(() {});
  }

  void shiftLeft() {
    EventsService.instance.clickBackwardCalendarLeagueToolsPage(index: 0);
    setState(() {
      int currentIndex = fullDates.indexOf(selectedDate);
      if (currentIndex > 0) {
        DateTime previousDate = fullDates[currentIndex - 1];
        if (visibleDates.contains(previousDate)) {
          selectedDate = previousDate;
        } else {
          if (fullDates.indexOf(visibleDates.first) > 0) {
            visibleDates.insert(
                0, fullDates[fullDates.indexOf(visibleDates.first) - 1]);
            visibleDates.removeLast();
          }
          selectedDate = visibleDates.first;
        }

        widget.onDateSelected(selectedDate);
      }
    });
  }

  void shiftRight() {
    EventsService.instance.clickBackwardCalendarLeagueToolsPage(index: 1);
    setState(() {
      int currentIndex = fullDates.indexOf(selectedDate);
      if (currentIndex < fullDates.length - 1) {
        DateTime nextDate = fullDates[currentIndex + 1];

        if (visibleDates.contains(nextDate)) {
          selectedDate = nextDate;
        } else {
          if (fullDates.indexOf(visibleDates.last) < fullDates.length - 1) {
            visibleDates
                .add(fullDates[fullDates.indexOf(visibleDates.last) + 1]);

            visibleDates.removeAt(0);
          }
          selectedDate = visibleDates.last;
        }

        widget.onDateSelected(selectedDate);
      } else {
        Utils().showLog('ELSE');
      }
    });
  }
  String formatDate(DateTime date) {
    return DateFormat('dd MMM yy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Pad.pad16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: ThemeColors.neutral5),
                  borderRadius: BorderRadius.circular(Pad.pad8)
                ),
                child: IconButton(
                  splashRadius: 20,
                  icon: const Icon(Icons.arrow_back_ios_new_outlined),
                  disabledColor: ThemeColors.greyText,
                  onPressed: visibleDates.first.isAfter(fullDates.first)
                      ? shiftLeft
                      : null,
                ),
              ),
              SpacerHorizontal(width: Pad.pad8),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: visibleDates.map((date) {
                    return Expanded(
                      child: GestureDetector(
                        onTap: () {

                          EventsService.instance.clickBackwardCalendarLeagueToolsPage(index: 2);
                          setState(() {
                            selectedDate = date;
                          });
                          widget.onDateSelected(selectedDate);
                        },
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          transitionBuilder: (child, animation) {
                            return SlideTransition(
                              position: animation.drive(
                                Tween(
                                  begin: const Offset(1.0, 0.0),
                                  end: Offset.zero,
                                ).chain(CurveTween(
                                  curve: Curves.easeInOut,
                                )),
                              ),
                              child: child,
                            );
                          },
                          key: ValueKey(date),
                          child: Stack(
                            children: [
                              Container(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                 /* color: selectedDate.day == date.day
                                      ? ThemeColors.success120.withAlpha(150)
                                      : ThemeColors.neutral40.withAlpha(150),
                                  borderRadius: visibleDates.first == date
                                      ? BorderRadius.only(
                                          topLeft: Radius.circular(10),
                                          bottomLeft: Radius.circular(10)
                                  )
                                      : visibleDates.last == date
                                          ? BorderRadius.only(
                                              topRight: Radius.circular(10),
                                              bottomRight: Radius.circular(10),
                                            )
                                          : null,*/
                                  borderRadius:BorderRadius.circular(Pad.pad8),
                                  border: Border.all(color: selectedDate.day == date.day ?ThemeColors.navigationBar:Colors.transparent),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: Pad.pad3,
                                  vertical: Pad.pad8,
                                ),
                                child: Text(
                                  formatDate(date),
                                  style: styleBaseSemiBold(
                                      fontSize: 14,
                                      color:ThemeColors.black
                                  ),
                                ),
                              ),
                              if ((visibleDates.last.day == DateTime.now().day) &&
                                  visibleDates.last.month == DateTime.now().month)
                                Positioned(
                                  right: 5,
                                  top: 3,
                                  child: Visibility(
                                    visible: (visibleDates.last.day ==
                                            date.day) &&
                                        (visibleDates.last.month == date.month),
                                    child: CircleAvatar(
                                      radius: 4,
                                      backgroundColor: ThemeColors.navigationBar,
                                    ),
                                  ),
                                )
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              SpacerHorizontal(width: Pad.pad8),
              Container(
                decoration: BoxDecoration(
                    border: Border.all(color: ThemeColors.neutral5),
                    borderRadius: BorderRadius.circular(Pad.pad8)
                ),
                child: IconButton(
                  splashRadius: 20,
                  icon: const Icon(Icons.arrow_forward_ios_outlined),
                  disabledColor: ThemeColors.greyText,
                  onPressed: selectedDate == fullDates.last ? null : shiftRight,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
