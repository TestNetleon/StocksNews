import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/managers/stockDetail/stock.detail.dart';
import 'package:stocks_news_new/ui/base/base_list_divider.dart';
import 'package:stocks_news_new/ui/base/base_scroll.dart';
import 'package:stocks_news_new/utils/utils.dart';
import 'package:stocks_news_new/widgets/custom/base_loader_container.dart';
import '../../../models/stockDetail/sec_filing.dart';
import '../../../utils/colors.dart';
import '../../../utils/constants.dart';
import '../../../utils/theme.dart';
import '../extra/list_heading.dart';

class SDSecFiling extends StatelessWidget {
  const SDSecFiling({super.key});

  @override
  Widget build(BuildContext context) {
    SDManager manager = context.watch<SDManager>();
    return BaseLoaderContainer(
      hasData: manager.dataSecFiling != null,
      isLoading: manager.isLoadingSecFiling,
      error: manager.errorSecFiling,
      onRefresh: manager.onSelectedTabRefresh,
      showPreparingText: true,
      child: BaseScroll(
        onRefresh: manager.onSelectedTabRefresh,
        margin: EdgeInsets.zero,
        children: [
          SDListHeading(
            data: ['Filling Date', 'Accepted Date'],
          ),
          ListView.separated(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              SecFilingDataRes? data = manager.dataSecFiling?.data?[index];
              if (data == null) {
                return SizedBox();
              }

              return Container(
                padding: EdgeInsets.symmetric(
                  horizontal: Pad.pad16,
                  vertical: Pad.pad10,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        data.fillingDate ?? '',
                        style: styleBaseRegular(
                            color: ThemeColors.neutral80, fontSize: 14),
                      ),
                    ),
                    Flexible(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Flexible(
                            child: Text(
                              data.acceptedDate ?? '',
                              style: styleBaseRegular(
                                  color: ThemeColors.neutral80, fontSize: 14),
                            ),
                          ),
                          Visibility(
                            visible: data.link != null && data.link != '',
                            child: Container(
                              margin: EdgeInsets.only(left: 8),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(4),
                                onTap: () {
                                  openUrl(data.link);
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                    border:
                                        Border.all(color: ThemeColors.neutral5),
                                  ),
                                  child: Image.asset(
                                    Images.moreItem,
                                    height: 24,
                                    width: 24,
                                  ),
                                ),
                              ),
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
              return BaseListDivider();
            },
            itemCount: manager.dataSecFiling?.data?.length ?? 0,
          ),
        ],
      ),
    );
  }
}
