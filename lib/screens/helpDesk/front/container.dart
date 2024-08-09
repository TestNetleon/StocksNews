import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/providers/help_desk.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/utils/utils.dart';
import 'package:stocks_news_new/widgets/base_ui_container.dart';
import 'package:stocks_news_new/widgets/screen_title.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';

import '../../../route/my_app.dart';
import '../../../widgets/custom/refresh_indicator.dart';
import '../listing/index.dart';
import '../listing/item.dart';
import '../tickets/index.dart';

class HelpDeskNewContainer extends StatelessWidget {
  const HelpDeskNewContainer({super.key});

  @override
  Widget build(BuildContext context) {
    NewHelpDeskProvider provider = context.watch<NewHelpDeskProvider>();

    return Column(
      children: [
        ScreenTitle(
          subTitle: provider.extraTickets?.subTitle ?? "",
        ),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: ThemeColors.greyBorder.withOpacity(0.4)),
            borderRadius: BorderRadius.circular(10),
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color.fromARGB(255, 23, 23, 23),
                Color.fromARGB(255, 48, 48, 48),
              ],
            ),
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.fromLTRB(15, 8, 8, 15),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle, color: ThemeColors.accent),
                      padding: const EdgeInsets.all(5),
                      child: const Icon(
                        Icons.edit_note_outlined,
                        size: 28,
                      ),
                    ),
                    const SpacerHorizontal(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Tickets",
                            style: stylePTSansBold(),
                          ),
                          Text(
                            "${provider.data?.totalActive ?? 0} Active",
                            style: stylePTSansRegular(
                                color: ThemeColors.greyText, fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                    Visibility(
                      visible: (provider.data?.subjects?.isNotEmpty == true &&
                          provider.data?.subjects != null),
                      child: InkWell(
                        onTap: () {
                          Utils().showLog("Create NEW");
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HelpDeskCreateTicket(),
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.fromLTRB(25, 10, 15, 10),
                          decoration: BoxDecoration(
                            color: ThemeColors.greyBorder.withOpacity(0.4),
                            borderRadius: const BorderRadius.only(
                              bottomRight: Radius.circular(10),
                              topRight: Radius.circular(10),
                              topLeft: Radius.circular(80),
                              bottomLeft: Radius.circular(20),
                            ),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "CREATE NEW",
                                style: stylePTSansBold(fontSize: 13),
                              ),
                              const SpacerHorizontal(width: 5),
                              const Icon(
                                Icons.add_circle_outline_rounded,
                                size: 16,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (provider.data?.tickets == null ||
                  provider.data?.tickets?.isEmpty == true)
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 25, horizontal: 10),
                  child: Text(
                    provider.isLoading
                        ? "Loading your complaint box"
                        : "Great, the complaint box is empty",
                    textAlign: TextAlign.center,
                    style: stylePTSansRegular(
                        color: ThemeColors.greyText, fontSize: 20),
                  ),
                ),
              if (provider.data?.tickets != null &&
                  provider.data?.tickets?.isNotEmpty == true)
                GestureDetector(
                    onTap: () {
                      Utils().showLog("GO");
                    },
                    child: const HelpDeskItemNew(
                      index: 0,
                      showBg: false,
                    )),
              const Divider(
                color: ThemeColors.dividerDark,
                height: 1,
              ),
              GestureDetector(
                onTap: () => _onViewAllRequestClick(),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    "View all Requests",
                    style: styleGeorgiaBold(),
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: BaseUiContainer(
            error: provider.data?.noTicketMsg ?? provider.error,
            // hasData: provider.data?.tickets != null &&
            //     provider.data?.tickets?.isNotEmpty == true,
            hasData: true,
            isLoading: provider.isLoadingTickets,
            errorDispCommon: true,
            showPreparingText: true,
            onRefresh: () => provider.getTickets(),
            child: CommonRefreshIndicator(
              onRefresh: () => provider.getTickets(),
              child: Visibility(
                visible: provider.data?.tickets != null &&
                    provider.data?.tickets?.isNotEmpty == true,
                child: ListView.separated(
                  // shrinkWrap: true,
                  // physics: const NeverScrollableScrollPhysics(),
                  itemCount: (provider.data?.tickets?.length ?? 0) < 5
                      ? provider.data?.tickets?.length ?? 0
                      : 5,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return const SizedBox();
                    }
                    return HelpDeskItemNew(index: index);
                  },
                  separatorBuilder: (context, index) {
                    return const Divider(
                      color: Colors.white12,
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  _onViewAllRequestClick() {
    Navigator.push(
      navigatorKey.currentContext!,
      MaterialPageRoute(builder: (_) => const HelpDeskAllRequestNew()),
    );
  }
}
