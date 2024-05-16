import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/providers/terms_policy_provider.dart';
import 'package:stocks_news_new/screens/drawer/base_drawer.dart';
import 'package:stocks_news_new/screens/tabs/home/widgets/app_bar_home.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/base_container.dart';
import 'package:stocks_news_new/widgets/error_display_common.dart';
import 'package:stocks_news_new/widgets/screen_title.dart';
import 'package:webview_flutter/webview_flutter.dart';

class TermsPolicyContainer extends StatefulWidget {
  final PolicyType policyType;
//
  const TermsPolicyContainer({super.key, required this.policyType});

  @override
  State<TermsPolicyContainer> createState() => _TermsPolicyContainerState();
}

class _TermsPolicyContainerState extends State<TermsPolicyContainer> {
  WebViewController twitter = WebViewController();
  WebViewController reddit = WebViewController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context
          .read<TermsAndPolicyProvider>()
          .getTermsPolicy(type: widget.policyType);
    });
  }

  @override
  Widget build(BuildContext context) {
    TermsAndPolicyProvider provider = context.watch<TermsAndPolicyProvider>();
    return BaseContainer(
      drawer: const BaseDrawer(resetIndex: true),
      appBar: const AppBarHome(isPopback: true, showTrailing: false),
      body:

          // Column(
          //   children: [
          //     Expanded(
          //       child: WebViewWidget(
          //         controller: reddit,
          //       ),
          //     ),
          //     Expanded(
          //       child: WebViewWidget(
          //         controller: twitter,
          //       ),
          //     ),
          //   ],
          // ),

          Padding(
        padding: EdgeInsets.fromLTRB(
            Dimen.padding.sp, Dimen.padding.sp, Dimen.padding.sp, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ScreenTitle(
              title: widget.policyType == PolicyType.aboutUs
                  ? "About Stocks.news"
                  : widget.policyType == PolicyType.tC
                      ? "Terms & Conditions"
                      : widget.policyType == PolicyType.privacy
                          ? "Privacy Policy"
                          : "Disclaimer",
              // optionalText: 'Last Updated: 5/12/2022',
            ),
            _getWidget(provider),
          ],
        ),
      ),
    );
  }

  Widget _getWidget(TermsAndPolicyProvider provider) {
    return Expanded(
      child: RefreshIndicator(
        onRefresh: () => provider.getTermsPolicy(type: widget.policyType),
        child: provider.isLoading
            ? const SizedBox()
            : provider.data != null
                ? SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Padding(
                      padding: EdgeInsets.only(bottom: Dimen.padding.sp),
                      child: HtmlWidget(
                        provider.data?.description ?? "",
                        textStyle: stylePTSansRegular(height: 1.5),
                      ),
                    ),
                  )
                : ErrorDisplayWidget(
                    error: provider.error,
                    onRefresh: () =>
                        provider.getTermsPolicy(type: widget.policyType),
                  ),
      ),
    );
  }
}
