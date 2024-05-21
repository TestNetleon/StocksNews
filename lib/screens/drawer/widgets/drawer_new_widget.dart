import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

class DrawerNewWidget extends StatelessWidget {
  final IconData icon;
  final String text;
  const DrawerNewWidget({super.key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          icon,
          size: 20.sp,
        ),
        const SpacerVertical(height: 10),
        Text(
          text,
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: stylePTSansRegular(fontSize: 11),
        ),
      ],
    );
  }
}
