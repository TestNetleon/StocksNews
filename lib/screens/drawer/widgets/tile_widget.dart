import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stocks_news_new/modals/drawer_res.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';

class DrawerTileWidget extends StatelessWidget {
  final int index;
  final Function() onTap;
  const DrawerTileWidget({super.key, required this.index, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Ink(
          decoration: BoxDecoration(
              gradient: drawerItems[index].isSelected
                  ? LinearGradient(
                      colors: [
                        ThemeColors.lightGreen.withOpacity(0.6),
                        ThemeColors.accent,
                        ThemeColors.lightGreen.withOpacity(0.6),
                      ],
                    )
                  : null,
              border: Border.all(
                  color: drawerItems[index].isSelected
                      ? ThemeColors.lightGreen.withOpacity(0.3)
                      // : ThemeColors.background,
                      : Colors.black,
                  width: 3),
              color: drawerItems[index].isSelected
                  ? ThemeColors.accent
                  // : ThemeColors.background,
                  : Colors.black,
              borderRadius: BorderRadius.circular(50.sp)),
          child: InkWell(
            borderRadius: BorderRadius.circular(50.sp),
            onTap: onTap,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.sp, vertical: 6.sp),
              child: Row(
                children: [
                  Stack(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(right: 2.sp),
                        child: Icon(
                          drawerItems[index].iconData,
                          size: 20,
                        ),
                      ),
                      Positioned(
                        right: 0,
                        top: 0,
                        child: Visibility(
                          visible: drawerItems[index].showBadge,
                          child: const CircleAvatar(
                            radius: 5,
                            backgroundColor: ThemeColors.accent,
                          ),
                        ),
                      )
                    ],
                  ),
                  const SpacerHorizontal(width: 20),
                  Expanded(
                    child: Text(drawerItems[index].text,
                        style: stylePTSansBold(fontSize: 14)),
                  ),
                  Visibility(
                    visible: drawerItems[index].badgeCount != null,
                    child: Container(
                      padding: EdgeInsets.all(6.sp),
                      decoration: BoxDecoration(
                          color: ThemeColors.greyBorder.withOpacity(0.4),
                          shape: BoxShape.circle),
                      child: ClipOval(
                        child: Text(
                          "${drawerItems[index].badgeCount}",
                          style: stylePTSansRegular(fontSize: 12),
                        ),
                      ),
                    ),
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
