import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:stocks_news_new/route/my_app.dart';
import 'package:stocks_news_new/utils/dialogs.dart';
import 'package:stocks_news_new/utils/theme.dart';

class InfoBottomSheet extends StatelessWidget {
  const InfoBottomSheet({super.key});

  void _showBottomSheet() {
    showPlatformBottomSheet(
        context: navigatorKey.currentContext!,
        content: Padding(
          padding: EdgeInsets.fromLTRB(10.sp, 0, 10.sp, 10.sp),
          child: HtmlWidget(textStyle: stylePTSansBold(), '''
        
        <!DOCTYPE html>
        <html>
        <head>
          <title>My First Webpage</title>
        </head>
        <body>
          <h1>Welcome to my webpage!</h1>
          <p>This is a simple example of an HTML document. It contains a heading and a paragraph.</p>
        </body>
        </html>
        
        
        '''),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _showBottomSheet,
      child: Icon(
        Icons.info_rounded,
        size: 25.sp,
      ),
    );
  }
}
