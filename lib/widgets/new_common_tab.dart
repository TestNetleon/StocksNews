import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/error_display_common.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';

class CommonTabs extends StatefulWidget {
  final List<Widget> tabContents, tabs;
  final bool isLoading, hasData;
  final Function(int) onTabChange;
  final String? error;
  final Function()? onRefresh;
  final bool screenScroll;
//
  const CommonTabs({
    super.key,
    required this.tabContents,
    required this.onTabChange,
    required this.tabs,
    required this.isLoading,
    this.screenScroll = true,
    required this.hasData,
    this.onRefresh,
    this.error,
  });

  @override
  State<CommonTabs> createState() => _CommonTabsState();
}

class _CommonTabsState extends State<CommonTabs>
    with SingleTickerProviderStateMixin {
  late TabController _builderPageController;
  late List<Widget> _tabs;
  int selectedTabIndex = 0;

  @override
  void initState() {
    super.initState();
    _initTabController();
    _prepareTabItems();
  }

  @override
  void dispose() {
    _builderPageController.dispose();
    super.dispose();
  }

  Widget _showWidgets() {
    return Column(
      children: [
        TabBar(
          tabs: widget.tabs,
          controller: _builderPageController,
          tabAlignment: TabAlignment.center,
          physics: const BouncingScrollPhysics(),
          isScrollable: true,
          labelPadding: EdgeInsets.all(6.sp),
          indicatorColor: Colors.transparent,
          automaticIndicatorColorAdjustment: false,
          enableFeedback: false,
        ),
        GestureDetector(
          onHorizontalDragEnd: (details) {
            if (details.primaryVelocity! > 0) {
              if (selectedTabIndex > 0) {
                _builderPageController.animateTo(selectedTabIndex - 1);
                // widget.onTabChange(selectedTabIndex - 1);
              }
            } else if (details.primaryVelocity! < 0) {
              if (selectedTabIndex < (widget.tabContents.length - 1)) {
                _builderPageController.animateTo(selectedTabIndex + 1);
                // widget.onTabChange(selectedTabIndex + 1);
              }
            }
          },
          child: widget.isLoading
              ? Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SpacerHorizontal(width: 5),
                      const CircularProgressIndicator(
                        color: ThemeColors.accent,
                      ),
                      const SpacerHorizontal(width: 5),
                      Flexible(
                        child: Text(
                          "Fetching data... Please wait",
                          style: stylePTSansRegular(color: ThemeColors.accent),
                        ),
                      ),
                    ],
                  ),
                )
              : !widget.isLoading && !widget.hasData
                  ? ErrorDisplayWidget(
                      showHeight: true,
                      smallHeight: true,
                      error: widget.error ?? "No error message.",
                      onRefresh: widget.onRefresh,
                    )
                  : _tabs[selectedTabIndex],
        ),
      ],
    );
  }

  Widget _showWidgets2() {
    return Column(
      children: [
        TabBar(
          tabs: widget.tabs,
          controller: _builderPageController,
          tabAlignment: TabAlignment.center,
          physics: const BouncingScrollPhysics(),
          isScrollable: true,
          labelPadding: EdgeInsets.all(6.sp),
          indicatorColor: Colors.transparent,
          automaticIndicatorColorAdjustment: false,
          enableFeedback: false,
        ),
        Expanded(
          child: GestureDetector(
            onHorizontalDragEnd: (details) {
              if (details.primaryVelocity! > 0) {
                if (selectedTabIndex > 0) {
                  _builderPageController.animateTo(selectedTabIndex - 1);
                  // widget.onTabChange(selectedTabIndex - 1);
                }
              } else if (details.primaryVelocity! < 0) {
                if (selectedTabIndex < (widget.tabContents.length - 1)) {
                  _builderPageController.animateTo(selectedTabIndex + 1);
                  // widget.onTabChange(selectedTabIndex + 1);
                }
              }
            },
            child: widget.isLoading
                ? Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SpacerHorizontal(width: 5),
                        const CircularProgressIndicator(
                          color: ThemeColors.accent,
                        ),
                        const SpacerHorizontal(width: 5),
                        Flexible(
                          child: Text(
                            "Fetching data... Please wait",
                            style:
                                stylePTSansRegular(color: ThemeColors.accent),
                          ),
                        ),
                      ],
                    ),
                  )
                : !widget.isLoading && !widget.hasData
                    ? ErrorDisplayWidget(
                        showHeight: true,
                        smallHeight: true,
                        error: widget.error ?? "No error message.",
                        onRefresh: widget.onRefresh,
                      )
                    : _tabs[selectedTabIndex],
          ),
        ),
      ],
    );
  }

  void _initTabController() {
    _builderPageController = TabController(
      length: widget.tabContents.length,
      vsync: this,
      initialIndex: selectedTabIndex,
    );
    _builderPageController.addListener(() {
      if (_builderPageController.indexIsChanging) {
        setState(() {
          selectedTabIndex = _builderPageController.index;
        });
        widget.onTabChange(selectedTabIndex);
      }
    });
  }

  List<Widget> _prepareTabItems() {
    _tabs = widget.tabContents;
    return _tabs;
  }

  @override
  Widget build(BuildContext context) {
    return widget.screenScroll
        ? Center(child: SingleChildScrollView(child: _showWidgets()))
        : _showWidgets2();
  }
}
