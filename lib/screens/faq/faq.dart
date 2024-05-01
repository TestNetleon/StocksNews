import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/providers/faq_provider.dart';
import 'package:stocks_news_new/screens/faq/faq_container.dart';
import 'package:stocks_news_new/screens/tabs/home/widgets/app_bar_home.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/widgets/base_container.dart';
import 'package:stocks_news_new/widgets/error_display_common.dart';
import 'package:stocks_news_new/widgets/screen_title.dart';

class FAQBase extends StatefulWidget {
  const FAQBase({super.key});
//
  @override
  State<FAQBase> createState() => _FAQBaseState();
}

class _FAQBaseState extends State<FAQBase> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<FaqProvide>().getFAQs();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BaseContainer(
      appBar: const AppBarHome(isPopback: true, showTrailing: false),
      body: Padding(
        padding: EdgeInsets.fromLTRB(
          Dimen.padding.sp,
          Dimen.padding.sp,
          Dimen.padding.sp,
          0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const ScreenTitle(title: "Frequently Asked Questions"),
            Expanded(child: _getWidget()),
          ],
        ),
      ),
    );
  }

  Widget _getWidget() {
    FaqProvide provider = context.watch<FaqProvide>();
    return provider.isLoading
        ? const SizedBox()
        : provider.data != null
            ? RefreshIndicator(
                onRefresh: () => provider.getFAQs(),
                child: const FAQContainer())
            : ErrorDisplayWidget(
                error: provider.error,
                onRefresh: provider.getFAQs,
              );
  }
}
