import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/theme.dart';
import '../../../providers/stockAnalysis/provider.dart';
import 'events/index.dart';
import 'posts/index.dart';
import 'view/overview.dart';

class MsTabs extends StatefulWidget {
  const MsTabs({super.key});

  @override
  State<MsTabs> createState() => _MsTabsState();
}

class _MsTabsState extends State<MsTabs> with SingleTickerProviderStateMixin {
  int selectedIndex = 0;
  List<String> menus = [
    'Overview',
    'News',
    'Events',
  ];

  onChange(int index) {
    setState(() {
      selectedIndex = index;
    });
    MSAnalysisProvider provider = context.read<MSAnalysisProvider>();

    if (selectedIndex == 1) {
      provider.getNewsData(symbol: provider.topData?.symbol ?? "");
    } else if (selectedIndex == 2) {
      provider.getEventsData(symbol: provider.topData?.symbol ?? "");
    }
  }

  @override
  Widget build(BuildContext context) {
    // return MsOverview();

    return Column(
      children: [
        CupertinoSlidingSegmentedControl<int>(
          groupValue: selectedIndex,
          thumbColor: ThemeColors.greyBorder.withOpacity(0.4),
          padding: const EdgeInsets.all(4),
          backgroundColor: const Color.fromARGB(255, 28, 28, 28),
          onValueChanged: (int? index) {
            // setState(() {
            //   selectedIndex = index ?? 0;
            // });
            onChange(index ?? 0);
          },
          children: {
            for (int i = 0; i < menus.length; i++)
              i: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Center(
                  child: Text(
                    menus[i],
                    style: styleGeorgiaRegular(
                      fontSize: 13,
                      color: selectedIndex == i
                          ? ThemeColors.accent
                          : ThemeColors.white,
                    ),
                  ),
                ),
              ),
          },
        ),
        selectedIndex == 0
            ? MsOverview()
            : selectedIndex == 1
                ? MsNews()
                : selectedIndex == 2
                    ? MsEvents()
                    : SizedBox(),
      ],
    );
  }
}
