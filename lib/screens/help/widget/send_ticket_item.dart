import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/providers/help_desk_provider.dart';
import 'package:stocks_news_new/route/my_app.dart';
import 'package:stocks_news_new/screens/help/widget/reason_bottom_list.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/utils/utils.dart';
import 'package:stocks_news_new/utils/validations.dart';
import 'package:stocks_news_new/widgets/theme_input_field.dart';

class SendTicketItem extends StatelessWidget {
  const SendTicketItem({super.key});

  @override
  Widget build(BuildContext context) {
    HelpDeskProvider provider = context.watch<HelpDeskProvider>();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.all(8),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            child: Text(
              provider.reasonController.text,
              style: styleGeorgiaBold(color: Colors.white, fontSize: 18),
            ),
          ),
        ),
        const Expanded(child: SizedBox()),
        if (isEmpty(provider.reasonController.text))
          Container(
              constraints: const BoxConstraints(maxHeight: 400),
              decoration: const BoxDecoration(
                  color: ThemeColors.primaryLight,
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20))),
              padding: const EdgeInsets.all(20),
              child: const SingleChildScrollView(
                  child: SelectReasonBottomSheet())),
        if (!isEmpty(provider.reasonController.text))
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: ThemeInputField(
                        contentPadding:
                            const EdgeInsets.fromLTRB(10, 10, 30, 10),
                        controller: provider.messageController,
                        placeholder: "Message",
                        keyboardType: TextInputType.emailAddress,
                        inputFormatters: [allSpecialSymbolsRemove],
                        minLines: 1,
                        maxLines: 4,
                        maxLength: 200,
                        textCapitalization: TextCapitalization.none,
                      ),
                    ),
                    IconButton(
                        icon: const Icon(Icons.send),
                        onPressed: () => _onSendTicketClick(),
                        color: ThemeColors.accent),
                  ],
                ),
              ),
            ],
          ),
      ],
    );
  }

  void _onSendTicketClick() {
    HelpDeskProvider provider =
        navigatorKey.currentContext!.read<HelpDeskProvider>();
    provider.chatData?.logs?.clear();

    closeKeyboard();

    if (isEmpty(provider.messageController.text)) {
      return;
    }

    provider.sendTicket();
    return;
  }
}
