import 'package:flutter/material.dart';
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
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
              color: ThemeColors.greyBorder.withOpacity(0.5), width: 2),
        ),
        padding: EdgeInsets.all(4),
        child: InkWell(
          borderRadius: BorderRadius.circular(30),
          onTap: () {
            showDialog(
              context: context,
              builder: (context) {
                return const DeleteAccountPopUp();
              },
            );
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 6),
            decoration: BoxDecoration(
              color: ThemeColors.greyBorder.withOpacity(0.5),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.delete_sweep, size: 20),
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
