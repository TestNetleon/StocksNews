import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/screens/tabs/news/typeData/index.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/widgets/base_container.dart';
import 'package:stocks_news_new/widgets/custom_tab_container.dart';
import 'package:stocks_news_new/widgets/error_display_common.dart';
import '../../../providers/news_provider.dart';

// class News extends StatefulWidget {
//   const News({super.key});

//   @override
//   State<News> createState() => _NewsState();
// }

// class _NewsState extends State<News> with SingleTickerProviderStateMixin {

//   @override
//   Widget build(BuildContext context) {
//     return BaseContainer(

//       body: Padding(
//           padding: EdgeInsets.fromLTRB(
//             Dimen.padding.sp,
//             0,
//             Dimen.padding.sp,
//             0,
//           ),
//           child: const CustomTabContainerNEW(
//             scrollable: false,
//             tabsPadding: EdgeInsets.zero,
//             tabs: ["Featured", "From Sources"],
//             widgets: [
//               FeaturedNewsList(),
//               NewsList(),
//             ],
//           )

//           ),
//     );
//   }
// }

class News extends StatefulWidget {
  const News({super.key});

  @override
  State<News> createState() => _NewsState();
}

class _NewsState extends State<News> with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // context.read<NewsCategoryProvider>().getTabsData(showProgress: true);
    });
  }

  @override
  Widget build(BuildContext context) {
    NewsCategoryProvider provider = context.watch<NewsCategoryProvider>();
    if (provider.tabLoading) {
      return const SizedBox();
    }

    if (!provider.tabLoading && provider.tabs == null) {
      return ErrorDisplayWidget(
        error: provider.error,
        onRefresh: () {
          provider.getTabsData(showProgress: true);
        },
      );
    }
    return BaseContainer(
      body: Padding(
        padding: EdgeInsets.fromLTRB(
          Dimen.padding.sp,
          0,
          Dimen.padding.sp,
          0,
        ),
        child: CustomTabContainerNEW(
          onChange: (index) {
            provider.tabChange(index);
          },
          scrollable: provider.tabs?.length == 2 ? false : true,
          tabsPadding: EdgeInsets.only(bottom: 10.sp),
          tabs: List.generate(provider.tabs?.length ?? 0,
              (index) => "${provider.tabs?[index].name}"),
          widgets: List.generate(
            provider.tabs?.length ?? 0,
            (index) {
              if (!provider.isLoading && provider.data?.isEmpty == true) {
                return ErrorDisplayWidget(
                  error: provider.error,
                  onRefresh: provider.onRefresh,
                );
              }
              return const NewsTypeData();
            },
          ),
        ),
      ),
    );
  }
}
