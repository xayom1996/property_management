import 'dart:math';

import 'package:carousel_slider/carousel_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:property_management/app/bloc/app_bloc.dart';
import 'package:property_management/app/bloc/app_state.dart';
import 'package:property_management/characteristics/cubit/characteristics_cubit.dart';
import 'package:property_management/characteristics/widgets/characteristics_carousel_slider.dart';
import 'package:property_management/characteristics/widgets/custom_tab_view.dart';
import 'package:property_management/objects/bloc/objects_bloc.dart';
import 'package:property_management/objects/pages/create_tenant_page.dart';
import 'package:property_management/objects/pages/edit_object_page.dart';
import 'package:property_management/objects/pages/edit_tenant_page.dart';
import 'package:property_management/app/theme/colors.dart';
import 'package:property_management/app/theme/styles.dart';
import 'package:property_management/app/widgets/box_icon.dart';
import 'package:property_management/app/widgets/custom_alert_dialog.dart';
import 'package:property_management/app/widgets/custom_tab_container.dart';

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });

  final double minHeight;
  final double maxHeight;
  final Widget child;

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => max(maxHeight, minHeight);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return new SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}

class CharacteristicsPage extends StatelessWidget {
  CharacteristicsPage({Key? key}) : super(key: key);

  bool isLoading = true;
  // int currentIndexTab = 0;

  List<Map> secondTabObjectItems = [];

  final CarouselController carouselController = CarouselController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
                centerTitle: true,
                elevation: 0,
                forceElevated: innerBoxIsScrolled,
                title: BlocBuilder<AppBloc, AppState>(
                  builder: (context, appState) {
                    return appState.user.isAdminOrManager()
                        ? Row(
                            children: [
                              Spacer(),
                              BlocBuilder<CharacteristicsCubit, CharacteristicsState>(
                                  builder: (context, state) {
                                    return BoxIcon(
                                      iconPath: 'assets/icons/edit.svg',
                                      iconColor: Colors.black,
                                      backgroundColor: Colors.white,
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) => state.currentIndexTab == 0
                                              ? EditObjectPage(id: state.selectedPlaceId)
                                              : context.read<ObjectsBloc>().state.places[state.selectedPlaceId].tenantItems != null
                                                ? EditTenantPage(id: state.selectedPlaceId)
                                                : CreateTenantPage(docId: context.read<ObjectsBloc>().state.places[state.selectedPlaceId].id),
                                          ),
                                        );
                                      },
                                    );
                                  }
                              ),
                              SizedBox(
                                width: 12.w,
                              ),
                              BoxIcon(
                                iconPath: 'assets/icons/trash.svg',
                                iconColor: Colors.black,
                                backgroundColor: Colors.white,
                                onTap: () {
                                  showDialog(
                                      context: context,
                                      builder: (context) => CustomAlertDialog(
                                        title: 'Вы действительно хотите удалить карточку объекта?',
                                        onApprove: () {
                                          context.read<ObjectsBloc>().add(DeleteObjectEvent(index: context.read<CharacteristicsCubit>().state.selectedPlaceId));
                                        }
                                      )
                                  );
                                },
                              ),
                            ],
                          )
                        : Container();
                  }
                ),
                expandedHeight: 70,
                toolbarHeight: 70,
                collapsedHeight: 70,
                pinned: true,
                backgroundColor: kBackgroundColor,
                flexibleSpace: LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
                  return FlexibleSpaceBar(
                    centerTitle: true,
                    titlePadding: EdgeInsets.symmetric(vertical: 24),
                    title: Text('Характеристики',
                      style: body,
                    ),
                  );
                })
            ),
            SliverPersistentHeader(
              pinned: false,
              delegate: _SliverAppBarDelegate(
                minHeight: 83,
                maxHeight: 83,
                child: BlocBuilder<ObjectsBloc, ObjectsState>(
                    buildWhen: (previousState, state) {
                      print(previousState.places.hashCode);
                      print(state.places.hashCode);
                      return previousState.places != state.places;
                    },
                    builder: (context, state) {
                      // context.read<CharacteristicsCubit>().changeSelectedPlaceId(0, state.places);
                      return CharacteristicsCarouselSlider(
                          key: const Key('carousel'),
                          places: state.places,
                          carouselController: carouselController,
                      );
                    }
                ),
              ),
            ),
            SliverPersistentHeader(
              pinned: false,
              delegate: _SliverAppBarDelegate(
                minHeight: 24,
                maxHeight: 24,
                child: Container(
                  color: kBackgroundColor,
                ),
              ),
            ),
            SliverPersistentHeader(
              pinned: true,
              delegate: _SliverAppBarDelegate(
                minHeight: 53,
                maxHeight: 53,
                child: BlocBuilder<CharacteristicsCubit, CharacteristicsState>(
                    buildWhen: (previousState, state) {
                      return previousState.currentIndexTab != state.currentIndexTab;
                    },
                    builder: (context, state) {
                      return CustomTabContainer(
                        firstTab: 'Объект',
                        secondTab: 'Арендатор',
                        currentIndex: state.currentIndexTab,
                        onChange: (int index) {
                          context.read<CharacteristicsCubit>().changeIndexTab(index);
                          // setState(() {
                          //   currentIndexTab = index;
                          // });
                        },
                      );
                    }
                ),
              ),
            ),
          ];
        },
        body: BlocBuilder<CharacteristicsCubit, CharacteristicsState>(
            buildWhen: (previousState, state) {
              return previousState.currentIndexTab != state.currentIndexTab ||
                  previousState.selectedPlaceId != state.selectedPlaceId;
            },
            builder: (context, state) {
              return BlocBuilder<ObjectsBloc, ObjectsState>(
                  builder: (context, objectState) {
                  return state.currentIndexTab == 0
                      ? CustomTabView(
                          objectItems: objectState.places.isEmpty
                              ? {}
                              : objectState.places[state.selectedPlaceId].objectItems,
                        )
                      : CustomTabView(
                          objectItems: objectState.places.isEmpty
                              ? {}
                              : objectState.places[state.selectedPlaceId].tenantItems ?? {},
                          checkbox: true,
                          textButton: objectState.places[state.selectedPlaceId].tenantItems == null
                              ? context.read<AppBloc>().state.user.isAdminOrManager()
                                ? GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => CreateTenantPage(docId: objectState.places[state.selectedPlaceId].id)),
                                      );
                                    },
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        SvgPicture.asset(
                                          'assets/icons/plus.svg',
                                          color: Color(0xff4B81EF),
                                          height: 16,
                                        ),
                                        SizedBox(width: 10),
                                        Text(
                                          'Добавить характеристики арендатора',
                                          style: title2.copyWith(
                                              color: Color(0xff4B81EF),
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : CustomScrollView(
                                    slivers: [
                                      SliverFillRemaining(
                                        hasScrollBody: false,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            SvgPicture.asset(
                                              'assets/icons/home_white.svg',
                                              color: Color(0xffE9ECEE),
                                              height: 80,
                                            ),
                                            SizedBox(
                                              height: 32,
                                            ),
                                            Text(
                                              'Данные не заполнены, обратитесь к вашему менеджеру',
                                              textAlign: TextAlign.center,
                                              style: body.copyWith(
                                                color: Color(0xffC7C9CC),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  )
                              : null,
                        );
                }
              );
            }
        ),
      )
    );
  }
}