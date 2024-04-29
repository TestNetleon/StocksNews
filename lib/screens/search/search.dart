import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/providers/search_provider.dart';
import 'package:stocks_news_new/screens/search/search_container.dart';
import 'package:stocks_news_new/screens/tabs/home/widgets/app_bar_home.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/widgets/base_container.dart';
import 'package:stocks_news_new/widgets/text_input_field_search_common.dart';
import '../drawer/base_drawer.dart';

class Search extends StatefulWidget {
  static const String path = "Home";
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

//
class _SearchState extends State<Search> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<SearchProvider>().getSearchDefaults();
    });
  }

  @override
  Widget build(BuildContext context) {
    SearchProvider provider = context.watch<SearchProvider>();
    return PopScope(
      canPop: true,
      onPopInvoked: (didPop) {
        context.read<SearchProvider>().clearSearch();
      },
      child: BaseContainer(
        drawer: const BaseDrawer(),
        appbar: const AppBarHome(isPopback: true, showTrailing: false),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(Dimen.padding.sp),
            child: Column(
              children: [
                TextInputFieldSearchCommon(
                  searchFocusNode: provider.searchFocusNode,
                  hintText: "Search symbol, company name or news",
                  searching: context.watch<SearchProvider>().isLoading,
                  onChanged: (text) {},
                  editable: true,
                ),
                if (provider.topSearch != null) const SearchContainer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
