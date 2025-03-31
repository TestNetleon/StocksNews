import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/managers/feedback.dart';
import 'package:stocks_news_new/routes/my_app.dart';
import 'package:stocks_news_new/ui/base/app_bar.dart';
import 'package:stocks_news_new/ui/base/bottom_sheet.dart';
import 'package:stocks_news_new/ui/base/button.dart';
import 'package:stocks_news_new/ui/base/heading.dart';
import 'package:stocks_news_new/ui/base/scaffold.dart';
import 'package:stocks_news_new/ui/base/text_field.dart';
import 'package:stocks_news_new/ui/tabs/more/feedback/widget/feedback_responce.dart';
import 'package:stocks_news_new/ui/theme/manager.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/utils/utils.dart';
import 'package:stocks_news_new/widgets/custom/alert_popup.dart';
import 'package:stocks_news_new/widgets/custom/base_loader_container.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

class FeedbackIndex extends StatefulWidget {
  static const String path = "FeedbackIndex";

  const FeedbackIndex({super.key});

  @override
  State<FeedbackIndex> createState() => _FeedbackIndexState();
}

class _FeedbackIndexState extends State<FeedbackIndex> {
  TextEditingController comment = TextEditingController();
  String? selectType;
  int? selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _callAPI();
    });
  }

  void _callAPI() async {
    FeedbackManager manager = context.read<FeedbackManager>();
    await manager.getFeedback();
    selectType = manager.feedbackData?.type?[0].title ?? "";
  }

  void _onSubmitClick() async {
    FeedbackManager manager = context.read<FeedbackManager>();
    if (comment.text.isEmpty) {
      popUpAlert(
        message: "Enter Your Opinion",
        title: "Alert",
        icon: Images.alertPopGIF,
      );
      return;
    } else {
      final result = await manager.sendFeedback(
        type: selectType ?? "",
        comment: comment.text,
      );

      closeKeyboard();
      if (result == true) {
        BaseBottomSheet().bottomSheet(
          barrierColor: ThemeColors.neutral5.withValues(alpha: 0.7),
          child: FeedbackShowSheet(
            feedbackSendRes: manager.dataSend,
            onTapKeep: () {
              Navigator.pop(navigatorKey.currentContext!);
            },
            onTapSure: () {
              Navigator.pop(navigatorKey.currentContext!);
            },
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    FeedbackManager manager = context.watch<FeedbackManager>();

    return BaseScaffold(
      //resizeToAvoidBottomInset: false,
      appBar: BaseAppBar(
        showBack: true,
        title: "Feedback",
        showSearch: true,
        showNotification: true,
      ),
      body: Consumer<ThemeManager>(
        builder: (context, value, child) {
          return BaseLoaderContainer(
            isLoading: manager.isLoading,
            hasData: manager.feedbackData != null && !manager.isLoading,
            showPreparingText: true,
            error: manager.error,
            onRefresh: () {
              _callAPI();
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: Pad.pad16, vertical: Pad.pad8),
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Visibility(
                            visible: manager.feedbackData?.title != '',
                            child: BaseHeading(
                              textAlign: TextAlign.center,
                              title: manager.feedbackData?.title ?? "",
                              titleStyle: styleBaseBold(
                                  fontSize: 32, color: ThemeColors.splashBG),
                              subtitle:
                                  manager.feedbackData?.existMessage ?? "",
                              subtitleStyle: styleBaseRegular(
                                  fontSize: 16, color: ThemeColors.neutral80),
                              crossAxisAlignment: CrossAxisAlignment.center,
                            ),
                          ),
                          SpacerVertical(height: Pad.pad16),
                          Visibility(
                            visible: manager.feedbackData?.type != null ||
                                manager.feedbackData?.type?.isNotEmpty == true,
                            child: SingleChildScrollView(
                              child: Row(
                                children: List.generate(
                                  manager.feedbackData?.type?.length ?? 0,
                                  (index) {
                                    bool isOpen = selectedIndex == index;
                                    return FeedbackItem(
                                      index: index,
                                      isOpen: isOpen,
                                      onTap: () {
                                        setState(() {
                                          selectedIndex = index;
                                          selectType = manager.feedbackData!
                                                  .type![index].title ??
                                              "";
                                        });
                                      },
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                          SpacerVertical(height: Pad.pad24),
                          BaseTextField(
                            placeholder:
                                manager.feedbackData?.placeholderText ?? "",
                            controller: comment,
                            textCapitalization: TextCapitalization.words,
                            keyboardType: TextInputType.name,
                            minLines: 10,
                            contentPadding: EdgeInsets.symmetric(
                              vertical: Pad.pad10,
                              horizontal: Pad.pad10,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  BaseButton(
                    text: "Submit",
                    // color: ThemeColors.primary10,
                    // textColor: ThemeColors.primary100,
                    onPressed: _onSubmitClick,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class FeedbackItem extends StatelessWidget {
  const FeedbackItem({
    super.key,
    required this.isOpen,
    required this.index,
    required this.onTap,
  });

  final bool isOpen;
  final int index;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    FeedbackManager manager = context.watch<FeedbackManager>();
    bool isDark = context.watch<ThemeManager>().isDarkMode;

    return Expanded(
      child: Column(
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(Pad.pad16),
            onTap: onTap,
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: 35,
                vertical: 27,
              ),
              decoration: BoxDecoration(
                  color: isOpen ? ThemeColors.secondary10 : ThemeColors.white,
                  border: Border.all(
                      color: isOpen
                          ? ThemeColors.secondary120
                          : ThemeColors.neutral10),
                  borderRadius: BorderRadius.circular(Pad.pad16)),
              child: CachedNetworkImage(
                imageUrl: manager.feedbackData!.type![index].icon ?? '',
                height: 33,
                width: 33,
                color: isOpen
                    ? ThemeColors.secondary120
                    : isDark
                        ? ThemeColors.golden
                        : ThemeColors.neutral10,
              ),
            ),
          )
          /* Text(
                                          manager.feedbackData!.type![index].title ?? '',
                                          style: styleBaseRegular(),
                                        ),*/
        ],
      ),
    );
  }
}
