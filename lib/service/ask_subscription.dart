import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import 'package:stocks_news_new/widgets/theme_button.dart';
import '../api/api_response.dart';
import '../route/my_app.dart';
import '../screens/affiliate/referFriend/howit_work.dart';
import '../utils/colors.dart';

Future askToSubscribe({void Function()? onPressed}) async {
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
          Padding(
            padding: const EdgeInsets.only(top: 50),
            child: SingleChildScrollView(
                child: AskToSubscribeDialog(
              onPressed: onPressed,
            )),
          ),
          Image.asset(
            Images.diamondS,
            height: 100,
            width: 100,
            fit: BoxFit.cover,
          ),
        ],
      );
    },
  );
}

class AskToSubscribeDialog extends StatelessWidget {
  final Function()? onPressed;
  const AskToSubscribeDialog({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    // UserProvider userProvider = context.read<UserProvider>();

    return Container(
      // padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
        gradient: const LinearGradient(
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
          colors: [
            Color.fromARGB(255, 3, 91, 14),
            Color.fromARGB(255, 0, 55, 7),
          ],
        ),
      ),
      child: Stack(
        children: [
          Image.asset(
            Images.referBack,
            color: const Color.fromARGB(150, 81, 81, 81),
            fit: BoxFit.cover,
            height: 500,
          ),
          // const Align(
          //   alignment: Alignment.center,
          //   child: Padding(
          //     padding: EdgeInsets.only(top: 7),
          //     child: BottomSheetTick(),
          //   ),
          // ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 70, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ClipRRect(
                //   borderRadius: BorderRadius.circular(6),
                //   child: Image.asset(
                //     Images.stockIcon3d,
                //     width: 100,
                //     height: 100,
                //   ),
                // ),
                // const SpacerVertical(height: 20),
                // const SpacerVertical(height: 15),
                Text(
                  "Get More with Membership!",
                  style: stylePTSansBold(fontSize: 30),
                  textAlign: TextAlign.start,
                ),
                const SpacerVertical(height: 5),
                Text(
                  "This feature is exclusive to premium members. Please create an account before purchasing a membership.",
                  style: stylePTSansRegular(fontSize: 17),
                  textAlign: TextAlign.start,
                ),

                const SpacerVertical(height: 30),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ScreenTitle(
                    //   title: "PURCHASE",
                    // ),
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.only(top: 10, bottom: 10),
                      itemBuilder: (context, index) {
                        StepRes? data;
                        if (index == 0) {
                          data = StepRes(
                              title: "Add Stocks to Alerts and Watchlist",
                              subTitle:
                                  "Stay informed about your favorite stocks with real-time alerts and a personalized watchlist.");
                        }
                        if (index == 1) {
                          data = StepRes(
                              title: "Access Market Data",
                              subTitle:
                                  "Get up-to-the-minute market data to make informed investment decisions.");
                        }

                        if (index == 2) {
                          data = StepRes(
                              title:
                                  "Connect Brokerage Account and Sync Portfolio",
                              subTitle:
                                  "Seamlessly integrate your brokerage account and keep your portfolio up to date.");
                        }

                        return HowItWorkItem(
                          index: index,
                          subtitle: Colors.white,
                          data: data,
                          icon: index == 0
                              ? Image.asset(
                                  Images.bellS,
                                  height: 25,
                                  width: 25,
                                )
                              : index == 1
                                  ? Image.asset(
                                      Images.reportS,
                                      height: 25,
                                      width: 25,
                                    )
                                  : Image.asset(
                                      Images.tickS,
                                      height: 25,
                                      width: 25,
                                    ),
                        );
                      },
                      separatorBuilder: (context, index) {
                        return const Divider(
                          color: ThemeColors.greyBorder,
                          height: 40,
                        );
                      },
                      itemCount: 3,
                    ),
                  ],
                ),
                const SpacerVertical(height: 10),
                ThemeButton(
                  color: const Color.fromARGB(255, 7, 127, 23),
                  // text: "Generate Affiliate Link",
                  // text: "Upgrade your membership",
                  text: "Get a Membership",
                  onPressed: onPressed,
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
