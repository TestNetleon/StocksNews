import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:stocks_news_new/managers/home/home.dart';
import 'package:stocks_news_new/managers/user.dart';
import 'package:stocks_news_new/models/my_home.dart';
import 'package:stocks_news_new/routes/my_app.dart';
import 'package:stocks_news_new/service/appsFlyer/service.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/utils/utils.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

bool affiliateClosed = false;

class HomeAffiliateBox extends StatefulWidget {
  const HomeAffiliateBox({super.key});

  @override
  State<HomeAffiliateBox> createState() => _HomeAffiliateBoxState();
}

class _HomeAffiliateBoxState extends State<HomeAffiliateBox> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _callAPI();
    });
  }

  Future _callAPI() async {
    if (shareUrl == null || shareUrl == "") {
      shareUrl = await AppsFlyerService.instance.createUserInvitationLink();
      setState(() {});
    }
    Utils().showLog('Share => $shareUrl');
  }

  void _shareApp() async {
    UserManager userManager = navigatorKey.currentContext!.read<UserManager>();
    await Share.share(
      "${userManager.user?.shareText ?? ''}${"\n\n"}${shareUrl.toString()}",
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MyHomeManager>(
      builder: (context, manager, child) {
        HomeLoginBoxRes? affiliateBox = manager.data?.affiliateBox;
        // affiliateClosed = false;
        return Visibility(
          visible: affiliateBox != null &&
              !affiliateClosed &&
              (shareUrl != null && shareUrl != ''),
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: Pad.pad10),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 4,
                  color: ThemeColors.primary120,
                  child: Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: Pad.pad14,
                      vertical: Pad.pad14,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Padding(
                                padding: const EdgeInsets.only(right: 10),
                                child: Text(
                                  affiliateBox?.title ?? '',
                                  style: styleBaseBold(
                                      color: Colors.white, fontSize: 15),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                affiliateClosed = true;
                                setState(() {});
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                ),
                                padding: EdgeInsets.all(2),
                                child: Icon(
                                  Icons.close,
                                  size: 17,
                                  color: ThemeColors.primary120,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SpacerVertical(height: 8),
                        Text(
                          affiliateBox?.subtitle ?? '',
                          style: styleBaseRegular(
                            fontSize: 12,
                            color: Colors.white,
                          ),
                        ),
                        SpacerVertical(height: 10),
                        IntrinsicHeight(
                          key: ValueKey(shareUrl),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.white),
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(8),
                                      bottomLeft: Radius.circular(8),
                                    ),
                                  ),
                                  padding: EdgeInsets.all(10),
                                  child: Text(
                                    affiliateBox?.link != null &&
                                            affiliateBox?.link != ''
                                        ? affiliateBox?.link ?? ''
                                        : shareUrl ?? '',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: styleBaseBold(
                                      color: Colors.white,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: double.infinity,
                                child: GestureDetector(
                                  // onTap: () {
                                  // if (affiliateBox?.link != null &&
                                  //     affiliateBox!.link!.isNotEmpty) {
                                  //   Clipboard.setData(ClipboardData(
                                  //       text: affiliateBox.link!));
                                  //   TopSnackbar.show(
                                  //     message: 'Link copied to clipboard!',
                                  //     type: ToasterEnum.success,
                                  //   );
                                  // }
                                  // },
                                  onTap: _shareApp,
                                  child: Container(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 8),
                                    decoration: BoxDecoration(
                                      border: Border(
                                        top: BorderSide(color: Colors.white),
                                        bottom: BorderSide(color: Colors.white),
                                        right: BorderSide(color: Colors.white),
                                      ),
                                      borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(8),
                                        bottomRight: Radius.circular(8),
                                      ),
                                    ),
                                    child: Icon(
                                      Icons.share,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
