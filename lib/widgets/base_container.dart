import 'package:flutter/material.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/utils.dart';

// final GlobalKey<PopScopeState> _popScopeKey = GlobalKey<PopScopeState>();

class BaseContainer extends StatefulWidget {
  const BaseContainer({
    required this.body,
    this.appBar,
    this.floatingAlingment,
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
  });

  final Widget? drawer;
  final Widget? bottomNavigationBar;
  final Widget? floatingActionButton;
  final PreferredSizeWidget? appBar;
  final FloatingActionButtonLocation? floatingAlingment;
  final Widget body;
  final bool showSync;
  final bool showBehind;
  final bool? resizeToAvoidBottomInset;
  final bool moreGradient;
  final Color? bottomSafeAreaColor;
  final bool isHome;
  final Color? baseColor;

  @override
  State<BaseContainer> createState() => _BaseContainerState();
}

class _BaseContainerState extends State<BaseContainer> {
  bool isNavigating = true;
//
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        closeKeyboard();
      },
      child: Container(
        decoration: !widget.isHome
            ? BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.topRight,
                  // radius: widget.moreGradient ? 0.7 : 0.6,
                  radius: widget.moreGradient ? 2.0 : 1.4,
                  stops: const [
                    0.0,
                    0.9,
                  ],
                  colors: [
                    widget.baseColor ?? Color(0xFF007D11),
                    Colors.black,
                  ],
                ),
              )
            : BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.bottomCenter,
                  radius: widget.moreGradient ? 0.7 : 0.6,
                  stops: const [
                    0.0,
                    0.9,
                  ],
                  colors: const [
                    Color.fromARGB(255, 0, 125, 17),
                    Colors.black,
                  ],
                ),
              ),
        child: Scaffold(
          extendBodyBehindAppBar: widget.showBehind,
          backgroundColor: ThemeColors.transparent,
          appBar: widget.appBar,
          resizeToAvoidBottomInset: widget.resizeToAvoidBottomInset,
          drawer: widget.drawer,
          body: PopScope(
            canPop: false,
            child: widget.bottomSafeAreaColor != null
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
          ),
          bottomNavigationBar: widget.bottomNavigationBar,
          floatingActionButton: widget.floatingActionButton,
          floatingActionButtonLocation: widget.floatingAlingment,
        ),
      ),
    );
  }
}
