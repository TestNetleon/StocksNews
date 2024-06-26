import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/providers/help_desk_provider.dart';
import 'package:stocks_news_new/route/my_app.dart';
import 'package:stocks_news_new/screens/help/chatScreen/chat_screen_item.dart';
import 'package:stocks_news_new/screens/help/widget/send_ticket_item.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/utils/utils.dart';
import 'package:stocks_news_new/utils/validations.dart';
import 'package:stocks_news_new/widgets/base_ui_container.dart';
import 'package:stocks_news_new/widgets/custom/refresh_indicator.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import 'package:stocks_news_new/widgets/theme_input_field.dart';

class ChatScreenList extends StatefulWidget {
  final String? slug;
  final String? ticketId;

  const ChatScreenList({this.slug, this.ticketId, super.key});

  @override
  State<ChatScreenList> createState() => _ChatScreenListState();
}

class _ChatScreenListState extends State<ChatScreenList> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      HelpDeskProvider provider = context.read<HelpDeskProvider>();

      provider.setSlug(widget.slug, widget.ticketId ?? "");
      if (widget.ticketId != "" && widget.slug != "0") {
        provider.getHelpDeskChatScreen(loaderChatMessage: "0");
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    HelpDeskProvider provider = context.watch<HelpDeskProvider>();
    return provider.slug == "0"
        ? const SendTicketItem()
        : Column(
            children: [
              provider.chatData?.logs?.isEmpty == true &&
                      provider.chatData == null
                  ? const SizedBox()
                  : Expanded(
                      child: BaseUiContainer(
                        isFull: true,
                        error: provider.error ?? "",
                        hasData: provider.chatData != null &&
                            provider.chatData?.logs?.isNotEmpty == true,
                        isLoading: provider.isLoading,
                        errorDispCommon: true,
                        showPreparingText: true,
                        onRefresh: () => provider.getHelpDeskChatScreen(),
                        child: CommonRefreshIndicator(
                          onRefresh: () => provider.getHelpDeskChatScreen(),
                          child: SingleChildScrollView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            child: Column(
                              children: [
                                Visibility(
                                  visible: provider.chatData?.subject != null &&
                                      provider.chatData?.subject != '',
                                  child: Container(
                                    margin: const EdgeInsets.only(top: 20),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30),
                                      color:
                                          const Color.fromARGB(255, 61, 61, 61),
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
                                    return ChatScreenItem(index: index);
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
              if (provider.loaderChatMessage == "0" ||
                  (provider.chatData?.logs != null &&
                      provider.chatData?.logs?.isNotEmpty == true))
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 20),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              children: [
                                Visibility(
                                  visible: provider.chatData?.closeMsg != null,
                                  child: Padding(
                                    padding: const EdgeInsets.only(bottom: 10),
                                    child: Text(
                                      provider.chatData?.closeMsg ?? "",
                                      style: stylePTSansBold(
                                          color: ThemeColors.sos),
                                    ),
                                  ),
                                ),
                                Stack(
                                  children: [
                                    ThemeInputField(
                                      contentPadding: const EdgeInsets.fromLTRB(
                                          10, 10, 30, 10),
                                      controller: provider.messageController,
                                      placeholder: "Message",
                                      keyboardType: TextInputType.text,
                                      inputFormatters: [
                                        allSpecialSymbolsRemove
                                      ],
                                      minLines: 1,
                                      maxLines: 4,
                                      maxLength: 200,
                                      textCapitalization:
                                          TextCapitalization.none,
                                    ),
                                    Positioned(
                                      right: 0,
                                      child: IconButton(
                                          icon: const Icon(Icons.send),
                                          onPressed: () =>
                                              _onReplyTicketClick(),
                                          color: ThemeColors.accent),
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

  void _onReplyTicketClick() {
    HelpDeskProvider provider =
        navigatorKey.currentContext!.read<HelpDeskProvider>();

    closeKeyboard();

    if (isEmpty(provider.messageController.text)) {
      return;
    }

    provider.replyTicket();
  }
}
