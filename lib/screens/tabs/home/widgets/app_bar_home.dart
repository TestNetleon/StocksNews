import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/providers/home_provider.dart';
import 'package:stocks_news_new/providers/search_provider.dart';
import 'package:stocks_news_new/providers/user_provider.dart';
import 'package:stocks_news_new/screens/notifications/index.dart';
import 'package:stocks_news_new/screens/search/search.dart';
import 'package:stocks_news_new/screens/tabs/tabs.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/utils.dart';
import 'package:stocks_news_new/widgets/cache_network_image.dart';

class AppBarHome extends StatefulWidget implements PreferredSizeWidget {
  final bool isHome;
  final bool showTrailing, isPopback, showQR, canSearch;
  final void Function()? filterClick;
//
  const AppBarHome({
    super.key,
    this.showTrailing = true,
    this.isPopback = false,
    this.showQR = false,
    this.filterClick,
    this.isHome = false,
    this.canSearch = false,
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
      // log("App bar init called-------");
    });
  }

  @override
  Widget build(BuildContext context) {
    UserProvider provider = context.watch<UserProvider>();
    String? image = provider.user?.image;
    // bool notificationSeen = provider.user?.notificationSeen == true;
    HomeProvider homeProvider = context.watch<HomeProvider>();
    // log("build updated for app bar showing Notification Seen? ${homeProvider.notificationSeen}");
    return AppBar(
      // backgroundColor: ThemeColors.background,
      backgroundColor: Colors.black,

      elevation: 0,
      automaticallyImplyLeading: false,
      leading: widget.isPopback
          ? IconButton(
              onPressed: () {
                context.read<SearchProvider>().clearSearch();
                Navigator.pop(context);
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
              icon: Container(
                decoration: BoxDecoration(
                  color:
                      image == null || image == '' ? ThemeColors.accent : null,
                  borderRadius: BorderRadius.circular(30.r),
                ),
                padding: image == null || image == ''
                    ? EdgeInsets.all(3.sp)
                    : EdgeInsets.all(0.9.sp),
                child: image == null || image == ''
                    ? const Icon(Icons.person)
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(30.r),
                        child: CachedNetworkImagesWidget(image),
                      ),
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

                Navigator.pushNamedAndRemoveUntil(
                    context, Tabs.path, (route) => false);
              },
        child: Container(
          width: MediaQuery.of(context).size.width * .45,
          constraints: BoxConstraints(maxHeight: kTextTabBarHeight - 2.sp),
          child: Image.asset(
            Images.logo,
            fit: BoxFit.contain,
          ),
        ),
      ),
      actions: [
        // Visibility(
        //   visible: widget.showQR,
        //   child: IconButton(
        //     onPressed: () {
        //       Navigator.pushNamed(context, QrScan.path);
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
          visible: widget.canSearch,
          child: IconButton(
            onPressed: () {
              Navigator.pushNamed(context, Search.path);
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
                      Navigator.pushNamed(context, Notifications.path);
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
                      child: CircleAvatar(
                        radius: 4.sp,
                        backgroundColor: ThemeColors.sos,
                      ),
                    ),
                  ),
                ],
              )
            : const SizedBox(),
      ],
    );
  }
}
