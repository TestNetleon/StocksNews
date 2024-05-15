import 'package:flutter/material.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/utils.dart';

class BaseContainer extends StatelessWidget {
  const BaseContainer({
    required this.body,
    this.appBar,
    this.bottomNavigationBar,
    this.showSync = false,
    this.drawer,
    this.moreGradient = false,
    super.key,
    this.resizeToAvoidBottomInset,
  });

  final Widget? drawer;
  final Widget? bottomNavigationBar;
  final PreferredSizeWidget? appBar;
  final Widget body;
  final bool showSync;
  final bool? resizeToAvoidBottomInset;
  final bool moreGradient;
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
            radius: moreGradient ? 0.7 : 0.6,
            stops: [
              0.0,
              0.9,
            ],
            colors: [
              Color.fromARGB(255, 0, 125, 17),
              Colors.black,
            ],
          ),
        ),
        child: Scaffold(
          extendBodyBehindAppBar: true,
          backgroundColor: ThemeColors.transparent,
          appBar: appBar,
          resizeToAvoidBottomInset: resizeToAvoidBottomInset,
          drawer: drawer,
          body: SafeArea(
            child: body,
          ),
          bottomNavigationBar: bottomNavigationBar,
        ),
      ),
    );
  }
}
