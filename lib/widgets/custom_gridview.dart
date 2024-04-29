import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomGridView extends StatelessWidget {
  const CustomGridView({
    required this.length,
    required this.getChild,
    this.paddingVerticle = 16,
    this.paddingHorizontal = 8,
    super.key,
  });

  final double paddingVerticle, paddingHorizontal;
  final int length;
  final Widget Function(int index) getChild;
//
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(vertical: paddingVerticle.sp),
      itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: paddingHorizontal.sp),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(child: getChild(index * 2)),
              length > (index * 2 + 1)
                  ? SizedBox(width: paddingHorizontal.sp)
                  : const SizedBox(),
              length > (index * 2 + 1)
                  ? Expanded(child: getChild(index * 2 + 1))
                  : const SizedBox(),
            ],
          ),
        );
      },
      separatorBuilder: (context, index) {
        return SizedBox(height: (paddingVerticle * 1.2).sp);
      },
      itemCount: ((length / 2) + (length % 2)).toInt(),
    );
  }
}
