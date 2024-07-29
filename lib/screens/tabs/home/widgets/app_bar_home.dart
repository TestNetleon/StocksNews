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
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/utils/utils.dart';

class AppBarHome extends StatefulWidget implements PreferredSizeWidget {
  final bool isHome;
  final bool showTrailing, isPopback, showQR, canSearch, shareClick;
  final void Function()? filterClick;
  final void Function()? onTap;
//
  const AppBarHome({
    super.key,
    this.showTrailing = true,
    this.isPopback = false,
    this.showQR = false,
    this.filterClick,
    this.isHome = false,
    this.canSearch = false,
    this.shareClick = false,
    this.onTap,
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
      // Utils().showLog("App bar init called-------");
    });
  }

  @override
  Widget build(BuildContext context) {
    UserProvider provider = context.watch<UserProvider>();
    // String? image = provider.user?.image;
    // bool notificationSeen = provider.user?.notificationSeen == true;
    HomeProvider homeProvider = context.watch<HomeProvider>();
    // Utils().showLog("build updated for app bar showing Notification Seen? ${homeProvider.notificationSeen}");
    return AppBar(
      // backgroundColor: ThemeColors.background,
      backgroundColor: Colors.black,
      elevation: 0,
      automaticallyImplyLeading: false,
      leading: widget.isPopback
          ? IconButton(
              onPressed: widget.onTap ??
                  () {
                    if (popHome) {
                      if (CustomNavigatorObserver().stackCount >= 2 &&
                          splashLoaded) {
                        Navigator.pop(navigatorKey.currentContext!);
                      } else {
                        Navigator.popUntil(navigatorKey.currentContext!,
                            (route) => route.isFirst);
                        Navigator.pushReplacement(
                          navigatorKey.currentContext!,
                          MaterialPageRoute(builder: (_) => const Tabs()),
                        );
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
                        Navigator.pushReplacement(
                          navigatorKey.currentContext!,
                          MaterialPageRoute(builder: (_) => const Tabs()),
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
              // icon: Container(
              //   decoration: BoxDecoration(
              //     color:
              //         image == null || image == '' ? ThemeColors.accent : null,
              //     borderRadius: BorderRadius.circular(30.r),
              //   ),
              //   padding: image == null || image == ''
              //       ? EdgeInsets.all(3.sp)
              //       : EdgeInsets.all(0.9.sp),
              //   child: image == null || image == ''
              //       ? const Icon(Icons.person)
              //       : ClipRRect(
              //           borderRadius: BorderRadius.circular(30.r),
              //           child: CachedNetworkImagesWidget(image),
              //         ),
              // ),
              icon: Image.asset(
                Images.dotsMenu,
                color: ThemeColors.white,
                height: 18,
                width: 18,
              ),
            ),
      centerTitle: true,
      title: GestureDetector(
        onTap: widget.isHome
            ? null
            : () {
                // Navigator.pushReplacement(
                //   context,
                //   MaterialPageRoute(builder: (_) => const Tabs(index: 0)),
                // );

                Navigator.popUntil(navigatorKey.currentContext!, (route) {
                  return route.isFirst;
                });
                Navigator.pushReplacement(
                  navigatorKey.currentContext!,
                  MaterialPageRoute(builder: (_) => const Tabs()),
                );
              },
        child: Container(
          width: MediaQuery.of(context).size.width * .40,
          constraints: BoxConstraints(maxHeight: kTextTabBarHeight - 2.sp),
          child: Container(
            margin: isPhone ? EdgeInsets.all(8.sp) : null,
            child: Image.asset(
              Images.logo,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
      actions: [
        // IconButton(
        //   onPressed: () async {
        //     final value = await referSheet(onReferral: (_) {});
        //     if (value == null) {
        //       // Bottom sheet was dismissed by sliding down
        //       print('Bottom sheet was slid down');
        //     } else {
        //       // Bottom sheet was closed with a result
        //       print('Bottom sheet was closed with result: $value');
        //     }
        //   },
        //   icon: const Icon(
        //     Icons.temple_buddhist_outlined,
        //     color: ThemeColors.white,
        //   ),
        // ),
        // Visibility(
        //   visible: widget.showQR,
        //   child: IconButton(
        //     onPressed: () {
        //       Navigator.push(context, QrScan.path);
        //     },
        //     icon: const Icon(
        //       Icons.qr_code,
        //       color: ThemeColors.white,
        //     ),
        //   ),
        // ),
        // Visibility(
        //   visible: widget.filterClick != null,
        //   child: IconButton(
        //     onPressed: widget.filterClick,
        //     icon: const Icon(
        //       Icons.filter_alt,
        //       color: ThemeColors.white,
        //     ),
        //   ),
        // ),

        Visibility(
          visible: widget.shareClick,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: GestureDetector(
                  onTap: () {},
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: ThemeColors.greyBorder),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(8))),
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20),
                    child: Center(
                      child: Text(
                        "Share",
                        style: stylePTSansBold(fontSize: 12),
                      ),
                    ),
                  ),
                ),
              ),
            ],
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
        widget.showTrailing
            ? Stack(
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
                    visible:
                        !homeProvider.notificationSeen && provider.user != null,
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
            : const SizedBox(),
        // TODO MUST REMOVE IN LIVE BUILD
        // IconButton(
        //   onPressed: () {
        //     Navigator.push(
        //       navigatorKey.currentContext!,
        //       MaterialPageRoute(builder: (_) => const NavigationDemo()),
        //     );
        //   },
        //   icon: const Icon(
        //     Icons.navigation_outlined,
        //     color: ThemeColors.white,
        //   ),
        // ),
      ],
    );
  }
}
