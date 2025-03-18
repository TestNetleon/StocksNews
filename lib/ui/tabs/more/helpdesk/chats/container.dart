import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/api/api_response.dart';
import 'package:stocks_news_new/managers/helpdesk.dart';
import 'package:stocks_news_new/models/helpdesk_chat_res.dart';
import 'package:stocks_news_new/ui/base/bottom_sheet.dart';
import 'package:stocks_news_new/ui/tabs/more/helpdesk/chats/item.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/utils/utils.dart';
import 'package:stocks_news_new/utils/validations.dart';
import 'package:stocks_news_new/widgets/custom/base_loader_container.dart';
import 'package:stocks_news_new/widgets/custom/refresh_indicator.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import 'package:stocks_news_new/widgets/theme_input_field.dart';

import 'image_type.dart';

class AllChatNewListing extends StatefulWidget {
  final String ticketId;
  const AllChatNewListing({super.key, required this.ticketId});

  @override
  State<AllChatNewListing> createState() => _AllChatNewListingState();
}

class _AllChatNewListingState extends State<AllChatNewListing> {
  bool show = true;
  final picker = ImagePicker();
  File? _image;
  TextEditingController controller = TextEditingController();
  _onTap() {
    NewHelpDeskManager provider = context.read<NewHelpDeskManager>();
    provider.getAllChats(
      ticketId: widget.ticketId,
      showProgress: false,
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Timer(const Duration(seconds: 5), () {
        show = false;
        setState(() {});
      });
    });
  }

  void _selectOption() {
    BaseBottomSheet().bottomSheet(
        barrierColor: ThemeColors.neutral5.withValues(alpha: 0.7),
        child: MyAccountImageType(
          onCamera: () => _pickImage(source: ImageSource.camera),
          onGallery: () => _pickImage(),
        ));
  }

  Future _pickImage({ImageSource? source}) async {
    Navigator.pop(context);
    closeKeyboard();
    try {
      XFile? pickedFile =
          await picker.pickImage(source: source ?? ImageSource.gallery);
      if (pickedFile != null) {
        File file = File(pickedFile.path);
        _image = file;
        setState(() {});
      }

      Utils().showLog("${pickedFile?.name}");
    } catch (e) {
      Utils().showLog("Error => $e");
    }
  }

  Future _onReplyTicketClick() async {
    NewHelpDeskManager manager = context.read<NewHelpDeskManager>();

    closeKeyboard();

    if (isEmpty(controller.text) && _image == null) {
      return;
    }

    try {
      ApiResponse res = await manager.replyTicketNew(
        image: _image,
        ticketId: widget.ticketId,
        message: controller.text,
        ticketNo: '${manager.chatData?.chatRes?.ticketNo ?? ''}',
      );
      if (res.status) {
        _image = null;
        controller.text = '';
        setState(() {});
      }
    } catch (e) {
      //
    }
  }

  @override
  Widget build(BuildContext context) {
    NewHelpDeskManager manager = context.watch<NewHelpDeskManager>();
    return Column(
      children: [
        manager.chatData?.chatRes?.logs?.isEmpty == true &&
                manager.chatData == null
            ? const SizedBox()
            : Expanded(
                child: BaseLoaderContainer(
                  error: manager.error ?? "",
                  hasData: manager.chatData != null &&
                      manager.chatData?.chatRes?.logs?.isNotEmpty == true,
                  isLoading: manager.isLoading && !manager.removeLoader,
                  showPreparingText: true,
                  onRefresh: _onTap,
                  child: CommonRefreshIndicator(
                    onRefresh: () async => _onTap(),
                    child: Column(
                      children: [
                        Visibility(
                          visible: manager.chatData?.chatRes?.subject != null &&
                              manager.chatData?.chatRes?.subject != '',
                          child: Container(
                            margin: const EdgeInsets.only(top: 20),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              // color: ThemeColors.splashBG,
                              color: ThemeColors.splashBG,
                            ),
                            padding: const EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: 15,
                            ),
                            child: Text(
                              manager.chatData?.chatRes?.subject ?? "",
                              style: styleBaseBold(
                                color: ThemeColors.white,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                        const SpacerVertical(),
                        Expanded(
                          child: ListView.builder(
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            //physics: const NeverScrollableScrollPhysics(),
                            itemCount: manager.chatData?.chatRes?.logs?.length,
                            itemBuilder: (context, index) {
                              Log? logs =
                                  manager.chatData?.chatRes?.logs?[index];
                              if (logs == null) {
                                return SizedBox();
                              }
                              return HelpDeskAllChatsItemNew(logs: logs);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
        if (manager.chatData?.chatRes?.logs != null &&
            manager.chatData?.chatRes?.logs?.isNotEmpty == true)
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Visibility(
                            visible:
                                manager.chatData?.chatRes?.closeMsg != null &&
                                    show &&
                                    !manager.isLoading,
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: Text(
                                manager.chatData?.chatRes?.closeMsg ?? "",
                                style:
                                    styleBaseBold(color: ThemeColors.error120),
                              ),
                            ),
                          ),
                          Visibility(
                            visible: _image != null,
                            child: Stack(
                              alignment: Alignment.topRight,
                              children: [
                                Container(
                                  margin:
                                      const EdgeInsets.only(top: 10, right: 10),
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: Image.file(
                                    height: 100,
                                    width: 100,
                                    fit: BoxFit.cover,
                                    File(
                                      _image?.path ?? "",
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    _image = null;
                                    setState(() {});
                                  },
                                  child: CircleAvatar(
                                    radius: 11,
                                    backgroundColor: ThemeColors.error120,
                                    child: Icon(
                                      Icons.close,
                                      size: 15,
                                      color: ThemeColors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (manager.chatData?.chatRes?.status != 3)
                            Stack(
                              alignment: Alignment.centerRight,
                              children: [
                                ThemeInputField(
                                  contentPadding:
                                      const EdgeInsets.fromLTRB(10, 10, 80, 10),
                                  controller: controller,
                                  placeholder: "Message",
                                  keyboardType: TextInputType.multiline,
                                  textInputAction: TextInputAction.newline,
                                  inputFormatters: [allSpecialSymbolsRemove],
                                  minLines: 1,
                                  maxLines: 4,
                                  maxLength: 500,
                                  textCapitalization: TextCapitalization.none,
                                  isUnderline: false,
                                  fillColor: ThemeColors.neutral5,
                                ),
                                Positioned(
                                  right: 0,
                                  child: Row(
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          closeKeyboard();

                                          _selectOption();
                                        },
                                        child: const Icon(
                                          Icons.attach_file,
                                          color: ThemeColors.greyBorder,
                                        ),
                                      ),
                                      IconButton(
                                          icon: const Icon(Icons.send),
                                          onPressed: () =>
                                              _onReplyTicketClick(),
                                          color: ThemeColors.splashBG),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
      ],
    );
  }
}
