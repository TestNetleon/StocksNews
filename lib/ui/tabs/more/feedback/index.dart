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
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/utils/utils.dart';
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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _callAPI();
    });
  }
  void _callAPI() {
    FeedbackManager manager = context.read<FeedbackManager>();
    manager.getFeedback();
  }
  @override
  Widget build(BuildContext context) {
    FeedbackManager manager = context.watch<FeedbackManager>();

    return BaseScaffold(
      appBar: BaseAppBar(
        showBack: true,
        title:"Feedback",
      ),
      body: BaseLoaderContainer(
          isLoading: manager.isLoading,
          hasData: manager.feedbackData != null && !manager.isLoading,
          showPreparingText: true,
          error: manager.error,
          onRefresh: () {
            _callAPI();
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: Pad.pad16,vertical: Pad.pad8),
            child: Column(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Visibility(
                        visible: manager.feedbackData?.subTitle != '',
                        child:BaseHeading(
                          textAlign: TextAlign.center,
                          title: manager.feedbackData?.title ?? "",
                          titleStyle: stylePTSansBold(fontSize: 32,color: ThemeColors.splashBG),
                          subtitle: manager.feedbackData?.subTitle ?? "",
                          subtitleStyle: stylePTSansRegular(fontSize: 16,color: ThemeColors.neutral80),
                          crossAxisAlignment: CrossAxisAlignment.center,
                        ),
                      ),
                      SpacerVertical(height:10),
                      BaseTextField(
                        placeholder: manager.feedbackData?.placeholderText ?? "",
                        controller: comment,
                        textCapitalization: TextCapitalization.words,
                        keyboardType: TextInputType.name,
                        minLines: 10,
                        contentPadding: EdgeInsets.symmetric(vertical: Pad.pad10,horizontal: Pad.pad10),
                      ),
                      /* ListView.separated(
                    // shrinkWrap: true,
                    // physics: NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: Pad.pad3),
                    itemBuilder: (context, index) {
                      BaseTickerRes? data = manager.alertData?.alerts?[index];
                      if (data == null) {
                        return SizedBox();
                      }
                      return BaseStockEditItem(
                        data: data,
                        deleteDataRes: manager.alertData?.deleteBox,
                        index: index,
                        onTap: (p0) {
                          Navigator.pushNamed(context, StockDetailIndex.path, arguments: {'symbol': p0.symbol});
                        },
                      );
                    },
                    separatorBuilder: (context, index) {
                      return BaseListDivider();
                    },
                    itemCount: manager.alertData?.alerts?.length ?? 0,
                  ),*/
                    ],
                  ),
                ),


                BaseButton(
                  text: "Submit",
                  color: ThemeColors.primary10,
                  textColor: ThemeColors.primary100,
                  onPressed:(){
                    manager.sendFeedback(
                        type: "absolutely",
                        comment: comment.text
                    ).then((value) {
                      closeKeyboard();
                      BaseBottomSheet().bottomSheet(
                        barrierColor: ThemeColors.neutral5.withValues(alpha: 0.7),
                        child: FeedbackShowSheet(
                          feedbackSendRes: manager.dataSend,
                          onTapKeep: () {
                            Navigator.pop(navigatorKey.currentContext!);
                          },
                          onTapSure: () {

                          },
                        ),
                      );
                    });

                  },
                ),
              ],
            ),
          )

      ),
    );
  }
}
