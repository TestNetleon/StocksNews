import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stocks_news_new/widgets/bottom_sheet_tick.dart';

class BottomSheetContainerPlain extends StatelessWidget {
  const BottomSheetContainerPlain({
    required this.child,
    this.showClose = true,
    super.key,
    this.padding,
  });

  final Widget child;
  final EdgeInsets? padding;
  final bool showClose;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding == null
          ? EdgeInsets.zero
          : EdgeInsets.symmetric(horizontal: 10.sp, vertical: 7.sp),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: EdgeInsets.only(top: padding == null ? 7.sp : 0),
                  child: const BottomSheetTick(),
                )),
            Visibility(
              visible: showClose,
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Align(
                  alignment: Alignment.centerRight,
                  child: Icon(Icons.close, size: 30),
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
