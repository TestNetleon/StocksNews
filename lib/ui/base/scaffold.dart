import 'package:flutter/material.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/utils.dart';

class BaseScaffold extends StatefulWidget {
  const BaseScaffold({
    required this.body,
    this.appBar,
    this.floatingAlignment,
    this.bottomNavigationBar,
    this.showSync = false,
    this.showBehind = true,
    this.drawer,
    this.moreGradient = false,
    super.key,
    this.resizeToAvoidBottomInset,
    this.bottomSafeAreaColor,
    this.floatingActionButton,
    this.isHome = false,
    this.baseColor,
    this.bgColor = ThemeColors.white,
  });

  final Widget? drawer;
  final Widget? bottomNavigationBar;
  final Widget? floatingActionButton;
  final PreferredSizeWidget? appBar;
  final FloatingActionButtonLocation? floatingAlignment;
  final Widget body;
  final bool showSync;
  final bool showBehind;
  final bool? resizeToAvoidBottomInset;
  final bool moreGradient;
  final Color? bottomSafeAreaColor;
  final bool isHome;
  final Color? baseColor;
  final Color? bgColor;

  @override
  State<BaseScaffold> createState() => _BaseScaffoldState();
}

class _BaseScaffoldState extends State<BaseScaffold> {
//
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        closeKeyboard();
      },
      child: Container(
        // decoration: BoxDecoration(
        //   color: widget.bgColor,
        // ),
        child: Scaffold(
          extendBodyBehindAppBar: widget.showBehind,
          backgroundColor: widget.bgColor,
          appBar: widget.appBar,
          resizeToAvoidBottomInset: widget.resizeToAvoidBottomInset,
          drawer: widget.drawer,
          body: widget.bottomSafeAreaColor != null
              ? Column(
                  children: [
                    Container(
                      // color: widget.bottomSafeAreaColor,
                      height: MediaQuery.of(context).padding.top +
                          (widget.appBar?.preferredSize.height ?? 0),
                    ),
                    Expanded(child: widget.body),
                    Container(
                      color: widget.bottomSafeAreaColor,
                      height: MediaQuery.of(context).padding.bottom,
                    ),
                  ],
                )
              : SafeArea(child: widget.body),
          bottomNavigationBar: widget.bottomNavigationBar,
          floatingActionButton: widget.floatingActionButton,
          floatingActionButtonLocation: widget.floatingAlignment,
        ),
      ),
    );
  }
}
