import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/providers/help_desk_provider.dart';
import 'package:stocks_news_new/route/my_app.dart';
import 'package:stocks_news_new/screens/help/chatScreen/chat_screen_item.dart';
import 'package:stocks_news_new/screens/help/widget/send_ticket_item.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/utils.dart';
import 'package:stocks_news_new/utils/validations.dart';
import 'package:stocks_news_new/widgets/base_ui_container.dart';
import 'package:stocks_news_new/widgets/loading.dart';
import 'package:stocks_news_new/widgets/refresh_controll.dart';
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

      provider.getHelpDeskChatScreen(loaderChatMessage: "0");
    });
  }

  @override
  Widget build(BuildContext context) {
    HelpDeskProvider provider = context.watch<HelpDeskProvider>();

    return provider.slug == "0"
        ? const SendTicketItem()
        : Column(
            children: [
              const SpacerVertical(),
              provider.chatData?.logs?.isEmpty == true &&
                      provider.chatData == null
                  ? const SizedBox()
                  : Expanded(
                      child: BaseUiContainer(
                        error: provider.error ?? "",
                        hasData: provider.chatData != null &&
                            provider.chatData?.logs?.isNotEmpty == true,
                        isLoading: provider.isLoading,
                        errorDispCommon: true,
                        showPreparingText: true,
                        onRefresh: () => provider.getHelpDeskChatScreen(),
                        child: RefreshControl(
                          onRefresh: () async =>
                              provider.getHelpDeskChatScreen(),
                          canLoadMore: false,
                          onLoadMore: () async => {},
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: provider.chatData?.logs?.length,
                            itemBuilder: (context, index) {
                              return ChatScreenItem(index: index);
                            },
                          ),
                        ),
                      ),
                    ),
              if (provider.loaderChatMessage == "0" ||
                  (provider.chatData?.logs != null &&
                      provider.chatData?.logs?.isNotEmpty == true))
                Positioned(
                  bottom: 10,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Row(
                          children: [
                            Expanded(
                              child: ThemeInputField(
                                controller: provider.messageController,
                                placeholder: "Enter your query",
                                keyboardType: TextInputType.emailAddress,
                                inputFormatters: [allSpecialSymbolsRemove],
                                minLines: 4,
                                textCapitalization: TextCapitalization.none,
                              ),
                            ),
                            IconButton(
                                icon: const Icon(Icons.send),
                                onPressed: () => _onReplyTicketClick(),
                                color: ThemeColors.accent),
                          ],
                        ),
                      ),
                    ],
                  ),
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
