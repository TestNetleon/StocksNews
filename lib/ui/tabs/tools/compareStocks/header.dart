import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/managers/tools.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/utils.dart';
import '../../../../models/ticker.dart';
import '../../../base/search/base_search.dart';

class ToolsCompareHeaderStocks extends StatelessWidget {
  const ToolsCompareHeaderStocks({super.key});

  @override
  Widget build(BuildContext context) {
    ToolsManager manager = context.watch<ToolsManager>();
    List<BaseTickerRes>? data = manager.compareData?.data;

    return Container(
      margin: EdgeInsets.only(top: 20, bottom: 16),
      width: double.infinity,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: AlwaysScrollableScrollPhysics(),
        child: IntrinsicHeight(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ...List.generate(
                data?.length ?? 0,
                (index) {
                  return Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(Pad.pad999),
                        child: Container(
                          margin: EdgeInsets.only(right: 10),
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: ThemeColors.neutral5,
                            shape: BoxShape.circle,
                          ),
                          child: CachedNetworkImage(
                            imageUrl: data?[index].image ?? '',
                            height: 40,
                            width: 40,
                          ),
                        ),
                      ),
                      Positioned(
                        right: 0,
                        child: InkWell(
                          onTap: () {
                            manager.deleteFromCompare(index);
                          },
                          child: Container(
                            padding: EdgeInsets.all(3),
                            decoration: BoxDecoration(
                              color: ThemeColors.black,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.close,
                              size: 17,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
              if ((data?.length ?? 0) < 4)
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      createRoute(
                        BaseSearch(
                          callRecent: false,
                          stockClick: (stock) {
                            if (stock.symbol == null || stock.symbol == '') {
                              return;
                            }
                            Navigator.pop(context);
                            manager.addToCompare(stock.symbol ?? '');
                          },
                        ),
                      ),
                    );
                  },
                  child: Container(
                    height: 68,
                    width: 68,
                    decoration: BoxDecoration(
                      color: ThemeColors.white,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: ThemeColors.neutral5,
                        width: 2,
                      ),
                    ),
                    child: Icon(
                      Icons.add,
                      color: ThemeColors.secondary120,
                      size: 35,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
