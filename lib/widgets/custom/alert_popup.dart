import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stocks_news_new/routes/my_app.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

Future popUpAlert({
  String? message,
  String? title,
  EdgeInsets? padding,
  String? icon,
  Function()? onTap,
  bool cancel = false,
  String? okText,
  String? cancelText = "Cancel",
  bool canPop = true,
  bool showButton = true,
  bool showOk = true,
  Widget? child,
  Widget? iconWidget,
  TextAlign? messageTextAlign = TextAlign.center,
}) async {
  if (navigatorKey.currentContext != null) {
    await showDialog(
      context: navigatorKey.currentContext!,
      barrierColor: const Color.fromARGB(72, 0, 0, 0),
      builder: (context) {
        return AlertPopupCustom(
          message: message,
          title: title,
          icon: icon,
          onTap: onTap,
          cancel: cancel,
          okText: okText,
          cancelText: cancelText,
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
}

class AlertPopupCustom extends StatelessWidget {
  final String? message, title;
  final String? icon;
  final TextAlign? messageTextAlign;
  final EdgeInsets? padding;
  final String? okText, cancelText;
  final Function()? onTap;
  final bool cancel;
  final bool showButton;
  final bool canPop;
  final bool showOk;
  final Widget? iconWidget;
  final Widget? child;

  const AlertPopupCustom({
    super.key,
    this.message,
    this.title,
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
    this.messageTextAlign,
    this.cancelText = "Cancel",
  });

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: canPop,
      child: Dialog(
        backgroundColor: Colors.transparent,
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
                    color: Colors.white,
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
                                if (title != null && title != '')
                                  Container(
                                    margin: EdgeInsets.only(
                                        top: icon == null ? 12 : 0),
                                    child: Text(
                                      title ?? "",
                                      style: styleBaseBold(
                                        // color: ThemeColors.background,
                                        color: Colors.black,

                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                const SpacerVertical(height: 8),
                                if (message != null && message != '')
                                  Text(
                                    message ?? "",
                                    textAlign:
                                        messageTextAlign ?? TextAlign.center,
                                    style: styleBaseRegular(
                                        // color: ThemeColors.background,
                                        color: Colors.black,
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
                                    "$cancelText",
                                    style: styleBaseBold(
                                      color: Colors.black,
                                    ),
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
                                    style: styleBaseBold(
                                      color: Colors.black,
                                      // color: ThemeColors.background,
                                    ),
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
                  color: ThemeColors.primary100,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
