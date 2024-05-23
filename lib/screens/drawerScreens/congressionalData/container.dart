import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stocks_news_new/screens/drawerScreens/congressionalData/item.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/widgets/screen_title.dart';

class CongressionalContainer extends StatelessWidget {
  const CongressionalContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
          Dimen.padding, Dimen.padding, Dimen.padding, 0),
      child: Column(
        children: [
          const ScreenTitle(title: "Congress Stock Trades"),
          Expanded(
            child: ListView.separated(
                itemBuilder: (context, index) {
                  return CongressionalItem(index: index);
                },
                separatorBuilder: (context, index) {
                  return Divider(
                    color: ThemeColors.greyBorder,
                    height: 15.sp,
                  );
                },
                itemCount: 20),
          ),
        ],
      ),
    );
  }
}
