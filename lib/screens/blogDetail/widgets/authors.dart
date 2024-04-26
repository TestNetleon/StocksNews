import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/modals/blogs_res.dart';
import 'package:stocks_news_new/providers/blog_provider.dart';
import 'package:stocks_news_new/screens/blogs/index.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';

import 'item.dart';

class BlogDetailAuthor extends StatelessWidget {
  const BlogDetailAuthor({super.key});

  @override
  Widget build(BuildContext context) {
    List<BlogItemRes>? authors =
        context.watch<BlogProvider>().blogsDetail?.authors;
    if (authors == null) {
      return const SizedBox();
    }

    return BlogDetailClickItem(
      showBottomDivider: false,
      title: "Authors: ",
      children: authors.map((item) {
        return InkWell(
          onTap: () {
            Navigator.of(context).popUntil((route) {
              return route.settings.name == IndexBlog.path;
            });
            Navigator.pushNamed(context, Blog.path, arguments: {
              "type": BlogsType.author,
              "id": item.id,
            });
          },
          child: Text(
            item.name.capitalizeWords(),
            style: stylePTSansRegular(
              color: ThemeColors.accent,
              fontSize: 12,
            ),
          ),
        );
      }).toList(),
    );
  }
}
