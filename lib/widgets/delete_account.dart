import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stocks_news_new/providers/user_provider.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_verticle.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/widgets/theme_alert_dialog.dart';

import '../../../utils/theme.dart';

class DeleteAccountPopUp extends StatefulWidget {
  const DeleteAccountPopUp({super.key});

  @override
  State<DeleteAccountPopUp> createState() => _DeleteAccountPopUpState();
}

class _DeleteAccountPopUpState extends State<DeleteAccountPopUp> {
  bool isChecked = false;
  @override
  Widget build(BuildContext context) {
    return ThemeAlertDialog(
      contentPadding: EdgeInsets.fromLTRB(18.sp, 16.sp, 10.sp, 10.sp),
      children: [
        Text("Delete Account",
            style: stylePTSansBold(
              fontSize: 19,
            )),
        const SpacerVerticel(height: 10),
        Text(
            "We regret to hear that you've chosen to delete your account from our service. Please be aware that upon account deletion, all your information, content, and data will be permanently removed from our systems. If you wish to use our application again, you will need to create a new account. We appreciate your understanding and value your time with us.",
            style: stylePTSansRegular()),
        GestureDetector(
          onTap: () {
            isChecked = !isChecked;
            setState(() {});
          },
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 10.sp),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(1.sp),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.sp),
                      color: isChecked
                          ? ThemeColors.border
                          : ThemeColors.background,
                      border: Border.all(color: ThemeColors.border)),
                  child: Icon(
                    Icons.check,
                    size: 20.sp,
                    color: ThemeColors.background,
                  ),
                ),
                const SpacerHorizontal(width: 8),
                Flexible(
                    child: Text(
                  "Delete account permanently",
                  style: stylePTSansRegular(fontSize: 14),
                )),
              ],
            ),
          ),
        ),
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
              onPressed: isChecked
                  ? () {
                      Map request = {
                        'token': context.read<UserProvider>().user?.token ?? "",
                      };
                      Navigator.pop(context);
                      context.read<UserProvider>().deleteUser(request);
                    }
                  : null,
              child: Text(
                "DELETE",
                style: stylePTSansRegular(
                    fontSize: 14,
                    color: isChecked ? Colors.white : ThemeColors.greyText),
              ),
            ),
          ],
        )
      ],
    );
  }
}
