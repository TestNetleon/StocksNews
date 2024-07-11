import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stocks_news_new/screens/drawer/widgets/drawer_lists.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';

import '../../../utils/colors.dart';
import '../../../utils/theme.dart';

class AboutTile extends StatelessWidget {
  final int index;
  final Function()? onTap;
  const AboutTile({super.key, required this.index, this.onTap});
//
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Ink(
          decoration: BoxDecoration(
              // border: Border.all(color: Colors.black, width: 3),
              // color: Colors.black,
              borderRadius: BorderRadius.circular(50.sp)),
          child: InkWell(
            borderRadius: BorderRadius.circular(50.sp),
            onTap: onTap,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.sp, vertical: 10.sp),
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(right: 2.sp),
                    child: Icon(
                      aboutTiles[index].iconData,
                      size: 20,
                    ),
                  ),
                  const SpacerHorizontal(width: 20),
                  Expanded(
                    child: Text(aboutTiles[index].text,
                        style: stylePTSansBold(fontSize: 16)),
                  ),
                ],
              ),
            ),
          ),
        ),
        Divider(color: ThemeColors.greyBorder, height: 5.sp),
      ],
    );
  }
}
