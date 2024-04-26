import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_verticle.dart';

class AddCompanyContainer extends StatelessWidget {
  final void Function()? onTap;
  const AddCompanyContainer({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(10.sp),
        decoration: BoxDecoration(
            color: ThemeColors.primaryLight,
            borderRadius: BorderRadius.circular(5.sp),
            border: Border.all(color: ThemeColors.dividerDark)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Add a Company",
              style: stylePTSansBold(fontSize: 13),
            ),
            const SpacerVerticel(height: 10),
            CircleAvatar(
              child: InkWell(onTap: onTap, child: const Icon(Icons.add)),
            )
          ],
        ),
      ),
    );
  }
}
