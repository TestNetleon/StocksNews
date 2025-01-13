import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/theme.dart';

DataCell dataCell({required String text, bool change = false, num? value}) {
  return DataCell(
    ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: ScreenUtil().screenWidth * .3,
      ),
      child: Text(
        // userPercent ? "$text%" : "$text",
        text,
        style: styleGeorgiaBold(
          fontSize: 12,
          // color: Colors.white,
          color: value != null
              ? (value >= 0 ? ThemeColors.accent : ThemeColors.sos)
              : Colors.white,
        ),
      ),
    ),
  );
}

DataColumn dataColumn({required String text, Function()? onTap, bool? sortBy}) {
  return DataColumn(
    label: InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 15,
        ),
        child: Row(
          children: [
            Text(
              text,
              style: styleGeorgiaBold(
                fontSize: 16,
                color: ThemeColors.greyText,
              ),
            ),
            if (sortBy != null)
              Container(
                margin: EdgeInsets.only(left: 5),
                child: FaIcon(
                  sortBy == true
                      ? FontAwesomeIcons.arrowDownLong
                      : FontAwesomeIcons.arrowUpLong,
                  size: 12,
                  color: ThemeColors.greyText,
                ),
              ),
          ],
        ),
      ),
    ),
  );
}
