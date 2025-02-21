import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/ui/subscription/manager.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import '../../model/subscription.dart';

class ViewPlanItem extends StatefulWidget {
  final ProductPlanRes data;
  final int index;

  const ViewPlanItem({
    super.key,
    required this.data,
    required this.index,
  });

  @override
  State<ViewPlanItem> createState() => _ViewPlanItemState();
}

class _ViewPlanItemState extends State<ViewPlanItem> {
  int _openIndex = -1;

  openBenefit(index) {
    _openIndex = _openIndex == index ? -1 : index;
    setState(() {});
  }

  // Future<void> _onPurchase() async {
  //   if (widget.data.storeProduct == null) return;
  //   UserManager manager = navigatorKey.currentContext!.read<UserManager>();
  //   manager.askLoginScreen();
  //   if (manager.user == null) {
  //     return;
  //   }

  //   // showGlobalProgressDialog();
  //   // closeGlobalProgressDialog();

  //   try {
  //     showGlobalProgressDialog();

  //     CustomerInfo customerInfo =
  //         await Purchases.purchaseStoreProduct(widget.data.storeProduct!);

  //     setState(() {});
  //     if (kDebugMode) {
  //       print("Successful: ${customerInfo.entitlements.active}");
  //     }
  //   } on PlatformException catch (e) {
  //     if (kDebugMode) {
  //       print('finally exception $e');
  //     }

  //     TopSnackbar.show(message: e.message ?? '', type: ToasterEnum.error);
  //   } catch (e) {
  //     if (kDebugMode) {
  //       print('finally catch');
  //     }
  //   } finally {
  //     closeGlobalProgressDialog();
  //     setState(() {});
  //     if (kDebugMode) {
  //       print('finally..');
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    SubscriptionManager manager = context.watch<SubscriptionManager>();
    bool isPopular =
        widget.data.popularBtn != null && widget.data.popularBtn != '';
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Stack(
        children: [
          Positioned.fill(
            child: Visibility(
              visible: isPopular,
              child: Container(
                alignment: Alignment.topCenter,
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                    color: ThemeColors.secondary100,
                    borderRadius: BorderRadius.circular(8)),
                child: Text(
                  widget.data.popularBtn ?? '',
                  style: styleBaseBold(fontSize: 13, color: ThemeColors.white),
                ),
              ),
            ),
          ),
          Padding(
            padding:
                isPopular ? const EdgeInsets.only(top: 30) : EdgeInsets.zero,
            child: InkWell(
              borderRadius: BorderRadius.circular(Pad.pad8),
              onTap: widget.data.isActive == true
                  ? null
                  : () {
                      manager.onChangePlan(widget.data);
                    },
              //  canClickable ? _onPurchase : null,
              child: Container(
                padding: EdgeInsets.all(Pad.pad24),
                decoration: BoxDecoration(
                  color: widget.data.isActive == true
                      ? ThemeColors.neutral5
                      : ThemeColors.white,
                  borderRadius: BorderRadius.circular(Pad.pad8),
                  border: Border.all(
                    color: manager.selectedPlan == widget.data
                        ? ThemeColors.secondary100
                        : ThemeColors.neutral10,
                    width: 2,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.data.title ?? '',
                          style: styleBaseBold(fontSize: 25),
                        ),
                        SpacerHorizontal(width: 8),
                        RichText(
                          text: TextSpan(
                            text: '${widget.data.storeProduct?.priceString}',
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: 20,
                              color: ThemeColors.black,
                              fontWeight: FontWeight.bold,
                            ),
                            children: [
                              TextSpan(
                                text: ' ${widget.data.period}',
                                style: styleBaseRegular(
                                    color: ThemeColors.neutral20),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SpacerVertical(height: Pad.pad16),
                    Text(
                      widget.data.text ?? '',
                      style: styleBaseRegular(
                        fontSize: 15,
                        color: ThemeColors.neutral80,
                      ),
                    ),
                    SpacerVertical(height: Pad.pad16),
                    InkWell(
                      borderRadius: BorderRadius.circular(8),
                      onTap: () {
                        openBenefit(widget.index);
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(right: 3),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset(
                              _openIndex == widget.index
                                  ? Images.arrowUP
                                  : Images.arrowDOWN,
                              height: 24,
                              width: 24,
                              color: ThemeColors.secondary100,
                            ),
                            Flexible(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 8),
                                child: Text(
                                  manager.subscriptionData?.cardBtn ?? '',
                                  style: styleBaseSemiBold(
                                    fontSize: 14,
                                    color: ThemeColors.secondary100,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    AnimatedSize(
                      duration: const Duration(milliseconds: 200),
                      child: Container(
                        padding: EdgeInsets.only(top: Pad.pad8),
                        height: _openIndex == widget.index ? null : 0,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: List.generate(
                            widget.data.benefits?.length ?? 0,
                            (index) {
                              return Container(
                                margin: EdgeInsets.only(bottom: 15),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      Images.tickCircle,
                                      height: 22,
                                      width: 22,
                                      color: ThemeColors.secondary100,
                                    ),
                                    Flexible(
                                      child: Container(
                                        margin: EdgeInsets.only(left: Pad.pad8),
                                        child: HtmlWidget(
                                          widget.data.benefits?[index] ?? '',
                                          textStyle:
                                              styleBaseRegular(fontSize: 14),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
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
  }
}
