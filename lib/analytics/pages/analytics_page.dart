import 'dart:async';
import 'dart:math';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:property_management/analytics/cubit/analytics_cubit.dart';
import 'package:property_management/analytics/cubit/edit_plan_cubit.dart';
import 'package:property_management/analytics/models/model.dart';
import 'package:property_management/analytics/pages/analytics_charts.dart';
import 'package:property_management/analytics/pages/create_plan_page.dart';
import 'package:property_management/analytics/widgets/analytics_carousel_slider.dart';
import 'package:property_management/app/bloc/app_bloc.dart';
import 'package:property_management/app/cubit/adding/adding_state.dart';
import 'package:property_management/app/cubit/editing/editing_state.dart';
import 'package:property_management/characteristics/models/characteristics.dart';
import 'package:property_management/characteristics/widgets/characteristics_carousel_slider.dart';
import 'package:property_management/characteristics/widgets/custom_tab_view.dart';
import 'package:property_management/exploitation/cubit/exploitation_cubit.dart';
import 'package:property_management/objects/bloc/objects_bloc.dart';
import 'package:property_management/objects/models/place.dart';
import 'package:property_management/objects/widgets/object_card.dart';
import 'package:property_management/objects/widgets/object_skeleton.dart';
import 'package:property_management/app/theme/colors.dart';
import 'package:property_management/app/theme/styles.dart';
import 'package:property_management/app/utils/utils.dart';
import 'package:property_management/app/widgets/box_button.dart';
import 'package:property_management/app/widgets/box_icon.dart';
import 'package:property_management/app/widgets/container_for_transition.dart';
import 'package:property_management/app/widgets/custom_alert_dialog.dart';
import 'package:property_management/app/widgets/custom_carousel_slider.dart';
import 'package:property_management/app/widgets/custom_tab_container.dart';
import 'package:property_management/app/widgets/input_field.dart';
import 'package:property_management/app/widgets/object_carousel_card.dart';

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

class AnalyticsPage extends StatefulWidget {
  const AnalyticsPage({Key? key}) : super(key: key);

  @override
  State<AnalyticsPage> createState() => _AnalyticsPageState();
}

class _AnalyticsPageState extends State<AnalyticsPage> {
  bool isLoading = true;
  int currentIndexTab = 0;

  List<Map> firstTabObjectItems = [];

  List<Map> secondTabObjectItems = [];

  final CarouselController carouselController = CarouselController();

  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 4), () {
      setState(() {
        isLoading = false;
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: BlocBuilder<ObjectsBloc, ObjectsState>(
        buildWhen: (previousState, state) {
          return previousState.places != state.places;
        },
        builder: (context, objectState) {
          return NestedScrollView(
            headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                SliverAppBar(
                    centerTitle: true,
                    elevation: 0,
                    forceElevated: innerBoxIsScrolled,
                    expandedHeight: 70,
                    toolbarHeight: 70,
                    collapsedHeight: 70,
                    pinned: true,
                    backgroundColor: kBackgroundColor,
                    flexibleSpace: LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
                      return FlexibleSpaceBar(
                        centerTitle: true,
                        titlePadding: EdgeInsets.symmetric(vertical: 24),
                        title: Text('Аналитика',
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
                          return previousState.places != state.places;
                        },
                        builder: (context, state) {
                          // context.read<CharacteristicsCubit>().changeSelectedPlaceId(0, state.places);
                          return AnalyticsCarouselSlider(
                            key: const Key('analytics_carousel'),
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
                    child: Container(),
                  ),
                ),
                SliverPersistentHeader(
                  pinned: true,
                  delegate: _SliverAppBarDelegate(
                    minHeight: 53,
                    maxHeight: 53,
                    child: CustomTabContainer(
                      firstTab: 'План',
                      secondTab: 'Факт',
                      currentIndex: currentIndexTab,
                      onChange: (int index) {
                        setState(() {
                          currentIndexTab = index;
                        });
                      },
                    ),
                  ),
                ),
              ];
            },
            body: currentIndexTab == 0
                ? CustomTabView(
                    objectItems: {},
                    child: BlocBuilder<AnalyticsCubit, AnalyticsState>(
                      buildWhen: (previousState, state) {
                        return previousState.selectedPlaceId != state.selectedPlaceId ||
                            previousState.currentIndexTab != state.currentIndexTab;
                      },
                      builder: (context, state) {
                        var plansItems = [];
                        if (objectState.places.isNotEmpty) {
                          plansItems = objectState.places[context.read<AnalyticsCubit>().state.selectedPlaceId].plansItems ?? [];
                        }

                        return plansItems.isEmpty && !context.read<AppBloc>().state.user.isAdminOrManager()
                            ? CustomScrollView(
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
                            : SingleChildScrollView(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: horizontalPadding(context, 44), vertical: 16),
                                  child: Column(
                                    children: [
                                      for (var i = 0; i < plansItems.length; i++)
                                        BlocConsumer<EditPlanCubit, EditingState>(
                                          listener: (context, state) {
                                            if (state.status == StateStatus.success) {
                                              context.read<ObjectsBloc>().add(ObjectsUpdateEvent());
                                            }
                                          },
                                          builder: (context, state) {
                                            return Slidable(
                                              key: ValueKey(plansItems[i].hashCode),
                                              enabled: context.read<AppBloc>().state.user.isAdminOrManager(),
                                              endActionPane: ActionPane(
                                                motion: ScrollMotion(),
                                                children: [
                                                  Spacer(),
                                                  Align(
                                                    alignment: Alignment.topCenter,
                                                    child: Padding(
                                                      padding: EdgeInsets.only(top: 5),
                                                      child: BoxIcon(
                                                        iconPath: 'assets/icons/trash.svg',
                                                        iconColor: Colors.black,
                                                        backgroundColor: Colors.white,
                                                        onTap: () {
                                                          showDialog(
                                                              context: context,
                                                              builder: (context) => CustomAlertDialog(
                                                                title: 'Вы действительно хотите удалить план?',
                                                                onApprove: () {
                                                                  Place place = context.read<ObjectsBloc>().state.places[context.read<AnalyticsCubit>().state.selectedPlaceId];
                                                                  context.read<EditPlanCubit>().getItems(plansItems[i], place.id);
                                                                  context.read<EditPlanCubit>().edit(i, action: 'delete');
                                                                },
                                                              ),
                                                          );
                                                        },

                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                ],
                                              ),
                                              child: ContainerForTransition(
                                                title: plansItems[i]['Название плана']!.getFullValue(),
                                                onTap: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(builder: (context) => AnalyticCharts(
                                                      title: plansItems[i]['Название плана']!.getFullValue(),
                                                      planIndex: i,
                                                    )),
                                                  );
                                                },
                                              ),
                                            );
                                          }
                                        ),
                                      const SizedBox(
                                        height: 48,
                                      ),
                                      if (plansItems.length < 3 && context.read<AppBloc>().state.user.isAdminOrManager())
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(builder: (context) => CreatePlanPage(
                                                docId: objectState.places[context.read<AnalyticsCubit>().state.selectedPlaceId].id,
                                              )),
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
                                                'Добавить план',
                                                style: title2.copyWith(
                                                    color: Color(0xff4B81EF),
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w400
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              );
                      }
                    ),
                    textButton: secondTabObjectItems.isEmpty
                        ? GestureDetector(
                      onTap: () {

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
                            'Добавить план',
                            style: title2.copyWith(
                                color: Color(0xff4B81EF),
                                fontSize: 14,
                                fontWeight: FontWeight.w400
                            ),
                          ),
                        ],
                      ),
                    )
                        : null,
                  )
                : CustomTabView(
                    objectItems: {},
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: horizontalPadding(context, 44), vertical: 16),
                        child: Column(
                          children: [
                            ContainerForTransition(
                              title: 'Таблица “Факт”',
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => AnalyticCharts(
                                    title: 'Таблица “Факт”',
                                  )),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    textButton: secondTabObjectItems.isEmpty
                        ? GestureDetector(
                      onTap: () {

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
                            'Добавить факт',
                            style: title2.copyWith(
                                color: Color(0xff4B81EF),
                                fontSize: 14,
                                fontWeight: FontWeight.w400
                            ),
                          ),
                        ],
                      ),
                    )
                        : null,
                  ),
          );
        }
      ),
    );
  }
}