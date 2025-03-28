// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:stocks_news_new/api/api_response.dart';
// import 'package:stocks_news_new/utils/colors.dart';
// import 'package:stocks_news_new/utils/theme.dart';

// class FilterListing extends StatelessWidget {
//   final List<KeyValueElement> items;
//   final Function(int) onSelected;
//   const FilterListing(
//       {super.key, required this.items, required this.onSelected});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.all(18.sp),
//       // decoration: const BoxDecoration(
//       //   gradient: LinearGradient(
//       //     begin: Alignment.topCenter,
//       //     end: Alignment.bottomCenter,
//       //     colors: [
//       //       Color.fromARGB(255, 23, 23, 23),
//       //       // ThemeColors.greyBorder,
//       //       Color.fromARGB(255, 48, 48, 48),
//       //     ],
//       //   ),
//       // ),
//       child: ListView.separated(
//           shrinkWrap: true,
//           physics: const NeverScrollableScrollPhysics(),
//           // padding: EdgeInsets.symmetric(horizontal: 10.sp, vertical: 10.sp),
//           padding: EdgeInsets.symmetric(horizontal: 0, vertical: 10.sp),
//           itemBuilder: (context, index) {
//             return InkWell(
//               onTap: () {
//                 onSelected(index);
//                 Navigator.pop(context);
//               },
//               child: Center(
//                 child: Text(
//                   items[index].value ?? "",
//                   style: styleBaseRegular(fontSize: 16),
//                 ),
//               ),
//             );
//           },
//           separatorBuilder: (context, index) {
//             return const Divider(
//               height: 20,
//               color: ThemeColors.greyBorder,
//             );
//           },
//           itemCount: items.length),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stocks_news_new/api/api_response.dart';
import 'package:stocks_news_new/ui/base/base_list_divider.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/cache_network_image.dart';

class FilterListing extends StatelessWidget {
  final List<KeyValueElement> items;
  final Function(int) onSelected;
  final double paddingLeft;
  final bool titleBold;

  const FilterListing({
    super.key,
    required this.items,
    required this.onSelected,
    this.paddingLeft = 0,
    this.titleBold = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 35),
      child: ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                onSelected(index);
                Navigator.pop(context);
              },
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  // mainAxisAlignment: MainAxisAlignment.center,

                  children: [
                    Visibility(
                      visible: items[index].image != null &&
                          items[index].image != "",
                      child: Container(
                          height: 20,
                          width: 20,
                          margin: EdgeInsets.only(right: 10.sp),
                          child: CachedNetworkImagesWidget(items[index].image)),
                    ),
                    Flexible(
                      child: Text(
                        items[index].value ?? "",
                        style: (index == 0 && titleBold)
                            ? styleBaseBold(fontSize: 16)
                            : styleBaseRegular(fontSize: 15),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
          separatorBuilder: (context, index) {
            return BaseListDivider(height: 20);
          },
          itemCount: items.length),
    );
  }
}
