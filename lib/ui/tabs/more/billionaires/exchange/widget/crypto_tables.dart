import 'package:flutter/material.dart';
import 'package:stocks_news_new/models/crypto_models/exchange_res.dart';
import 'package:stocks_news_new/ui/base/button.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/utils/utils.dart';
import 'package:stocks_news_new/widgets/cache_network_image.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

class CryptoTables extends StatelessWidget {
  final List<Exchanges>? exchanges;
  const CryptoTables({super.key,this.exchanges});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [


        /* Container(
          padding: EdgeInsets.symmetric(horizontal:10),
          color:ThemeColors.background,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Icon(Icons.menu_open_outlined),
                onPressed: () {

                },
                iconSize: 20,
              ),
              IconButton(
                icon: Icon(Icons.search),
                onPressed: () {

                },
              ),
            ],
          ),
        ),*/
        SpacerVertical(height: Pad.pad10),
        Row(
          children: [
            DataTable(
              horizontalMargin: 10,
              dataRowColor: WidgetStatePropertyAll(
                ThemeColors.black.withValues(alpha: 0.4),
              ),
              headingRowColor: WidgetStatePropertyAll(
                ThemeColors.black.withValues(alpha: 0.4),
              ),
              border: TableBorder.all(
                color: ThemeColors.black,
                width: 0.9,
              ),
              columns: [
                DataColumn(
                  label: Text(
                    'Name',
                    style: styleBaseBold(
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
              rows: exchanges?.map((company) {
                return DataRow(
                  cells: [
                    DataCell(
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 5,vertical:5),
                          child: Row(
                            crossAxisAlignment:
                            CrossAxisAlignment.center,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(22),
                                child: CachedNetworkImagesWidget(
                                  company.image ?? '',
                                  height: 22,
                                  width: 22,
                                  placeHolder: Images.placeholder,
                                  showLoading: true,
                                  fit: BoxFit.contain,
                                ),
                              ),
                              SpacerHorizontal(width:10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                  MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      company.name ?? "",
                                      style: styleBaseBold(fontSize: 12),
                                    ),
                                    /*Text(
                                      company.type ?? "",
                                      style: styleBaseRegular(fontSize: 12),
                                    ),*/
                                  ],
                                ),
                              ),
                            ],
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
                  horizontalMargin: 10,
                  border: TableBorder(
                    top: BorderSide(
                      color: ThemeColors.black,
                      width: 0.5,
                    ),
                    bottom: BorderSide(
                      color: ThemeColors.black,
                      width: 0.5,
                    ),
                    horizontalInside: BorderSide(
                      color: ThemeColors.black,
                      width: 0.5,
                    ),
                  ),
                  columns: ["Price","Trust Score","Trade Volume (24h) BTC"].map((header) {
                    return DataColumn(
                      label: Text(
                        header,
                        style: styleBaseBold(
                        fontSize: 12,
                      ),
                      ),
                    );
                  }).toList(),
                  rows: exchanges?.map((exchange) {
                    return DataRow(
                      cells: [
                        _dataButtonCell(url: exchange.url??""),
                        _dataNormalCell(
                          text: "${exchange.trustScore ?? 0}",
                        ),
                        _dataNormalCell(
                          text: exchange.tradeVolume24HBtc ?? "\$0",
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
        SpacerVertical(height: Pad.pad10),
      ],
    );
  }

  DataCell _dataButtonCell({String? text,String? url}) {
    return DataCell(
        BaseButton(
          margin: EdgeInsets.symmetric(vertical: 5),
          onPressed: () {
            openUrl(url.toString());
          },
          text: text??"Go to exchange",
          textSize: 14,
          fontBold: true,
          fullWidth: false,
        ),

    );
  }

  DataCell _dataNormalCell({required String text}) {
    return DataCell(
      Text(
        text,
        style: styleBaseBold(
            fontSize: 12,
      ),
            )
    );
  }
}
