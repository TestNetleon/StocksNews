import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stocks_news_new/route/my_app.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/widgets/screen_title.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import 'package:stocks_news_new/widgets/theme_button.dart';
import 'package:stocks_news_new/widgets/theme_input_field.dart';

createTicketSheet() async {
  await showModalBottomSheet(
    useSafeArea: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(5.sp),
        topRight: Radius.circular(5.sp),
      ),
    ),
    backgroundColor: ThemeColors.transparent,
    isScrollControlled: true,
    context: navigatorKey.currentContext!,
    builder: (context) => const CreateTicket(),
  );
}

class CreateTicket extends StatelessWidget {
  static const String path = "CreateTicket";
  const CreateTicket({super.key});
//
  @override
  Widget build(BuildContext context) {
    return const CreateTicketBase();
  }
}

class CreateTicketBase extends StatefulWidget {
  const CreateTicketBase({super.key});

  @override
  State<CreateTicketBase> createState() => _CreateTicketBaseState();
}

class _CreateTicketBaseState extends State<CreateTicketBase> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      // context.read<TermsAndPolicyProvider>().getTermsPolicy(
      //       type: PolicyType.contactUs,
      //       slug: "contact-us",
      //     );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxHeight: ScreenUtil().screenHeight - 30),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10.sp), topRight: Radius.circular(10.sp)),
        gradient: const RadialGradient(
          center: Alignment.bottomCenter,
          radius: 0.6,
          // transform: GradientRotation(radians),
          // tileMode: TileMode.decal,
          stops: [
            0.0,
            0.9,
          ],
          colors: [
            Color.fromARGB(255, 0, 93, 12),
            // ThemeColors.accent.withOpacity(0.1),
            Colors.black,
          ],
        ),
        color: ThemeColors.background,
        border: const Border(
          top: BorderSide(color: ThemeColors.greyBorder),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
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
          // const SpacerVertical(height: 20),
          // Container(
          //   width: MediaQuery.of(context).size.width * .45,
          //   constraints: BoxConstraints(maxHeight: kTextTabBarHeight - 2.sp),
          //   child: Image.asset(
          //     Images.logo,
          //     fit: BoxFit.contain,
          //   ),
          // ),
          // const SpacerVertical(height: 10),
          Padding(
            padding: const EdgeInsets.all(Dimen.authScreenPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const ScreenTitle(title: "CREATE TICKET"),
                // Text(
                //   "CREATE TICKET",
                //   style: stylePTSansBold(fontSize: 24),
                // ),
                const SpacerVertical(height: 30),
                // Text(
                //   "Email Address",
                //   style: stylePTSansRegular(fontSize: 14),
                // ),
                // const SpacerVertical(height: 5),
                ThemeInputField(
                  // controller: _controller,
                  controller: TextEditingController(),
                  placeholder: "Select Reason",
                  keyboardType: TextInputType.emailAddress,
                  inputFormatters: [],
                  textCapitalization: TextCapitalization.none,
                ),
                const SpacerVertical(height: Dimen.itemSpacing),
                ThemeInputField(
                  // controller: _controller,
                  controller: TextEditingController(),
                  placeholder: "Enter your query",
                  keyboardType: TextInputType.emailAddress,
                  inputFormatters: [],
                  minLines: 4,
                  textCapitalization: TextCapitalization.none,
                ),
                const SpacerVertical(height: Dimen.itemSpacing),
                ThemeButton(
                  text: "Create",
                  onPressed: () {},
                ),
                const SpacerVertical(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
