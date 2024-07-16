import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/providers/home_provider.dart';
import 'package:stocks_news_new/providers/membership.dart';
import 'package:stocks_news_new/screens/tabs/tabs.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

import '../../../utils/colors.dart';

import '../../../widgets/theme_button.dart';

class SubscriptionPurchased extends StatefulWidget {
  final bool isMembership;
  const SubscriptionPurchased({
    super.key,
    this.isMembership = false,
  });

  @override
  State<SubscriptionPurchased> createState() => _SubscriptionPurchasedState();
}

class _SubscriptionPurchasedState extends State<SubscriptionPurchased> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomeProvider>().getHomeSlider();
    });
  }

  @override
  Widget build(BuildContext context) {
    MembershipProvider provider = context.watch<MembershipProvider>();
    return Container(
      constraints: BoxConstraints(maxHeight: ScreenUtil().screenHeight - 30),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10), topRight: Radius.circular(10)),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [ThemeColors.bottomsheetGradient, Colors.black],
        ),
        color: ThemeColors.background,
        border: Border(
          top: BorderSide(color: ThemeColors.greyBorder),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 6.sp,
              width: 50.sp,
              margin: EdgeInsets.only(top: 8.sp),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.sp),
                color: ThemeColors.greyBorder,
              ),
            ),
            Image.asset(
              Images.referSuccess,
              height: 250,
              width: 300,
            ),
            Text(
              provider.success?.title ?? "SUCCESS",
              textAlign: TextAlign.center,
              style: stylePTSansBold(fontSize: 35),
            ),
            const SpacerVertical(height: 20),
            Visibility(
              visible: widget.isMembership,
              child: Text(
                provider.success?.description ??
                    "Your membership purchase is successful. It may take 3-5 minutes to reflect.",
                textAlign: TextAlign.center,
                style: stylePTSansRegular(
                    fontSize: 20, color: ThemeColors.greyText),
              ),
            ),
            Visibility(
              visible: !widget.isMembership,
              child: Text(
                provider.success?.description ??
                    "Your points purchase is successful. It may take 3-5 minutes to reflect.",
                textAlign: TextAlign.center,
                style: stylePTSansRegular(
                    fontSize: 20, color: ThemeColors.greyText),
              ),
            ),
            const SpacerVertical(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                provider.success?.subTitle ??
                    "Explore Stocks.News without limits.",
                textAlign: TextAlign.center,
                style: stylePTSansRegular(
                    fontSize: 20, color: ThemeColors.greyText),
              ),
            ),
            const SpacerVertical(height: 70),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: ThemeButton(
                text: "GO TO HOME",
                onPressed: () {
                  // Navigator.pop(context);
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => const Tabs()),
                      (routes) => false);
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
