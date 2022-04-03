import 'dart:async';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:property_management/app/widgets/custom_carousel_slider.dart';
import 'package:property_management/app/widgets/object_carousel_card.dart';
import 'package:property_management/characteristics/cubit/characteristics_cubit.dart';
import 'package:property_management/exploitation/cubit/exploitation_cubit.dart';
import 'package:property_management/objects/models/place.dart';

class CharacteristicsCarouselSlider extends StatelessWidget {
  final List<Place> places;
  final CarouselController carouselController;
  CharacteristicsCarouselSlider({Key? key, this.places = const [], required this.carouselController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CharacteristicsCubit, CharacteristicsState>(
      listener: (context, state) async {
        if (state.isJump) {
          carouselController.jumpToPage(state.selectedPlaceId);
        }
      },
      builder: (context, state) {
        return CustomCarouselSlider(
          carouselController: carouselController,
          places: places,
          selectedPlaceId: state.selectedPlaceId,
          onPageChanged: (int index) {
            context.read<CharacteristicsCubit>().changeSelectedPlaceId(index, places);
            context.read<ExploitationCubit>().changeSelectedPlaceId(index, places, isJump: true);
          },
        );
      },
    );
  }
}