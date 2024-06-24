import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/providers/terms_policy_provider.dart';
import 'package:stocks_news_new/screens/contactUs/contact_us_container.dart';
import 'package:stocks_news_new/screens/help/create_ticket.dart';
import 'package:stocks_news_new/screens/tabs/home/widgets/app_bar_home.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/base_container.dart';
import 'package:stocks_news_new/widgets/loading.dart';
import 'package:stocks_news_new/widgets/screen_title.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';

class HelpDesk extends StatelessWidget {
  static const String path = "HelpDesk";

  final String? slug;
  const HelpDesk({this.slug, super.key});

  @override
  Widget build(BuildContext context) {
    return BaseContainer(
      appBar: const AppBarHome(isPopback: true, canSearch: true),
      body: Padding(
        padding: EdgeInsets.all(Dimen.padding.sp),
        child: Column(
          children: [
            const ScreenTitle(title: "Helpdesk", subTitleHtml: true),
            // subTitle: provider.data?.subTitle ?? "",
            Expanded(
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: const LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color.fromARGB(255, 23, 23, 23),
                          Color.fromARGB(255, 48, 48, 48),
                        ],
                      ),
                    ),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: ThemeColors.accent
                                    // gradient: LinearGradient(
                                    //   transform: GradientRotation(50),
                                    //   colors: [
                                    //     Color.fromARGB(140, 53, 186, 71),
                                    //   ],
                                    // ),
                                    ),
                                padding: const EdgeInsets.all(5),
                                child: const Icon(
                                  Icons.edit_note_outlined,
                                  size: 28,
                                ),
                              ),
                              const SpacerHorizontal(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Tickets",
                                      style: stylePTSansBold(),
                                    ),
                                    Text(
                                      "0 Active",
                                      style: stylePTSansRegular(
                                          color: ThemeColors.greyText,
                                          fontSize: 13),
                                    ),
                                  ],
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  createTicketSheet();
                                },
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "CREATE NEW",
                                      style: stylePTSansBold(fontSize: 13),
                                    ),
                                    const SpacerHorizontal(width: 5),
                                    const Icon(
                                      Icons.add_circle_outline_rounded,
                                      size: 16,
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        const Divider(
                          color: ThemeColors.dividerDark,
                          height: 1,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Text(
                            "View All Requests",
                            // "VIEW ALL TICKETS",
                            style: styleGeorgiaBold(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
