import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/providers/help_desk.dart';
import 'package:stocks_news_new/routes/my_app.dart';

import '../../../api/api_response.dart';
import '../../../utils/bottom_sheets.dart';
import '../../../utils/colors.dart';
import '../../../utils/theme.dart';
import '../../../utils/utils.dart';
import '../../../utils/validations.dart';
import '../../../widgets/base_ui_container.dart';
import '../../../widgets/custom/refresh_indicator.dart';
import '../../../widgets/spacer_vertical.dart';
import '../../../widgets/theme_input_field.dart';
import '../../myAccount/widgets/select_type.dart';
import 'item.dart';

class HelpDeskAllChatNewListing extends StatefulWidget {
  final String ticketId;
  const HelpDeskAllChatNewListing({super.key, required this.ticketId});

  @override
  State<HelpDeskAllChatNewListing> createState() =>
      _HelpDeskAllChatNewListingState();
}

class _HelpDeskAllChatNewListingState extends State<HelpDeskAllChatNewListing> {
  bool show = true;
  final picker = ImagePicker();
  File? _image;

  TextEditingController controller = TextEditingController();
  _onTap() {
    NewHelpDeskProvider provider =
        navigatorKey.currentContext!.read<NewHelpDeskProvider>();
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
    BaseBottomSheets().gradientBottomSheet(
        child: MyAccountImageType(
      onCamera: () => _pickImage(source: ImageSource.camera),
      onGallery: () => _pickImage(),
    ));
  }

  Future _pickImage({ImageSource? source}) async {
    Navigator.pop(navigatorKey.currentContext!);
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
    NewHelpDeskProvider provider =
        navigatorKey.currentContext!.read<NewHelpDeskProvider>();

    closeKeyboard();

    if (isEmpty(controller.text) && _image == null) {
      return;
    }

    try {
      ApiResponse res = await provider.replyTicketNew(
        image: _image,
        ticketId: widget.ticketId,
        message: controller.text,
        ticketNo: '${provider.chatData?.ticketNo ?? ''}',
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
    NewHelpDeskProvider provider = context.watch<NewHelpDeskProvider>();
    return Column(
      children: [
        provider.chatData?.logs?.isEmpty == true && provider.chatData == null
            ? const SizedBox()
            : Expanded(
                child: BaseUiContainer(
                  isFull: true,
                  error: provider.error ?? "",
                  hasData: provider.chatData != null &&
                      provider.chatData?.logs?.isNotEmpty == true,
                  isLoading: provider.isLoading && !provider.removeLoader,
                  errorDispCommon: true,
                  showPreparingText: true,
                  onRefresh: _onTap,
                  child: CommonRefreshIndicator(
                    onRefresh: () async => _onTap(),
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      reverse: true,
                      child: Column(
                        children: [
                          Visibility(
                            visible: provider.chatData?.subject != null &&
                                provider.chatData?.subject != '',
                            child: Container(
                              margin: const EdgeInsets.only(top: 20),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                color: const Color.fromARGB(255, 61, 61, 61),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 15),
                              child: Text(
                                provider.chatData?.subject ?? "",
                                style: styleGeorgiaBold(
                                    color: Colors.white, fontSize: 18),
                              ),
                            ),
                          ),
                          const SpacerVertical(),
                          ListView.builder(
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: provider.chatData?.logs?.length,
                            itemBuilder: (context, index) {
                              return HelpDeskAllChatsItemNew(index: index);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
        if (provider.chatData?.logs != null &&
            provider.chatData?.logs?.isNotEmpty == true)
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
                            visible: provider.chatData?.closeMsg != null &&
                                show &&
                                !provider.isLoading,
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: Text(
                                provider.chatData?.closeMsg ?? "",
                                style: stylePTSansBold(color: ThemeColors.sos),
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
                                  child: const CircleAvatar(
                                    radius: 11,
                                    backgroundColor: ThemeColors.sos,
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
                          if (provider.chatData?.status != 3)
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
                                          color: ThemeColors.accent),
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
