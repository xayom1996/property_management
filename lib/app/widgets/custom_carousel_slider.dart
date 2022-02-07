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
  CustomCarouselSlider({Key? key, this.places = const []}) : super(key: key);

  final CarouselController buttonCarouselController = CarouselController();

  @override
  Widget build(BuildContext context) {
    print('aa');
    final List fixedList = Iterable<int>.generate(places!.length).toList();
    return BlocConsumer<CharacteristicsCubit, CharacteristicsState>(
      listener: (context, state) {
        if (state.isJump) {
          buttonCarouselController.jumpToPage(state.selectedPlaceId);
        }
      },
      builder: (context, state) {
        return CarouselSlider(
          carouselController: buttonCarouselController,
          options: CarouselOptions(
              viewportFraction: 316 / MediaQuery.of(context).size.width,
              height: 83,
              enableInfiniteScroll: false,
              // initialPage: state.selectedPlaceId,
              onPageChanged: (int index, CarouselPageChangedReason reason) {
                context.read<CharacteristicsCubit>().changeSelectedPlaceId(index);
              },
          ),
          items: fixedList.map((index) {
            return Builder(
              builder: (BuildContext context) {
                return ObjectCarouselCard(
                  place: places![index],
                  bordered: state.selectedPlaceId == index,
                );
              },
            );
          }).toList(),
        );
      },
    );
  }
}