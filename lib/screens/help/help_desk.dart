import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/modals/user_res.dart';
import 'package:stocks_news_new/providers/help_desk_provider.dart';
import 'package:stocks_news_new/providers/user_provider.dart';
import 'package:stocks_news_new/screens/auth/bottomSheets/login_sheet.dart';
import 'package:stocks_news_new/screens/auth/bottomSheets/login_sheet_tablet.dart';
import 'package:stocks_news_new/screens/help/help_desk_list.dart';
import 'package:stocks_news_new/screens/tabs/home/widgets/app_bar_home.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/widgets/base_container.dart';
import 'package:stocks_news_new/widgets/login_error.dart';

class HelpDesk extends StatelessWidget {
  static const String path = "HelpDesk";

  final String? slug;
  const HelpDesk({this.slug, super.key});

  @override
  Widget build(BuildContext context) {
    UserRes? user = context.watch<UserProvider>().user;
    HelpDeskProvider provider = context.read<HelpDeskProvider>();
    return BaseContainer(
      appBar: const AppBarHome(isPopback: true, canSearch: true),
      body: Padding(
        padding: EdgeInsets.all(Dimen.padding.sp),
        child: user == null
            ? Column(
                children: [
                  Expanded(
                      child: LoginError(
                    state: "notification",
                    onClick: () async {
                      isPhone ? await loginSheet() : await loginSheetTablet();

                      if (context.read<UserProvider>().user != null) {
                        provider.getHelpDeskList(reset: true);
                      }
                    },
                  ))
                ],
              )
            : HelpDeskList(
                slug: slug,
              ),
      ),
    );
  }
}
