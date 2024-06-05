import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/utils/utils.dart';

//
PreferredSizeWidget getThemeAppBar({Widget? leading, required String title}) {
  return AppBar(
    leading: leading,
    centerTitle: true,
    title: Text(
      title,
      style: stylePTSansBold(),
    ),
    automaticallyImplyLeading: false,
    actions: [
      Builder(
        builder: (BuildContext context) {
          return IconButton(
            icon: Icon(
              Icons.menu,
              color: Colors.black,
              size: 30.sp, // This is the drawer icon
            ),
            onPressed: () {
              closeKeyboard();
              Scaffold.of(context).openEndDrawer();
            },
          );
        },
      )
    ],
    elevation: 1,
    backgroundColor: Colors.white,
  );
}
