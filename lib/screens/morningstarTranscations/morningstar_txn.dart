import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/providers/morningstar_txn_provider.dart';
import 'package:stocks_news_new/providers/user_provider.dart';
import 'package:stocks_news_new/screens/morningstarTranscations/morningstar_txn_list.dart';
import 'package:stocks_news_new/screens/tabs/home/widgets/app_bar_home.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/widgets/base_container.dart';
import 'package:stocks_news_new/widgets/login_error.dart';

import '../auth/base/base_auth.dart';

class MorningStarTransaction extends StatelessWidget {
  const MorningStarTransaction({super.key});

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = context.watch<UserProvider>();
    MorningstarTxnProvider provider = context.watch<MorningstarTxnProvider>();
    return BaseContainer(
      bottomSafeAreaColor: ThemeColors.background,
      appBar: AppBarHome(
        isPopback: true,
        title: provider.extra?.title.toString(),
      ),
      body: userProvider.user == null
          ? Column(
              children: [
                // const ScreenTitle(title: "My Profile"),
                Expanded(child: LoginError(
                  onClick: () async {
                    // isPhone ? await loginSheet() : await loginSheetTablet();
                    await loginFirstSheet();
                  },
                ))
              ],
            )
          : MorningStarTxnList(),
    );
  }
}
