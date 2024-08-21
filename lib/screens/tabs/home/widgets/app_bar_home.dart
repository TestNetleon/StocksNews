import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/providers/home_provider.dart';
import 'package:stocks_news_new/providers/search_provider.dart';
import 'package:stocks_news_new/providers/user_provider.dart';
import 'package:stocks_news_new/route/my_app.dart';
import 'package:stocks_news_new/route/navigation_observer.dart';
import 'package:stocks_news_new/screens/notifications/index.dart';
import 'package:stocks_news_new/screens/search/search.dart';
import 'package:stocks_news_new/screens/tabs/tabs.dart';
import 'package:stocks_news_new/tradingSimulator/screens/portfolio/index.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/utils/utils.dart';
import 'package:stocks_news_new/widgets/cache_network_image.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:svg_flutter/svg_flutter.dart';

class AppBarHome extends StatefulWidget implements PreferredSizeWidget {
  final bool isHome;
  final bool showTrailing, isPopback, canSearch, showPortfolio, showTitleLogo;
  final void Function()? onFilterClick;
  final void Function()? onTap;
  final String? title;
  final String? subTitle;
  final Widget? widget;
//
  const AppBarHome({
    super.key,
    this.showTrailing = true,
    this.isPopback = false,
    this.onFilterClick,
    this.isHome = false,
    this.canSearch = true,
    this.showPortfolio = false,
    this.showTitleLogo = true,
    this.onTap,
    this.title,
    this.subTitle,
    this.widget,
  });

  @override
  State<AppBarHome> createState() => _AppBarHomeState();
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _AppBarHomeState extends State<AppBarHome> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      // _isSVG();
    });
  }

  @override
  Widget build(BuildContext context) {
    UserProvider provider = context.watch<UserProvider>();
    HomeProvider homeProvider = context.watch<HomeProvider>();

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Stack(
          alignment: Alignment.center,
          children: [
            if ((widget.title == null && widget.widget == null) ||
                widget.isHome)
              GestureDetector(
                onTap: widget.isHome
                    ? null
                    : () {
                        // Navigator.pushReplacement(
                        //   context,
                        //   MaterialPageRoute(builder: (_) => const Tabs(index: 0)),
                        // );
                        Navigator.popUntil(navigatorKey.currentContext!,
                            (route) => route.isFirst);
                        Navigator.pushReplacement(
                          navigatorKey.currentContext!,
                          MaterialPageRoute(builder: (_) => const Tabs()),
                        );
                      },
                child: Container(
                  width: MediaQuery.of(context).size.width * .40,
                  constraints:
                      BoxConstraints(maxHeight: kTextTabBarHeight - 2.sp),
                  child: Container(
                    margin: isPhone ? EdgeInsets.all(8.sp) : null,
                    child: Image.asset(
                      Images.logo,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                // Leading
                widget.isPopback
                    ? IconButton(
                        onPressed: widget.onTap ??
                            () {
                              if (popHome) {
                                if (CustomNavigatorObserver().stackCount >= 2 &&
                                    splashLoaded) {
                                  Navigator.pop(navigatorKey.currentContext!);
                                } else {
                                  Navigator.popUntil(
                                      navigatorKey.currentContext!,
                                      (route) => route.isFirst);
                                  Navigator.pushReplacement(
                                    navigatorKey.currentContext!,
                                    MaterialPageRoute(
                                        builder: (_) => const Tabs()),
                                  );
                                  popHome = false;
                                }
                              } else {
                                // Navigator.pop(navigatorKey.currentContext!);
                                if (CustomNavigatorObserver().stackCount >= 2 &&
                                    splashLoaded) {
                                  Navigator.pop(navigatorKey.currentContext!);
                                } else {
                                  Navigator.popUntil(
                                      navigatorKey.currentContext!,
                                      (route) => route.isFirst);
                                  Navigator.pushReplacement(
                                    navigatorKey.currentContext!,
                                    MaterialPageRoute(
                                        builder: (_) => const Tabs()),
                                  );
                                  popHome = false;
                                }
                              }
                            },
                        icon: const Icon(
                          Icons.arrow_back_ios,
                          color: ThemeColors.white,
                        ),
                      )
                    : IconButton(
                        onPressed: () {
                          closeKeyboard();
                          context.read<SearchProvider>().clearSearch();
                          Scaffold.of(context).openDrawer();
                        },
                        icon: ClipRRect(
                          borderRadius: BorderRadius.circular(90),
                          child: isSVG
                              ? SvgPicture.network(
                                  fit: BoxFit.cover,
                                  height: 24,
                                  width: 24,
                                  provider.user?.image ?? "",
                                  placeholderBuilder: (BuildContext context) =>
                                      Container(
                                    padding: const EdgeInsets.all(30.0),
                                    child: const CircularProgressIndicator(
                                      color: ThemeColors.accent,
                                    ),
                                  ),
                                )
                              : CachedNetworkImagesWidget(
                                  provider.user?.image,
                                  height: 24,
                                  width: 24,
                                  showLoading: true,
                                  placeHolder: Images.userPlaceholder,
                                ),
                        ),
                        // icon: ProfileImage(
                        //   url: provider.user?.image,
                        //   showCameraIcon: false,
                        //   imageSize: 24,
                        //   roundImage: true,
                        // ),
                        // Image.asset(
                        //   Images.dotsMenu,
                        //   color: ThemeColors.white,
                        //   height: 18,
                        //   width: 18,
                        // ),
                      ),
                // Title
                Expanded(
                  child: Visibility(
                    visible: widget.title != null || widget.widget != null,
                    child: widget.widget ??
                        Row(
                          children: [
                            Image.asset(Images.k, width: 24, height: 24),
                            SpacerHorizontal(width: 8),
                            Flexible(
                              child: Text(
                                "${widget.title}",
                                style: stylePTSansBold(fontSize: 18),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                  ),
                ),
                // Actions
                Row(
                  children: [
                    Visibility(
                      visible: widget.onFilterClick != null,
                      child: IconButton(
                        onPressed: widget.onFilterClick,
                        icon: const Icon(
                          Icons.filter_alt,
                          color: ThemeColors.accent,
                        ),
                      ),
                    ),
                    Visibility(
                      visible: widget.canSearch,
                      child: IconButton(
                        onPressed: () {
                          Navigator.push(
                            navigatorKey.currentContext!,
                            MaterialPageRoute(builder: (_) => const Search()),
                          );
                        },
                        icon: const Icon(
                          Icons.search,
                          color: ThemeColors.white,
                        ),
                      ),
                    ),
                    Visibility(
                      visible: widget.showPortfolio,
                      child: IconButton(
                        onPressed: () {
                          Navigator.push(
                            navigatorKey.currentContext!,
                            MaterialPageRoute(
                              builder: (_) => const TsPortfolio(),
                            ),
                          );
                        },
                        icon: const Icon(
                          Icons.person,
                          color: ThemeColors.white,
                        ),
                      ),
                    ),
                    if (widget.showTrailing)
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          IconButton(
                            onPressed: () {
                              if (provider.user != null) {
                                homeProvider.setNotification(true);
                              }
                              Navigator.push(
                                navigatorKey.currentContext!,
                                MaterialPageRoute(
                                  builder: (_) => const Notifications(),
                                ),
                              );
                            },
                            icon: const Icon(
                              Icons.notifications,
                              color: ThemeColors.white,
                            ),
                          ),
                          Visibility(
                            visible: !homeProvider.notificationSeen &&
                                provider.user != null,
                            child: Positioned(
                              right: 13.sp,
                              top: 14.sp,
                              child: const CircleAvatar(
                                radius: 4,
                                backgroundColor: ThemeColors.sos,
                              ),
                            ),
                          ),
                        ],
                      )
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
