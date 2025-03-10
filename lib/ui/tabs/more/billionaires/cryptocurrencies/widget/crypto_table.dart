import 'package:flutter/material.dart';
import 'package:stocks_news_new/models/billionaires_res.dart';
import 'package:stocks_news_new/ui/base/app_bar.dart';
import 'package:stocks_news_new/ui/base/heading.dart';
import 'package:stocks_news_new/ui/tabs/more/billionaires/crypto_index.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/cache_network_image.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

class CryptoTable extends StatelessWidget {
  final int? fromTo;
  final SymbolMentionList? symbolMentionRes;
  const CryptoTable({super.key,this.symbolMentionRes,this.fromTo});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Visibility(
            visible: symbolMentionRes?.title != null && symbolMentionRes?.title!= '',
            child: BaseHeading(
              title: symbolMentionRes?.title??"",
              titleStyle: stylePTSansBold(fontSize: 24,color: ThemeColors.splashBG),
              margin: EdgeInsets.symmetric(horizontal: Pad.pad16,vertical: Pad.pad5),

            )
        ),
        SpacerVertical(height: Pad.pad16),
        Container(
          padding: EdgeInsets.symmetric(horizontal: Pad.pad16,vertical: 10),
          color:ThemeColors.neutral5,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ActionButton(
                icon: Images.table_menu,
                onTap: () {

                },
                size: 20,
              ),
              ActionButton(
                icon: Images.search,
                onTap: () {

                },
              ),
            ],
          ),
        ),
        fromTo==1?
        Row(
          children: [
            DataTable(
              horizontalMargin: 10,
              decoration: BoxDecoration(color: ThemeColors.neutral5),
              border: TableBorder(
                right: BorderSide(
                  color: ThemeColors.neutral10,
                ),
                top: BorderSide(
                  color: ThemeColors.neutral10,
                ),
              ),
              columns: [
                DataColumn(
                  label: Text(
                    'Exchange',
                    style: styleBaseBold(fontSize: 12,color: ThemeColors.splashBG),
                  ),
                ),
              ],
              rows: symbolMentionRes?.data?.map((company) {
                return DataRow(
                  cells: [
                    DataCell(
                        GestureDetector(
                          onTap:(){
                            Navigator.pushNamed(context, CryptoIndex.path,arguments: {'symbol':company.symbol ?? ""});
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: Pad.pad5,vertical: Pad.pad5),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(22),
                                  child: CachedNetworkImagesWidget(
                                    company.image ?? '',
                                    height: 22,
                                    width: 22,
                                    placeHolder: Images.userPlaceholderNew,
                                    showLoading: true,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                                SpacerHorizontal(width: Pad.pad10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        company.name ?? "",
                                        style: stylePTSansBold(fontSize: 12,color: ThemeColors.neutral8),
                                      ),
                                      Text(
                                        company.symbol ?? "",
                                        style: styleBaseRegular(fontSize: 12,color: ThemeColors.neutral8),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                    ),
                  ],
                );
              }).toList() ??
                  [],
            ),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  border: TableBorder(
                    top: BorderSide(
                      color: ThemeColors.neutral10,
                    ),
                  ),
                  horizontalMargin: 10,
                  columns: ["Price","Pair","Total Volume"].map((header) {
                    return DataColumn(
                      label: Text(
                        header,
                        style: styleBaseBold(fontSize: 12,color: ThemeColors.splashBG),
                      ),
                    );
                  }).toList(),
                  rows: symbolMentionRes?.data?.map((company) {
                    return DataRow(
                      cells: [
                        _dataCell(
                          text: company.price ?? 0,
                          fromTo: 1
                        ),
                        DataCell(
                          Text(
                            "${company.symbol}/${company.exchange}",
                            style: styleGeorgiaBold(
                                fontSize: 12,
                                color: ThemeColors.neutral8
                            ),
                          ),
                        ),

                        _dataNormalCell(
                            text: company.volume ?? "0",
                        ),

                      ],
                    );
                  }).toList() ??
                      [],
                ),
              ),
            ),
          ],
        ):
        Row(
          children: [
            DataTable(
              horizontalMargin: 10,
              decoration: BoxDecoration(color: ThemeColors.neutral5),
              border: TableBorder(
                right: BorderSide(
                  color: ThemeColors.neutral10,
                ),
                top: BorderSide(
                  color: ThemeColors.neutral10,
                ),
              ),
              columns: [
                DataColumn(
                  label: Text(
                    'Name',
                    style: styleBaseBold(fontSize: 12,color: ThemeColors.splashBG),
                  ),
                ),
              ],
              rows: symbolMentionRes?.data?.map((company) {
                return DataRow(
                  cells: [
                    DataCell(
                        GestureDetector(
                          onTap:(){
                            Navigator.pushNamed(context, CryptoIndex.path,arguments: {'symbol':company.symbol ?? ""});
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: Pad.pad5,vertical: Pad.pad5),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(22),
                                  child: CachedNetworkImagesWidget(
                                    company.image ?? '',
                                    height: 22,
                                    width: 22,
                                    placeHolder: Images.userPlaceholderNew,
                                    showLoading: true,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                                SpacerHorizontal(width: Pad.pad10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        company.name ?? "",
                                        style: stylePTSansBold(fontSize: 12,color: ThemeColors.neutral8),
                                      ),
                                      Text(
                                        company.symbol ?? "",
                                        style: styleBaseRegular(fontSize: 12,color: ThemeColors.neutral8),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                    ),
                  ],
                );
              }).toList() ??
                  [],
            ),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  border: TableBorder(
                    top: BorderSide(
                      color: ThemeColors.neutral10,
                    ),
                  ),
                  horizontalMargin: 10,
                  columns: ["Price","1h %","24h %"].map((header) {
                    return DataColumn(
                      label: Text(
                        header,
                        style: styleBaseBold(fontSize: 12,color: ThemeColors.splashBG),
                      ),
                    );
                  }).toList(),
                  rows: symbolMentionRes?.data?.map((company) {
                    return DataRow(
                      cells: [
                        _dataCell(
                          text: company.price ?? 0,
                        ),
                        _dataCellMentions(
                            text: company.changesPercentage ?? 0,
                            count: company.mentionCount ?? 0,
                            userPercent: true
                        ),
                        _dataCellMentions(
                            text: company.changesPercentage ?? 0,
                            count: company.mentionCount ?? 0,
                            userPercent: true
                        ),

                      ],
                    );
                  }).toList() ??
                      [],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
  DataCell _dataCell({required num text,int? fromTo}) {
    return DataCell(
      Text(
        text.toFormattedPriceForSim(),
        style: styleGeorgiaBold(
            fontSize: 12,
            color: fromTo==1?ThemeColors.neutral8:text >= 0 ? ThemeColors.success120 : ThemeColors.error120),
      ),
    );
  }

  DataCell _dataCellMentions({required num text,required num count, bool userPercent = true}) {
    return DataCell(
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            userPercent ? "$text%" : "$text",
            style: styleBaseBold(
                fontSize: 12,
                color: text >= 0 ? ThemeColors.success120 : ThemeColors.error120),
          ),
          Text(
            "$count (Mentions)",
            style: stylePTSansBold(
                fontSize: 12,
                color: ThemeColors.neutral8),
          ),
        ],
      ),
    );
  }
  DataCell _dataNormalCell({required String text}) {
    return DataCell(
      Text(
        text,
        style: styleGeorgiaBold(
            fontSize: 12,
            color: ThemeColors.neutral8,
      ),
            )
    );
  }
}
