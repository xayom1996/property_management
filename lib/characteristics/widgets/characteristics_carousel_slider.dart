import 'dart:async';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:property_management/analytics/cubit/analytics_cubit.dart';
import 'package:property_management/app/bloc/app_bloc.dart';
import 'package:property_management/app/widgets/custom_carousel_slider.dart';
import 'package:property_management/app/widgets/object_carousel_card.dart';
import 'package:property_management/characteristics/cubit/characteristics_cubit.dart';
import 'package:property_management/exploitation/cubit/exploitation_cubit.dart';
import 'package:property_management/objects/bloc/objects_bloc.dart';
import 'package:property_management/objects/cubit/add_tenant/add_tenant_cubit.dart';
import 'package:property_management/objects/models/place.dart';

class CharacteristicsCarouselSlider extends StatelessWidget {
  final List<Place> places;
  final CarouselController carouselController;
  CharacteristicsCarouselSlider({Key? key, this.places = const [], required this.carouselController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CharacteristicsCubit, CharacteristicsState>(
      listener: (context, state) async {
        Place place = context.read<ObjectsBloc>().state.places[state.selectedPlaceId];
        context.read<AddTenantCubit>().getItems(
            context.read<AppBloc>().state.owners[place.objectItems['Собственник']!.value]['tenant_characteristics']
        );
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
            context.read<AnalyticsCubit>().changeSelectedPlaceId(index, places, isJump: true);
          },
        );
      },
    );
  }
}