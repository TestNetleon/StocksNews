// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:provider/provider.dart';
// import 'package:stocks_news_new/providers/contact_us_provider.dart';
// import 'package:stocks_news_new/providers/user_provider.dart';
// import 'package:stocks_news_new/utils/colors.dart';

// import 'package:stocks_news_new/utils/utils.dart';
// import 'package:stocks_news_new/widgets/alphabet_inputformatter.dart';
// import 'package:stocks_news_new/widgets/custom/alert_popup.dart';
// import 'package:stocks_news_new/widgets/optional_parent.dart';
// import 'package:validators/validators.dart';

// import '../../utils/constants.dart';
// import '../../utils/theme.dart';
// import '../../utils/validations.dart';
// import '../../widgets/custom/comment_formatter.dart';
// import '../../widgets/spacer_vertical.dart';
// import '../../widgets/theme_button.dart';
// import '../../widgets/theme_input_field.dart';

// //
// class ContactUsItem extends StatefulWidget {
//   const ContactUsItem({super.key});

//   @override
//   State<ContactUsItem> createState() => _ContactUsItemState();
// }

// class _ContactUsItemState extends State<ContactUsItem> {
//   TextEditingController name = TextEditingController();
//   TextEditingController email = TextEditingController();
//   TextEditingController phone = TextEditingController();
//   TextEditingController comments = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       UserProvider provider = context.read<UserProvider>();
//       if (provider.user != null) {
//         setState(() {
//           name.text = provider.user?.name ?? "";
//           email.text = provider.user?.email ?? "";
//         });
//         // phone.text = provider.user?.name ?? "";
//       }
//     });
//   }

//   void _onTap() async {
//     closeKeyboard();
//     if (!isName(name.text)) {
//       popUpAlert(
//         message: "Please enter valid name",
//         title: "Alert",
//         icon: Images.alertPopGIF,
//       );

//       // showErrorMessage(message: "Please enter valid name");
//     } else if (!isEmail(email.text) || email.text.isEmpty) {
//       popUpAlert(
//         message: "Please enter valid email address",
//         title: "Alert",
//         icon: Images.alertPopGIF,
//       );
//       // showErrorMessage(message: "Please enter valid email address");
//     }

//     //  else if (!isNumeric(phone.text) &&
//     //     (isEmpty(phone.text) || !isLength(phone.text, 10))) {
//     //   showErrorMessage(message: "Please enter valid phone number");
//     // }

//     else if (comments.text.isEmpty) {
//       popUpAlert(
//           message: "Please enter your comment",
//           title: "Alert",
//           icon: Images.alertPopGIF);
//       // showErrorMessage(message: "Please enter your comment");
//     } else {
//       context.read<ContactUsProvider>().contactUS(
//             name: name,
//             email: email,
//             message: comments,
//           );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.all(Dimen.padding.sp),
//       decoration: BoxDecoration(
//           border: Border.all(color: ThemeColors.accent),
//           borderRadius: BorderRadius.circular(10.sp)),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           showAsteriskText(text: "Name"),
//           const SpacerVertical(height: 5),
//           ThemeInputField(
//             textCapitalization: TextCapitalization.words,
//             controller: name,
//             placeholder: "Enter your name",
//             keyboardType: TextInputType.name,
//             inputFormatters: [AlphabetInputFormatter()],
//           ),
//           const SpacerVertical(height: 10),
//           // Text(
//           //   "Email Id",
//           //   style: styleBaseRegular(fontSize: 14),
//           // ),

//           showAsteriskText(text: "Email"),

//           const SpacerVertical(height: 5),
//           ThemeInputField(
//             controller: email,
//             placeholder: "Enter your email address",
//             keyboardType: TextInputType.emailAddress,
//             inputFormatters: [emailFormatter],
//           ),
//           // const SpacerVertical(height: 10),
//           // Text(
//           //   "Phone Number",
//           //   style: styleBaseRegular(fontSize: 14),
//           // ),
//           // _richText(text: "Phone Number"),

//           // const SpacerVertical(height: 5),
//           // ThemeInputField(
//           //   controller: phone,
//           //   placeholder: "Enter your phone number",
//           //   keyboardType: TextInputType.phone,
//           //   inputFormatters: [
//           //     FilteringTextInputFormatter.digitsOnly,
//           //   ],
//           // ),
//           const SpacerVertical(height: 10),
//           // Text(
//           //   "Comments",
//           //   style: styleBaseRegular(fontSize: 14),
//           // ),
//           showAsteriskText(text: "Comment"),

//           const SpacerVertical(height: 5),
//           ThemeInputField(
//             minLines: 5,
//             maxLength: 250,
//             controller: comments,
//             placeholder: "Enter your comment",
//             inputFormatters: [CustomCommentInputFormatter()],
//             keyboardType: TextInputType.text,
//           ),
//           const SpacerVertical(height: 25),
//           ThemeButton(
//             text: "Submit",
//             onPressed: _onTap,
//           ),
//         ],
//       ),
//     );
//   }
// }

// Widget showAsteriskText({
//   required String text,
//   bool showAsterisk = true,
//   bool bold = false,
// }) {
//   return OptionalParent(
//     addParent: showAsterisk,
//     parentBuilder: (child) {
//       return RichText(
//         text: TextSpan(
//           text: text,
//           style: bold
//               ? styleBaseBold(fontSize: 14)
//               : styleBaseRegular(fontSize: 14),
//           children: [
//             TextSpan(
//               text: ' *',
//               style: styleBaseBold(fontSize: 15, color: ThemeColors.sos),
//             ),
//           ],
//         ),
//       );
//     },
//     child: Text(
//       text,
//       style: bold
//           ? styleBaseBold(fontSize: 15)
//           : styleBaseRegular(fontSize: 15),
//     ),
//   );
// }
