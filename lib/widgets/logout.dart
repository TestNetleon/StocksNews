import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stocks_news_new/providers/home_provider.dart';
import 'package:stocks_news_new/providers/user_provider.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/widgets/theme_alert_dialog.dart';

import '../../../utils/theme.dart';

class LogoutDialog extends StatefulWidget {
  const LogoutDialog({super.key});

  @override
  State<LogoutDialog> createState() => _LogoutDialogState();
}

//
class _LogoutDialogState extends State<LogoutDialog> {
  @override
  Widget build(BuildContext context) {
    return ThemeAlertDialog(
      contentPadding: EdgeInsets.fromLTRB(18.sp, 16.sp, 10.sp, 10.sp),
      children: [
        Text("Sign Out",
            style: stylePTSansBold(
              fontSize: 19,
            )),
        const SpacerVertical(height: 10),
        Text("Are you sure you want to sign out?", style: stylePTSansRegular()),
        const SpacerVertical(height: 20),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                "CANCEL",
                style: stylePTSansRegular(fontSize: 14),
              ),
            ),
            TextButton(
              onPressed: () {
                Map request = {
                  'token': context.read<UserProvider>().user?.token ?? "",
                };
                Navigator.pop(context);
                context.read<UserProvider>().logoutUser(request);
                context.read<HomeProvider>().getHomeAlerts(userAvail: false);
              },
              child: Text(
                "LOGOUT",
                style: stylePTSansRegular(fontSize: 14),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
