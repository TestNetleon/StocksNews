import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/modals/membership.dart';
import 'package:stocks_news_new/providers/membership.dart';
import 'package:stocks_news_new/screens/myAccount/my_account.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/utils/utils.dart';
import 'package:stocks_news_new/widgets/base_ui_container.dart';
import 'package:stocks_news_new/widgets/custom/refresh_indicator.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import 'package:stocks_news_new/providers/user_provider.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import '../drawer/widgets/profile_image.dart';
import 'item.dart';

class MembershipView extends StatelessWidget {
  const MembershipView({super.key});

  @override
  Widget build(BuildContext context) {
    MembershipProvider provider = context.watch<MembershipProvider>();
    return BaseUiContainer(
      hasData: !provider.isLoading &&
          (provider.data?.isNotEmpty == true && provider.data != null),
      isLoading: provider.isLoading,
      error: provider.error,
      isFull: true,
      showPreparingText: true,
      child: CommonRefreshIndicator(
        onRefresh: () async {
          provider.getData();
        },
        child: ListView.separated(
          itemBuilder: (context, index) {
            MembershipRes? data = provider.data?[index];

            if (index == 0) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const MyMembershipWidget(),
                  Text(
                    "Invoices",
                    style: stylePTSansBold(fontSize: 20),
                  ),
                  const SpacerVertical(height: 10),
                  MembershipItem(data: data),
                ],
              );
            }

            return MembershipItem(data: data);
          },
          separatorBuilder: (context, index) {
            return const SpacerVertical(height: 10);
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
    UserProvider provider = context.watch<UserProvider>();
    String? colorHex = provider.user?.membership?.color;
    Color? color;

    if (colorHex != null && colorHex.isNotEmpty) {
      colorHex = colorHex.replaceAll('#', '');
      color = Color(int.parse('0xFF$colorHex'));
      Utils().showLog("$color, $colorHex");
    } else {
      color = ThemeColors.background;
    }
    return GestureDetector(
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
            Row(
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
                          color: provider.user?.membership?.purchased == 1
                              ? const Color.fromARGB(255, 253, 245, 4)
                              : const Color.fromARGB(255, 113, 113, 113),
                          width: 1.2),
                    ),
                    gradient: LinearGradient(
                      colors: provider.user?.membership?.purchased == 1
                          ? [
                              const Color.fromARGB(255, 242, 234, 12),
                              const Color.fromARGB(255, 186, 181, 53),
                            ]
                          : [
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
                        color: provider.user?.membership?.purchased == 1
                            ? const Color.fromARGB(255, 242, 234, 12)
                            : const Color.fromARGB(255, 156, 153, 153),
                      ),
                    ],
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  child: Text(
                    provider.user?.membership?.purchased == 1
                        ? "${provider.user?.membership?.displayName}"
                        : "Free",
                    style: stylePTSansBold(color: Colors.black),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
