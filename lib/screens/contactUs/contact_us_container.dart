import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/modals/terms_policy_res.dart';
import 'package:stocks_news_new/providers/terms_policy_provider.dart';
import 'package:stocks_news_new/screens/contactUs/contact_us_item.dart';
import 'package:stocks_news_new/screens/contactUs/widgets/bullet_point.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/widgets/spacer_verticle.dart';

class ContactUsContainer extends StatelessWidget {
  const ContactUsContainer({super.key});
  @override
  Widget build(BuildContext context) {
    TermsAndPolicyProvider provider = context.watch<TermsAndPolicyProvider>();
    if (provider.isLoading) {
      return const SizedBox();
    }

    return RefreshIndicator(
      onRefresh: () async {
        provider.getTermsPolicy(type: PolicyType.contactUs);
      },
      child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              // ContactUsBulletPoint(point: "Interested in a demo."),
              // SpacerVerticel(height: 5),
              // const ContactUsBulletPoint(point: "Have a question or a comment?"),
              // const SpacerVerticel(height: 5),
              // const ContactUsBulletPoint(
              //     point: "Simply fill out the form and we will be in touch."),
              const SpacerVerticel(height: 5),

              ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    ContactDetail? detail =
                        provider.data?.contactDetail?[index];
                    return ContactUsBulletPoint(
                        point: detail?.key == null || detail?.key == ''
                            ? "${detail?.value}"
                            : "${detail?.key}: ${detail?.value}");
                  },
                  separatorBuilder: (context, index) {
                    return const SpacerVerticel(height: 5);
                  },
                  itemCount: provider.data?.contactDetail?.length ?? 0),
              // ContactUsClickEvent(
              //   heading: "PHONE NUMBER",
              //   subHeading: "+91 9503928475",
              //   iconData: Icons.call,
              //   onTap: () {},
              // ),
              // const SpacerVerticel(height: 10),
              // ContactUsClickEvent(
              //   heading: "EMAIL ID",
              //   subHeading: "demoEmailIdentity@gmail.com",
              //   iconData: Icons.email,
              //   onTap: () {},
              // ),
              // const SpacerVerticel(height: 10),
              // const ContactUsClickEvent(
              //   heading: "Address",
              //   subHeading:
              //       "Demo addres, Plot 101, 3rd floot keshavMarg, Jaipur, Rajasthan, 203955",
              //   iconData: Icons.email,
              // ),
              const SpacerVerticel(height: 30),
              const ContactUsItem(),
            ],
          )),
    );
  }
}
