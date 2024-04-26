import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/modals/blogs_res.dart';
import 'package:stocks_news_new/providers/blog_provider.dart';
import 'package:stocks_news_new/screens/blogs/widgets/item.dart';
import 'package:stocks_news_new/screens/blogs/widgets/header.dart';
import 'package:stocks_news_new/screens/tabs/home/widgets/app_bar_home.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/widgets/base_container.dart';
import 'package:stocks_news_new/widgets/base_ui_container.dart';
import 'package:stocks_news_new/widgets/refresh_controll.dart';
import 'package:stocks_news_new/widgets/spacer_verticle.dart';

class BlogContainer extends StatelessWidget {
  const BlogContainer({super.key});

  @override
  Widget build(BuildContext context) {
    BlogProvider provider = context.watch<BlogProvider>();

    return BaseContainer(
      appbar: const AppBarHome(isPopback: true),
      body: Padding(
        padding: EdgeInsets.fromLTRB(
            Dimen.padding.sp, Dimen.padding.sp, Dimen.padding.sp, 0),
        child: BaseUiContainer(
          isLoading: provider.isLoading,
          hasData: provider.blogData != null &&
              provider.blogData?.isNotEmpty == true,
          error: provider.error,
          errorDispCommon: true,
          onRefresh: () => provider.getData(showProgress: true),
          child: RefreshControll(
            onRefresh: () => provider.getData(showProgress: true),
            canLoadmore: provider.canLoadMore,
            onLoadMore: () => provider.getData(loadMore: true),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  BlogsHeader(data: provider.blogRes),
                  ListView.separated(
                    padding: EdgeInsets.symmetric(vertical: 10.sp),
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: provider.blogData?.length ?? 0,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      BlogItemRes? blogItem = provider.blogData?[index];
                      if (blogItem == null) {
                        return const SizedBox();
                      }
                      return BlogItem(
                        blogItem: blogItem,
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return const SpacerVerticel(height: 16);
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class AuthorContainer extends StatelessWidget {
  final BlogsType type;
  final String id;

  const AuthorContainer({super.key, required this.type, this.id = ""});

  @override
  Widget build(BuildContext context) {
    BlogProvider provider = context.watch<BlogProvider>();

    return BaseContainer(
      appbar: const AppBarHome(isPopback: true),
      body: Padding(
        padding: EdgeInsets.fromLTRB(
            Dimen.padding.sp, Dimen.padding.sp, Dimen.padding.sp, 0),
        child: BaseUiContainer(
          isLoading: provider.isLoading,
          hasData: provider.authorsData != null &&
              provider.authorsData?.isNotEmpty == true,
          error: provider.error,
          errorDispCommon: true,
          onRefresh: () =>
              provider.getData(showProgress: true, type: type, id: id),
          child: RefreshControll(
            onRefresh: () =>
                provider.getData(showProgress: true, type: type, id: id),
            canLoadmore: provider.canLoadMore,
            onLoadMore: () =>
                provider.getData(loadMore: true, type: type, id: id),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  BlogsHeader(data: provider.authorRes),
                  ListView.separated(
                    padding: EdgeInsets.symmetric(vertical: 10.sp),
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: provider.authorsData?.length ?? 0,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      BlogItemRes? blogItem = provider.authorsData?[index];
                      if (blogItem == null) {
                        return const SizedBox();
                      }
                      return BlogItem(
                        blogItem: blogItem,
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return const SpacerVerticel(height: 16);
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CategoryContainer extends StatelessWidget {
  final BlogsType type;
  final String id;

  const CategoryContainer({super.key, required this.type, this.id = ""});

  @override
  Widget build(BuildContext context) {
    BlogProvider provider = context.watch<BlogProvider>();

    return BaseContainer(
      appbar: const AppBarHome(isPopback: true),
      body: Padding(
        padding: EdgeInsets.fromLTRB(
            Dimen.padding.sp, Dimen.padding.sp, Dimen.padding.sp, 0),
        child: BaseUiContainer(
          isLoading: provider.isLoading,
          hasData: provider.categoryData != null &&
              provider.categoryData?.isNotEmpty == true,
          error: provider.error,
          errorDispCommon: true,
          onRefresh: () =>
              provider.getData(showProgress: true, type: type, id: id),
          child: RefreshControll(
            onRefresh: () =>
                provider.getData(showProgress: true, type: type, id: id),
            canLoadmore: provider.canLoadMore,
            onLoadMore: () =>
                provider.getData(loadMore: true, type: type, id: id),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  BlogsHeader(data: provider.categoryRes),
                  ListView.separated(
                    padding: EdgeInsets.symmetric(vertical: 10.sp),
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: provider.categoryData?.length ?? 0,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      BlogItemRes? blogItem = provider.categoryData?[index];
                      if (blogItem == null) {
                        return const SizedBox();
                      }
                      return BlogItem(
                        blogItem: blogItem,
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return const SpacerVerticel(height: 16);
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class TagsContainer extends StatelessWidget {
  final BlogsType type;
  final String id;

  const TagsContainer({super.key, required this.type, this.id = ""});

  @override
  Widget build(BuildContext context) {
    BlogProvider provider = context.watch<BlogProvider>();

    return BaseContainer(
      appbar: const AppBarHome(isPopback: true),
      body: Padding(
        padding: EdgeInsets.fromLTRB(
            Dimen.padding.sp, Dimen.padding.sp, Dimen.padding.sp, 0),
        child: BaseUiContainer(
          isLoading: provider.isLoading,
          hasData: provider.tagsData != null &&
              provider.tagsData?.isNotEmpty == true,
          error: provider.error,
          errorDispCommon: true,
          onRefresh: () =>
              provider.getData(showProgress: true, type: type, id: id),
          child: RefreshControll(
            onRefresh: () =>
                provider.getData(showProgress: true, type: type, id: id),
            canLoadmore: provider.canLoadMore,
            onLoadMore: () =>
                provider.getData(loadMore: true, type: type, id: id),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  BlogsHeader(data: provider.tagsRes),
                  ListView.separated(
                    padding: EdgeInsets.symmetric(vertical: 10.sp),
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: provider.tagsData?.length ?? 0,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      BlogItemRes? blogItem = provider.tagsData?[index];
                      if (blogItem == null) {
                        return const SizedBox();
                      }
                      return BlogItem(
                        blogItem: blogItem,
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return const SpacerVerticel(height: 16);
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
