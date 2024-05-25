import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stocks_news_new/utils/colors.dart';

class InAppMsgDialogBase extends StatelessWidget {
  const InAppMsgDialogBase({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            margin: EdgeInsets.all(8.sp),
            child: child,
          ),
          Positioned(
            right: 0,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                decoration: const BoxDecoration(
                  color: ThemeColors.divider,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.cancel,
                  color: ThemeColors.background,
                  size: 28,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
