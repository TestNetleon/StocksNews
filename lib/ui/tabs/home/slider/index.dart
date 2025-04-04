import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:stocks_news_new/managers/home/home.dart';
import 'package:stocks_news_new/models/news.dart';
import 'package:stocks_news_new/service/events/service.dart';
import 'package:stocks_news_new/ui/tabs/more/news/detail.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import '../../../../../utils/utils.dart';

class HomeTopNewsSlider extends StatefulWidget {
  const HomeTopNewsSlider({super.key});

  @override
  State<HomeTopNewsSlider> createState() => _HomeTopNewsSliderState();
}

//
class _HomeTopNewsSliderState extends State<HomeTopNewsSlider> {
  int _activeIndex = 0;

  void _newsDetail({String? slug}) {
    closeKeyboard();
    EventsService.instance.enterPostHomePage();
    Navigator.pushNamed(context, NewsDetailIndex.path, arguments: {
      'slug': slug,
    });
  }

  @override
  Widget build(BuildContext context) {
    List<BaseNewsRes>? sliderPosts =
        context.watch<MyHomeManager>().data?.recentNews;

    return Container(
      padding: EdgeInsets.only(top: Pad.pad16),
      margin: EdgeInsets.symmetric(horizontal: Pad.pad16),
      child: LayoutBuilder(
        builder: (context, constraints) {
          double imageHeight = constraints.maxWidth * 0.6;
          double dotSize = 7;
          return Stack(
            alignment: Alignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Stack(
                    children: [
                      Image.asset(
                        Images.bull,
                        height: imageHeight,
                        width: constraints.maxWidth,
                        fit: BoxFit.cover,
                      ),
                      Positioned(
                        top: 0,
                        bottom: 0,
                        left: 0,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.bottomLeft,
                              colors: [
                                ThemeColors.background,
                                Colors.black,
                                // Colors.green,
                                // Colors.red,
                              ],
                            ),
                          ),
                          width: 30,
                          height: double.infinity,
                        ),
                      ),
                      Positioned(
                        top: 0,
                        right: 0,
                        left: 0,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomLeft,
                              colors: [
                                Colors.black,
                                ThemeColors.background,
                                // Colors.green,
                                // Colors.red,
                              ],
                            ),
                          ),
                          width: double.infinity,
                          height: 30,
                        ),
                      ),
                      Positioned(
                        top: 0,
                        right: 0,
                        bottom: 0,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.bottomLeft,
                              colors: [
                                Colors.black,
                                ThemeColors.background,

                                // Colors.green, Colors.red,
                              ],
                            ),
                          ),
                          width: 20,
                          height: double.infinity,
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        left: 0,
                        child: Container(
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              ThemeColors.background.withOpacity(0.1),
                              Colors.black,
                            ],
                          )),
                          width: double.infinity,
                          height: 30,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (sliderPosts != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: CarouselSlider(
                    options: CarouselOptions(
                      height: imageHeight,
                      enlargeCenterPage: true,
                      autoPlay: true,
                      autoPlayInterval: const Duration(seconds: 3),
                      autoPlayAnimationDuration:
                          const Duration(milliseconds: 800),
                      pauseAutoPlayOnTouch: true,
                      viewportFraction: 1,
                      autoPlayCurve: Curves.fastOutSlowIn,
                      onPageChanged: (index, reason) {
                        _activeIndex = index;
                        setState(() {});
                      },
                    ),
                    items: sliderPosts.map((i) {
                      bool showAuthor =
                          i.authors != null && i.authors?.isNotEmpty == true;
                      bool showSite = i.site != null && i.site != '';
                      bool showDate =
                          i.publishedDate != null && i.publishedDate != '';

                      return Builder(
                        builder: (BuildContext context) {
                          return GestureDetector(
                            onTap: () => _newsDetail(slug: i.slug),
                            child: Container(
                              width: constraints.maxWidth,
                              padding: EdgeInsets.symmetric(
                                horizontal: 15,
                                vertical: 10,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    i.title ?? "",
                                    style: styleBaseBold(
                                      fontSize: 25,
                                      color: Colors.white,
                                    ),
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SpacerVertical(height: 10),
                                  Padding(
                                    padding:
                                        const EdgeInsets.only(top: Pad.pad5),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Flexible(
                                          child: RichText(
                                            text: TextSpan(
                                              children: [
                                                if (showAuthor)
                                                  TextSpan(
                                                    text: 'By ',
                                                    style: styleBaseRegular(
                                                      fontSize: 14,
                                                      color:
                                                          ThemeColors.greyText,
                                                    ),
                                                  ),
                                                if (showAuthor)
                                                  TextSpan(
                                                    text:
                                                        i.authors?.first.name ??
                                                            '',
                                                    style: styleBaseRegular(
                                                      fontSize: 14,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                if (showAuthor && showDate)
                                                  WidgetSpan(
                                                    alignment:
                                                        PlaceholderAlignment
                                                            .middle,
                                                    child: Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 4),
                                                      child: Icon(
                                                        Icons.circle,
                                                        size: 4,
                                                        color: ThemeColors
                                                            .greyText,
                                                      ),
                                                    ),
                                                  ),
                                                if (showDate)
                                                  TextSpan(
                                                    text: i.publishedDate ?? '',
                                                    style: styleBaseRegular(
                                                      fontSize: 14,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Visibility(
                                          visible: showSite,
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 10, vertical: 4),
                                            decoration: BoxDecoration(
                                              color: ThemeColors.secondary10,
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: Text(
                                              i.site ?? '',
                                              style: styleBaseRegular(
                                                fontSize: 14,
                                                color: ThemeColors.secondary120,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    }).toList(),
                  ),
                ),
              Visibility(
                visible: sliderPosts != null && sliderPosts.isNotEmpty == true,
                child: Positioned(
                  bottom: 10,
                  child: Container(
                    decoration: BoxDecoration(
                      color: ThemeColors.sliderDots,
                      borderRadius: BorderRadius.circular(36),
                      boxShadow: [
                        BoxShadow(
                          color: Color.fromRGBO(66, 66, 66, 0.25),
                          blurRadius: 30,
                          offset: Offset(0, 10),
                        ),
                      ],
                    ),
                    padding: EdgeInsets.symmetric(
                        horizontal: Pad.pad16, vertical: 8),
                    child: AnimatedSmoothIndicator(
                      activeIndex: _activeIndex,
                      count: sliderPosts?.length ?? 0,
                      effect: WormEffect(
                        activeDotColor: ThemeColors.primary120,
                        dotColor: ThemeColors.neutral20,
                        dotWidth: dotSize,
                        dotHeight: dotSize,
                      ),
                    ),
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
