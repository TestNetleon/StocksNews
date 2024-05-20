import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/providers/blog_provider.dart';
import 'package:stocks_news_new/screens/blogs/container.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

class Blog extends StatefulWidget {
  final BlogsType type;
  final String id;
  final String? inAppMsgId;
  static const path = "Blog";
  const Blog({
    super.key,
    this.type = BlogsType.blog,
    this.id = "",
    this.inAppMsgId,
  });

  @override
  State<Blog> createState() => _BlogState();
}

//
class _BlogState extends State<Blog> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<BlogProvider>().getData(
            showProgress: true,
            type: widget.type,
            id: widget.id,
            inAppMsgId: widget.inAppMsgId,
          );
      FirebaseAnalytics.instance.logEvent(
        name: 'ScreensVisit',
        parameters: {'screen_name': 'Blogs'},
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    log("message");
    if (widget.type == BlogsType.author) {
      return AuthorContainer(
        type: widget.type,
        id: widget.id,
      );
    }

    if (widget.type == BlogsType.category) {
      return CategoryContainer(
        type: widget.type,
        id: widget.id,
      );
    }

    if (widget.type == BlogsType.tag) {
      return TagsContainer(
        type: widget.type,
        id: widget.id,
      );
    }

    return const BlogContainer();
  }
}

class IndexBlog extends StatefulWidget {
  static const path = "IndexBlog";
  const IndexBlog({super.key});

  @override
  State<IndexBlog> createState() => _IndexBlogState();
}

class _IndexBlogState extends State<IndexBlog> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context
          .read<BlogProvider>()
          .getData(showProgress: true, type: BlogsType.blog);
    });
  }

  @override
  Widget build(BuildContext context) {
    return const BlogContainer();
  }
}
