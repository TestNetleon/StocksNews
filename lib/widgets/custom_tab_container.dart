import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/utils.dart';
import 'package:stocks_news_new/widgets/custom_tab.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import 'package:vibration/vibration.dart';

class CustomTabContainer extends StatefulWidget {
  const CustomTabContainer({
    required this.tabs,
    required this.widgets,
    this.rightWidget = const SizedBox(),
    this.header,
    this.padding,
    this.onChange,
    this.showDivider = false,
    this.isScrollable = false,
    this.initialIndex = 0,
    super.key,
  });
//
  final Widget rightWidget;
  final Widget? header;
  final List<Widget> tabs;
  final EdgeInsets? padding;
  final bool isScrollable;
  final List<Widget> widgets;
  final bool showDivider;
  final Function(int index)? onChange;
  final int initialIndex;

  @override
  State<CustomTabContainer> createState() => _CustomState();
}

class _CustomState extends State<CustomTabContainer>
    with SingleTickerProviderStateMixin {
  bool sync = true;
  TabController? _controller;
  int _selectedIndex = 0;
  @override
  void initState() {
    super.initState();
    _controller = TabController(
      length: widget.tabs.length,
      vsync: this,
      initialIndex: widget.initialIndex,
    );

    _controller?.addListener(() {
      // if (_controller?.indexIsChanging == true) {
      setState(() {
        _selectedIndex = _controller?.index ?? 0;
      });
      if (widget.onChange != null) {
        widget.onChange!(_selectedIndex);
      }
      // }
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: widget.tabs.length,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(5),
            margin: widget.padding,
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 21, 21, 21),
              borderRadius: BorderRadius.circular(10),
            ),
            child: TabBar(
              controller: _controller,
              onTap: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
              indicator: BoxDecoration(
                color: const Color.fromARGB(255, 0, 82, 4),
                borderRadius: BorderRadius.circular(8),
              ),
              isScrollable: widget.isScrollable,
              tabs: widget.tabs,
            ),
          ),
          const SpacerVertical(height: 10),
          // TabBar(
          //   tabAlignment: TabAlignment.start,
          //   physics: const BouncingScrollPhysics(),
          //   isScrollable: true,
          //   labelPadding:
          //       const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
          //   controller: _controller,
          //   indicatorColor: Colors.transparent,
          //   automaticIndicatorColorAdjustment: false,
          //   enableFeedback: false,
          //   onTap: (index) {
          //     setState(() {
          //       _selectedIndex = index;
          //     });
          //   },
          //   tabs: widget.tabs,
          // ),
          Visibility(
              visible: widget.showDivider,
              child: Divider(color: ThemeColors.border, height: 10.sp)),
          Expanded(
            child: TabBarView(
              controller: _controller,
              children: widget.widgets,
            ),
          )
        ],
      ),
    );
  }
}

// class CustomTabContainerNEW extends StatefulWidget {
//   const CustomTabContainerNEW({
//     required this.tabs,
//     required this.widgets,
//     this.rightWidget = const SizedBox(),
//     this.header,
//     this.onChange,
//     this.showDivider = false,
//     this.scrollable,
//     this.isTabWidget,
//     this.tabsPadding,
//     this.physics = const AlwaysScrollableScrollPhysics(),
//     this.onController,
//     super.key,
//   });
// //
//   final Widget rightWidget;
//   final Widget? header;
//   final List<String> tabs;
//   final List<Widget> widgets;
//   final List<Widget>? isTabWidget;
//   final EdgeInsets? tabsPadding;
//   final bool showDivider;
//   final bool? scrollable;
//   final ScrollPhysics physics;
//   final Function(int index)? onChange;
//   final Function(TabController? controller)? onController;

//   @override
//   State<CustomTabContainerNEW> createState() => _CustomTabContainerNEWState();
// }

// class _CustomTabContainerNEWState extends State<CustomTabContainerNEW>
//     with SingleTickerProviderStateMixin {
//   bool sync = true;
//   TabController? _controller;
//   int _selectedIndex = 0;

//   @override
//   void initState() {
//     super.initState();
//     _controller = TabController(length: widget.tabs.length, vsync: this);
//     _controller?.addListener(() {
//       setState(() {
//         _selectedIndex = _controller?.index ?? 0;
//       });
//       if (widget.onChange != null) {
//         widget.onChange!(_selectedIndex);
//       }
//       Utils().showLog("$_selectedIndex");
//     });
//   }

//   @override
//   void dispose() {
//     _controller?.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return DefaultTabController(
//       length: widget.tabs.length,
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const SpacerVertical(height: 5),
//           // Visibility(
//           //   child: Container(
//           //     decoration: const BoxDecoration(
//           //       border: Border(
//           //         bottom: BorderSide(
//           //           color: ThemeColors.greyBorder,
//           //         ),
//           //       ),
//           //     ),
//           //   ),
//           // ),
//           // SpacerVertical(height: 5),
//           Padding(
//             padding:
//                 widget.tabsPadding ?? EdgeInsets.symmetric(horizontal: 10.sp),
//             child: TabBar(
//               tabAlignment: widget.scrollable == true
//                   ? TabAlignment.start
//                   : TabAlignment.fill,
//               physics: const BouncingScrollPhysics(),
//               isScrollable: widget.scrollable ?? true,
//               labelPadding: EdgeInsets.symmetric(
//                 horizontal: 13.sp,
//                 vertical: 2.sp,
//               ),
//               indicator: const BoxDecoration(
//                 border: Border(
//                   bottom: BorderSide(color: ThemeColors.accent),
//                 ),
//               ),
//               controller: _controller,
//               indicatorColor: ThemeColors.white,
//               automaticIndicatorColorAdjustment: true,
//               // enableFeedback: false,
//               onTap: (index) {
//                 setState(() {
//                   _selectedIndex = index;
//                 });
//               },
//               tabs: [
//                 ...widget.tabs.asMap().entries.map((entry) {
//                   return CustomTabNEW(
//                     index: entry.key,
//                     label: entry.value,
//                     selectedIndex: _selectedIndex,
//                   );
//                 }),
//               ],
//             ),
//           ),
//           // const SpacerVertical(height: 5),
//           // Visibility(
//           //   child: Container(
//           //     decoration: const BoxDecoration(
//           //       border: Border(
//           //         bottom: BorderSide(
//           //           color: ThemeColors.greyBorder,
//           //         ),
//           //       ),
//           //     ),
//           //   ),
//           // ),
//           Expanded(
//             child: TabBarView(
//               physics: widget.physics,
//               controller: _controller,
//               children: widget.widgets,
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }

class CommonTabContainer extends StatefulWidget {
  const CommonTabContainer({
    required this.tabs,
    required this.widgets,
    this.rightWidget = const SizedBox(),
    this.header,
    this.padding,
    this.tabPaddingNew = true,
    this.onChange,
    this.showDivider = false,
    this.scrollable = false,
    this.physics,
    this.fillWidth = false,
    this.initialIndex = 0,
    super.key,
  });
//
  final Widget rightWidget;
  final Widget? header;
  final List<String> tabs;
  final EdgeInsets? padding;
  final bool tabPaddingNew;

  final bool fillWidth;
  final bool scrollable;
  final List<Widget> widgets;
  final bool showDivider;
  final ScrollPhysics? physics;
  final Function(int index)? onChange;
  final int initialIndex;

  @override
  State<CommonTabContainer> createState() => _CommonTabContainerState();
}

class _CommonTabContainerState extends State<CommonTabContainer>
    with SingleTickerProviderStateMixin {
  bool sync = true;
  TabController? _controller;
  int _selectedIndex = 0;
  @override
  void initState() {
    super.initState();
    _controller = TabController(
      length: widget.tabs.length,
      vsync: this,
      initialIndex: widget.initialIndex,
    );

    _controller?.addListener(() async {
      if (_controller?.indexIsChanging == true) {
        setState(() {
          _selectedIndex = _controller?.index ?? 0;
        });
        try {
          if (Platform.isAndroid) {
            bool isVibe = await Vibration.hasVibrator() ?? false;
            if (isVibe) {
              Vibration.vibrate(
                pattern: [50, 50, 79, 55],
                intensities: [1, 10],
              );
            }
          } else {
            HapticFeedback.lightImpact();
          }
        } catch (e) {
          //
        }
        try {
          if (widget.onChange != null) {
            widget.onChange!(_selectedIndex);
          }
        } catch (e) {
          Utils().showLog("tab error $e");
        }
      }
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: widget.tabs.length,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: widget.tabPaddingNew
                ? const EdgeInsets.symmetric(horizontal: Dimen.padding)
                : EdgeInsets.zero,
            child: Container(
              padding: const EdgeInsets.all(2),
              // margin: widget.padding,
              decoration: BoxDecoration(
                // color: const Color.fromARGB(255, 30, 30, 30),
                color: Color.fromARGB(255, 0, 38, 4),
                borderRadius: BorderRadius.circular(4),
              ),
              child: TabBar(
                controller: _controller,
                onTap: (index) {
                  setState(() {
                    _selectedIndex = index;
                  });
                },
                indicator: BoxDecoration(
                  color: ThemeColors.themeGreen,
                  borderRadius: BorderRadius.circular(4),
                ),
                isScrollable: widget.scrollable,
                tabs: [
                  ...widget.tabs.asMap().entries.map((entry) {
                    return CustomTabNEW(
                      index: entry.key,
                      label: entry.value,
                      selectedIndex: _selectedIndex,
                    );
                  }),
                ],
              ),
            ),
          ),
          const SpacerVertical(height: 10),
          Visibility(
            visible: widget.showDivider,
            child: Divider(color: ThemeColors.border, height: 10.sp),
          ),
          Expanded(
            child: TabBarView(
              physics: widget.physics,
              controller: _controller,
              children: widget.widgets,
            ),
          )
        ],
      ),
    );
  }
}
