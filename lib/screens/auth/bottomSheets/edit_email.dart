import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/providers/user_provider.dart';
import 'package:stocks_news_new/route/my_app.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/dialogs.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import 'package:validators/validators.dart';

import '../../../utils/constants.dart';
import '../../../utils/validations.dart';
import '../../../widgets/theme_button.dart';
import '../../../widgets/theme_input_field.dart';

class EditEmail extends StatelessWidget {
  final String email;
  const EditEmail({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    // return Text(
    //   "Please enter the 4-digit verification code that was sent to $email. The code is valid for 10 minutes.",
    //   style: stylePTSansRegular(
    //     fontSize: 14,
    //     color: Colors.white,
    //   ),
    // );

    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: "$email.",
            style: stylePTSansRegular(fontSize: 14, color: ThemeColors.accent),
          ),
          TextSpan(
            text: " The code is valid for 10 minutes.",
            style: stylePTSansRegular(fontSize: 14),
          ),
        ],
        text: "Please enter the 4-digit verification code that was send to ",
        style: stylePTSansRegular(fontSize: 14),
      ),
    );
  }
}

class EditEmailClick extends StatefulWidget {
  final String email;
  final String? state;
  final String? dontPop;
  final bool fromLoginOTP;

  const EditEmailClick({
    super.key,
    required this.email,
    this.fromLoginOTP = true,
    this.state,
    this.dontPop,
  });

  @override
  State<EditEmailClick> createState() => _EditEmailClickState();
}

class _EditEmailClickState extends State<EditEmailClick> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    UserProvider provider = context.watch<UserProvider>();
    return Column(
      children: [
        Visibility(
          visible: !widget.fromLoginOTP,
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: widget.email,
                  style: stylePTSansRegular(
                      fontSize: 14, color: ThemeColors.accent),
                ),
                TextSpan(
                  text: " is not your email address, click here to edit it.",
                  style: stylePTSansRegular(fontSize: 14),
                ),
              ],
              text: "If ",
              style: stylePTSansRegular(fontSize: 14),
            ),
          ),
        ),
        const SpacerVertical(
          height: 16,
        ),
        Visibility(
          visible: !widget.fromLoginOTP,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 53, 125, 62),
              padding: EdgeInsets.symmetric(horizontal: 10.sp),
              maximumSize: Size(200.sp, 30.sp),
              minimumSize: Size(60.sp, 28.sp),
            ),
            onPressed: () {
              _openEditSheet(controller: _controller, provider: provider);
            },
            child: Text(
              "Edit Email Address",
              style: stylePTSansRegular(fontSize: 13),
            ),
          ),
        ),
      ],
    );
  }

  void _openEditSheet(
      {TextEditingController? controller, required UserProvider provider}) {
    showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(5.sp),
          topRight: Radius.circular(5.sp),
        ),
      ),
      backgroundColor: ThemeColors.transparent,
      isScrollControlled: true,
      context: navigatorKey.currentContext!,
      builder: (context) {
        return Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10.sp),
                  topRight: Radius.circular(10.sp)),
              color: ThemeColors.background,
              border: const Border(
                top: BorderSide(color: ThemeColors.greyBorder),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 6.sp,
                  width: 50.sp,
                  margin: EdgeInsets.only(top: 8.sp),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.sp),
                    color: ThemeColors.greyBorder,
                  ),
                ),
                const SpacerVertical(height: 16),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.sp),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SpacerVertical(height: 40),
                      Text(
                        "NEW EMAIL ADDRESS",
                        style: stylePTSansBold(fontSize: 22),
                      ),
                      const SpacerVertical(height: 20),
                      ThemeInputField(
                        controller: controller,
                        placeholder: "Enter new email address",
                        keyboardType: TextInputType.emailAddress,
                        inputFormatters: [emailFormatter],
                        textCapitalization: TextCapitalization.none,
                      ),
                      const SpacerVertical(height: Dimen.itemSpacing),
                      ThemeButton(
                        text: "Next",
                        onPressed: _onPressed,
                      ),
                      const SpacerVertical(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _onPressed() {
    UserProvider provider = context.read<UserProvider>();
    if (!isEmail(_controller.text) && !isNumeric(_controller.text)) {
      showErrorMessage(
        duration: 10,
        snackbar: false,
        message: "Please enter valid email address",
      );

      return;
    }
    if (widget.fromLoginOTP) {
      Map request = {
        "username": _controller.text.toLowerCase(),
        "type": "email",
      };
      provider.login(
        request,
        state: widget.state,
        dontPop: widget.dontPop,
        editEmail: true,
      );
    } else {
      Map request = {"username": _controller.text.toLowerCase()};

      provider.signup(request, editEmail: true);
    }
    _controller.clear();
  }
}
