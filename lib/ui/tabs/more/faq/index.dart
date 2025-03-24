import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/managers/faq.dart';
import 'package:stocks_news_new/models/faq.dart';
import 'package:stocks_news_new/ui/base/app_bar.dart';
import 'package:stocks_news_new/ui/base/button.dart';
import 'package:stocks_news_new/ui/base/color_container.dart';
import 'package:stocks_news_new/ui/base/heading.dart';
import 'package:stocks_news_new/ui/base/scaffold.dart';
import 'package:stocks_news_new/ui/base/text_field.dart';
import 'package:stocks_news_new/ui/tabs/more/faq/item.dart';
import 'package:stocks_news_new/ui/theme/manager.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/custom/base_loader_container.dart';
import 'package:stocks_news_new/widgets/custom/refresh_indicator.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

class FaqIndex extends StatefulWidget {
  static const String path = "Faqs";
  const FaqIndex({super.key});

  @override
  State<FaqIndex> createState() => _FaqIndexState();
}

class _FaqIndexState extends State<FaqIndex> {
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _controller = TextEditingController();
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _callAPI();
    });
  }

  String _searchQuery = '';

  void _callAPI() {
    FaqManager manager = context.read<FaqManager>();
    manager.getFaq();
  }

  void _onSearchChanged(String query) async {
    setState(() {
      _searchQuery = query;
    });
    FaqManager manager = context.read<FaqManager>();
    await manager.getFaq(search: _searchQuery, isRest: true);
  }

  @override
  void dispose() {
    super.dispose();
    _focusNode.dispose();
    _controller.dispose();
    _timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    FaqManager manager = context.watch<FaqManager>();
    return BaseScaffold(
      appBar: BaseAppBar(
        showBack: true,
        title: manager.faqData?.title ?? "FAQ’s",
        showSearch: true,
        showNotification: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: Pad.pad16, vertical: Pad.pad8),
        child: Column(
          children: [
            SpacerVertical(height: 10),
            BaseTextField(
              placeholder: 'Search',
              controller: _controller,
              focusNode: _focusNode,
              textCapitalization: TextCapitalization.words,
              keyboardType: TextInputType.text,
              prefixIcon: Icon(
                Icons.search,
                size: isPhone ? 22 : 16,
                color: ThemeColors.neutral40,
              ),
              onChanged: (value) {
                if (_timer != null) {
                  _timer!.cancel();
                }
                _timer = Timer(
                  const Duration(milliseconds: 1000),
                  () {
                    _onSearchChanged(value);
                  },
                );
              },
            ),
            SpacerVertical(height: Pad.pad24),
            Consumer<ThemeManager>(
              builder: (context, value, child) {
                bool isDark = value.isDarkMode;
                return BaseColorContainer(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      BaseHeading(
                        margin: EdgeInsets.zero,
                        title: "Can’t find what you’re looking for?",
                        subtitle: "We are happy to help you",
                        titleStyle: styleBaseBold(
                          fontSize: 20,
                          color: isDark ? ThemeColors.black : ThemeColors.white,
                        ),
                        subtitleStyle: styleBaseRegular(
                          fontSize: 16,
                          color: isDark ? ThemeColors.black : ThemeColors.white,
                        ),
                      ),
                      SpacerVertical(height: Pad.pad10),
                      BaseButton(
                        onPressed: () {},
                        text: "Contact Us",
                        color: isDark ? ThemeColors.black : ThemeColors.white,
                        textColor: ThemeColors.secondary120,
                        textSize: 16,
                      )
                    ],
                  ),
                );
              },
            ),
            SpacerVertical(height: Pad.pad20),
            Expanded(
              child: BaseLoaderContainer(
                isLoading: manager.isLoading,
                hasData: manager.faqData != null && !manager.isLoading,
                showPreparingText: true,
                error: manager.error,
                child: manager.faqData?.faqs != null &&
                        manager.faqData?.faqs?.isNotEmpty == true
                    ? CommonRefreshIndicator(
                        onRefresh: () => manager.getFaq(),
                        child: ListView.separated(
                          itemBuilder: (context, index) {
                            BaseFaqDataRes? data =
                                manager.faqData?.faqs?[index];
                            if (data == null) {
                              return SizedBox();
                            }
                            bool isOpen = manager.openIndex == index;
                            return FAQItem(
                              isOpen: isOpen,
                              faq: data,
                              onChange: () =>
                                  manager.change(isOpen ? -1 : index),
                            );
                          },
                          separatorBuilder: (context, index) {
                            return SpacerVertical();
                          },
                          itemCount: manager.faqData?.faqs?.length ?? 0,
                        ),
                      )
                    : Align(
                        alignment: Alignment.center,
                        child: Column(
                          children: [
                            Container(
                              margin: EdgeInsets.only(top: Pad.pad16),
                              decoration: BoxDecoration(
                                color: ThemeColors.neutral5,
                                borderRadius: BorderRadius.circular(Pad.pad16),
                              ),
                              child: Image.asset(
                                Images.search,
                                height: 56,
                                width: 56,
                              ),
                            ),
                            BaseHeading(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              title: 'No Results Found',
                              subtitle: manager.errorSearch,
                            ),
                          ],
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
