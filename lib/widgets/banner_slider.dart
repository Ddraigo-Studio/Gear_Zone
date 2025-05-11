import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:gear_zone/core/utils/size_utils.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../core/utils/responsive.dart';
import '../theme/theme_helper.dart';

class MyBannerSlider extends StatefulWidget {
  const MyBannerSlider({super.key});

  @override
  State<MyBannerSlider> createState() => _MyBannerSliderState();
}

class _MyBannerSliderState extends State<MyBannerSlider> {
  final myitems = [
    'assets/images/banner_appbar.png',
    'assets/images/banner_appbar2.png',
    'assets/images/banner_appbar_3.png',
    'assets/images/banner_appbar4.png',
    'assets/images/banner_appbar5.png',
  ];

  int myCurrentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(          
          width: double.infinity,
          child: CarouselSlider(
            options: CarouselOptions(
              autoPlay: true,
              height: Responsive.isDesktop(context) ? 400.h : 250.h, // Tăng chiều cao để phù hợp với thiết kế mới
              autoPlayCurve: Curves.fastOutSlowIn,
              autoPlayAnimationDuration: const Duration(milliseconds: 800),
              autoPlayInterval: const Duration(seconds: 2),
              enlargeCenterPage: false,
              viewportFraction: 1.0,
              onPageChanged: (index, reason) {
                setState(() {
                  myCurrentIndex = index;
                });
              },
            ),
            items: myitems.map((item) {
              return Builder(
                builder: (BuildContext context) {
                  return Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(item),
                        fit: BoxFit.cover,
                      ),
                    ),
                    
                  );
                },
              );
            }).toList(),
          ),
        ),
        SizedBox(height: 8), // Add some space between the slider and the indicator
        AnimatedSmoothIndicator(
          activeIndex: myCurrentIndex,
          count: myitems.length,
          effect: WormEffect(
            dotHeight: 8,
            dotWidth: 8,
            spacing: 10,
            dotColor: Colors.grey.shade200,
            activeDotColor: appTheme.deepPurpleA100,
            paintStyle: PaintingStyle.fill,
          ),
        ),
      ],
    );
  }
}
