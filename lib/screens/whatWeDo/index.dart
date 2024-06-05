import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/providers/what_we_do_provider.dart';
import 'package:stocks_news_new/screens/tabs/home/widgets/app_bar_home.dart';
import 'package:stocks_news_new/widgets/base_container.dart';
import 'package:stocks_news_new/widgets/base_ui_container.dart';
import 'package:stocks_news_new/widgets/custom_tab_container.dart';
import 'package:stocks_news_new/widgets/error_display_common.dart';
import 'package:stocks_news_new/widgets/loading.dart';
import 'package:stocks_news_new/widgets/progress_dialog.dart';
import 'package:stocks_news_new/widgets/screen_title.dart';

import '../../utils/colors.dart';
import '../../utils/constants.dart';
import '../../utils/theme.dart';

class WhatWeDoIndex extends StatelessWidget {
  static const path = "WhatWeDoIndex";
  const WhatWeDoIndex({super.key});
//
  @override
  Widget build(BuildContext context) {
    return const BaseContainer(
        appBar: AppBarHome(
          isPopback: true,
          canSearch: true,
        ),
        body: WhatWeDoContainer());
  }
}

class WhatWeDoContainer extends StatefulWidget {
  const WhatWeDoContainer({super.key});

  @override
  State<WhatWeDoContainer> createState() => _WhatWeDoContainerState();
}

class _WhatWeDoContainerState extends State<WhatWeDoContainer> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _callApi();
    });
  }

  _callApi() {
    WhatWeDoProvider provider = context.read<WhatWeDoProvider>();
    if (provider.data == null || provider.data?.isEmpty == true) {
      provider.getWhatWeDO(reset: true);
    }
    // provider.getWhatWeDO(reset: true);
  }

  @override
  Widget build(BuildContext context) {
    WhatWeDoProvider provider = context.watch<WhatWeDoProvider>();

    return provider.isLoading && provider.data == null
        ? const Loading()
        : !provider.isLoading && provider.data == null
            ? ErrorDisplayWidget(
                error: provider.error,
                onRefresh: () {
                  provider.getWhatWeDO();
                },
              )
            : Padding(
                padding: EdgeInsets.fromLTRB(
                    Dimen.padding.sp, Dimen.padding.sp, Dimen.padding.sp, 0),
                child: Column(
                  children: [
                    const ScreenTitle(title: "What We Do"),
                    Expanded(
                      child: CustomTabContainerNEW(
                        tabsPadding: REdgeInsets.only(bottom: 10.sp),
                        onChange: (index) => provider.onTapChange(index),
                        scrollable: true,
                        tabs: List.generate(provider.data?.length ?? 0,
                            (index) => '${provider.data?[index].title}'),
                        widgets:
                            List.generate(provider.data?.length ?? 0, (index) {
                          TabsWhatWeDoHolder? whatWeDoHolder =
                              provider.weDoData[provider.data?[index].slug];

                          return BaseUiContainer(
                            // isLoading: provider.isLoadingData
                            // hasData:
                            //     !provider.isLoadingData && provider.res != null,
                            // error: provider.error,

                            error: whatWeDoHolder?.error,
                            hasData: whatWeDoHolder?.data != null,
                            isLoading: whatWeDoHolder?.loading ?? true,

                            errorDispCommon: true,
                            showPreparingText: true,
                            // onRefresh: () => provider.getWhatWeDOData(
                            //     slug: provider.data?[index].slug),
                            onRefresh: () => provider.getWhatWeDODataNew(
                                slug: provider.data?[index].slug),
                            child: SingleChildScrollView(
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 10.sp),
                                child: HtmlWidget(
                                  onLoadingBuilder:
                                      (context, element, loadingProgress) {
                                    return const ProgressDialog();
                                  },
                                  whatWeDoHolder?.data?.page.description ?? "",
                                  textStyle: stylePTSansRegular(height: 1.5),
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                  ],
                ),
              );
  }
}

class CustomTabWhatWeDO extends StatelessWidget {
  const CustomTabWhatWeDO({
    required this.index,
    required this.lable,
    required this.selectedIndex,
    super.key,
  });

  final int index;
  final String lable;
  final int selectedIndex;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.sp, vertical: 10.sp),
      decoration: BoxDecoration(
        border: Border.all(color: ThemeColors.greyBorder),
        color: selectedIndex == index
            ? ThemeColors.accent
            : ThemeColors.primaryLight,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        children: [
          Text(
            lable,
            style: stylePTSansBold(
              fontSize: 12, color: Colors.white,
              // index == selectedIndex ? ThemeColors.border : ThemeColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}
