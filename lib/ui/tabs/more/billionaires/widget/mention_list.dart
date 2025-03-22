import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/managers/billionaires.dart';
import 'package:stocks_news_new/models/crypto_models/billionaires_res.dart';
import 'package:stocks_news_new/models/ticker.dart';
import 'package:stocks_news_new/ui/base/heading.dart';
import 'package:stocks_news_new/ui/tabs/more/billionaires/crypto_index.dart';
import 'package:stocks_news_new/ui/tabs/more/billionaires/widget/crypto_container.dart';
import 'package:stocks_news_new/ui/theme/manager.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/cache_network_image.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

class MentionsListIndex extends StatefulWidget {
  final SymbolMentionList? symbolMentionRes;
  const MentionsListIndex({super.key, this.symbolMentionRes});
  @override
  State<MentionsListIndex> createState() => _MentionsListIndexState();
}

class _MentionsListIndexState extends State<MentionsListIndex> {
  @override
  Widget build(BuildContext context) {
    BillionairesManager manager = context.watch<BillionairesManager>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Visibility(
            visible: widget.symbolMentionRes != null &&
                (widget.symbolMentionRes?.data?.isNotEmpty == true),
            child: SpacerVertical(height: Pad.pad10)),
        Visibility(
            visible: widget.symbolMentionRes?.title != null &&
                widget.symbolMentionRes?.title != '',
            child: BaseHeading(
              margin: EdgeInsets.symmetric(horizontal: Pad.pad16),
              title: widget.symbolMentionRes?.title ?? "",
              titleStyle: styleBaseBold(),
              textAlign: TextAlign.start,
            )),
        Visibility(
            visible: widget.symbolMentionRes != null &&
                (widget.symbolMentionRes?.data?.isNotEmpty == true),
            child: SpacerVertical(height: Pad.pad10)),
        SizedBox(
          height: 120,
          child: ListView.separated(
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemBuilder: (context, index) {
              BaseTickerRes? cryptos = widget.symbolMentionRes?.data?[index];
              return Consumer<ThemeManager>(builder: (context, value, child) {
                bool isDark = value.isDarkMode;
                return CryptoContainer(
                  isDark: isDark,
                  onTap: () {
                    Navigator.pushNamed(context, CryptoIndex.path,
                        arguments: {'symbol': cryptos?.symbol ?? ""});
                  },
                  innerPadding:
                      EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  withWidth: true,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Visibility(
                            visible:
                                cryptos?.image != null && cryptos?.image != '',
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(43),
                              child: CachedNetworkImagesWidget(
                                cryptos?.image ?? '',
                                placeHolder: Images.userPlaceholderNew,
                                showLoading: true,
                                fit: BoxFit.cover,
                                height: 43,
                                width: 43,
                              ),
                            ),
                          ),
                          const SpacerHorizontal(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Visibility(
                                  visible: cryptos?.symbol != null &&
                                      cryptos?.symbol != '',
                                  child: Text(
                                    cryptos?.symbol ?? '',
                                    style: styleBaseBold(fontSize: 14),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Visibility(
                                  visible: cryptos?.name != null &&
                                      cryptos?.name != '',
                                  child: Text(
                                    cryptos?.name ?? '',
                                    style: styleBaseRegular(
                                      fontSize: 12,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Column(
                            children: [
                              SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: IconButton(
                                      splashColor: Colors
                                          .transparent, // No ripple effect
                                      highlightColor: Colors
                                          .transparent, // No highlight effect
                                      hoverColor: Colors.transparent,
                                      disabledColor: Colors.transparent,
                                      onPressed: () {
                                        if (cryptos?.isCryptoAdded == 0) {
                                          manager.requestAddToWatch(
                                              cryptos?.symbol ?? "",
                                              cryptos: cryptos);
                                        } else {
                                          manager.requestRemoveToWatch(
                                              cryptos?.symbol ?? "",
                                              cryptos: cryptos);
                                        }
                                      },
                                      icon: cryptos?.isCryptoAdded == 0
                                          ? Icon(Icons.star_outline_sharp)
                                          : Icon(Icons.star_sharp,
                                              color: ThemeColors.accent),
                                      iconSize: 26,
                                      padding: EdgeInsets.zero)),
                            ],
                          )
                        ],
                      ),
                      const SpacerVertical(height: 5),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${cryptos?.displayPrice}",
                                  style: styleBaseBold(
                                      fontSize: 18, fontFamily: 'Roboto'),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SpacerVertical(height: 3),
                                Text(
                                  "${cryptos?.displayChange} (${cryptos?.changesPercentage}%)",
                                  style: styleBaseRegular(
                                    fontSize: 12,
                                    fontFamily: 'Roboto',
                                    color: (cryptos?.changesPercentage ?? 0) > 0
                                        ? ThemeColors.success120
                                        : ThemeColors.error120,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Visibility(
                            visible: cryptos?.mentionCount != null,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  "${cryptos?.mentionCount ?? ""}",
                                  style: styleBaseBold(fontSize: 20),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SpacerVertical(height: 3),
                                Text(
                                  "Mentions",
                                  style: styleBaseBold(fontSize: 12),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                );
              });
            },
            separatorBuilder: (context, index) {
              return const SpacerHorizontal(width: 12);
            },
            itemCount: widget.symbolMentionRes?.data?.length ?? 0,
          ),
        ),
      ],
    );
  }
}
