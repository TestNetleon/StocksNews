import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/providers/home_provider.dart';
import 'package:stocks_news_new/screens/auth/bottomSheets/refer/refer_code.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import 'package:stocks_news_new/widgets/theme_button_small.dart';
import '../../../api/api_response.dart';
import '../../../widgets/screen_title.dart';
import '../../affiliate/referFriend/howit_work.dart';

class ReferDialog extends StatelessWidget {
  const ReferDialog({super.key});

  @override
  Widget build(BuildContext context) {
    HomeProvider provider = context.read<HomeProvider>();
    // UserProvider userProvider = context.read<UserProvider>();

    return Container(
      // padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color.fromARGB(255, 0, 93, 12),
            Colors.black,
          ],
        ),
      ),
      child: Stack(
        children: [
          Image.asset(
            Images.referBack,
            color: const Color.fromARGB(150, 81, 81, 81),
            fit: BoxFit.cover,
            height: 290,
          ),
          // const Align(
          //   alignment: Alignment.center,
          //   child: Padding(
          //     padding: EdgeInsets.only(top: 7),
          //     child: BottomSheetTick(),
          //   ),
          // ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 30, 16, 16),
            child: Column(
              // crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: Image.asset(
                    Images.stockIcon3d,
                    width: 100,
                    height: 100,
                  ),
                ),
                // const SpacerVertical(height: 20),
                const SpacerVertical(height: 15),
                Text(
                  provider.extra?.referral?.message ?? "",
                  style: styleGeorgiaRegular(),
                  textAlign: TextAlign.center,
                ),
                const SpacerVertical(height: 15),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ScreenTitle(
                      title: provider.extra?.howItWork?.title ?? "",
                    ),
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.only(top: 10, bottom: 10),
                      itemBuilder: (context, index) {
                        StepRes? data =
                            provider.extra?.howItWork?.steps?[index];
                        return HowItWorkItem(
                          index: index,
                          subtitle: Colors.white,
                          data: data,
                        );
                      },
                      separatorBuilder: (context, index) {
                        return const Divider(
                          color: ThemeColors.greyBorder,
                          height: 40,
                        );
                      },
                      itemCount: provider.extra?.howItWork?.steps?.length ?? 0,
                    ),
                  ],
                ),
                const SpacerVertical(height: 10),
                ThemeButtonSmall(
                  color: const Color.fromARGB(255, 7, 127, 23),
                  text: "Generate Affiliate Link",
                  onPressed: () {
                    Navigator.pop(context);
                    referLogin();
                  },
                ),
                // Text(
                //   provider.extra?.referral?.title ?? "Refer and Earn",
                //   style: styleGeorgiaBold(fontSize: 20),
                //   textAlign: TextAlign.center,
                // ),
                // const SpacerVertical(height: 10),
                // Text(
                //   provider.extra?.referral?.message ?? "",
                //   style: styleGeorgiaRegular(),
                //   textAlign: TextAlign.center,
                // ),
                // const SpacerVertical(height: 15),
                // GestureDetector(
                //   onTap: () {
                //     Navigator.pop(context);
                //     // Share.share(
                //     //   "${provider.extra?.referral?.shareText}${"\n\n"}${userProvider.user?.referralUrl}",
                //     // );
                //     DynamicLinkService.instance.createDynamicLink(
                //       userProvider.user?.referralCode,
                //     );
                //   },
                //   child: Container(
                //     decoration: BoxDecoration(
                //       borderRadius: BorderRadius.circular(4),
                //       color: ThemeColors.gradientLight,
                //     ),
                //     padding: const EdgeInsets.symmetric(
                //       horizontal: 20,
                //       vertical: 10,
                //     ),
                //     child: Row(
                //       mainAxisSize: MainAxisSize.min,
                //       children: [
                //         Text("Refer Now", style: styleGeorgiaBold()),
                //         const SpacerHorizontal(width: 5),
                //         const Icon(Icons.share, size: 20),
                //       ],
                //     ),
                //   ),
                // ),
                SpacerVertical(height: ScreenUtil().bottomBarHeight),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
