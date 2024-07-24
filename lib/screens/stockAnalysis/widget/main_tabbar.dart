import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dash/flutter_dash.dart';
import 'package:stocks_news_new/screens/stockAnalysis/performance_tabbarview/overview.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

class PerformaceTabbar extends StatefulWidget {
  const PerformaceTabbar({super.key});

  @override
  State<PerformaceTabbar> createState() => _PerformaceTabbarState();
}

class _PerformaceTabbarState extends State<PerformaceTabbar>
    with SingleTickerProviderStateMixin {
  late TabController controller;

  @override
  void initState() {
    super.initState();

    controller = TabController(vsync: this, length: 3);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  List<String> menus = [
    'Overview',
    'News',
    'Events',
  ];

  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CupertinoSlidingSegmentedControl<int>(
          groupValue: selectedIndex,
          thumbColor: ThemeColors.greyBorder.withOpacity(0.4),
          padding: const EdgeInsets.all(4),
          backgroundColor: const Color.fromARGB(255, 28, 28, 28),
          onValueChanged: (int? index) {
            setState(() {
              if (index == 0) {
                selectedIndex = index!;
              } else if (index == 1) {
                selectedIndex = index!;
              } else if (index == 2) {
                selectedIndex = index!;
              }
            });
          },
          children: {
            for (int i = 0; i < menus.length; i++)
              i: SizedBox(
                width: MediaQuery.of(context).size.width,
                // padding:const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                child: Center(
                  child: Text(
                    menus[i],
                    style: styleGeorgiaRegular(
                      fontSize: 13,
                      color: selectedIndex == i
                          ? ThemeColors.accent
                          : ThemeColors.white,
                      //color: ThemeColors.white,
                    ),
                  ),
                ),
              ),
          },
        ),

        selectedIndex == 0
            ? PerformanceOverview()
            : selectedIndex == 1
                ? Text('hello')
                : selectedIndex == 2
                    ? Text('hiii')
                    : PerformanceOverview(),

        // DefaultTabController(
        //   length: 3,
        //   initialIndex: 1,
        //   child: TabBar(
        //     dividerColor: Colors.transparent,
        //     indicator: BoxDecoration(
        //         gradient: LinearGradient(
        //             begin: Alignment.topCenter,
        //             end: Alignment.bottomCenter,
        //             colors: const [
        //               Color.fromARGB(255, 24, 189, 33),
        //               Colors.yellow,
        //               Colors.orange,
        //             ]),
        //         // color: const Color.fromARGB(255, 6, 185, 6),
        //         borderRadius: BorderRadius.circular(10)),
        //     labelStyle: const TextStyle(color: Colors.white, fontSize: 16),
        //     unselectedLabelColor: Colors.grey,
        //     controller: controller,
        //     indicatorWeight: 0,
        //     indicatorSize: TabBarIndicatorSize.tab,
        //     labelPadding: EdgeInsets.all(0),
        //     tabs: const [
        //       Tab(
        //         text: 'Overview',
        //       ),
        //       Tab(
        //         text: 'News',
        //       ),
        //       Tab(
        //         text: 'Event',
        //       ),
        //     ],
        //   ),
        // ),
        // SizedBox(
        //   height: MediaQuery.of(context).size.height,
        //   child: TabBarView(
        //     physics: NeverScrollableScrollPhysics(),
        //     controller: controller,
        //     children: const <Widget>[
        //       PerformanceOverview(),
        //       PerformanceOverview(),
        //       PerformanceOverview(),
        //     ],
        //   ),
        // ),
      ],
    );
  }
}
