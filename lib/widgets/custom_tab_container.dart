import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/utils.dart';
import 'package:stocks_news_new/widgets/custom_tab.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

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
    _controller = TabController(length: widget.tabs.length, vsync: this);

    _controller?.addListener(() {
      if (_controller?.indexIsChanging == true) {
        setState(() {
          _selectedIndex = _controller?.index ?? 0;
        });
        if (widget.onChange != null) {
          widget.onChange!(_selectedIndex);
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
                tabs: widget.tabs),
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

// class CustomTabContainerNews extends StatefulWidget {
//   const CustomTabContainerNews({
//     required this.tabs,
//     required this.widgets,
//     this.rightWidget = const SizedBox(),
//     this.header,
//     required this.onChange,
//     this.showDivider = false,
//     super.key,
//   });

//   final Widget rightWidget;
//   final Widget? header;
//   final List<Widget> tabs;
//   final List<Widget> widgets;
//   final bool showDivider;
//   final Function() onChange;

//   @override
//   State<CustomTabContainerNews> createState() => _CustomTabContainerNewsState();
// }

// class _CustomTabContainerNewsState extends State<CustomTabContainerNews>
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
//       widget.onChange();
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
//         children: [
//           TabBar(
//             tabAlignment: TabAlignment.center,
//             physics: const BouncingScrollPhysics(),
//             isScrollable: true,
//             labelPadding: EdgeInsets.all(6.sp),
//             controller: _controller,
//             indicatorColor: Colors.transparent,
//             automaticIndicatorColorAdjustment: false,
//             enableFeedback: false,
//             // onTap: (index) {
//             //   setState(
//             //     () {
//             //       _selectedIndex = index;
//             //     },
//             //   );
//             // },
//             tabs: List.generate(
//               widget.tabs.length,
//               (index) => CustomTabLabelNews(
//                 "${widget.tabs[index]}",
//                 selected: 1 == index,
//                 onTap: widget.onChange,
//               ),
//             ),
//           ),
//           Visibility(
//               visible: widget.showDivider,
//               child: Divider(color: ThemeColors.border, height: 10.sp)),
//           Expanded(
//             child: TabBarView(
//               controller: _controller,
//               children: widget.widgets,
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }

class CustomTabContainerNEW extends StatefulWidget {
  const CustomTabContainerNEW({
    required this.tabs,
    required this.widgets,
    this.rightWidget = const SizedBox(),
    this.header,
    this.onChange,
    this.showDivider = false,
    this.scrollable,
    this.isTabWidget,
    this.tabsPadding,
    this.physics = const AlwaysScrollableScrollPhysics(),
    super.key,
  });
//
  final Widget rightWidget;
  final Widget? header;
  final List<String> tabs;
  final List<Widget> widgets;
  final List<Widget>? isTabWidget;
  final EdgeInsets? tabsPadding;
  final bool showDivider;
  final bool? scrollable;
  final ScrollPhysics physics;
  final Function(int index)? onChange;

  @override
  State<CustomTabContainerNEW> createState() => _CustomTabContainerNEWState();
}

class _CustomTabContainerNEWState extends State<CustomTabContainerNEW>
    with SingleTickerProviderStateMixin {
  bool sync = true;
  TabController? _controller;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _controller = TabController(length: widget.tabs.length, vsync: this);
    _controller?.addListener(() {
      setState(() {
        _selectedIndex = _controller?.index ?? 0;
      });
      if (widget.onChange != null) {
        widget.onChange!(_selectedIndex);
      }
      Utils().showLog("$_selectedIndex");
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SpacerVertical(height: 5),
          // Visibility(
          //   child: Container(
          //     decoration: const BoxDecoration(
          //       border: Border(
          //         bottom: BorderSide(
          //           color: ThemeColors.greyBorder,
          //         ),
          //       ),
          //     ),
          //   ),
          // ),
          // SpacerVertical(height: 5),
          Padding(
            padding:
                widget.tabsPadding ?? EdgeInsets.symmetric(horizontal: 10.sp),
            child: TabBar(
              tabAlignment: widget.scrollable == true
                  ? TabAlignment.start
                  : TabAlignment.fill,
              physics: const BouncingScrollPhysics(),
              isScrollable: widget.scrollable ?? true,
              labelPadding: EdgeInsets.symmetric(
                horizontal: 13.sp,
                vertical: 2.sp,
              ),
              indicator: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: ThemeColors.accent),
                ),
              ),
              controller: _controller,
              indicatorColor: ThemeColors.white,
              automaticIndicatorColorAdjustment: true,
              // enableFeedback: false,
              onTap: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
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
          // const SpacerVertical(height: 5),
          // Visibility(
          //   child: Container(
          //     decoration: const BoxDecoration(
          //       border: Border(
          //         bottom: BorderSide(
          //           color: ThemeColors.greyBorder,
          //         ),
          //       ),
          //     ),
          //   ),
          // ),
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
