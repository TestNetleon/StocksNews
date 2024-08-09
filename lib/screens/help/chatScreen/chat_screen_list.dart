// import 'dart:async';
// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:provider/provider.dart';
// import 'package:stocks_news_new/api/api_response.dart';
// import 'package:stocks_news_new/providers/help_desk_provider.dart';
// import 'package:stocks_news_new/route/my_app.dart';
// import 'package:stocks_news_new/screens/help/chatScreen/chat_screen_item.dart';
// import 'package:stocks_news_new/screens/help/widget/send_ticket_item.dart';
// import 'package:stocks_news_new/utils/colors.dart';
// import 'package:stocks_news_new/utils/theme.dart';
// import 'package:stocks_news_new/utils/utils.dart';
// import 'package:stocks_news_new/utils/validations.dart';
// import 'package:stocks_news_new/widgets/base_ui_container.dart';
// import 'package:stocks_news_new/widgets/custom/refresh_indicator.dart';
// import 'package:stocks_news_new/widgets/spacer_vertical.dart';
// import 'package:stocks_news_new/widgets/theme_input_field.dart';

// import '../../../utils/bottom_sheets.dart';
// import '../../myAccount/widgets/select_type.dart';

// class ChatScreenList extends StatefulWidget {
//   final String? slug;
//   final String? ticketId;

//   const ChatScreenList({this.slug, this.ticketId, super.key});

//   @override
//   State<ChatScreenList> createState() => _ChatScreenListState();
// }

// class _ChatScreenListState extends State<ChatScreenList> {
//   bool show = true;
//   final ScrollController _scrollController =
//       ScrollController(); // Step 1: ScrollController

//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
//       HelpDeskProvider provider = context.read<HelpDeskProvider>();
//       Timer(const Duration(seconds: 5), () {
//         show = false;
//         setState(() {});
//       });
//       provider.setSlug(widget.slug, widget.ticketId ?? "");
//       if (widget.ticketId != "" && widget.slug != "0") {
//         provider.getHelpDeskChatScreen(loaderChatMessage: "0");
//       }
//     });
//     // _scrollToBottom();
//   }

//   @override
//   void dispose() {
//     _scrollController.dispose(); // Step 6: Dispose ScrollController
//     super.dispose();
//   }

//   void _scrollToBottom() {
//     // Step 4: Scroll to the bottom of the list
//     _scrollController.animateTo(
//       _scrollController.position.maxScrollExtent,
//       duration: const Duration(milliseconds: 300),
//       curve: Curves.easeOut,
//     );
//   }

//   final picker = ImagePicker();
//   File? _image;

//   void _selectOption() {
//     BaseBottomSheets().gradientBottomSheet(
//         child: MyAccountImageType(
//       onCamera: () => _pickImage(source: ImageSource.camera),
//       onGallery: () => _pickImage(),
//     ));
//   }

//   Future _pickImage({ImageSource? source}) async {
//     Navigator.pop(navigatorKey.currentContext!);
//     closeKeyboard();
//     try {
//       XFile? pickedFile =
//           await picker.pickImage(source: source ?? ImageSource.gallery);
//       if (pickedFile != null) {
//         File file = File(pickedFile.path);
//         _image = file;
//         setState(() {});
//       }

//       Utils().showLog("${pickedFile?.name}");
//     } catch (e) {
//       Utils().showLog("Error => $e");
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     HelpDeskProvider provider = context.watch<HelpDeskProvider>();
//     return provider.slug == "0"
//         ? const SendTicketItem()
//         : Column(
//             children: [
//               provider.chatData?.logs?.isEmpty == true &&
//                       provider.chatData == null
//                   ? const SizedBox()
//                   : Expanded(
//                       child: BaseUiContainer(
//                         isFull: true,
//                         error: provider.error ?? "",
//                         hasData: provider.chatData != null &&
//                             provider.chatData?.logs?.isNotEmpty == true,
//                         isLoading: provider.isLoading,
//                         errorDispCommon: true,
//                         showPreparingText: true,
//                         onRefresh: () => provider.getHelpDeskChatScreen(),
//                         child: CommonRefreshIndicator(
//                           onRefresh: () => provider.getHelpDeskChatScreen(),
//                           child: SingleChildScrollView(
//                             physics: const AlwaysScrollableScrollPhysics(),
//                             reverse: true,
//                             controller: _scrollController,
//                             child: Column(
//                               children: [
//                                 Visibility(
//                                   visible: provider.chatData?.subject != null &&
//                                       provider.chatData?.subject != '',
//                                   child: Container(
//                                     margin: const EdgeInsets.only(top: 20),
//                                     decoration: BoxDecoration(
//                                       borderRadius: BorderRadius.circular(30),
//                                       color:
//                                           const Color.fromARGB(255, 61, 61, 61),
//                                     ),
//                                     padding: const EdgeInsets.symmetric(
//                                         vertical: 10, horizontal: 15),
//                                     child: Text(
//                                       provider.chatData?.subject ?? "",
//                                       style: styleGeorgiaBold(
//                                           color: Colors.white, fontSize: 18),
//                                     ),
//                                   ),
//                                 ),
//                                 const SpacerVertical(),
//                                 ListView.builder(
//                                   padding: EdgeInsets.zero,
//                                   shrinkWrap: true,
//                                   physics: const NeverScrollableScrollPhysics(),
//                                   itemCount: provider.chatData?.logs?.length,
//                                   itemBuilder: (context, index) {
//                                     return ChatScreenItem(index: index);
//                                   },
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//               if (provider.loaderChatMessage == "0" ||
//                   (provider.chatData?.logs != null &&
//                       provider.chatData?.logs?.isNotEmpty == true))
//                 Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 10, vertical: 20),
//                       child: Row(
//                         children: [
//                           Expanded(
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Visibility(
//                                   visible:
//                                       provider.chatData?.closeMsg != null &&
//                                           show,
//                                   child: Padding(
//                                     padding: const EdgeInsets.only(bottom: 10),
//                                     child: Text(
//                                       provider.chatData?.closeMsg ?? "",
//                                       style: stylePTSansBold(
//                                           color: ThemeColors.sos),
//                                     ),
//                                   ),
//                                 ),
//                                 Visibility(
//                                   visible: _image != null,
//                                   child: Stack(
//                                     alignment: Alignment.topRight,
//                                     children: [
//                                       Container(
//                                         margin: const EdgeInsets.only(
//                                             top: 10, right: 10),
//                                         padding:
//                                             const EdgeInsets.only(bottom: 10),
//                                         child: Image.file(
//                                           height: 100,
//                                           width: 100,
//                                           fit: BoxFit.cover,
//                                           File(
//                                             _image?.path ?? "",
//                                           ),
//                                         ),
//                                       ),
//                                       InkWell(
//                                         onTap: () {
//                                           _image = null;
//                                           setState(() {});
//                                         },
//                                         child: const CircleAvatar(
//                                           radius: 11,
//                                           backgroundColor: ThemeColors.sos,
//                                           child: Icon(
//                                             Icons.close,
//                                             size: 15,
//                                             color: ThemeColors.white,
//                                           ),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                                 Stack(
//                                   alignment: Alignment.centerRight,
//                                   children: [
//                                     ThemeInputField(
//                                       contentPadding: const EdgeInsets.fromLTRB(
//                                           10, 10, 80, 10),
//                                       controller: provider.messageController,
//                                       placeholder: "Message",
//                                       keyboardType: TextInputType.multiline,
//                                       textInputAction: TextInputAction.newline,
//                                       inputFormatters: [
//                                         allSpecialSymbolsRemove
//                                       ],
//                                       minLines: 1,
//                                       maxLines: 4,
//                                       maxLength: 500,
//                                       textCapitalization:
//                                           TextCapitalization.none,
//                                     ),
//                                     Positioned(
//                                       right: 0,
//                                       child: Row(
//                                         children: [
//                                           InkWell(
//                                             onTap: () {
//                                               closeKeyboard();

//                                               _selectOption();
//                                             },
//                                             child: const Icon(
//                                               Icons.attach_file,
//                                               color: ThemeColors.greyBorder,
//                                             ),
//                                           ),
//                                           IconButton(
//                                               icon: const Icon(Icons.send),
//                                               onPressed: () =>
//                                                   _onReplyTicketClick(),
//                                               color: ThemeColors.accent),
//                                         ],
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//             ],
//           );
//   }

//   Future _onReplyTicketClick() async {
//     HelpDeskProvider provider =
//         navigatorKey.currentContext!.read<HelpDeskProvider>();

//     closeKeyboard();

//     if (isEmpty(provider.messageController.text) && _image == null) {
//       return;
//     }

//     try {
//       ApiResponse res = await provider.replyTicketNew(image: _image);
//       if (res.status) {
//         _image = null;
//         setState(() {});
//       }
//     } catch (e) {
//       //
//     }
//   }
// }
