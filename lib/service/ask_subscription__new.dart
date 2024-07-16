import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/modals/plans_res.dart';
import 'package:stocks_news_new/providers/membership.dart';
import 'package:stocks_news_new/service/widgets/list_item_plan.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/custom/alert_popup.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import 'package:stocks_news_new/widgets/theme_button.dart';
import '../route/my_app.dart';

Future askToSubscribe({void Function()? onPressed}) async {
  // API call for Plans

  MembershipProvider provider =
      navigatorKey.currentContext!.read<MembershipProvider>();

  await provider.getPlansDetail();

  if (provider.plansRes == null) {
    popUpAlert(
      message: Const.errSomethingWrong,
      title: "Alert",
      icon: Images.alertPopGIF,
    );
    return;
  }

  await showModalBottomSheet(
    useSafeArea: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(10),
        topRight: Radius.circular(10),
      ),
    ),
    context: navigatorKey.currentContext!,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    enableDrag: true,
    barrierColor: Colors.transparent,
    builder: (BuildContext ctx) {
      return AskToSubscribeDialog(
        onPressed: onPressed,
      );
    },
  );
}

class AskToSubscribeDialog extends StatelessWidget {
  final Function()? onPressed;
  const AskToSubscribeDialog({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    MembershipProvider provider = context.watch<MembershipProvider>();

    return Container(
      constraints: BoxConstraints(maxHeight: ScreenUtil().screenHeight * .85),
      padding: const EdgeInsets.only(top: 12),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
        gradient: LinearGradient(
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
          colors: [
            Color.fromARGB(255, 3, 91, 14),
            Color.fromARGB(255, 0, 55, 7),
          ],
        ),
      ),
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Image.asset(
            Images.referBack,
            color: const Color.fromARGB(150, 81, 81, 81),
            fit: BoxFit.cover,
            height: 500,
          ),

          Padding(
            padding: EdgeInsets.zero,
            // padding: const EdgeInsets.only(top: 50),
            child: Column(
              children: [
                Flexible(
                  child: SingleChildScrollView(
                    child: Container(
                      color: Colors.transparent,
                      padding: const EdgeInsets.all(16),
                      // decoration: const BoxDecoration(
                      //   borderRadius: BorderRadius.only(
                      //     topLeft: Radius.circular(10),
                      //     topRight: Radius.circular(10),
                      //   ),
                      //   gradient: const LinearGradient(
                      //     begin: Alignment.bottomLeft,
                      //     end: Alignment.topRight,
                      //     colors: [
                      //       Color.fromARGB(255, 3, 91, 14),
                      //       Color.fromARGB(255, 0, 55, 7),
                      //     ],
                      //   ),
                      // ),
                      child: Padding(
                        padding: EdgeInsets.zero,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              provider.plansRes?.title ?? '',
                              style: stylePTSansBold(fontSize: 30),
                              textAlign: TextAlign.start,
                            ),
                            const SpacerVertical(height: 5),
                            Text(
                              provider.plansRes?.subTitle ?? '',
                              style: stylePTSansRegular(fontSize: 17),
                              textAlign: TextAlign.start,
                            ),
                            const SpacerVertical(height: 30),
                            // if (provider.plansRes?.plans != null)
                            // if (provider.plansRes?.plans != null)
                            ListView.separated(
                              shrinkWrap: true,
                              padding: EdgeInsets.zero,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                Plan plan = provider.plansRes!.plans[index];
                                return ListItemPlan(plan: plan);
                              },
                              separatorBuilder: (context, index) {
                                return const SpacerVertical(height: 12);
                              },
                              itemCount: provider.plansRes?.plans.length ?? 0,
                            ),
                            // const SpacerVertical(height: 10),
                            // ThemeButton(
                            //   color: Color.fromARGB(255, 0, 1, 0),
                            //   text: "Get a Membership",
                            //   onPressed: onPressed,
                            // ),
                            // SpacerVertical(
                            //     height: ScreenUtil().bottomBarHeight),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                ThemeButton(
                  color: const Color.fromARGB(255, 0, 1, 0),
                  text: "Get a Membership",
                  onPressed: onPressed,
                  margin: EdgeInsets.only(
                    top: 5,
                    bottom: ScreenUtil().bottomBarHeight,
                    left: 12,
                    right: 12,
                  ),
                ),
              ],
            ),
          ),

          // ThemeButton(
          //   color: const Color.fromARGB(255, 0, 1, 0),
          //   text: "Get a Membership",
          //   onPressed: onPressed,
          //   margin: const EdgeInsets.symmetric(horizontal: 12),
          // ),
          // Image.asset(
          //   Images.diamondS,
          //   height: 100,
          //   width: 100,
          //   fit: BoxFit.cover,
          // ),
        ],
      ),
    );
  }
}
