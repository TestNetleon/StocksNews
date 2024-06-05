import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stocks_news_new/modals/blogs_res.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/screen_title.dart';
import 'package:stocks_news_new/widgets/theme_image_view.dart';

class BlogsHeader extends StatelessWidget {
  final BlogsRes? data;
  const BlogsHeader({super.key, this.data});
//
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Visibility(
          visible: data?.image != null && data?.image != "",
          child: ClipRRect(
            borderRadius: BorderRadius.circular(80.sp),
            child: SizedBox(
              width: ScreenUtil().screenWidth * .22,
              height: ScreenUtil().screenWidth * .22,
              child: ThemeImageView(url: data?.image ?? ""),
              // Image.network(news!.image, fit: BoxFit.cover),
            ),
          ),
        ),
        ScreenTitle(title: data?.title ?? ""),
        Visibility(
          visible: data?.subTitle != null && data?.subTitle != "",
          child: Text(
            data?.subTitle ?? "",
            style: stylePTSansRegular(fontSize: 12),
          ),
        ),
      ],
    );
  }
}
