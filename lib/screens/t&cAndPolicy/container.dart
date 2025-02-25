// ignore_for_file: unused_import

import 'dart:developer';

import 'package:firebase_in_app_messaging/firebase_in_app_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/api/api_requester.dart';
import 'package:stocks_news_new/providers/terms_policy_provider.dart';
import 'package:stocks_news_new/screens/drawer/base_drawer.dart';
import 'package:stocks_news_new/screens/t&cAndPolicy/tc_policy.dart';

import 'package:stocks_news_new/screens/tabs/home/widgets/app_bar_home.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/utils/utils.dart';
import 'package:stocks_news_new/widgets/base_container.dart';
import 'package:stocks_news_new/widgets/custom/refresh_indicator.dart';
import 'package:stocks_news_new/widgets/disclaimer_widget.dart';
import 'package:stocks_news_new/widgets/error_display_common.dart';
import 'package:stocks_news_new/widgets/loading.dart';
import 'package:stocks_news_new/widgets/screen_title.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../widgets/progress_dialog.dart';

class TermsPolicyContainer extends StatefulWidget {
  final PolicyType policyType;
  final String slug;
//
  const TermsPolicyContainer({
    super.key,
    required this.policyType,
    required this.slug,
  });

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
      context.read<TermsAndPolicyProvider>().getTermsPolicy(slug: widget.slug);
      _triggerEvents();
    });
  }

  void _triggerEvents() {
    if (widget.policyType == PolicyType.aboutUs) {
      FirebaseInAppMessaging.instance.triggerEvent("about_click");
      Utils().showLog("about_click");
    } else if (widget.policyType == PolicyType.tC) {
      FirebaseInAppMessaging.instance.triggerEvent("terms_click");
      Utils().showLog("terms_click");
    } else if (widget.policyType == PolicyType.privacy) {
      FirebaseInAppMessaging.instance.triggerEvent("privacy_click");
      Utils().showLog("privacy_click");
    } else {
      FirebaseInAppMessaging.instance.triggerEvent("disclaimer_click");
      Utils().showLog("disclaimer_click");
    }
  }

  @override
  Widget build(BuildContext context) {
    TermsAndPolicyProvider provider = context.watch<TermsAndPolicyProvider>();
    return BaseContainer(
      drawer: const BaseDrawer(resetIndex: true),
      appBar: AppBarHome(
        isPopBack: true,
        title: widget.slug == "about-us"
            ? "About Stocks.News"
            : widget.slug == "referral-terms"
                ? "Referral Program Terms and Conditions"
                : widget.slug == "terms-of-service"
                    ? "Terms of Service"
                    : widget.slug == "privacy-policy"
                        ? "Privacy Policy"
                        : widget.slug == "membership-terms"
                            ? "Membership Terms"
                            : "Disclaimer",
      ),
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
          Dimen.padding,
          // Dimen.padding.sp,
          0,
          Dimen.padding,
          0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // GestureDetector(
            //   onTap: _triggerEvents,
            //   child: ScreenTitle(
            //     title: widget.slug == "about-us"
            //         ? "About Stocks.News"
            //         : widget.slug == "referral-terms"
            //             ? "Referral Program Terms and Conditions"
            //             : widget.slug == "terms-of-service"
            //                 ? "Terms of Service"
            //                 : widget.slug == "privacy-policy"
            //                     ? "Privacy Policy"
            //                     : widget.slug == "membership-terms"
            //                         ? "Membership Terms"
            //                         : "Disclaimer",
            //     // title: widget.policyType == PolicyType.aboutUs
            //     //     ? "About Stocks.News"
            //     //     : widget.policyType == PolicyType.tC
            //     //         ? "Terms of Service"
            //     //         : widget.policyType == PolicyType.privacy
            //     //             ? "Privacy Policy"
            //     //             : "Disclaimer",
            //     // optionalText: 'Last Updated: 5/12/2022',
            //   ),
            // ),
            _getWidget(provider),
          ],
        ),
      ),
    );
  }

  Widget _getWidget(TermsAndPolicyProvider provider) {
    return Expanded(
      child: CommonRefreshIndicator(
        onRefresh: () => provider.getTermsPolicy(
          slug: widget.slug,
        ),
        child: provider.isLoading
            ? const Loading()
            : provider.data != null
                ? SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Padding(
                      padding: EdgeInsets.only(bottom: Dimen.padding),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          HtmlWidget(
                            onLoadingBuilder:
                                (context, element, loadingProgress) {
                              return const ProgressDialog();
                            },
                            provider.data?.description ?? "",
                            textStyle: stylePTSansRegular(height: 1.5),
                            onTapUrl: (url) {
                              if (url.startsWith("https://app.stocks.news") ||
                                  url.startsWith("http://app.stocks.news")) {
                                String slug =
                                    extractLastPathComponent(Uri.parse(url));
                                Navigator.pushReplacement(
                                  context,
                                  createRoute(
                                    TCandPolicy(
                                      policyType: PolicyType.disclaimer,
                                      slug: slug,
                                    ),
                                  ),
                                );
                                return true;
                              }
                              return false;
                            },
                          ),
                          if (context
                                      .read<TermsAndPolicyProvider>()
                                      .extra
                                      ?.disclaimer !=
                                  null &&
                              widget.policyType != PolicyType.disclaimer)
                            DisclaimerWidget(
                              data: context
                                  .read<TermsAndPolicyProvider>()
                                  .extra!
                                  .disclaimer!,
                            )
                        ],
                      ),
                    ),
                  )
                : ErrorDisplayWidget(
                    error: provider.error,
                    onRefresh: () => provider.getTermsPolicy(slug: widget.slug),
                  ),
      ),
    );
  }
}
