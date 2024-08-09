import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/providers/help_desk.dart';
import 'package:stocks_news_new/screens/tabs/home/widgets/app_bar_home.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/widgets/base_container.dart';
import 'package:stocks_news_new/widgets/screen_title.dart';

import '../../../modals/user_res.dart';
import '../../../providers/user_provider.dart';
import '../../../widgets/login_error.dart';
import '../../auth/login/login_sheet.dart';
import '../../auth/login/login_sheet_tablet.dart';
import 'container.dart';

class HelpDeskNew extends StatefulWidget {
  const HelpDeskNew({super.key});

  @override
  State<HelpDeskNew> createState() => _HelpDeskNewState();
}

class _HelpDeskNewState extends State<HelpDeskNew> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      UserRes? user = context.read<UserProvider>().user;
      if (user == null) {
        return;
      }
      context.read<NewHelpDeskProvider>().getTickets();
    });
  }

  @override
  Widget build(BuildContext context) {
    NewHelpDeskProvider provider = context.watch<NewHelpDeskProvider>();
    UserRes? user = context.watch<UserProvider>().user;

    return BaseContainer(
      appBar: AppBarHome(
        isPopback: true,
        title: provider.extraTickets?.title,
        subTitle: provider.extraTickets?.subTitle,
      ),
      body: Container(
        padding: const EdgeInsets.fromLTRB(Dimen.padding, 0, Dimen.padding, 0),
        child: user == null
            ? Column(
                children: [
                  ScreenTitle(
                    subTitle: provider.extraTickets?.subTitle,
                  ),
                  Expanded(
                    child: LoginError(
                      state: "notification",
                      title: "Helpdesk",
                      onClick: () async {
                        isPhone ? await loginSheet() : await loginSheetTablet();
                        if (context.read<UserProvider>().user != null) {
                          provider.getTickets();
                        }
                      },
                    ),
                  )
                ],
              )
            : HelpDeskNewContainer(),
      ),
    );
  }
}
