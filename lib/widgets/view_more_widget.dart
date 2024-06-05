import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';

class ViewMoreWidget extends StatelessWidget {
  const ViewMoreWidget({
    required this.text,
    required this.onTap,
    this.paddingLeft,
    super.key,
  });

  final String text;
  final Function() onTap;
  final double? paddingLeft;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Divider(
            height: 10.sp,
            color: ThemeColors.dividerDark,
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 5.sp),
            child: Row(
              children: [
                SpacerHorizontal(width: paddingLeft != null ? paddingLeft! : 2),
                Expanded(
                  child: Text(
                    text,
                    style: stylePTSansBold(fontSize: 14),
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 18,
                )
              ],
            ),
          ),
          Divider(
            height: 10.sp,
            color: ThemeColors.divider,
          ),
        ],
      ),
    );
  }
}
