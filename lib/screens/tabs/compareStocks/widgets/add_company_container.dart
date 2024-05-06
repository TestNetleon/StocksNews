import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

class AddCompanyContainer extends StatelessWidget {
  final void Function()? onTap;
  const AddCompanyContainer({super.key, this.onTap});
//
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 100.sp,
        height: 100.sp,
        alignment: Alignment.center,
        // padding: EdgeInsets.all(10.sp),
        decoration: BoxDecoration(
            color: ThemeColors.primaryLight,
            borderRadius: BorderRadius.circular(5.sp),
            border: Border.all(color: ThemeColors.dividerDark)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Add New Stock",
              style: stylePTSansBold(fontSize: 13),
            ),
            const SpacerVertical(height: 10),
            CircleAvatar(
              child: InkWell(onTap: onTap, child: const Icon(Icons.add)),
            )
          ],
        ),
      ),
    );
  }
}
