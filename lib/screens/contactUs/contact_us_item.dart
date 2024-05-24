import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/providers/contact_us_provider.dart';
import 'package:stocks_news_new/utils/colors.dart';

import 'package:stocks_news_new/utils/utils.dart';
import 'package:stocks_news_new/widgets/alphabet_inputformatter.dart';
import 'package:stocks_news_new/widgets/optiona_parent.dart';
import 'package:validators/validators.dart';

import '../../utils/constants.dart';
import '../../utils/theme.dart';
import '../../utils/validations.dart';
import '../../widgets/custom/comment_formatter.dart';
import '../../widgets/spacer_vertical.dart';
import '../../widgets/theme_button.dart';
import '../../widgets/theme_input_field.dart';

//
class ContactUsItem extends StatefulWidget {
  const ContactUsItem({super.key});

  @override
  State<ContactUsItem> createState() => _ContactUsItemState();
}

class _ContactUsItemState extends State<ContactUsItem> {
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController comments = TextEditingController();

  void _onTap() async {
    closeKeyboard();
    if (!isName(name.text)) {
      // showErrorMessage(message: "Please enter valid name");
    } else if (!isEmail(email.text) && email.text.isNotEmpty) {
      // showErrorMessage(message: "Please enter valid email address");
    }

    //  else if (!isNumeric(phone.text) &&
    //     (isEmpty(phone.text) || !isLength(phone.text, 10))) {
    //   showErrorMessage(message: "Please enter valid phone number");
    // }

    else if (comments.text.isEmpty) {
      // showErrorMessage(message: "Please enter your comment");
    } else {
      context.read<ContactUsProvider>().contactUS(
            name: name,
            email: email,
            message: comments,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(Dimen.padding.sp),
      decoration: BoxDecoration(
          border: Border.all(color: ThemeColors.accent),
          borderRadius: BorderRadius.circular(10.sp)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _richText(text: "Name"),
          const SpacerVertical(height: 5),
          ThemeInputField(
            textCapitalization: TextCapitalization.words,
            controller: name,
            placeholder: "Enter your name",
            keyboardType: TextInputType.name,
            inputFormatters: [AlphabetInputFormatter()],
          ),
          const SpacerVertical(height: 10),
          // Text(
          //   "Email Id",
          //   style: stylePTSansRegular(fontSize: 14),
          // ),

          _richText(text: "Email"),

          const SpacerVertical(height: 5),
          ThemeInputField(
            controller: email,
            placeholder: "Enter your email address",
            keyboardType: TextInputType.emailAddress,
            inputFormatters: [emailFormatter],
          ),
          // const SpacerVertical(height: 10),
          // Text(
          //   "Phone Number",
          //   style: stylePTSansRegular(fontSize: 14),
          // ),
          // _richText(text: "Phone Number"),

          // const SpacerVertical(height: 5),
          // ThemeInputField(
          //   controller: phone,
          //   placeholder: "Enter your phone number",
          //   keyboardType: TextInputType.phone,
          //   inputFormatters: [
          //     FilteringTextInputFormatter.digitsOnly,
          //   ],
          // ),
          const SpacerVertical(height: 10),
          // Text(
          //   "Comments",
          //   style: stylePTSansRegular(fontSize: 14),
          // ),
          _richText(text: "Comment"),

          const SpacerVertical(height: 5),
          ThemeInputField(
            minLines: 5,
            maxLength: 250,
            controller: comments,
            placeholder: "Enter your comment",
            inputFormatters: [CustomCommentInputFormatter()],
            keyboardType: TextInputType.text,
          ),
          const SpacerVertical(height: 25),
          ThemeButton(
            text: "Submit",
            onPressed: _onTap,
          ),
        ],
      ),
    );
  }

  Widget _richText({required String text, bool showAsterisk = true}) {
    return OptionalParent(
      addParent: showAsterisk,
      parentBuilder: (child) {
        return RichText(
          text: TextSpan(
            text: text,
            style: stylePTSansRegular(fontSize: 14),
            children: [
              TextSpan(
                text: ' *',
                style: stylePTSansBold(fontSize: 14, color: ThemeColors.sos),
              ),
            ],
          ),
        );
      },
      child: Text(
        text,
        style: stylePTSansRegular(fontSize: 14),
      ),
    );
  }
}
