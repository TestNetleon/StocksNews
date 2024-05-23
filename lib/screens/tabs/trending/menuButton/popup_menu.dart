// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stocks_news_new/providers/user_provider.dart';
import 'package:stocks_news_new/screens/auth/bottomSheets/login_sheet.dart';
import 'package:stocks_news_new/screens/auth/bottomSheets/login_sheet_tablet.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';

import 'package:provider/provider.dart';

class PopUpMenuButtonCommon extends StatelessWidget {
  final String symbol;
  final String alertString;
  final String watchlistString;
//
  final Function() onClickAlert, onClickWatchlist;
  const PopUpMenuButtonCommon({
    super.key,
    required this.symbol,
    required this.onClickAlert,
    required this.onClickWatchlist,
    required this.alertString,
    required this.watchlistString,
  });

  @override
  Widget build(BuildContext context) {
    UserProvider provider = context.watch<UserProvider>();

    return PopupMenuButton<AddType>(
      constraints: BoxConstraints.loose(Size(200.sp, 170.sp)),
      iconSize: !isPhone ? 16.sp : 20.sp,
      position: PopupMenuPosition.under,
      icon: const Icon(Icons.more_vert_rounded),
      color: ThemeColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.sp),
        // side: const BorderSide(color: ThemeColors.border),
      ),
      itemBuilder: (BuildContext context) => <PopupMenuEntry<AddType>>[
        PopupMenuItem<AddType>(
          onTap: provider.user == null
              ? () async {
                  // await Navigator.push(
                  //   context,
                  //   createRoute(const Login()),
                  // );

                  isPhone ? await loginSheet() : await loginSheetTablet();

                  if (context.read<UserProvider>().user == null) {
                    return;
                  }
                  onClickAlert();
                }
              : () => onClickAlert(),
          value: AddType.alert,
          child: Row(
            children: [
              Icon(
                Icons.add_alert_outlined,
                size: !isPhone ? 18 : 16,
                color: ThemeColors.background,
              ),
              const SpacerHorizontal(width: 2),
              Text(
                alertString,
                style: stylePTSansBold(
                  fontSize: 14,
                  color: ThemeColors.background,
                ),
              ),
              Visibility(
                visible: alertString == "Alert Added",
                child: Padding(
                  padding: EdgeInsets.only(left: 2.sp),
                  child: Icon(
                    Icons.check,
                    size: !isPhone ? 18 : 16,
                    color: ThemeColors.accent,
                  ),
                ),
              ),
            ],
          ),
        ),
        const PopupMenuDivider(height: 0),
        PopupMenuItem<AddType>(
          onTap: provider.user == null
              // ? () => _login(context)
              ? () async {
                  // await Navigator.push(
                  //   context,
                  //   createRoute(const Login()),
                  // );
                  isPhone ? await loginSheet() : await loginSheetTablet();

                  if (context.read<UserProvider>().user == null) {
                    return;
                  }
                  onClickWatchlist();
                }
              : () => onClickWatchlist(),
          value: AddType.watchlist,
          child: Row(
            children: [
              Icon(
                Icons.star_border,
                size: !isPhone ? 18 : 16,
                color: ThemeColors.background,
              ),
              const SpacerHorizontal(width: 2),
              Text(
                watchlistString,
                style: stylePTSansBold(
                    fontSize: 14, color: ThemeColors.background),
              ),
              Visibility(
                visible: watchlistString == "Watchlist Added",
                child: Padding(
                  padding: EdgeInsets.only(left: 2.sp),
                  child: Icon(
                    Icons.check,
                    size: !isPhone ? 18 : 16,
                    color: ThemeColors.accent,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
