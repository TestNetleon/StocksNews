import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/managers/search.dart';
import 'package:stocks_news_new/models/news.dart';
import 'package:stocks_news_new/routes/my_app.dart';
import 'package:stocks_news_new/ui/base/app_bar.dart';
import 'package:stocks_news_new/ui/base/scaffold.dart';
import 'package:stocks_news_new/ui/base/text_field.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/widgets/custom/base_loader_container.dart';
import '../../../models/ticker.dart';
import 'search_data.dart';

//MARK: Base Search
class BaseSearch extends StatefulWidget {
  final bool callRecent;
  final void Function(BaseTickerRes)? stockClick;
  final void Function(BaseNewsRes)? newsClick;

  const BaseSearch({
    super.key,
    this.callRecent = true,
    this.stockClick,
    this.newsClick,
  });

  @override
  State<BaseSearch> createState() => _BaseSearchState();
}

class _BaseSearchState extends State<BaseSearch> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      SearchManager manager = context.read<SearchManager>();
      manager.clearSearchData();
      if (widget.callRecent) {
        manager.getRecentSearchData();
      }
    });
  }

  String _searchQuery = '';

  void _onSearchChanged(String query) async {
    setState(() {
      _searchQuery = query;
    });
    SearchManager manager = context.read<SearchManager>();
    await manager.getBaseSearchData(
      term: _searchQuery,
      searchWithNews: widget.callRecent,
    );
  }

  @override
  void deactivate() {
    if (kDebugMode) {
      print('Search deactivated');
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      SearchManager manager =
          navigatorKey.currentContext!.read<SearchManager>();
      manager.clearSearchData();
    });

    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    SearchManager manager = context.watch<SearchManager>();
    return BaseScaffold(
      appBar: BaseAppBar(
        toolbarHeight: 70,
        searchFieldWidget: BaseSearchField(onSearchChanged: _onSearchChanged),
        showBack: true,
      ),
      body: (manager.searchData == null && manager.errorSearch == null) &&
              !manager.isLoadingSearch
          ? Visibility(
              visible: widget.callRecent,
              child: BaseLoaderContainer(
                hasData: manager.recentSearchData != null,
                isLoading: manager.isLoadingRecentSearch,
                error: manager.errorRecentSearch,
                showPreparingText: true,
                child: BaseSearchData(
                  stockClick: widget.stockClick,
                  newsClick: widget.newsClick,
                  symbolRes: manager.recentSearchData?.symbols,
                  newsRes: manager.recentSearchData?.news,
                  onRefresh: manager.getRecentSearchData,
                ),
              ),
            )
          : BaseSearchData(
              symbolRes: manager.searchData?.symbols,
              newsRes: manager.searchData?.news,
              fromSearch: true,
              stockClick: widget.stockClick,
            ),
    );
  }
}

// MARK: Search Box
class BaseSearchField extends StatefulWidget {
  final Function(String) onSearchChanged;

  const BaseSearchField({super.key, required this.onSearchChanged});

  @override
  State<BaseSearchField> createState() => _BaseSearchFieldState();
}

class _BaseSearchFieldState extends State<BaseSearchField> {
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _controller = TextEditingController();
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 250), () {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _controller.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SearchManager manager = context.watch<SearchManager>();
    return Container(
      margin: EdgeInsets.only(left: 40, right: Pad.pad16),
      child: BaseTextField(
        controller: _controller,
        focusNode: _focusNode,
        onChanged: (text) {
          if (_timer != null) {
            _timer!.cancel();
          }
          _timer = Timer(
            const Duration(milliseconds: 1000),
            () {
              widget.onSearchChanged(text);
            },
          );
        },
        contentPadding: EdgeInsets.symmetric(
          vertical: Pad.pad10,
          horizontal: Pad.pad16,
        ),
        maxLines: 1,
        prefixIcon: Container(
          padding: EdgeInsets.all(10),
          child: Image.asset(Images.search),
        ),
        suffixIcon: manager.isLoadingSearch
            ? Container(
                margin: EdgeInsets.symmetric(horizontal: 15, vertical: 14),
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  color: ThemeColors.secondary100,
                ),
              )
            : null,
      ),
    );
  }
}
