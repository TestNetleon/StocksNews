import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../utils/theme.dart';
import '../../../widgets/spacer_horizontal.dart';

class ContactUsBulletPoint extends StatelessWidget {
  final String point;
  const ContactUsBulletPoint({super.key, required this.point});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 4.sp),
          child: Icon(Icons.circle, size: 6.sp),
        ),
        const SpacerHorizontal(width: 5),
        Expanded(
          child: Text(
            point,
            style: stylePTSansRegular(fontSize: 14),
          ),
        ),
      ],
    );
  }
}
