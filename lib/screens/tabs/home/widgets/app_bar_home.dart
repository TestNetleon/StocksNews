import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/providers/search_provider.dart';
import 'package:stocks_news_new/screens/auth/qrScan/index.dart';
import 'package:stocks_news_new/screens/notifications/index.dart';
import 'package:stocks_news_new/screens/search/search.dart';
import 'package:stocks_news_new/screens/tabs/tabs.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/utils.dart';

class AppBarHome extends StatelessWidget implements PreferredSizeWidget {
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
  Widget build(BuildContext context) {
    return AppBar(
      // backgroundColor: ThemeColors.lightRed,
      backgroundColor: ThemeColors.background,
      automaticallyImplyLeading: false,
      leading: isPopback
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
                  color: ThemeColors.accent,
                  borderRadius: BorderRadius.circular(30.r),
                ),
                padding: EdgeInsets.all(3.sp),
                child: const Icon(Icons.person),
              ),
            ),
      centerTitle: true,
      title: GestureDetector(
        onTap: isHome
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
        Visibility(
          visible: showQR,
          child: IconButton(
            onPressed: () {
              Navigator.pushNamed(context, QrScan.path);
            },
            icon: const Icon(
              Icons.qr_code,
              color: ThemeColors.white,
            ),
          ),
        ),
        Visibility(
          visible: filterClick != null,
          child: IconButton(
            onPressed: filterClick,
            icon: const Icon(
              Icons.filter_alt,
              color: ThemeColors.white,
            ),
          ),
        ),
        Visibility(
          visible: canSearch,
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
        if (showTrailing)
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, Notifications.path);
            },
            icon: const Icon(
              Icons.add_alert,
              color: ThemeColors.white,
            ),
          )
        else
          SizedBox(width: 20.sp),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
