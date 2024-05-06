import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/providers/alert_provider.dart';
import 'package:stocks_news_new/providers/user_provider.dart';
import 'package:stocks_news_new/screens/tabs/home/widgets/app_bar_home.dart';
import 'package:stocks_news_new/screens/tabs/tabs.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/base_container.dart';
import 'package:stocks_news_new/widgets/base_ui_container.dart';
import 'package:stocks_news_new/widgets/login_error.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

import '../../widgets/screen_title.dart';
import 'alert_container.dart';

class AlertBase extends StatefulWidget {
  const AlertBase({super.key});

  @override
  State<AlertBase> createState() => _AlertBaseState();
}

class _AlertBaseState extends State<AlertBase> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _getData();
    });
  }

  void _getData() {
    UserProvider provider = context.read<UserProvider>();
    if (provider.user != null) {
      context.read<AlertProvider>().getAlerts(showProgress: false);
    }
  }

  @override
  Widget build(BuildContext context) {
    AlertProvider provider = context.watch<AlertProvider>();
    UserProvider userProvider = context.read<UserProvider>();

    return BaseContainer(
      appBar: const AppBarHome(isPopback: true, canSearch: true),
      body: Padding(
        padding: EdgeInsets.fromLTRB(
          Dimen.padding.sp,
          Dimen.padding.sp,
          Dimen.padding.sp,
          0,
        ),
        child: Column(
          children: [
            const ScreenTitle(title: "Stock Alerts"),
            Visibility(
              visible: provider.textRes?.subTitle != '',
              child: Text(
                provider.textRes?.subTitle ?? "",
                style: stylePTSansRegular(fontSize: 12),
              ),
            ),
            Visibility(
              visible: provider.textRes?.note != '',
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 10.sp),
                padding: EdgeInsets.symmetric(vertical: 5.sp, horizontal: 5.sp),
                decoration: const BoxDecoration(
                  color: ThemeColors.greyBorder,
                  border: Border(
                    left: BorderSide(
                      color: ThemeColors.white,
                      width: 3,
                    ),
                  ),
                ),
                child: Text(
                  provider.textRes?.note ?? "",
                  style: stylePTSansRegular(fontSize: 12),
                ),
              ),
            ),
            Visibility(
              visible: provider.textRes?.other != '',
              child: Text(
                provider.textRes?.other ?? "",
                style: stylePTSansRegular(fontSize: 12),
              ),
            ),
            const SpacerVertical(height: 5),
            userProvider.user == null
                ? const Expanded(
                    child: LoginError(
                      error: "User Not logged in",
                      state: "alert",
                    ),
                  )
                : Expanded(
                    child: BaseUiContainer(
                      isLoading: provider.isLoading && provider.data == null,
                      hasData:
                          provider.data != null && provider.data!.isNotEmpty,
                      error: provider.error,
                      errorDispCommon: true,
                      showPreparingText: true,
                      // onRefresh: () => provider.getAlerts(showProgress: false),
                      navBtnText: "Add First Stock Alert",
                      onNavigate: () {
                        Navigator.popUntil(context, (route) => route.isFirst);
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const Tabs(index: 1),
                          ),
                        );
                      },
                      child: const AlertContainer(),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
//