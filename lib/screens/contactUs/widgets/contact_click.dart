import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../utils/colors.dart';
import '../../../utils/theme.dart';
import '../../../widgets/spacer_horizontal.dart';

class ContactUsClickEvent extends StatelessWidget {
  final String heading, subHeading;
  final IconData iconData;
  final void Function()? onTap;
  const ContactUsClickEvent({
    super.key,
    required this.heading,
    required this.subHeading,
    required this.iconData,
    this.onTap,
  });
//
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10.sp, horizontal: 10.sp),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(5.sp),
              decoration: BoxDecoration(
                  color: ThemeColors.greyBorder,
                  borderRadius: BorderRadius.circular(5.sp)),
              child: Icon(iconData, size: 20.sp),
            ),
            const SpacerHorizontal(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    heading,
                    style: stylePTSansRegular(fontSize: 11),
                  ),
                  Text(
                    subHeading,
                    style: stylePTSansRegular(
                        fontSize: 11, color: ThemeColors.greyText),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
