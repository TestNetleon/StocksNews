import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stocks_news_new/api/api_response.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

class FilterListing extends StatelessWidget {
  final List<KeyValueElement> items;
  final Function(int) onSelected;
  const FilterListing(
      {super.key, required this.items, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(18.sp),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color.fromARGB(255, 23, 23, 23),
            // ThemeColors.greyBorder,
            Color.fromARGB(255, 48, 48, 48),
          ],
        ),
      ),
      child: ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 10.sp, vertical: 10.sp),
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                onSelected(index);
                Navigator.pop(context);
              },
              child: Center(
                child: Text(
                  items[index].value ?? "",
                  style: stylePTSansRegular(fontSize: 16),
                ),
              ),
            );
          },
          separatorBuilder: (context, index) {
            return const Divider(
              height: 20,
              color: ThemeColors.greyBorder,
            );
          },
          itemCount: items.length),
    );
  }
}
