import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/api/api_response.dart';
import 'package:stocks_news_new/modals/featured_watchlist.dart';
import 'package:stocks_news_new/providers/home_provider.dart';
import 'package:stocks_news_new/screens/stocks/index.dart';
import 'package:stocks_news_new/screens/watchlist/watchlist.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

import '../../../../../../routes/my_app.dart';
import '../../../../../../utils/utils.dart';
import '../../../../../allFeatured/index.dart';
import '../../myAlerts/index_copy.dart' as mya;
import 'item.dart';
import 'title.dart';

class FeaturedWatchlistStockView extends StatelessWidget {
  final bool isFeatured;
  final List<FeaturedTicker>? data;
  const FeaturedWatchlistStockView(
      {super.key, this.isFeatured = false, this.data});

  @override
  Widget build(BuildContext context) {
    HomeProvider provider = context.watch<HomeProvider>();
    Extra? extra = provider.extraFW;

    return Stack(
      children: [
        if (!isFeatured && data != null && data?.isNotEmpty == true)
          Container(
            width: double.infinity,
            height: 140,
            // color: ThemeColors.blue,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color.fromARGB(255, 1, 41, 3),
                  // Color.fromARGB(255, 0, 0, 0),
                  Colors.transparent
                ],
              ),
            ),
          ),
        LayoutBuilder(
          builder: (context, constraints) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Visibility(
                  visible:
                      isFeatured && data?.isNotEmpty == true && data != null,
                  child: Padding(
                    padding:
                        const EdgeInsets.only(bottom: 10, left: 15, right: 15),
                    child: FeaturedWatchlistTitle(
                      title: extra?.featuredTitle ?? "Featured Stocks",
                      onTap: () {
                        closeKeyboard();

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AllFeaturedIndex(),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                Visibility(
                  visible:
                      !isFeatured && (data?.isNotEmpty == true && data != null),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        bottom: 10, left: 15, right: 15, top: 20),
                    child: FeaturedWatchlistTitle(
                      title: extra?.watchlistTitle ?? "Your Watchlist",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const WatchList(),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 15, left: 15),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    child: Row(
                      children: List.generate(
                        data?.length ?? 1,
                        (index) {
                          if (index == 0 && !isFeatured && data?.length == 1) {
                            return _singleItem(provider, constraints, index);
                          }

                          return AnimatedSwitcher(
                            duration: const Duration(milliseconds: 200),
                            child: (data?.isEmpty == true || data == null) &&
                                    provider.isLoadinFW
                                ? mya.Placeholder(
                                    height: isPhone
                                        ? constraints.maxWidth * 0.60
                                        : constraints.maxWidth * 0.25,
                                  )
                                : isFeatured
                                    ? FeaturedWatchlistItem(
                                        data: data?[index],
                                      )
                                    : FeatureWatchListItem(
                                        data: data?[index],
                                      ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _singleItem(
      HomeProvider provider, BoxConstraints constraints, int index) {
    return IntrinsicHeight(
      child: Row(
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child:
                (data?.isEmpty == true || data == null) && provider.isLoadinFW
                    ? mya.Placeholder(
                        height: isPhone
                            ? constraints.maxWidth * 0.60
                            : constraints.maxWidth * 0.25,
                      )
                    : FeatureWatchListItem(
                        data: data?[index],
                      ),
          ),
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                // height: 10,
                width: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  gradient: const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color.fromARGB(255, 23, 23, 23),
                      Color.fromARGB(255, 48, 48, 48),
                    ],
                  ),
                ),
                margin: const EdgeInsets.only(right: 10),
                // child:
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 5,
                  vertical: 5,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Add new watchlist",
                      style: stylePTSansBold(),
                    ),
                    const SpacerVertical(height: 10),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          navigatorKey.currentContext!,
                          MaterialPageRoute(
                            builder: (_) => const StocksIndex(),
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: const BoxDecoration(
                          color: Color.fromARGB(255, 76, 76, 76),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.add,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
