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
    super.key,
    this.resizeToAvoidBottomInset,
  });

  final Widget? drawer;
  final Widget? bottomNavigationBar;
  final PreferredSizeWidget? appBar;
  final Widget body;
  final bool showSync;
  final bool? resizeToAvoidBottomInset;
//
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            ThemeColors.accent.withOpacity(0.1),
            ThemeColors.background,
            ThemeColors.background,
            ThemeColors.accent.withOpacity(0.1),
          ],
        ),
      ),
      child: GestureDetector(
        onTap: () {
          closeKeyboard();
        },
        child: Scaffold(
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
