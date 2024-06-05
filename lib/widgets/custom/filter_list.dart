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
//                   style: stylePTSansRegular(fontSize: 16),
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
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/cache_network_image.dart';

class FilterListing extends StatelessWidget {
  final List<KeyValueElement> items;
  final Function(int) onSelected;
  final double paddingLeft;
  const FilterListing({
    super.key,
    required this.items,
    required this.onSelected,
    this.paddingLeft = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 35),
      child: ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          // padding: EdgeInsets.symmetric(horizontal: 10.sp, vertical: 10.sp),
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                onSelected(index);
                Navigator.pop(context);
              },
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.only(left: 20),
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
                            child:
                                CachedNetworkImagesWidget(items[index].image)),
                      ),
                      Flexible(
                        child: Text(
                          items[index].value ?? "",
                          style: index == 0
                              ? stylePTSansBold(fontSize: 16)
                              : stylePTSansRegular(fontSize: 15),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
          separatorBuilder: (context, index) {
            return Divider(
              height: 20,
              color: ThemeColors.greyBorder.withOpacity(0.4),
            );
          },
          itemCount: items.length),
    );
  }
}
