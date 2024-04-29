import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/providers/all_stocks_provider.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/widgets/spacer_verticle.dart';

class TextFieldChangePercentage extends StatelessWidget {
  const TextFieldChangePercentage({super.key});

  @override
  Widget build(BuildContext context) {
    AllStocksProvider provider = context.watch<AllStocksProvider>();
//
    return TextField(
      controller: provider.controller,
      onChanged: (value) => provider.onChanged(value),
      keyboardType: TextInputType.phone,
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^-?\d{0,7}$')),
        LengthLimitingTextInputFormatter(7),
      ],
      decoration: InputDecoration(
        hintText: "Enter Percentage Change",
        contentPadding:
            EdgeInsets.symmetric(horizontal: 10.sp, vertical: 10.sp),
        fillColor: ThemeColors.white,
        filled: true,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.sp),
          borderSide: const BorderSide(color: ThemeColors.greyBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.sp),
          borderSide: const BorderSide(color: ThemeColors.accent),
        ),
        suffixIcon: Padding(
          padding: EdgeInsets.all(3.sp),
          child: Column(
            children: [
              InkWell(
                onTap: provider.incrementCounter,
                child: Container(
                  decoration: BoxDecoration(
                      color: ThemeColors.divider,
                      borderRadius: BorderRadius.circular(5.sp)),
                  width: 40.sp,
                  child: Icon(
                    Icons.arrow_drop_up,
                    size: 20.sp,
                  ),
                ),
              ),
              const SpacerVerticel(height: 2),
              InkWell(
                onTap: provider.decrementCounter,
                child: Container(
                  width: 40.sp,
                  decoration: BoxDecoration(
                      color: ThemeColors.divider,
                      borderRadius: BorderRadius.circular(5.sp)),
                  child: Icon(
                    Icons.arrow_drop_down,
                    size: 20.sp,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
