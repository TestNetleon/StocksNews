import 'package:flutter/material.dart';
import 'package:stocks_news_new/models/news.dart';
import 'package:stocks_news_new/ui/tabs/more/news/detail.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/cache_network_image.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

class HomeNewsItem extends StatelessWidget {
  final BaseNewsRes data;
  const HomeNewsItem({super.key, required this.data});

  List<Widget> _buildTextWidgets(List<NewsAuthorRes>? data,
      {required BlogsType type}) {
    if (data == null || data.isEmpty) return [];

    List<Widget> widgets = [];

    for (var detail in data) {
      widgets.add(
        Text(
          "${detail.name}",
          style: styleBaseRegular(color: ThemeColors.black, fontSize: 13),
        ),
      );
      if (detail != data.last) {
        widgets.add(Text(
          ", ",
          style: styleBaseRegular(color: ThemeColors.black, fontSize: 13),
        ));
      }
    }

    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    bool showAuthor = data.authors != null && data.authors?.isNotEmpty == true;
    bool showDate = data.publishedDate != null && data.publishedDate != '';
    return GestureDetector(
      onTap: () {
        if (data.slug == null || data.slug == '') return;
        Navigator.pushNamed(context, NewsDetailIndex.path, arguments: {
          'slug': data.slug,
        });
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: Pad.pad10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data.title ?? '',
                    style: styleBaseBold(),
                  ),
                  SpacerVertical(height: 10),
                  Visibility(
                    visible: showAuthor,
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Wrap(
                            children: [
                              Visibility(
                                visible: data.authors?.isNotEmpty == true,
                                child: Text(
                                  "By ",
                                  style: styleBaseRegular(
                                      color: ThemeColors.greyText,
                                      fontSize: 13),
                                ),
                              ),
                              Wrap(
                                children: _buildTextWidgets(data.authors,
                                    type: BlogsType.author),
                              ),
                            ],
                          ),
                          const SpacerVertical(height: 2),
                          Visibility(
                            visible: showDate,
                            child: Text(
                              data.publishedDate ?? '',
                              style: styleBaseRegular(
                                  color: ThemeColors.greyText, fontSize: 13),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 10),
              width: 100,
              height: 70,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: CachedNetworkImagesWidget(data.image),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
