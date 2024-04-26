import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stocks_news_new/widgets/bottom_sheet_tick.dart';

class BottomSheetContainerPlain extends StatelessWidget {
  const BottomSheetContainerPlain({
    required this.child,
    this.showClose = true,
    super.key,
  });

  final Widget child;
  final bool showClose;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.sp, vertical: 7.sp),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Align(alignment: Alignment.center, child: BottomSheetTick()),
            Visibility(
              visible: showClose,
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Icon(
                    Icons.close,
                    size: 30.sp,
                    // color: ThemeColors.background,
                  ),
                ),
              ),
            ),
            child
          ],
        ),
      ),
    );
  }
}
