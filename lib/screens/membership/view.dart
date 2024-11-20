import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/modals/membership.dart';
import 'package:stocks_news_new/providers/membership.dart';
import 'package:stocks_news_new/screens/myAccount/my_account.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/custom/refresh_indicator.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import 'package:stocks_news_new/providers/user_provider.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import '../../api/api_response.dart';
import '../../widgets/refresh_controll.dart';
import '../drawer/widgets/profile_image.dart';
import 'item.dart';

class MembershipView extends StatelessWidget {
  const MembershipView({super.key});

  @override
  Widget build(BuildContext context) {
    MembershipProvider provider = context.watch<MembershipProvider>();

    return CommonRefreshIndicator(
      onRefresh: () async {
        provider.getData();
      },
      child: RefreshControl(
        onRefresh: () async => provider.getData(),
        canLoadMore: provider.canLoadMore,
        onLoadMore: () async => provider.getData(loadMore: true),
        child: ListView.separated(
          padding: EdgeInsets.only(bottom: 10),
          itemBuilder: (context, index) {
            MembershipRes? data = provider.data?[index];

            return MembershipItem(data: data);
          },
          separatorBuilder: (context, index) {
            return const SpacerVertical(height: 20);
          },
          itemCount: provider.data?.length ?? 0,
        ),
      ),
    );
  }
}

class MyMembershipWidget extends StatefulWidget {
  const MyMembershipWidget({super.key});
  @override
  State<MyMembershipWidget> createState() => _MyMembershipWidgetState();
}

class _MyMembershipWidgetState extends State<MyMembershipWidget> {
  @override
  Widget build(BuildContext context) {
    Extra? extra = context.watch<MembershipProvider>().extra;

    UserProvider provider = context.watch<UserProvider>();

    return Column(
      children: [
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const MyAccount(),
              ),
            );
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: 20),
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            decoration: BoxDecoration(
              // border: Border.all(
              //   color: const Color.fromARGB(255, 253, 245, 4),
              // ),
              borderRadius: BorderRadius.circular(5),
              // color: color,
              // color: color,
              color: ThemeColors.background,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    ProfileImage(
                      url: provider.user?.image,
                      showCameraIcon: false,
                      imageSize: 70,
                      roundImage: false,
                    ),
                    const SpacerHorizontal(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            provider.user?.name?.isNotEmpty == true
                                ? "${provider.user?.name}"
                                : "Hello",
                            style: stylePTSansBold(),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            provider.user?.email?.isNotEmpty == true
                                ? "${provider.user?.email}"
                                : "",
                            style: stylePTSansRegular(
                                color: ThemeColors.greyText, fontSize: 12),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const Divider(
                  color: ThemeColors.greyBorder,
                  height: 20,
                ),
                Visibility(
                  visible: extra?.activeMembership == null ||
                      extra?.activeMembership?.isEmpty == true,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Current Plan",
                        style: stylePTSansBold(),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: ThemeColors.white,
                          border: Border(
                            bottom: BorderSide(
                                color: const Color.fromARGB(255, 113, 113, 113),
                                width: 1.2),
                          ),
                          gradient: LinearGradient(
                            colors: [
                              Colors.white,
                              Colors.grey,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 0,
                              spreadRadius: 1,
                              offset: const Offset(0, 1),
                              color: const Color.fromARGB(255, 156, 153, 153),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        child: Text(
                          "Free",
                          style: stylePTSansBold(color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                ),
                Visibility(
                  visible: extra?.activeMembership != null &&
                      extra?.activeMembership?.isNotEmpty == true,
                  child: ListView.separated(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            extra?.activeMembership?[index].title ?? '',
                            style: stylePTSansBold(),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: ThemeColors.white,
                              border: Border(
                                bottom: BorderSide(
                                  color: const Color.fromARGB(255, 253, 245, 4),
                                  width: 1.2,
                                ),
                              ),
                              gradient: LinearGradient(
                                colors: [
                                  const Color.fromARGB(255, 242, 234, 12),
                                  const Color.fromARGB(255, 186, 181, 53),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  blurRadius: 0,
                                  spreadRadius: 1,
                                  offset: const Offset(0, 1),
                                  color:
                                      const Color.fromARGB(255, 242, 234, 12),
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            child: Text(
                              extra?.activeMembership?[index].displayName ?? '',
                              style: stylePTSansBold(color: Colors.black),
                            ),
                          ),
                        ],
                      );
                    },
                    separatorBuilder: (context, index) {
                      return SpacerVertical(height: 15);
                    },
                    itemCount: extra?.activeMembership?.length ?? 0,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
