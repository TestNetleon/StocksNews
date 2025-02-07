import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/api/api_response.dart';
import 'package:stocks_news_new/providers/home_provider.dart';
import 'package:stocks_news_new/screens/membership/store/store.dart';
import 'package:stocks_news_new/screens/offerMembership/christmas/index.dart';
import 'package:stocks_news_new/service/revenue_cat.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/theme_button_small.dart';
import '../../screens/offerMembership/blackFriday/index.dart';
import '../../utils/constants.dart';
import '../../utils/utils.dart';

class UpdateMembershipCard extends StatelessWidget {
  const UpdateMembershipCard({super.key});

  @override
  Widget build(BuildContext context) {
    Extra? extra = context.watch<HomeProvider>().extra;
    // UserRes? userRes = context.watch<UserProvider>().user;

    return MembershipStoreCard(
      isMembership: true,
      data: extra?.membershipText?.card,
      onTap: () {
        closeKeyboard();
        if (extra?.showBlackFriday == true) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const BlackFridayMembershipIndex(),
            ),
          );
        } else if (extra?.christmasMembership == true ||
            extra?.newYearMembership == true) {
          Navigator.push(
            context,
            createRoute(
              const ChristmasMembershipIndex(),
            ),
          );
        } else {
          // if (kDebugMode) {
          //   //STATIC CHRISTMAS
          //   Navigator.push(
          //     context,
          //     MaterialPageRoute(
          //       builder: (context) => const ChristmasMembershipIndex(),
          //     ),
          //   );
          //   return;
          // }
          subscribe();
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) => const NewMembership(),
          //   ),
          // );
        }
      },
    );
  }
}

class UpdateStoreCard extends StatelessWidget {
  const UpdateStoreCard({super.key});

  @override
  Widget build(BuildContext context) {
    Extra? extra = context.watch<HomeProvider>().extra;

    return MembershipStoreCard(
      data: extra?.membershipText?.storeCard,
      onTap: () {
        closeKeyboard();

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const Store(),
          ),
        );
      },
    );
  }
}

class MembershipStoreCard extends StatelessWidget {
  final MembershipCardRes? data;
  final bool isMembership;
  final Function() onTap;
  const MembershipStoreCard({
    super.key,
    this.data,
    required this.onTap,
    this.isMembership = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        border:
            Border.all(color: const Color.fromARGB(255, 5, 147, 26), width: 2),
        // color: ThemeColors.background,
        gradient: const LinearGradient(
          // colors: [
          //   ThemeColors.background,
          //   Color.fromARGB(255, 54, 54, 54),
          // ],
          colors: [
            Color.fromARGB(255, 1, 61, 10),
            Color.fromARGB(255, 22, 117, 35)
          ],
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Stack(
        children: [
          Positioned(
            right: 0,
            child: Opacity(
              opacity: 0.15,
              child: Image.asset(
                Images.diamondS,
                height: 150,
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Visibility(
                visible: data?.text1 != null && data?.text1 != '',
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    data?.text1 ?? "",
                    style: stylePTSansBold(fontSize: 30),
                  ),
                ),
              ),
              Visibility(
                visible: data?.text2 != null && data?.text2 != '',
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Text(
                    data?.text2 ?? "",
                    style: stylePTSansRegular(),
                  ),
                ),
              ),
              Visibility(
                visible: data?.text3 != null && data?.text3 != '',
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: Text(
                    data?.text3 ?? "",
                    style: stylePTSansBold(fontSize: 15),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: ThemeButtonSmall(
                  color: const Color.fromARGB(255, 194, 216, 51),
                  onPressed: onTap,
                  radius: 30,
                  text: data?.button ?? "",
                  textColor: ThemeColors.background,
                  fontBold: true,
                  // iconWidget: Padding(
                  //   padding: const EdgeInsets.only(right: 10),
                  //   child: Image.asset(
                  //     Images.membership,
                  //     height: 25,
                  //   ),
                  // ),
                  iconWidget: Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: isMembership
                        ? Image.asset(
                            Images.membership,
                            height: 25,
                          )
                        : const Icon(
                            Icons.store,
                            size: 20,
                            color: ThemeColors.background,
                          ),
                  ),

                  showArrow: false,
                  mainAxisSize: MainAxisSize.max,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
