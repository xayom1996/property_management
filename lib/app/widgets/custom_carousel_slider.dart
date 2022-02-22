import 'dart:async';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:property_management/app/widgets/object_carousel_card.dart';
import 'package:property_management/characteristics/cubit/characteristics_cubit.dart';
import 'package:property_management/objects/models/place.dart';

class CustomCarouselSlider extends StatelessWidget {
  final List<Place>? places;
  final int? selectedPlaceId;
  final Function(int)? onPageChanged;
  final CarouselController? carouselController;
  CustomCarouselSlider({Key? key, this.places = const [], this.selectedPlaceId, this.onPageChanged, this.carouselController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List fixedList = Iterable<int>.generate(places!.length).toList();

    return CarouselSlider(
      carouselController: carouselController,
      options: CarouselOptions(
        viewportFraction: 316 / MediaQuery.of(context).size.width,
        height: 83,
        enableInfiniteScroll: false,
        // initialPage: 2,
        onPageChanged: (int index, CarouselPageChangedReason reason) {
          if (index != selectedPlaceId) {
            onPageChanged!(index);
          }
        },
      ),
      items: fixedList.map((index) {
        return Builder(
          builder: (BuildContext context) {
            return ObjectCarouselCard(
              place: places![index],
              bordered: selectedPlaceId == index,
            );
          },
        );
      }).toList(),
    );
  }
}