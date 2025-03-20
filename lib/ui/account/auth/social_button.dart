import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import '../../../utils/theme.dart';

class AccountSocialButton extends StatelessWidget {
  final String text;
  final void Function() onPressed;
  const AccountSocialButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        elevation: 0,
        minimumSize: const Size.fromHeight(45),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(color: Colors.black),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            height: 24.sp,
            width: 24.sp,
            text == 'Continue with Google'
                ? Images.googleSignUP
                : Images.appleSignUP,
          ),
          SpacerHorizontal(width: 8),
          Flexible(
            child: Text(
              text,
              style: styleBaseBold(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
