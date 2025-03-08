import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/managers/global.dart';
import 'package:stocks_news_new/routes/my_app.dart';
import 'package:stocks_news_new/routes/navigation_observer.dart';
import 'package:stocks_news_new/ui/stockDetail/index.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/utils/utils.dart';
import '../../../../ui/tabs/tabs.dart';
import '../tabs/more/news/detail.dart';
import 'search/base_search.dart';

class BaseAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool isHome,
      showBack,
      showSearch,
      showNotification,
      showActionNotification;
  final Widget? searchFieldWidget;
  final bool showClose;
  final String? title;
  final Function()? onSaveClick;
  final Function()? shareURL;
  final double toolbarHeight;
  final bool showLogo;
  final Function()? leadingFilterClick, showFilter;

  const BaseAppBar({
    super.key,
    this.toolbarHeight = 56,
    this.searchFieldWidget,
    this.isHome = false,
    this.showBack = false,
    this.showFilter,
    this.title,
    this.showSearch = false,
    this.showNotification = false,
    this.showActionNotification = false,
    this.onSaveClick,
    this.shareURL,
    this.showClose = false,
    this.showLogo = true,
    this.leadingFilterClick,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        // padding: const EdgeInsets.symmetric(vertical: 8.0),
        padding: const EdgeInsets.all(Pad.pad8),
        child: Stack(
          children: [
            if (searchFieldWidget != null) searchFieldWidget ?? SizedBox(),
            if ((title == null || title == '') &&
                searchFieldWidget == null &&
                showLogo)
              CenterLogo(isHome: isHome),
            if (title != null && title != '') CenterTitle(title: title!),
            Positioned(
              left: 0,
              right: 0,
              top: 0,
              bottom: 0,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Leading
                  Row(
                    children: [
                      if (showBack)
                        ActionButton(
                          icon: Images.back,
                          onTap: () {
                            if (popHome) {
                              if (CustomNavigatorObserver().stackCount >= 2 &&
                                  splashLoaded) {
                                Navigator.pop(navigatorKey.currentContext!);
                              } else {
                                Navigator.popUntil(navigatorKey.currentContext!,
                                    (route) => route.isFirst);
                                Navigator.pushReplacementNamed(
                                    navigatorKey.currentContext!, Tabs.path);
                                /* Navigator.pushReplacement(
                                  navigatorKey.currentContext!,
                                  MaterialPageRoute(
                                      builder: (_) => const Tabs()),
                                );*/
                                popHome = false;
                              }
                            } else {
                              // Navigator.pop(navigatorKey.currentContext!);
                              if (CustomNavigatorObserver().stackCount >= 2 &&
                                  splashLoaded) {
                                Navigator.pop(navigatorKey.currentContext!);
                              } else {
                                Navigator.popUntil(navigatorKey.currentContext!,
                                    (route) => route.isFirst);
                                Navigator.pushReplacementNamed(
                                    navigatorKey.currentContext!, Tabs.path);
                                /* Navigator.pushReplacement(
                                  navigatorKey.currentContext!,
                                  MaterialPageRoute(
                                      builder: (_) => const Tabs()),
                                );*/
                                popHome = false;
                              }
                            }
                          },
                        ),
                      if (showNotification)
                        LeadingNotification(showIndicator: true),
                      if (leadingFilterClick != null)
                        ActionButton(
                          icon: Images.marketFilter,
                          size: 22,
                          padding: EdgeInsets.all(8),
                          onTap: leadingFilterClick!,
                        ),
                    ],
                  ),
                  // Actions
                  Row(
                    children: [
                      if (showActionNotification)
                        LeadingNotification(showIndicator: true),
                      if (showSearch)
                        ActionButton(
                          icon: Images.search,
                          onTap: () {
                            Navigator.push(
                              context,
                              createRoute(
                                BaseSearch(
                                  stockClick: (p0) {
                                    if (p0.symbol == null || p0.symbol == '') {
                                      return;
                                    }
                                    Navigator.pushNamed(context, SDIndex.path,
                                        arguments: {
                                          'symbol': p0.symbol,
                                        });
                                  },
                                  newsClick: (data) {
                                    if (data.slug == null || data.slug == '') {
                                      return;
                                    }
                                    Navigator.pushNamed(
                                        context, NewsDetailIndex.path,
                                        arguments: {
                                          'slug': data.slug,
                                        });
                                  },
                                ),
                              ),
                            );
                          },
                        ),
                      if (shareURL != null)
                        Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: ActionButton(
                            size: 38,
                            icon: Images.shareURL,
                            onTap: shareURL!,
                          ),
                        ),
                      if (showFilter != null)
                        Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: ActionButton(
                            size: 19,
                            icon: Images.filter,
                            onTap: showFilter!,
                          ),
                        ),
                      if (onSaveClick != null)
                        SaveAction(onSaveClick: onSaveClick!),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(toolbarHeight);
}

class CenterLogo extends StatelessWidget {
  const CenterLogo({super.key, required this.isHome});

  final bool isHome;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: GestureDetector(
        onTap: () {
          if (isHome) return;
          Navigator.popUntil(
              navigatorKey.currentContext!, (route) => route.isFirst);
          Navigator.pushReplacementNamed(
            navigatorKey.currentContext!,
            Tabs.path,
          );
        },
        child: Container(
          width: MediaQuery.of(context).size.width * .40,
          constraints: BoxConstraints(maxHeight: kTextTabBarHeight - 2.sp),
          child: Container(
            margin: isPhone ? EdgeInsets.all(8.sp) : null,
            child: Image.asset(
              Images.mainBlackLogo,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}

class CenterTitle extends StatelessWidget {
  const CenterTitle({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Text(
        title,
        style: styleBaseBold(fontSize: 18),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.center,
      ),
    );
  }
}

class ActionButton extends StatelessWidget {
  const ActionButton({
    super.key,
    this.size = 32,
    required this.icon,
    required this.onTap,
    this.padding,
    this.color,
  });

  final String icon;
  final double size;
  final EdgeInsets? padding;
  final Color? color;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(Pad.pad999),
      onTap: onTap,
      child: Container(
        padding: padding ?? EdgeInsets.zero,
        child: Image.asset(
          icon,
          color: color ?? ThemeColors.black,
          width: size,
          height: size,
        ),
      ),
    );
  }
}

class LeadingNotification extends StatelessWidget {
  const LeadingNotification({
    super.key,
    this.showIndicator = false,
  });

  final bool showIndicator;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        InkWell(
          borderRadius: BorderRadius.circular(Pad.pad999),
          onTap: () {
            closeKeyboard();
            GlobalManager globalManager = context.read<GlobalManager>();
            globalManager.navigateToNotification();
          },
          child: Image.asset(
            Images.notification,
            color: ThemeColors.black,
            height: 35,
            width: 35,
          ),
        ),
        Visibility(
          visible: showIndicator,
          child: Positioned(
            right: 5.sp,
            top: 6.sp,
            child: Container(
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: ThemeColors.black,
                  border: Border.all(color: Colors.white, width: 1)),
              padding: EdgeInsets.all(0.7),
              child: const CircleAvatar(
                radius: 4,
                backgroundColor: ThemeColors.secondary100,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class SaveAction extends StatelessWidget {
  const SaveAction({super.key, required this.onSaveClick});

  final Function() onSaveClick;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(Pad.pad999),
      onTap: onSaveClick,
      child: Container(
        decoration: BoxDecoration(
          color: ThemeColors.primary100,
          borderRadius: BorderRadius.circular(8),
        ),
        padding: EdgeInsets.symmetric(horizontal: Pad.pad16, vertical: 8),
        child: Text(
          "Save",
          style: styleBaseBold(fontSize: 14, color: ThemeColors.black),
        ),
      ),
    );
  }
}
