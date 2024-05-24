// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:provider/provider.dart';
// import 'package:stocks_news_new/modals/high_low_beta_stocks_res_dart';
// import 'package:stocks_news_new/providers/most_active_provider.dart';
// import 'package:stocks_news_new/utils/colors.dart';
// import 'package:stocks_news_new/widgets/drawer_screen_title.dart';

// import '../../../utils/constants.dart';
// import '../../../widgets/base_ui_container.dart';
// import '../../../widgets/refresh_controll.dart';
// import 'item.dart';

// class MostActiveStocks extends StatefulWidget {
//   const MostActiveStocks({super.key});

//   @override
//   State<MostActiveStocks> createState() => _MostActiveStocksState();
// }

// class _MostActiveStocksState extends State<MostActiveStocks> {
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
//       context.read<MostActiveProvider>().getMostActiveData(type: 1);
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     MostActiveProvider provider = context.watch<MostActiveProvider>();

//     return BaseUiContainer(
//       error: provider.error,
//       // hasData: up != null && up.isNotEmpty,
//       hasData: true,
//       isLoading: provider.isLoading,
//       errorDispCommon: true,
//       showPreparingText: true,
//       onRefresh: () => provider.getMostActiveData(type: 1),
//       child: RefreshControl(
//         onRefresh: () async => provider.getMostActiveData(type: 1),
//         canLoadMore: provider.canLoadMore,
//         onLoadMore: () async =>
//             provider.getMostActiveData(type: 1, loadMore: true),
//         child: ListView.separated(
//           padding: EdgeInsets.only(
//             bottom: Dimen.padding.sp,
//             // top: Dimen.padding.sp,
//           ),
//           itemBuilder: (context, index) {
//             HighLowBetaStocksRes? high = provider.data?[index];
//             return Column(
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               children: [
//                 if (index == 0) DrawerScreenTitle(subTitle: provider.subTitle),
//                 MostActiveItem(index: index, data: high),
//               ],
//             );
//           },
//           separatorBuilder: (BuildContext context, int index) {
//             return Divider(color: ThemeColors.greyBorder, height: 20.sp);
//           },
//           itemCount: provider.data?.length ?? 0,
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/modals/most_active_stocks_res.dart';
import 'package:stocks_news_new/providers/most_active_provider.dart';
import 'package:stocks_news_new/screens/drawerScreens/mostActive/item.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/widgets/drawer_screen_title.dart';

import '../../../utils/constants.dart';
import '../../../widgets/base_ui_container.dart';
import '../../../widgets/refresh_controll.dart';

class MostActiveStocks extends StatefulWidget {
  const MostActiveStocks({super.key});

  @override
  State<MostActiveStocks> createState() => _MostActiveStocksState();
}

class _MostActiveStocksState extends State<MostActiveStocks> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<MostActiveProvider>().getMostActiveData(type: 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    MostActiveProvider provider = context.watch<MostActiveProvider>();
    List<MostActiveStocksRes>? data = provider.data;

    return BaseUiContainer(
      error: provider.error,
      hasData: data != null && data.isNotEmpty,
      isLoading: provider.isLoading,
      errorDispCommon: true,
      showPreparingText: true,
      onRefresh: () => provider.getMostActiveData(type: 1),
      child: RefreshControl(
        onRefresh: () async => provider.getMostActiveData(type: 1),
        canLoadMore: provider.canLoadMore,
        onLoadMore: () async =>
            provider.getMostActiveData(loadMore: true, type: 1),
        child: ListView.separated(
          padding: EdgeInsets.only(
            bottom: Dimen.padding.sp,
            top: Dimen.padding.sp,
          ),
          itemBuilder: (context, index) {
            if (data == null || data.isEmpty) {
              return const SizedBox();
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (index == 0)
                  DrawerScreenTitle(subTitle: provider.extraUp?.subTitle),
                MostActiveItem(
                  data: data[index],
                  index: index,
                ),
              ],
            );
          },
          separatorBuilder: (BuildContext context, int index) {
            return Divider(
              color: ThemeColors.greyBorder,
              height: 20.sp,
            );
          },
          // itemCount: up?.length ?? 0,
          itemCount: data?.length ?? 0,
        ),
      ),
    );
  }
}
