import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:property_management/app/widgets/object_carousel_card.dart';

class CustomCarouselSlider extends StatefulWidget {
  const CustomCarouselSlider({Key? key}) : super(key: key);

  @override
  State<CustomCarouselSlider> createState() => _CustomCarouselSliderState();
}

class _CustomCarouselSliderState extends State<CustomCarouselSlider> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      options: CarouselOptions(
          viewportFraction: 316 / MediaQuery.of(context).size.width,
          height: 83,
          enableInfiniteScroll: true,
          onPageChanged: (int index, CarouselPageChangedReason reason) {
            setState(() {
              currentIndex = index;
            });
          }
      ),
      items: [1,2,3,4,5].map((i) {
        return Builder(
          builder: (BuildContext context) {
            return ObjectCarouselCard(
              id: i,
              bordered: currentIndex == i - 1,
            );
          },
        );
      }).toList(),
    );
  }
}