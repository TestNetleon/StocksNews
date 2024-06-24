import 'package:flutter/material.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/utils.dart';

// final GlobalKey<PopScopeState> _popScopeKey = GlobalKey<PopScopeState>();

class BaseContainer extends StatefulWidget {
  const BaseContainer({
    required this.body,
    this.appBar,
    this.bottomNavigationBar,
    this.showSync = false,
    this.drawer,
    this.moreGradient = false,
    super.key,
    this.resizeToAvoidBottomInset,
    this.bottomSafeAreaColor,
    this.floatingActionButton,
  });

  final Widget? drawer;
  final Widget? bottomNavigationBar;
  final Widget? floatingActionButton;
  final PreferredSizeWidget? appBar;
  final Widget body;
  final bool showSync;
  final bool? resizeToAvoidBottomInset;
  final bool moreGradient;
  final Color? bottomSafeAreaColor;

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
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.bottomCenter,
            // radius: 0.6,
            // stops: [
            //   0.0,
            //   0.9,
            // ],
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
        child:
            // onPopInvoked: (didPop) {
            //   log("POPDPODPODPODPO  ===>  $didPop  NAVI =>$isNavigating  popHONE => $popHome");
            //   if (isNavigating) {
            //     // if (!didPop) return;
            //     Preference.saveDataList(
            //       DeeplinkData(
            //         uri: null,
            //         from: "POP Scope => didPop => $didPop",
            //         onDeepLink: onDeepLinking,
            //       ),
            //     );
            //     if (popHome) {
            //       Navigator.popUntil(
            //           navigatorKey.currentContext!, (route) => route.isFirst);
            //       Navigator.pushReplacement(
            //         navigatorKey.currentContext!,
            //         MaterialPageRoute(builder: (_) => const Tabs()),
            //       );
            //     } else {
            //       log("HERE ******* ");
            //       try {
            //         Navigator.pop(context);
            //       } catch (e) {
            //         log("HERE ERROR  ******* ${e.toString()}");
            //       }
            //     }
            //     isNavigating = false;
            //   }
            // },
            Scaffold(
          extendBodyBehindAppBar: true,
          backgroundColor: ThemeColors.transparent,
          appBar: widget.appBar,
          resizeToAvoidBottomInset: widget.resizeToAvoidBottomInset,
          drawer: widget.drawer,
          body: PopScope(
            canPop: false,
            // onPopInvoked: (didPop) {
            //   log("POPDPODPODPODPO  ===>  $didPop  NAVI =>$isNavigating  popHONE => $popHome");
            //   if (isNavigating) {
            //     try {
            //       // if (!didPop) return;
            //       Preference.saveDataList(
            //         DeeplinkData(
            //           uri: null,
            //           from: "POP Scope => didPop => $didPop",
            //           onDeepLink: onDeepLinking,
            //         ),
            //       );
            //       if (popHome) {
            //         // Navigator.popUntil(
            //         //     navigatorKey.currentContext!, (route) => route.isFirst);
            //         Navigator.pushReplacement(
            //           navigatorKey.currentContext!,
            //           MaterialPageRoute(builder: (_) => const Tabs()),
            //         );
            //       } else {
            //         log("HERE ******* ");
            //         Navigator.pop(navigatorKey.currentContext!);
            //       }
            //       isNavigating = false;
            //     } catch (e) {
            //       log("HERE ERROR  ******* ${e.toString()}");
            //     }
            //   }
            // },
            child: widget.bottomSafeAreaColor != null
                ? Column(
                    children: [
                      Container(
                        color: widget.bottomSafeAreaColor,
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
        ),
      ),
    );
  }
}
