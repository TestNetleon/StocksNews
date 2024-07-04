import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stocks_news_new/screens/auth/refer/refer_code.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import 'package:stocks_news_new/widgets/theme_button.dart';
import '../../../widgets/screen_title.dart';
import '../route/my_app.dart';

Future askToSubscribe() async {
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
            child: SingleChildScrollView(child: AskToSubscribeDialog()),
          ),
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

class AskToSubscribeDialog extends StatelessWidget {
  const AskToSubscribeDialog({super.key});

  @override
  Widget build(BuildContext context) {
    // HomeProvider provider = context.read<HomeProvider>();
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
            Color.fromARGB(255, 103, 98, 1),
            Color.fromARGB(255, 174, 172, 0),
          ],
        ),
      ),
      child: Stack(
        children: [
          Image.asset(
            Images.referBack,
            color: const Color.fromARGB(150, 81, 81, 81),
            fit: BoxFit.cover,
            height: 550,
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
                  "provider.extra?.referral?.message",
                  style: styleGeorgiaRegular(),
                  textAlign: TextAlign.center,
                ),
                const SpacerVertical(height: 15),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ScreenTitle(
                      title: " provider.extra?.howItWork?.title",
                    ),
                    // ListView.separated(
                    //   shrinkWrap: true,
                    //   physics: const NeverScrollableScrollPhysics(),
                    //   padding: const EdgeInsets.only(top: 10, bottom: 10),
                    //   itemBuilder: (context, index) {
                    //     StepRes? data =
                    //         provider.extra?.howItWork?.steps?[index];
                    //     return HowItWorkItem(
                    //       index: index,
                    //       subtitle: Colors.white,
                    //       data: data,
                    //     );
                    //   },
                    //   separatorBuilder: (context, index) {
                    //     return const Divider(
                    //       color: ThemeColors.greyBorder,
                    //       height: 40,
                    //     );
                    //   },
                    //   itemCount: provider.extra?.howItWork?.steps?.length ?? 0,
                    // ),
                  ],
                ),
                const SpacerVertical(height: 10),
                ThemeButton(
                  color: const Color.fromARGB(255, 7, 127, 23),
                  // text: "Generate Affiliate Link",
                  text: "GENERATE AFFILIATE LINK",
                  onPressed: () {
                    Navigator.pop(context);
                    referLogin();
                  },
                ),

                SpacerVertical(height: ScreenUtil().bottomBarHeight),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
