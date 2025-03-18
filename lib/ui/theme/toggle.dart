import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/ui/theme/manager.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:toggle_switch/toggle_switch.dart';

class ThemeToggleSwitch extends StatefulWidget {
  final ValueChanged<ThemeMode> onToggle;

  const ThemeToggleSwitch({super.key, required this.onToggle});

  @override
  State<ThemeToggleSwitch> createState() => _ThemeToggleSwitchState();
}

class _ThemeToggleSwitchState extends State<ThemeToggleSwitch> {
  int? _selectedIndex;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ThemeManager manager = context.read<ThemeManager>();
      switch (manager.themeMode) {
        case ThemeMode.light:
          _selectedIndex = 0;
          break;
        case ThemeMode.dark:
          _selectedIndex = 1;
          break;
        case ThemeMode.system:
          _selectedIndex = manager.isDarkMode ? 1 : 0;
          break;
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: Pad.pad10),
      padding: const EdgeInsets.symmetric(horizontal: Pad.pad16),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return ToggleSwitch(
            borderWidth: 2,
            // activeBgColor: [
            //   ThemeColors.black,
            //   ThemeColors.black,
            //   ThemeColors.black,
            // ],
            borderColor: [
              ThemeColors.neutral5,
              ThemeColors.neutral5,
              ThemeColors.neutral5,
            ],
            cornerRadius: 20.0,
            minWidth: constraints.maxWidth / 3,
            centerText: true,
            activeBgColors: [
              [Colors.white],
              [Colors.black],
              [ThemeColors.secondary120],
            ],
            activeFgColor: _selectedIndex == 0
                ? ThemeColors.black
                : _selectedIndex == 1
                    // ? ThemeColors.white
                    ? ThemeColors.black
                    : ThemeColors.white,
            inactiveBgColor: ThemeColors.neutral10,
            inactiveFgColor: Colors.black,
            labels: ['Light', 'Dark', 'System'],
            icons: [Icons.wb_sunny, Icons.nightlight_round, Icons.settings],
            initialLabelIndex: _selectedIndex,
            onToggle: (index) {
              setState(() {
                _selectedIndex = index;
              });

              if (index == 0) {
                widget.onToggle(ThemeMode.light);
              } else if (index == 1) {
                widget.onToggle(ThemeMode.dark);
              } else {
                widget.onToggle(ThemeMode.system);
              }
            },
          );
        },
      ),
    );
  }
}
