import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/providers/home_provider.dart';
import 'package:stocks_news_new/route/my_app.dart';
import 'package:stocks_news_new/screens/auth/login/login_sheet.dart';
import 'package:stocks_news_new/screens/auth/login/login_sheet_tablet.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

import '../../modals/referral_res.dart';
import '../../providers/user_provider.dart';
import '../../screens/affiliate/index.dart';
import '../../screens/drawer/about/refer_dialog.dart';
import '../../utils/constants.dart';

class ReferApp extends StatelessWidget {
  const ReferApp({super.key});
  Future _onShareAppClick() async {
    UserProvider provider = navigatorKey.currentContext!.read<UserProvider>();

    if (provider.user == null) {
      isPhone ? await loginSheet() : await loginSheetTablet();
    }

    log("NOW SHOWING SHEET => ${provider.user?.signupStatus}");

    if (provider.user?.signupStatus ?? false) {
      // This condition is only to stop sheet in sign up condition
      // because signup success will be open here and we want to
      // avoid double bottomsheet
      return;
    }

    if (provider.user == null) {
      return;
    }

    if (provider.user?.affiliateStatus != 1) {
      await _bottomSheet();
    } else {
      await Navigator.push(
        navigatorKey.currentContext!,
        MaterialPageRoute(builder: (_) => const ReferAFriend()),
      );
    }
  }

  Future _bottomSheet() async {
    await showModalBottomSheet(
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
        // side: const BorderSide(color: ThemeColors.greyBorder),
      ),
      context: navigatorKey.currentContext!,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      enableDrag: true,
      barrierColor: Colors.transparent,
      builder: (BuildContext ctx) {
        return Stack(
          alignment: Alignment.topCenter,
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 30),
              child: SingleChildScrollView(child: ReferDialog()),
            ),
            // Container(
            //   width: 50,
            //   height: 50,
            //   color: Colors.amber,
            // ),
            // Image.asset(
            //   Images.apple,
            //   height: 60,
            //   width: 60,
            // ),
            Image.asset(
              Images.kingGIF,
              height: 70,
              width: 100,
              fit: BoxFit.cover,
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // UserProvider provider = context.read<UserProvider>();
    ReferralRes? referral = context.watch<HomeProvider>().extra?.referral;
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: () {
        _onShareAppClick();

        // Navigator.push(
        //   navigatorKey.currentContext!,
        //   MaterialPageRoute(
        //     builder: (context) => const ReferSuccess(),
        //   ),
        // );
        // Share.share(
        //   "${referral?.shareText}${"\n\n"}${provider.user?.referralUrl}",
        // );
      },
      child: Ink(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          // color: ThemeColors.accent,
          // gradient: const LinearGradient(
          //   begin: Alignment.bottomLeft,
          //   end: Alignment.topRight,
          //   colors: [
          //     Colors.black,
          //     ThemeColors.accent,
          //     // Color.fromARGB(255, 10, 114, 24),
          //   ],.
          // ),
          gradient: const RadialGradient(
            center: Alignment.bottomCenter,
            radius: 2,
            stops: [0.0, 0.6],
            colors: [
              Color.fromARGB(255, 0, 93, 12),
              Color.fromARGB(255, 6, 41, 1),
            ],
          ),
          // gradient: const RadialGradient(
          //   center: Alignment.bottomCenter,
          //   radius: 3,
          //   stops: [0.0, 0.2, 1.0],
          //   colors: [
          //     Color.fromARGB(255, 20, 156, 10),
          //     Color.fromARGB(255, 0, 93, 12),
          //     Color.fromARGB(255, 4, 34, 0),
          //   ],
          // ),
        ),
        child: Row(
          children: [
            Image.asset(
              Images.pointIcon,
              // Images.reward,
              // Images.flames,

              height: 60,
              width: 60,
            ),
            const SpacerHorizontal(width: 10),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Text(
                  //   referral?.title ?? "Refer and Earn",
                  //   style: stylePTSansBold(fontSize: 18),
                  // ),
                  Text(
                    referral?.title ?? "",
                    style: stylePTSansBold(fontSize: 18),
                  ),
                  const SpacerVertical(height: 3),
                  Text(
                    referral?.message ?? "",
                    style: stylePTSansRegular(fontSize: 14, height: 1.4),
                  ),
                ],
              ),
            ),
            // const SpacerHorizontal(width: 10),
            // const Icon(Icons.arrow_forward_ios_rounded),
          ],
        ),
      ),
    );
  }
}
