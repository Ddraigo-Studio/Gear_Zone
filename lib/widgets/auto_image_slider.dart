import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../theme/theme_helper.dart';

class MyImageSlider extends StatefulWidget {
  const MyImageSlider({super.key});

  @override
  State<MyImageSlider> createState() => _MyImageSliderState();
}

class _MyImageSliderState extends State<MyImageSlider> {
  final myitems = [
    Image.asset('assets/images/img_product_detail.png'),
    Image.asset('assets/images/img_product_detail_4.png'),
    Image.asset('assets/images/img_product_detail_2.png'),
    Image.asset('assets/images/img_product_detail_3.png'),
    Image.asset('assets/images/img_product_detail_5.png'),
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
              height: 200, // Ensure it's constrained within the container
              autoPlayCurve: Curves.fastOutSlowIn,
              autoPlayAnimationDuration: const Duration(milliseconds: 800),
              autoPlayInterval: const Duration(seconds: 2),
              enlargeCenterPage: true,
              aspectRatio: 2.0,
              onPageChanged: (index, reason) {
                setState(() {
                  myCurrentIndex = index;
                });
              },
            ),
            items: myitems,
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
