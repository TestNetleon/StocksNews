import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/providers/terms_policy_provider.dart';
import 'package:stocks_news_new/screens/contactUs/contact_us_item.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/disclaimer_widget.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../widgets/custom/refresh_indicator.dart';

class ContactUsContainer extends StatelessWidget {
  const ContactUsContainer({super.key});
  @override
  Widget build(BuildContext context) {
    TermsAndPolicyProvider provider = context.watch<TermsAndPolicyProvider>();
    if (provider.isLoading) {
      return const SizedBox();
    }
//
    return CommonRefreshIndicator(
      onRefresh: () async {
        provider.getTermsPolicy(
          type: PolicyType.contactUs,
          slug: "contact-us",
        );
      },
      child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              // ContactUsBulletPoint(point: "Interested in a demo."),
              // SpacerVertical(height: 5),
              // const ContactUsBulletPoint(point: "Have a question or a comment?"),
              // const SpacerVertical(height: 5),
              // const ContactUsBulletPoint(
              //     point: "Simply fill out the form and we will be in touch."),

              // ListView.separated(
              //     shrinkWrap: true,
              //     physics: const NeverScrollableScrollPhysics(),
              //     itemBuilder: (context, index) {
              //       ContactDetail? detail =
              //           provider.data?.contactDetail?[index];
              //       return ContactUsBulletPoint(
              //           point: detail?.key == null || detail?.key == ''
              //               ? "${detail?.value}"
              //               : "${detail?.key}: ${detail?.value}");
              //     },
              //     separatorBuilder: (context, index) {
              //       return const SpacerVertical(height: 5);
              //     },
              //     itemCount: provider.data?.contactDetail?.length ?? 0),
              // ContactUsClickEvent(
              //   heading: "PHONE NUMBER",
              //   subHeading: "+91 9503928475",
              //   iconData: Icons.call,
              //   onTap: () {},
              // ),
              // const SpacerVertical(height: 10),
              // ContactUsClickEvent(
              //   heading: "EMAIL ID",
              //   subHeading: "demoEmailIdentity@gmail.com",
              //   iconData: Icons.email,
              //   onTap: () {},
              // ),
              // const SpacerVertical(height: 10),
              // const ContactUsClickEvent(
              //   heading: "Address",
              //   subHeading:
              //       "Demo addres, Plot 101, 3rd floot keshavMarg, Jaipur, Rajasthan, 203955",
              //   iconData: Icons.email,
              // ),
              // const SpacerVertical(height: 30),
              const ContactUsItem(),
              Padding(
                padding: const EdgeInsets.only(top: 30, bottom: 10),
                child: Column(
                  children: [
                    Text(
                      "Write us on",
                      textAlign: TextAlign.center,
                      style: stylePTSansRegular(
                          color: ThemeColors.white, fontSize: 25),
                    ),
                    const SpacerVertical(height: 5),
                    GestureDetector(
                      onTap: () {
                        _launchEmail();
                      },
                      child: Text(
                        "support@stocks.news",
                        textAlign: TextAlign.center,
                        style: stylePTSansBold(
                            color: ThemeColors.white, fontSize: 25),
                      ),
                    ),
                  ],
                ),
              ),

              if (context.read<TermsAndPolicyProvider>().extra?.disclaimer !=
                  null)
                DisclaimerWidget(
                    data: context
                        .read<TermsAndPolicyProvider>()
                        .extra!
                        .disclaimer!)
            ],
          )),
    );
  }

  void _launchEmail() async {
    final Uri params = Uri(
      scheme: 'mailto',
      path: 'support@stocks.news',
      query: 'subject=Support Request&body=',
    );

    if (await canLaunchUrl(params)) {
      await launchUrl(params);
    } else {
      print('Could not launch $params');
    }
  }
}
