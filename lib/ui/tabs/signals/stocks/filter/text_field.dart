import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/managers/signals/stocks.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

class TextFieldChangePercentage extends StatefulWidget {
  const TextFieldChangePercentage({
    super.key,
    required this.onChanged,
    required this.onIncrement,
    required this.onDecrement,
    // required this.controller,
  });

  final Function(String)? onChanged;
  final Function()? onIncrement;
  final Function()? onDecrement;

  @override
  State<TextFieldChangePercentage> createState() =>
      _TextFieldChangePercentageState();
}

class _TextFieldChangePercentageState extends State<TextFieldChangePercentage> {
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SignalsStocksManager>().controller.addListener(() {
        widget.onChanged!(controller.text);
      });
    });
  }

  // final TextEditingController? controller;
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: context.watch<SignalsStocksManager>().controller,
      // onChanged: widget.onChanged,
      keyboardType: TextInputType.phone,
      inputFormatters: [
        // FilteringTextInputFormatter.allow(RegExp(r'^-?\d{0,7}$')),
        FilteringTextInputFormatter.allow(RegExp(r'^-?\d*$')),
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
                onTap: widget.onIncrement,
                child: Container(
                  decoration: BoxDecoration(
                    color: ThemeColors.neutral60,
                    borderRadius: BorderRadius.circular(5.sp),
                  ),
                  width: 40.sp,
                  child: Icon(
                    Icons.arrow_drop_up,
                    size: 20.sp,
                    color: ThemeColors.white,
                  ),
                ),
              ),
              const SpacerVertical(height: 2),
              InkWell(
                onTap: widget.onDecrement,
                child: Container(
                  width: 40.sp,
                  decoration: BoxDecoration(
                    color: ThemeColors.neutral60,
                    borderRadius: BorderRadius.circular(5.sp),
                  ),
                  child: Icon(
                    Icons.arrow_drop_down,
                    size: 20.sp,
                    color: ThemeColors.white,
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
