import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/providers/home_provider.dart';
import 'package:stocks_news_new/providers/user_provider.dart';
import 'package:stocks_news_new/routes/my_app.dart';
import 'package:stocks_news_new/routes/navigation_observer.dart';
import 'package:stocks_news_new/screens/notifications/index.dart';
import 'package:stocks_news_new/stocksScanner/providers/market_scanner_provider.dart';
import 'package:stocks_news_new/tradingSimulator/screens/portfolio/index.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/utils/utils.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import '../../../../ui/tabs/tabs.dart';

class BaseAppBar extends StatefulWidget implements PreferredSizeWidget {
  final bool isHome;
  final bool showNotification,
      isPopBack,
      canSearch,
      showPortfolio,
      showTitleLogo;
  final bool isScannerFilter;
  final void Function()? onFilterClick;
  final void Function()? onTap;
  final String? title;
  final String? subTitle;
  final Widget? widget;
  final IconData? icon;
//
  const BaseAppBar({
    super.key,
    this.icon,
    this.showNotification = true,
    this.isPopBack = false,
    this.onFilterClick,
    this.isHome = false,
    this.canSearch = true,
    this.showPortfolio = false,
    this.showTitleLogo = true,
    this.isScannerFilter = false,
    this.onTap,
    this.title,
    this.subTitle,
    this.widget,
  });

  @override
  State<BaseAppBar> createState() => _BaseAppBarState();
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _BaseAppBarState extends State<BaseAppBar> {
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
                      Images.mainBlackLogo,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                // Leading
                widget.isPopBack
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
                        icon: Icon(
                          widget.icon ?? Icons.arrow_back_ios,
                          color: ThemeColors.black,
                        ),
                      )
                    : widget.showNotification
                        ? Container(
                            padding: const EdgeInsets.only(left: 16),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                InkWell(
                                  borderRadius:
                                      BorderRadius.circular(Pad.pad999),
                                  onTap: () {
                                    closeKeyboard();

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
                                  child: Image.asset(
                                    Images.notification,
                                    color: ThemeColors.black,
                                    height: 35,
                                    width: 35,
                                  ),
                                ),
                                Visibility(
                                  visible: !homeProvider.notificationSeen &&
                                      provider.user != null,
                                  child: Positioned(
                                    right: 8.sp,
                                    top: 8.sp,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: ThemeColors.black,
                                      ),
                                      padding: EdgeInsets.all(0.7),
                                      child: const CircleAvatar(
                                        radius: 4,
                                        backgroundColor: ThemeColors.sos,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : SizedBox(),
                // IconButton(
                //     onPressed: () {
                //       closeKeyboard();
                //       context.read<SearchProvider>().clearSearch();
                //       Scaffold.of(context).openDrawer();
                //     },
                //     icon: ClipRRect(
                //       borderRadius: BorderRadius.circular(90),
                //       child: isSVG
                //           ? SvgPicture.network(
                //               fit: BoxFit.cover,
                //               height: 24,
                //               width: 24,
                //               provider.user?.image ?? "",
                //               placeholderBuilder: (BuildContext context) =>
                //                   Container(
                //                 padding: const EdgeInsets.all(30.0),
                //                 child: const CircularProgressIndicator(
                //                   color: ThemeColors.accent,
                //                 ),
                //               ),
                //             )
                //           : CachedNetworkImagesWidget(
                //               provider.user?.image,
                //               height: 24,
                //               width: 24,
                //               showLoading: true,
                //               placeHolder: Images.userPlaceholder,
                //             ),
                //     ),
                //     // icon: ProfileImage(
                //     //   url: provider.user?.image,
                //     //   showCameraIcon: false,
                //     //   imageSize: 24,
                //     //   roundImage: true,
                //     // ),
                //     // Image.asset(
                //     //   Images.dotsMenu,
                //     //   color: ThemeColors.white,
                //     //   height: 18,
                //     //   width: 18,
                //     // ),
                //   ),

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
                    if (!widget.isScannerFilter)
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

                    if (widget.isScannerFilter)
                      Consumer<MarketScannerProvider>(
                          builder: (context, value, child) {
                        return Visibility(
                          visible:
                              widget.onFilterClick != null && value.visible,
                          child: Stack(
                            children: [
                              IconButton(
                                onPressed: widget.onFilterClick,
                                icon: const Icon(
                                  Icons.filter_alt,
                                  color: ThemeColors.accent,
                                ),
                              ),
                              Positioned(
                                right: 24,
                                top: 14,
                                child: Container(
                                  width: 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }),

                    // Visibility(
                    //   visible: widget.onFilterClick != null,
                    //   child: IconButton(
                    //     onPressed: widget.onFilterClick,
                    //     icon: const Icon(
                    //       Icons.filter_alt,
                    //       color: ThemeColors.accent,
                    //     ),
                    //   ),
                    // ),

                    Visibility(
                      visible: widget.canSearch,
                      child: Container(
                        padding: EdgeInsets.only(right: Pad.pad16),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(Pad.pad999),
                          onTap: () {
                            closeKeyboard();

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
                          child: Image.asset(
                            Images.search,
                            color: ThemeColors.black,
                            height: 32,
                            width: 32,
                          ),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: widget.showPortfolio,
                      child: IconButton(
                        onPressed: () {
                          Navigator.push(
                            navigatorKey.currentContext!,
                            createRoute(TsPortfolio()),
                          );
                        },
                        icon: const Icon(
                          Icons.person,
                          color: ThemeColors.black,
                        ),
                      ),
                    ),
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
