import 'package:flutter/material.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/cache_network_image.dart';

import '../../models/my_home.dart';

class BaseNewsItem extends StatelessWidget {
  final NewsItemRes data;
  const BaseNewsItem({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    bool showAuthor = data.authors != null && data.authors?.isNotEmpty == true;
    bool showSite = data.site != null && data.site != '';
    bool showDate = data.publishedDate != null && data.publishedDate != '';

    return Container(
      margin: EdgeInsets.only(bottom: Pad.pad24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: CachedNetworkImagesWidget(data.image),
          ),
          Padding(
            padding: const EdgeInsets.only(top: Pad.pad10),
            child: Text(
              data.title ?? '',
              style: styleBaseBold(fontSize: 22),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: Pad.pad5),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: RichText(
                    text: TextSpan(
                      children: [
                        if (showAuthor)
                          TextSpan(
                            text: data.authors?.first.name ?? '',
                            style: styleBaseRegular(
                              fontSize: 14,
                              color: ThemeColors.neutral80,
                            ),
                          ),
                        if (showAuthor && showDate)
                          WidgetSpan(
                            alignment: PlaceholderAlignment.middle,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 4),
                              child: Icon(
                                Icons.circle,
                                size: 4,
                                color: ThemeColors.neutral40,
                              ),
                            ),
                          ),
                        if (showDate)
                          TextSpan(
                            text: data.publishedDate ?? '',
                            style: styleBaseRegular(
                              fontSize: 14,
                              color: ThemeColors.neutral40,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                Flexible(
                  child: Visibility(
                    visible: showSite,
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                          color: ThemeColors.secondary10,
                          borderRadius: BorderRadius.circular(8)),
                      child: Text(
                        data.site ?? '',
                        style: styleBaseRegular(
                          fontSize: 14,
                          color: ThemeColors.secondary120,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
