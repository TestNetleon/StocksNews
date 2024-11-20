import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/providers/user_provider.dart';
import 'package:stocks_news_new/route/my_app.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import '../../../modals/user_res.dart';
import '../../../utils/colors.dart';
import '../../../utils/theme.dart';
import '../index.dart';

void blackFridayPermission() {
  showDialog(
    context: navigatorKey.currentContext!,
    barrierColor: ThemeColors.transparentDark,
    builder: (context) {
      return LogoutPopUpCustom();
    },
  );
}

class LogoutPopUpCustom extends StatefulWidget {
  const LogoutPopUpCustom({super.key});

  @override
  State<LogoutPopUpCustom> createState() => _LogoutPopUpCustomState();
}

class _LogoutPopUpCustomState extends State<LogoutPopUpCustom> {
  bool isChecked = false;
  @override
  Widget build(BuildContext context) {
    UserRes? user = context.watch<UserProvider>().user;
    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 15),
      backgroundColor: ThemeColors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Container(
            padding: EdgeInsets.only(bottom: 5),
            child: Container(
              decoration: BoxDecoration(
                color: ThemeColors.white,
                borderRadius: BorderRadius.circular(10.sp),
              ),
              child: Padding(
                padding: EdgeInsets.fromLTRB(10.sp, 0, 10.sp, 0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      Images.alertPopGIF,
                      height: 80.sp,
                      width: 80.sp,
                    ),
                    Text(
                      user?.blackFriday?.title ?? "Black Friday Special!",
                      style: stylePTSansBold(
                        color: ThemeColors.background,
                        fontSize: 20,
                      ),
                    ),
                    const SpacerVertical(height: 8),
                    // RichText(
                    //   textAlign: TextAlign.center,
                    //   text: TextSpan(
                    //     style:
                    //         stylePTSansRegular(color: ThemeColors.background),
                    //     children: [
                    //       TextSpan(
                    //         text:
                    //             "You're currently using an active membership. ",
                    //       ),
                    //       TextSpan(
                    //         text:
                    //             "This Black Friday, we're offering incredible discounts:\n\n",
                    //       ),
                    //       TextSpan(
                    //         text: "- Monthly Special: ",
                    //         style:
                    //             stylePTSansBold(color: ThemeColors.background),
                    //       ),
                    //       TextSpan(
                    //         text: "90% off for the first month.\n",
                    //       ),
                    //       TextSpan(
                    //         text: "- Annual Special: ",
                    //         style:
                    //             stylePTSansBold(color: ThemeColors.background),
                    //       ),
                    //       TextSpan(
                    //         text: "50% off for the first year.\n\n",
                    //       ),
                    //       TextSpan(
                    //         text:
                    //             "If you'd like to purchase these offers, we recommend first canceling your current membership. ",
                    //       ),
                    //       TextSpan(
                    //         text:
                    //             "Your existing plan will remain active until its expiration date.\n\n",
                    //       ),
                    //       TextSpan(
                    //         text:
                    //             "Alternatively, you can proceed directly with the Black Friday offers by checking the box below.",
                    //       ),
                    //     ],
                    //   ),
                    // ),

                    HtmlWidget(
                      user?.blackFriday?.html ?? '',
                    ),

                    const SpacerVertical(height: 5),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          isChecked = !isChecked;
                        });
                      },
                      child: Row(
                        children: [
                          Checkbox(
                            value: isChecked,
                            onChanged: (value) {
                              setState(() {
                                isChecked = value!;
                              });
                            },
                            activeColor: ThemeColors.accent,
                          ),
                          Expanded(
                            child: Text(
                              user?.blackFriday?.checkbox ??
                                  "I understand and wish to proceed with the Black Friday plan.",
                              style: stylePTSansRegular(
                                  color: ThemeColors.background),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            user?.blackFriday?.noBtn ?? 'Cancel',
                            style:
                                stylePTSansBold(color: ThemeColors.background),
                          ),
                        ),
                        TextButton(
                          onPressed: isChecked
                              ? () async {
                                  Navigator.pop(context);

                                  Navigator.push(
                                    navigatorKey.currentContext!,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const BlackFridayMembershipIndex(),
                                    ),
                                  );
                                }
                              : null,
                          child: Text(
                            user?.blackFriday?.yesBtn ?? "Goto Membership",
                            style: stylePTSansBold(
                                color: isChecked
                                    ? ThemeColors.background
                                    : ThemeColors.greyText),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            width: ScreenUtil().screenWidth / 1.35,
            height: 5.sp,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10.sp),
                  bottomRight: Radius.circular(10.sp)),
              color: ThemeColors.accent,
            ),
          ),
        ],
      ),
    );
  }
}
