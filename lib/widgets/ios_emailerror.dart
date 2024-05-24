import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/route/my_app.dart';
import 'package:stocks_news_new/utils/constants.dart';

import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/utils/validations.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import 'package:stocks_news_new/widgets/theme_button.dart';
import 'package:stocks_news_new/widgets/theme_input_field.dart';

import '../providers/user_provider.dart';
import '../utils/dialogs.dart';

void showIosEmailError({String? state, String? dontPop}) {
  showPlatformBottomSheet(
      padding: EdgeInsets.symmetric(horizontal: 10.sp, vertical: 7.sp),
      context: navigatorKey.currentContext!,
      content: IOSemailError(
        state: state,
        dontPop: dontPop,
      ));
}

class IOSemailError extends StatefulWidget {
  final Function()? onPress;
  final String? state;
  final String? dontPop;
  const IOSemailError({super.key, this.onPress, this.state, this.dontPop});

  @override
  State<IOSemailError> createState() => _IOSemailErrorState();
}

class _IOSemailErrorState extends State<IOSemailError> {
  TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.sp),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Email Address",
            style: stylePTSansRegular(fontSize: 14),
          ),
          const SpacerVertical(height: 5),
          ThemeInputField(
            controller: controller,
            placeholder: "Enter email address",
            keyboardType: TextInputType.emailAddress,
            inputFormatters: [emailFormatter],
            textCapitalization: TextCapitalization.none,
          ),
          const SpacerVertical(height: Dimen.itemSpacing),
          ThemeButton(
            text: "Next",
            onPressed: () {
              UserProvider provider = context.read<UserProvider>();
              Map request = {
                "username": controller.text.toLowerCase(),
                "type": "email",
              };
              Navigator.pop(context);
              provider.login(request,
                  state: widget.state, dontPop: widget.dontPop);
            },
          ),
          const SpacerVertical(height: Dimen.itemSpacing),
        ],
      ),
    );
  }
}
