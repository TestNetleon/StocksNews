import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/providers/home_provider.dart';
import 'package:stocks_news_new/route/my_app.dart';
import 'package:stocks_news_new/screens/auth/bottomSheets/login_sheet_tablet.dart';
import 'package:stocks_news_new/screens/auth/bottomSheets/refer/refer_code.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

import '../../modals/referral_res.dart';
import '../../providers/user_provider.dart';
import '../../screens/auth/bottomSheets/login_sheet.dart';
import '../../screens/drawer/about/refer_dialog.dart';
import '../../utils/constants.dart';

class ReferApp extends StatelessWidget {
  const ReferApp({super.key});
  Future _onShareAppClick() async {
    UserProvider provider = navigatorKey.currentContext!.read<UserProvider>();

    if (provider.user == null) {
      isPhone ? await loginSheet() : await loginSheetTablet();
    }
    
    if (provider.user == null) {
      return;
    }

    if (provider.user?.phone == null || provider.user?.phone == '') {
      await referLogin();
    } else {
      await _bottomSheet();
      // await referLogin();
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
        return const SingleChildScrollView(child: ReferDialog());
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
        // Share.share(
        //   "${referral?.shareText}${"\n\n"}${provider.user?.referralUrl}",
        // );
      },
      child: Ink(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          // color: ThemeColors.accent,
          gradient: const LinearGradient(
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
            colors: [
              ThemeColors.accent,
              Color.fromARGB(255, 10, 114, 24),
            ],
          ),
        ),
        child: Row(
          children: [
            Container(
              // padding: const EdgeInsets.all(8),
              // decoration: const BoxDecoration(
              //     shape: BoxShape.circle, color: Colors.transparent),
              // child: const Icon(
              //   Icons.share,
              //   color: ThemeColors.accent,
              // ),
              child: Image.asset(
                Images.coin,
                // Images.reward,
                // Images.flames,

                height: 40,
                width: 40,
              ),
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
                    style: stylePTSansRegular(fontSize: 12),
                  ),
                ],
              ),
            ),
            const SpacerHorizontal(width: 10),
            const Icon(Icons.arrow_forward_ios_rounded),
          ],
        ),
      ),
    );
  }
}
