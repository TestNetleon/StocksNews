import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:stocks_news_new/modals/home_slider_res.dart';
import 'package:stocks_news_new/modals/news_datail_res.dart';
import 'package:stocks_news_new/providers/home_provider.dart';
import 'package:stocks_news_new/screens/blogDetail/widgets/item.dart';
import 'package:stocks_news_new/screens/tabs/news/newsAuthor/index.dart';
import 'package:stocks_news_new/screens/tabs/news/newsDetail/new_detail.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

class HomeTopNewsSlider extends StatefulWidget {
  const HomeTopNewsSlider({super.key});

  @override
  State<HomeTopNewsSlider> createState() => _HomeTopNewsSliderState();
}

//
class _HomeTopNewsSliderState extends State<HomeTopNewsSlider> {
  int _activeIndex = 0;

  void _newsDetail({String? slug}) {
    Navigator.pushNamed(
      context,
      NewsDetails.path,
      arguments: {"slug": slug},
    );
  }

  @override
  Widget build(BuildContext context) {
    List<SliderPost>? sliderPosts =
        context.watch<HomeProvider>().homeSliderRes?.sliderPosts;

    return LayoutBuilder(
      builder: (context, constraints) {
        double imageHeight = constraints.maxWidth * 0.6;
        double dotSize = 7.sp;
        return Stack(
          alignment: Alignment.center,
          children: [
            Stack(
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
                          ThemeColors.background.withOpacity(0.1),
                          Colors.black,
                          // Colors.green,
                          // Colors.red,
                        ],
                      ),
                    ),
                    width: 30.sp,
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
                          ThemeColors.background.withOpacity(0.1),
                          // Colors.green,
                          // Colors.red,
                        ],
                      ),
                    ),
                    width: double.infinity,
                    height: 30.sp,
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
                          ThemeColors.background.withOpacity(0.1),

                          // Colors.green, Colors.red,
                        ],
                      ),
                    ),
                    width: 20.sp,
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
                    height: 30.sp,
                  ),
                ),
              ],
            ),
            if (sliderPosts != null)
              CarouselSlider(
                options: CarouselOptions(
                  height: imageHeight,
                  enlargeCenterPage: true,
                  autoPlay: true,
                  autoPlayInterval: const Duration(seconds: 3),
                  autoPlayAnimationDuration: const Duration(milliseconds: 800),
                  pauseAutoPlayOnTouch: true,
                  viewportFraction: 1,
                  autoPlayCurve: Curves.fastOutSlowIn,
                  onPageChanged: (index, reason) {
                    _activeIndex = index;
                    setState(() {});
                  },
                ),
                items: sliderPosts.map((i) {
                  return Builder(
                    builder: (BuildContext context) {
                      return GestureDetector(
                        onTap: () => _newsDetail(slug: i.slug),
                        // onTap: () => openUrl(i.url),
                        child: Container(
                          width: constraints.maxWidth,
                          padding: EdgeInsets.symmetric(
                              horizontal: 15.sp, vertical: 10.sp),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                i.title ?? "",
                                style: styleGeorgiaBold(fontSize: 25),
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SpacerVertical(height: 10),
                              Padding(
                                padding: EdgeInsets.only(bottom: 3.sp),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Visibility(
                                      visible: i.authors != null &&
                                          i.authors?.isNotEmpty == true,
                                      child: Text(
                                        "By ",
                                        style: styleGeorgiaRegular(
                                            color: ThemeColors.greyText,
                                            fontSize: 13),
                                      ),
                                    ),
                                    Flexible(
                                      child: NewsDetailAuthorA(
                                        type: BlogsType.author,
                                        title: "Author: ",
                                        data: i.authors,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                i.publishedDate ?? "",
                                style: styleGeorgiaRegular(
                                    color: ThemeColors.greyText, fontSize: 13),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }).toList(),
              ),
            Positioned(
              bottom: 5.sp,
              child: AnimatedSmoothIndicator(
                activeIndex: _activeIndex,
                count: sliderPosts?.length ?? 0,
                effect: WormEffect(
                  activeDotColor: ThemeColors.accent,
                  dotColor: ThemeColors.gradientLight,
                  dotWidth: dotSize,
                  dotHeight: dotSize,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class NewsDetailAuthorA extends StatelessWidget {
  final List<DetailListType>? data;
  final String title;
  final BlogsType type;
  final double fontSize;
  final bool underLines;
  const NewsDetailAuthorA({
    super.key,
    this.data,
    required this.title,
    required this.type,
    this.underLines = true,
    this.fontSize = 13,
  });

  @override
  Widget build(BuildContext context) {
    // List<DetailListType>? authors =
    //     context.watch<NewsDetailProvider>().data?.postDetail?.authors;
    List<Widget> widgets = [];
    if (data == null) {
      return const SizedBox();
    }

    if (data?.isNotEmpty == true) {
      for (int i = 0; i < data!.length; i++) {
        widgets.add(
          InkWell(
            onTap: () {
              Navigator.pushNamed(context, NewsAuthorIndex.path, arguments: {
                "data": data?[i],
                "type": type,
              });
            },
            child: Text(
              "${data?[i].name}",
              style: styleGeorgiaRegular(
                  color: ThemeColors.white,
                  fontSize: fontSize,
                  decoration: underLines ? TextDecoration.underline : null),
            ),
          ),
        );
        if (i != data!.length - 1) {
          widgets.add(
            Text(
              ", ",
              style: styleGeorgiaRegular(
                  color: ThemeColors.white, fontSize: fontSize),
            ),
          );
        }
      }
    }

    return BlogDetailClickItem(
      fromNews: true,
      showTopDivider: false,
      showBottomDivider: false,
      children: widgets,
    );
  }
}
