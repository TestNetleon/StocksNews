import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/modals/membership/membership_info_res.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/utils/utils.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import '../../../../providers/offerMembership/black_friday.dart';
import '../../../../providers/user_provider.dart';
import '../../../../routes/my_app.dart';
import '../../../../service/revenue_cat.dart';
import '../../../auth/base/base_auth.dart';
import '../../../auth/membershipAsk/ask.dart';

class BlackFridayUpgradeCurrentPlan extends StatefulWidget {
  const BlackFridayUpgradeCurrentPlan({
    super.key,
  });

  @override
  State<BlackFridayUpgradeCurrentPlan> createState() =>
      _BlackFridayUpgradeCurrentPlanState();
}

class _BlackFridayUpgradeCurrentPlanState
    extends State<BlackFridayUpgradeCurrentPlan> {
  Future _subscribe({type, required int index}) async {
    UserProvider? provider = navigatorKey.currentContext!.read<UserProvider>();
    BlackFridayProvider? membershipProvider =
        navigatorKey.currentContext!.read<BlackFridayProvider>();
    withLoginMembership = false;
    if (provider.user == null) {
      Utils().showLog("Ask login-----");
      await loginFirstSheet();

      if (provider.user?.membership?.purchased == 1) {
        Utils().showLog("---user already purchased membership----");
        await membershipProvider.getMembershipInfo();
      }
    }
    withLoginMembership = true;

    if (provider.user == null) {
      Utils().showLog("---still user not found----");
      return;
    }

    if (membershipProvider.membershipInfoRes?.plans?[index].activeText != '' &&
        membershipProvider.membershipInfoRes?.plans?[index].activeText !=
            null) {
      Utils().showLog("---As this membership is already purchased----");
      return;
    }

    if (provider.user?.phone == null || provider.user?.phone == '') {
      Utils().showLog("Ask phone for membership-----");
      await membershipLogin();
    }
    if (provider.user?.phone != null && provider.user?.phone != '') {
      Utils().showLog("Open Paywall-----");
      await RevenueCatService.initializeSubscription(type: type);
    }
  }

  _featuresSheet() {
    BlackFridayProvider provider = context.read<BlackFridayProvider>();
    MembershipInfoRes? data = provider.membershipInfoRes;

    showModalBottomSheet(
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(5),
          topRight: Radius.circular(5),
        ),
      ),
      backgroundColor: ThemeColors.transparent,
      isScrollControlled: true,
      context: navigatorKey.currentContext!,
      builder: (context) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            ),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [ThemeColors.bottomsheetGradient, Colors.black],
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Icon(
                      Icons.close,
                      color: ThemeColors.white,
                    ),
                  ),
                ),
                Text(
                  provider.membershipInfoRes?.newTitle ?? "",
                  style: stylePTSansBold(color: Colors.white, fontSize: 30),
                ),
                Visibility(
                  visible: data?.newFeatures?.isNotEmpty == true,
                  child: ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
                    itemBuilder: (context, index) {
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 7,
                            width: 7,
                            margin: const EdgeInsets.only(top: 10),
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: ThemeColors.white,
                            ),
                          ),
                          const SpacerHorizontal(width: 6),
                          Flexible(
                            child: HtmlWidget(
                              '${data?.newFeatures?[index]}',
                              textStyle: const TextStyle(
                                color: ThemeColors.white,
                                height: 1.5,
                                fontFamily: Fonts.sdPRO,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                    separatorBuilder: (context, index) {
                      return const SpacerVertical(height: 15);
                    },
                    itemCount: data?.newFeatures?.length ?? 0,
                  ),
                ),
                const SpacerVertical(height: 20),
                // Text(
                //   data?.selectTitle ?? "",
                //   style: styleSansBold(
                //     color: Colors.white,
                //     fontSize: 22,
                //   ),
                // ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    BlackFridayProvider provider = context.watch<BlackFridayProvider>();
    MembershipInfoRes? data = provider.membershipInfoRes;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Visibility(
            visible: data?.view_features != null && data?.view_features != '',
            child: GestureDetector(
              onTap: () {
                _featuresSheet();
              },
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  data?.view_features ?? 'View premium membership features',
                  style: styleGeorgiaBold(
                    fontSize: 17,
                    fontStyle: FontStyle.italic,
                    color: ThemeColors.accent,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ),
          ),
          const SpacerVertical(height: 25),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              Plan? plan = data?.plans?[index];

              return GestureDetector(
                onTap: plan?.activeText != null && plan?.activeText != ''
                    ? null
                    : () {
                        _subscribe(
                          type: plan?.type,
                          index: index,
                        );

                        provider.selectedIndex(index);
                        setState(() {});
                      },
                child: Column(
                  children: [
                    Visibility(
                      // visible:
                      //     index == 0 && user?.membership?.canUpgrade == true,

                      visible:
                          plan?.activeText != null && plan?.activeText != '',

                      child: Container(
                        width: double.infinity,
                        alignment: Alignment.center,
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 4,
                        ),
                        decoration: const BoxDecoration(
                          // color: Colors.yellow,
                          gradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [
                              // Color.fromARGB(255, 101, 1, 1),
                              // ThemeColors.sos
                              Color.fromARGB(255, 1, 101, 16),
                              ThemeColors.accent
                            ],
                          ),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                          ),
                        ),
                        child: Text(
                          plan?.activeText ?? "Your current plan",
                          style: styleSansBold(
                              fontSize: 16, color: ThemeColors.white),
                        ),
                      ),
                    ),
                    Container(
                      // width: MediaQuery.of(context).size.width / 1.05,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          stops: const [0.2, 0.65],
                          colors: [
                            // index == 0 && user?.membership?.canUpgrade == true
                            plan?.activeText != null && plan?.activeText != ''
                                ? const Color(0xFF434343)
                                : const Color(0xFF064E1F),
                            const Color(0xFF161616),
                          ],
                        ),
                        border: Border.all(
                          width: 3,
                          color:
                              // index == 0 && user?.membership?.canUpgrade == true
                              plan?.activeText != null && plan?.activeText != ''
                                  ? Colors.grey
                                  : ThemeColors.accent,
                        ),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10.0),
                                    topRight: Radius.circular(10.0),
                                    bottomLeft: Radius.circular(10.0),
                                  ),
                                ),
                                padding: const EdgeInsets.all(8.0),
                                child: Center(
                                  child: Text(
                                    plan?.name ?? "",
                                    style: stylePTSansBold(
                                        fontSize: 17, color: Colors.black),
                                  ),
                                ),
                              ),
                              const SpacerHorizontal(width: 10),
                              // index == 0 && user?.membership?.canUpgrade == true
                              //     ? SizedBox()
                              //     :

                              Visibility(
                                visible: plan?.activeText == null ||
                                    plan?.activeText == '',
                                child: Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: ThemeColors.accent,
                                      width: 3,
                                    ),
                                  ),
                                  padding: const EdgeInsets.all(5),
                                  child: Container(
                                    padding: const EdgeInsets.all(6.7),
                                    decoration: BoxDecoration(
                                      color: plan?.selected == true
                                          ? ThemeColors.accent
                                          : null,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SpacerVertical(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: Text(
                                  plan?.price ?? "",
                                  style: const TextStyle(
                                    fontFamily: 'Roboto',
                                    fontSize: 30,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Container(
                                decoration: const BoxDecoration(
                                  color: Color(0xFFdf151d),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(30),
                                  ),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 15,
                                  vertical: 6,
                                ),
                                child: Text(
                                  plan?.discount ?? "",
                                  style: styleGeorgiaBold(
                                    fontSize: 20,
                                    color: ThemeColors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SpacerVertical(height: 1),
                          HtmlWidget(
                            plan?.billed ?? "",
                            textStyle: stylePTSansRegular(
                                fontSize: 16, color: ThemeColors.greyText),
                          ),
                          const SpacerVertical(height: 10),
                          HtmlWidget(
                            plan?.description ?? "",
                            textStyle: stylePTSansBold(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
            separatorBuilder: (context, index) {
              return const SpacerVertical(height: 20);
            },
            itemCount: data?.plans?.length ?? 0,
          ),
          const SpacerVertical(height: 10),
        ],
      ),
    );
  }
}
