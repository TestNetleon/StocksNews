import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/modals/congressional_res.dart';
import 'package:stocks_news_new/providers/congressional_provider.dart';
import 'package:stocks_news_new/screens/drawerScreens/congressionalData/item.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/widgets/base_ui_container.dart';
import 'package:stocks_news_new/widgets/refresh_controll.dart';
import 'package:stocks_news_new/widgets/screen_title.dart';

class CongressionalContainer extends StatelessWidget {
  const CongressionalContainer({super.key});

  @override
  Widget build(BuildContext context) {
    CongressionalProvider provider = context.watch<CongressionalProvider>();
    return Padding(
      padding: const EdgeInsets.fromLTRB(
          Dimen.padding, Dimen.padding, Dimen.padding, 0),
      child: BaseUiContainer(
        error: provider.error,
        isLoading: provider.isLoading,
        showPreparingText: true,
        hasData: !provider.isLoading && provider.data != null ||
            provider.data?.isNotEmpty == true,
        child: Column(
          children: [
            ScreenTitle(
              title: provider.title,
              subTitle: provider.subTitle,
            ),
            Expanded(
              child: RefreshControl(
                onLoadMore: () => provider.getData(loadMore: true),
                onRefresh: () => provider.getData(),
                canLoadMore: provider.canLoadMore,
                child: ListView.separated(
                    padding: EdgeInsets.only(bottom: 10.sp),
                    itemBuilder: (context, index) {
                      CongressionalRes? data = provider.data?[index];
                      return CongressionalItem(
                        index: index,
                        data: data,
                      );
                    },
                    separatorBuilder: (context, index) {
                      return Divider(
                        color: ThemeColors.greyBorder,
                        height: 15.sp,
                      );
                    },
                    itemCount: provider.data?.length ?? 0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
