import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/managers/home/home.dart';
import 'package:stocks_news_new/managers/user.dart';
import 'package:stocks_news_new/modals/user_res.dart';
import 'package:stocks_news_new/models/my_home.dart';
import 'package:stocks_news_new/ui/base/base_list_divider.dart';
import 'package:stocks_news_new/ui/base/button.dart';
import 'package:stocks_news_new/ui/subscription/manager.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/cache_network_image.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import 'package:svg_flutter/svg.dart';

class MoreDrawerHeader extends StatelessWidget {
  const MoreDrawerHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(Pad.pad16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: ThemeColors.neutral5, width: 1),
              borderRadius: BorderRadius.circular(8),
            ),
            padding: EdgeInsets.all(Pad.pad16),
            child: Consumer<UserManager>(
              builder: (context, value, child) {
                UserRes? user = value.user;
                bool phonePresent = user?.phone != null && user?.phone != '';
                bool emailPresent = user?.email != null && user?.email != '';
                bool namePresent = user?.name != null && user?.name != '';
                bool displayNamePresent =
                    user?.displayName != null && user?.displayName != '';

                bool verified = phonePresent &&
                    emailPresent &&
                    namePresent &&
                    displayNamePresent;

                if (user == null) {
                  return Consumer<MyHomeManager>(
                    builder: (context, homeManager, child) {
                      HomeLoginBoxRes? loginBoxDrawer =
                          homeManager.data?.loginBoxDrawer;

                      return Column(
                        children: [
                          Text(
                            loginBoxDrawer?.title ?? '',
                            style: styleBaseBold(fontSize: 24),
                          ),
                          SpacerVertical(height: 5),
                          Text(
                            loginBoxDrawer?.subtitle ?? '',
                            style: styleBaseRegular(
                                fontSize: 14, color: ThemeColors.neutral40),
                          ),
                          SpacerVertical(height: 15),
                          BaseButton(
                            text: loginBoxDrawer?.buttonText ??
                                'Log in or Sign up',
                            onPressed: () async {
                              await value.askLoginScreen();
                              if (value.user == null) return;
                            },
                          ),
                        ],
                      );
                    },
                  );
                }

                return Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(right: 10, bottom: 0),
                      child: user.image == null || user.image == ''
                          ? Image.asset(
                              Images.userPlaceholderNew,
                              height: 64,
                              width: 64,
                            )
                          : user.imageType == 'svg'
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(9),
                                  child: SvgPicture.network(
                                    height: 64,
                                    width: 64,
                                    user.image ?? '',
                                    fit: BoxFit.cover,
                                    placeholderBuilder:
                                        (BuildContext context) => Image.asset(
                                      height: 64,
                                      width: 64,
                                      Images.userPlaceholderNew,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                )
                              : ClipRRect(
                                  borderRadius: BorderRadius.circular(9),
                                  child: CachedNetworkImagesWidget(
                                    user.image ?? '',
                                    height: 64,
                                    width: 64,
                                    placeHolder: Images.userPlaceholderNew,
                                    showLoading: true,
                                  ),
                                ),
                    ),
                    SpacerVertical(height: Pad.pad8),
                    Text(
                      user.name != null && user.name != ''
                          ? user.name ?? 'N/A'
                          : 'Welcome Guest',
                      style: styleBaseBold(
                        fontSize: 25,
                        height: 1.5,
                      ),
                    ),
                    Visibility(
                      visible: user.email != null && user.email != '',
                      child: Text(
                        user.email ?? '',
                        style: Theme.of(context)
                            .textTheme
                            .displaySmall
                            ?.copyWith(height: 1.5),
                      ),
                    ),
                    SpacerVertical(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                          child: Column(
                            children: [
                              Icon(
                                Icons.verified,
                                color: verified
                                    ? ThemeColors.secondary120
                                    : ThemeColors.sos,
                                size: 25,
                              ),
                              Text(
                                verified ? 'Verified' : 'Unverified',
                                style: styleBaseSemiBold(
                                  height: 1.5,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SpacerHorizontal(width: 40),
                        Flexible(
                          child: Column(
                            children: [
                              Image.asset(
                                Images.pointIcon2,
                                height: 25,
                                width: 25,
                              ),
                              Text(
                                '${user.pointEarn ?? 0} Points',
                                style: styleBaseSemiBold(
                                  height: 1.5,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    BaseListDivider(height: 30),
                    InkWell(
                      onTap: value.user?.membership?.purchased == 1
                          ? () {
                              Scaffold.of(context).closeDrawer();
                              Scaffold.of(context).closeDrawer();
                              SubscriptionManager manager =
                                  context.read<SubscriptionManager>();
                              manager.startProcess(viewPlans: false);
                            }
                          : null,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Current Plan",
                            style: styleBaseBold(fontSize: 18),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: ThemeColors.white,
                              border: Border(
                                bottom: BorderSide(
                                    color: value.user?.membership?.purchased ==
                                            1
                                        ? const Color.fromARGB(255, 253, 245, 4)
                                        : const Color.fromARGB(
                                            255, 113, 113, 113),
                                    width: 1.2),
                              ),
                              gradient: LinearGradient(
                                colors: value.user?.membership?.purchased == 1
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
                                  color: value.user?.membership?.purchased == 1
                                      ? const Color.fromARGB(255, 242, 234, 12)
                                      : const Color.fromARGB(
                                          255, 156, 153, 153),
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            child: value.user?.membership?.purchased == 0
                                ? Text(
                                    "Free",
                                    style: styleBaseBold(color: Colors.black),
                                  )
                                : Text(
                                    value.user?.membership?.displayName ==
                                                null ||
                                            value.user?.membership
                                                    ?.displayName ==
                                                ''
                                        ? "N/A"
                                        : "${value.user?.membership?.displayName}",
                                    style: styleBaseBold(color: Colors.black),
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          Consumer<UserManager>(
            builder: (context, value, child) {
              return Visibility(
                visible:
                    value.user?.membership?.purchased != null && showMembership,
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  height: 50,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        ThemeColors.drawerMemDark,
                        ThemeColors.drawerMemLight,
                      ],
                    ),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(5),
                      bottomRight: Radius.circular(5),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          value.user?.membership?.upgradeText?.title ??
                              "Upgrade to Premium",
                          style: styleBaseBold(color: Colors.white),
                        ),
                      ),
                      const SpacerHorizontal(width: 5),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          backgroundColor: ThemeColors.drawerMemBtn,
                        ),
                        onPressed: () async {
                          Scaffold.of(context).closeDrawer();
                          SubscriptionManager manager =
                              context.read<SubscriptionManager>();
                          await manager.startProcess();
                        },
                        child: Text(
                          value.user?.membership?.upgradeText?.buttonText ??
                              "UPGRADE",
                          style:
                              styleBaseBold(fontSize: 14, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
