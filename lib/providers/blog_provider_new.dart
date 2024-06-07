import 'package:flutter/material.dart';
import 'package:stocks_news_new/modals/blog_detail_res.dart';

class BlogProviderNew extends ChangeNotifier {}

class TabsNewsHolder {
  BlogsDetailRes? data;
  int currentPage;
  String? error;
  bool loading;

  TabsNewsHolder({
    this.data,
    this.currentPage = 1,
    this.loading = true,
    this.error,
  });
}
