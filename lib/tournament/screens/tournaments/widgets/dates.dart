import 'package:flutter/material.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:intl/intl.dart';
import 'package:stocks_news_new/utils/utils.dart';

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
    for (var date in visibleDates) {
      print("visibleDates ----------> ${date.day} ${date.month}");
    }
    widget.onDateSelected(selectedDate);
    setState(() {});
  }

  void shiftLeft() {
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
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              splashRadius: 20,
              icon: const Icon(Icons.arrow_left),
              disabledColor: Colors.grey,
              onPressed: visibleDates.first.isAfter(fullDates.first)
                  ? shiftLeft
                  : null,
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: visibleDates.map((date) {
                  return Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedDate = date;
                        });

                        // Notify the parent widget about the updated selected date
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
                                color: selectedDate.day == date.day
                                    ? ThemeColors.accent.withAlpha(150)
                                    : ThemeColors.greyBorder.withAlpha(150),
                                borderRadius: visibleDates.first == date
                                    ? BorderRadius.only(
                                        topLeft: Radius.circular(10),
                                        bottomLeft: Radius.circular(10))
                                    : visibleDates.last == date
                                        ? BorderRadius.only(
                                            topRight: Radius.circular(10),
                                            bottomRight: Radius.circular(10),
                                          )
                                        : null,
                                border:
                                    Border.all(color: ThemeColors.greyBorder),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 2,
                                vertical: 10,
                              ),
                              child: Text(
                                formatDate(date),
                                style: styleGeorgiaBold(
                                    fontSize: 13,
                                    color: date == DateTime.now()
                                        ? ThemeColors.darkRed
                                        : ThemeColors.white),
                              ),
                            ),
                            if ((visibleDates.last.day == DateTime.now().day) &&
                                visibleDates.last.month == DateTime.now().month)
                              Positioned(
                                right: 5,
                                top: 5,
                                child: Visibility(
                                  visible: (visibleDates.last.day ==
                                          date.day) &&
                                      (visibleDates.last.month == date.month),
                                  child: CircleAvatar(
                                    radius: 4,
                                    backgroundColor: ThemeColors.accent,
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
            IconButton(
              splashRadius: 20,
              icon: const Icon(Icons.arrow_right),
              disabledColor: Colors.grey,
              onPressed: selectedDate == fullDates.last ? null : shiftRight,
            ),
          ],
        ),
      ],
    );
  }
}
