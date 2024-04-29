import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/providers/user_provider.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/delete_account.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';

class MyAccountDelete extends StatelessWidget {
  const MyAccountDelete({super.key});
//
  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: !context.watch<UserProvider>().isKeyboardVisible,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30.sp),
          border: Border.all(
              color: ThemeColors.greyBorder.withOpacity(0.5), width: 2.sp),
        ),
        padding: EdgeInsets.all(4.sp),
        child: InkWell(
          borderRadius: BorderRadius.circular(30.sp),
          onTap: () {
            showDialog(
              context: context,
              builder: (context) {
                return const DeleteAccountPopUp();
              },
            );
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 15.sp, vertical: 6.sp),
            decoration: BoxDecoration(
              color: ThemeColors.greyBorder.withOpacity(0.5),
              borderRadius: BorderRadius.circular(30.sp),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.delete_sweep, size: 20.sp),
                const SpacerHorizontal(width: 5),
                Text(
                  "Delete Account",
                  style: stylePTSansBold(fontSize: 13),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
