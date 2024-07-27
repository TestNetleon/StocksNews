import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stocks_news_new/route/my_app.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

Future popUpAlert({
  required String message,
  required String title,
  EdgeInsets? padding,
  String? icon,
  Function()? onTap,
  bool cancel = false,
  String? okText,
  bool canPop = true,
  bool showButton = true,
  bool showOk = true,
  Widget? child,
  Widget? iconWidget,
  TextAlign? messageTextAlign = TextAlign.center,
}) async {
  await showDialog(
    context: navigatorKey.currentContext!,
    barrierColor: ThemeColors.transparentDark,
    builder: (context) {
      return AlertPopupCustom(
        message: message,
        title: title,
        icon: icon,
        onTap: onTap,
        cancel: cancel,
        okText: okText,
        canPop: canPop,
        showButton: showButton,
        showOk: showOk,
        messageTextAlign: messageTextAlign,
        padding: padding,
        iconWidget: iconWidget,
        child: child,
      );
    },
  );
}

class AlertPopupCustom extends StatelessWidget {
  final String message, title;
  final String? icon;
  final TextAlign? messageTextAlign;
  final EdgeInsets? padding;
  final String? okText;
  final Function()? onTap;
  final bool cancel;
  final bool showButton;
  final bool canPop;
  final bool showOk;
  final Widget? iconWidget;
  final Widget? child;
  const AlertPopupCustom(
      {super.key,
      required this.message,
      required this.title,
      this.iconWidget,
      this.showOk = true,
      this.padding,
      this.icon,
      this.showButton = true,
      this.cancel = false,
      this.onTap,
      this.okText,
      this.child,
      this.canPop = true,
      this.messageTextAlign});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: canPop,
      child: Dialog(
        backgroundColor: ThemeColors.transparent,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.sp)),
        child: SingleChildScrollView(
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Container(
                padding: EdgeInsets.only(bottom: 5.sp),
                child: Container(
                  decoration: BoxDecoration(
                    color: ThemeColors.white,
                    borderRadius: BorderRadius.circular(10.sp),
                  ),
                  child: Padding(
                    padding: padding ?? EdgeInsets.fromLTRB(10.sp, 0, 10.sp, 0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Visibility(
                          visible: icon != null,
                          child: Image.asset(
                            icon ?? "",
                            height: 80.sp,
                            width: 80.sp,
                          ),
                        ),
                        iconWidget ?? const SizedBox(),
                        // const SpacerVertical(height: 5),
                        child ??
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  title,
                                  style: stylePTSansBold(
                                    color: ThemeColors.background,
                                    fontSize: 20,
                                  ),
                                ),
                                const SpacerVertical(height: 8),
                                Text(
                                  message,
                                  textAlign:
                                      messageTextAlign ?? TextAlign.center,
                                  style: stylePTSansRegular(
                                      color: ThemeColors.background,
                                      height: 1.4),
                                ),
                              ],
                            ),
                        const SpacerVertical(height: 5),
                        Visibility(
                          visible: showButton,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Visibility(
                                visible: cancel,
                                child: TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text(
                                    "Cancel",
                                    style: stylePTSansBold(
                                        color: ThemeColors.background),
                                  ),
                                ),
                              ),
                              Visibility(
                                visible: showOk,
                                child: TextButton(
                                  onPressed: onTap ??
                                      () {
                                        Navigator.of(context).pop();
                                      },
                                  child: Text(
                                    okText ?? "OK",
                                    style: stylePTSansBold(
                                        color: ThemeColors.background),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                width: ScreenUtil().screenWidth / 1.35,
                height: 5.sp,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(10.sp),
                      bottomRight: Radius.circular(10.sp)),
                  color: ThemeColors.accent,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
