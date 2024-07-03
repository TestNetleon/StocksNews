import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/modals/most_purchased.dart';
import 'package:stocks_news_new/providers/home_provider.dart';
import 'package:stocks_news_new/screens/stockDetail/index.dart';
import 'package:stocks_news_new/screens/tabs/home/widgets/app_bar_home.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/base_container.dart';
import 'package:stocks_news_new/widgets/base_ui_container.dart';
import 'package:stocks_news_new/widgets/custom/refresh_indicator.dart';
import 'package:stocks_news_new/widgets/screen_title.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import '../../../../../widgets/cache_network_image.dart';
import '../../../../../widgets/spacer_horizontal.dart';

class TopPlaidIndexView extends StatefulWidget {
  const TopPlaidIndexView({super.key});

  @override
  State<TopPlaidIndexView> createState() => _TopPlaidIndexViewState();
}

class _TopPlaidIndexViewState extends State<TopPlaidIndexView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomeProvider>().getMostPurchased();
    });
  }

  @override
  Widget build(BuildContext context) {
    HomeProvider provider = context.watch<HomeProvider>();

    if (provider.mostPurchasedView?.isEmpty == true ||
        provider.mostPurchasedView == null) {
      return const SizedBox();
    }

    return BaseContainer(
      appBar: const AppBarHome(
        canSearch: true,
        showTrailing: true,
        isPopback: true,
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(
          Dimen.padding,
          Dimen.padding,
          Dimen.padding,
          0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ScreenTitle(
              title: provider.extraMostPopular?.title ?? "",
            ),
            Expanded(
              child: BaseUiContainer(
                hasData: !provider.isLoadingMostPurchased &&
                    (provider.mostPurchasedView?.isNotEmpty == true &&
                        provider.mostPurchasedView != null),
                isLoading: provider.isLoadingMostPurchased,
                error: provider.errorMostPurchased,
                isFull: true,
                showPreparingText: true,
                onRefresh: () {
                  provider.getMostPurchased();
                },
                child: CommonRefreshIndicator(
                  onRefresh: () async {
                    provider.getMostPurchased();
                  },
                  child: ListView.separated(
                    padding: const EdgeInsets.only(bottom: Dimen.padding),
                    itemBuilder: (context, index) {
                      MostPurchasedRes? data =
                          provider.mostPurchasedView?[index];
                      if (data == null) {
                        return const SizedBox();
                      }
                      return TopPlaidItemView(data: data);
                    },
                    separatorBuilder: (context, index) {
                      return const SpacerVertical();
                    },
                    itemCount: provider.mostPurchasedView?.length ?? 0,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TopPlaidItem extends StatelessWidget {
  final MostPurchasedRes? data;
  final EdgeInsets? padding;
  const TopPlaidItem({
    super.key,
    this.data,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsets.fromLTRB(0, 10, 10, 10),
      child: InkWell(
        borderRadius: BorderRadius.circular(5),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => StockDetail(symbol: data?.symbol ?? ""),
            ),
          );
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          decoration: BoxDecoration(
            // color: Colors.transparent,
            border: Border.all(color: ThemeColors.greyBorder.withOpacity(0.4)),
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0.2, 0.55],
              colors: [
                Color.fromARGB(255, 19, 57, 0),
                // ThemeColors.greyBorder,
                Color.fromARGB(255, 0, 0, 0),
              ],
            ),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    child: SizedBox(
                      width: 43,
                      height: 43,
                      child: CachedNetworkImagesWidget(data?.image),
                    ),
                  ),
                  const SpacerHorizontal(width: 12),
                  Expanded(
                    child: Text(
                      data?.symbol ?? '',
                      style: stylePTSansBold(fontSize: 14),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SpacerVertical(height: 8),
              Text(
                data?.name ?? '',
                style: stylePTSansRegular(
                  color: ThemeColors.greyText,
                  fontSize: 12,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SpacerVertical(height: 8),
              Text(
                data?.price ?? '',
                style: stylePTSansBold(fontSize: 18),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SpacerVertical(height: 5),
              Text(
                "${data?.change ?? ""} (${data?.changesPercentage ?? ""}%)",
                style: stylePTSansRegular(
                  fontSize: 12,
                  color: (data?.changesPercentage ?? 0) > 0
                      ? ThemeColors.accent
                      : Colors.red,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TopPlaidItemView extends StatelessWidget {
  final MostPurchasedRes? data;
  const TopPlaidItemView({
    super.key,
    this.data,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(5),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => StockDetail(symbol: data?.symbol ?? ""),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        decoration: BoxDecoration(
          // color: Colors.transparent,
          border: Border.all(color: ThemeColors.greyBorder.withOpacity(0.4)),
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.2, 0.55],
            colors: [
              Color.fromARGB(255, 19, 57, 0),
              // ThemeColors.greyBorder,
              Color.fromARGB(255, 0, 0, 0),
            ],
          ),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(0),
              child: Container(
                padding: const EdgeInsets.all(5),
                width: 43,
                height: 43,
                child: CachedNetworkImagesWidget(data?.image),
              ),
            ),
            const SpacerHorizontal(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data?.symbol ?? "",
                    style: styleGeorgiaBold(fontSize: 14),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SpacerVertical(height: 5),
                  Text(
                    data?.name ?? "",
                    style: styleGeorgiaRegular(
                      color: ThemeColors.greyText,
                      fontSize: 12,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            // Container(
            //   margin: EdgeInsets.only(right: 8.sp, left: 8.sp),
            //   width: 80.sp,
            //   height: 26.sp,
            //   child: LineChart(_avgData()),
            // ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(data?.price ?? "", style: stylePTSansBold(fontSize: 15)),
                const SpacerVertical(height: 2),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text:
                            "${data?.change ?? ""} (${data?.changesPercentage ?? ""}%)",
                        style: stylePTSansRegular(
                          fontSize: 11,
                          color: (data?.changesPercentage ?? 0) > 0
                              ? Colors.green
                              : Colors.red,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
