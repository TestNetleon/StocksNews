import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/providers/user_provider.dart';
import 'package:stocks_news_new/screens/auth/login/login_sheet.dart';
import 'package:stocks_news_new/screens/auth/login/login_sheet_tablet.dart';
import 'package:stocks_news_new/screens/morningstarTranscations/morningstar_txn_list.dart';
import 'package:stocks_news_new/screens/tabs/home/widgets/app_bar_home.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/widgets/base_container.dart';
import 'package:stocks_news_new/widgets/login_error.dart';

class MorningStarTransaction extends StatelessWidget {
  const MorningStarTransaction({super.key});

  @override
  Widget build(BuildContext context) {
    UserProvider provider = context.watch<UserProvider>();
    return BaseContainer(
      bottomSafeAreaColor: ThemeColors.background,
      appBar: const AppBarHome(
        isPopback: true,
        canSearch: true,
      ),
      body: provider.user == null
          ? Column(
              children: [
                // const ScreenTitle(title: "My Profile"),
                Expanded(child: LoginError(
                  onClick: () async {
                    isPhone ? await loginSheet() : await loginSheetTablet();
                  },
                ))
              ],
            )
          : MorningStarTxnList(),
    );
  }
}
