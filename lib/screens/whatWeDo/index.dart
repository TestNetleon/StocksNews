import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/providers/what_we_do_provider.dart';
import 'package:stocks_news_new/screens/tabs/home/widgets/app_bar_home.dart';
import 'package:stocks_news_new/widgets/base_container.dart';
import 'package:stocks_news_new/widgets/custom_tab_container.dart';
import 'package:stocks_news_new/widgets/error_display_common.dart';
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
    return ChangeNotifierProvider.value(
      value: WhatWeDoProvider(),
      child: const BaseContainer(
          appBar: AppBarHome(isPopback: true), body: WhatWeDoContainer()),
    );
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
      context
          .read<WhatWeDoProvider>()
          .getWhatWeDO(type: "disclaimer", reset: true);
    });
  }

  @override
  Widget build(BuildContext context) {
    WhatWeDoProvider provider = context.watch<WhatWeDoProvider>();
    return provider.isLoading && provider.data == null
        ? const SizedBox()
        : !provider.isLoading && provider.data == null
            ? ErrorDisplayWidget(
                error: provider.error,
                onRefresh: () {
                  provider.getWhatWeDO(type: "disclaimer");
                },
              )
            : Padding(
                padding: EdgeInsets.fromLTRB(
                    Dimen.padding.sp, Dimen.padding.sp, Dimen.padding.sp, 0),
                child: Column(
                  children: [
                    const ScreenTitle(title: "What We Do"),
                    Expanded(
                        child: CustomTabContainer(
                      isTabWidget: List.generate(
                          provider.tabs.length,
                          (index) => CustomTabWhatWeDO(
                              index: index,
                              lable: provider.tabs[index].name,
                              selectedIndex: provider.selectedIndex)),
                      tabs: List.generate(provider.tabs.length,
                          (index) => provider.tabs[index].name),
                      widgets: List.generate(
                        provider.tabs.length,
                        (index) => SingleChildScrollView(
                          child: HtmlWidget(
                            provider.data?.description ?? "",
                            textStyle: stylePTSansRegular(height: 1.5),
                          ),
                        ),
                      ),
                      onChange: (index) => provider.onTapChange(index),
                    )),
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
