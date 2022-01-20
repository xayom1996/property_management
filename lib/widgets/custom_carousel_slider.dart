import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:property_management/widgets/object_carousel_card.dart';

class CustomCarouselSlider extends StatelessWidget {
  const CustomCarouselSlider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      options: CarouselOptions(
          viewportFraction: 300 / MediaQuery.of(context).size.width,
          height: 83,
          enableInfiniteScroll: true,
          onPageChanged: (int index, CarouselPageChangedReason reason) {
          }
      ),
      items: [1,2,3,4,5].map((i) {
        return Builder(
          builder: (BuildContext context) {
            return ObjectCarouselCard(id: i);
          },
        );
      }).toList(),
    );
  }

}