import 'dart:async';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:property_management/analytics/cubit/analytics_cubit.dart';
import 'package:property_management/app/widgets/custom_carousel_slider.dart';
import 'package:property_management/app/widgets/object_carousel_card.dart';
import 'package:property_management/characteristics/cubit/characteristics_cubit.dart';
import 'package:property_management/exploitation/cubit/exploitation_cubit.dart';
import 'package:property_management/objects/models/place.dart';

class AnalyticsCarouselSlider extends StatelessWidget {
  final List<Place> places;
  final CarouselController carouselController;
  AnalyticsCarouselSlider({Key? key, this.places = const [], required this.carouselController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AnalyticsCubit, AnalyticsState>(
      listener: (context, state) async {
        if (state.isJump) {
          carouselController.jumpToPage(state.selectedPlaceId);
        }
      },
      builder: (context, state) {
        return CustomCarouselSlider(
          places: places,
          carouselController: carouselController,
          selectedPlaceId: state.selectedPlaceId < places.length
              ? state.selectedPlaceId
              : 0,
          onPageChanged: (int index) {
            context.read<AnalyticsCubit>().changeSelectedPlaceId(index, places);
            context.read<ExploitationCubit>().changeSelectedPlaceId(index, places, isJump: true);
            context.read<CharacteristicsCubit>().changeSelectedPlaceId(index, places, isJump: true);
          },
        );
      },
    );
  }
}