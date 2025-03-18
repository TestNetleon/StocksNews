import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:photo_view/photo_view.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/models/helpdesk_chat_res.dart';
import 'package:stocks_news_new/ui/base/app_bar.dart';
import 'package:stocks_news_new/ui/base/scaffold.dart';
import 'package:stocks_news_new/ui/theme/manager.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

class HelpDeskAllChatsItemNew extends StatelessWidget {
  final Log logs;
  const HelpDeskAllChatsItemNew({required this.logs, super.key});

  @override
  Widget build(BuildContext context) {
    bool isDark = context.watch<ThemeManager>().isDarkMode;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Align(
        alignment:
            logs.replyFrom == 1 ? Alignment.centerLeft : Alignment.centerRight,
        child: Container(
          margin: logs.replyFrom == 1
              ? const EdgeInsets.only(right: 40)
              : const EdgeInsets.only(left: 40),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: logs.replyFrom == 1
                ? ThemeColors.neutral5
                : ThemeColors.secondary10,
            // logs.replyFrom == 1
            //     ? ThemeColors.neutral5
            //     : ThemeColors.secondary10,
          ),
          padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              HtmlWidget(
                "${logs.replyHtml}",
                customWidgetBuilder: (element) {
                  if (element.localName == 'img') {
                    String imageUrl = element.attributes['src'] ?? "";

                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => BaseScaffold(
                              appBar: const BaseAppBar(showBack: true),
                              body: Center(
                                child: PhotoView(
                                  imageProvider: NetworkImage(imageUrl),
                                  minScale:
                                      PhotoViewComputedScale.contained * 0.9,
                                  maxScale:
                                      PhotoViewComputedScale.covered * 2.0,
                                  enableRotation: false,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                      child: Image.network(imageUrl),
                    );
                  }
                  return null;
                },
                textStyle: styleBaseRegular(
                  height: 1.3,
                  // color: ThemeColors.splashBG,
                  color: ThemeColors.black,
                ),
              ),
              const SpacerVertical(height: 8),
              Text(
                "${logs.replyDate}",
                style: styleBaseRegular(
                  color: ThemeColors.neutral80,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
