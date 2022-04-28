import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:property_management/account/pages/account_page.dart';
import 'package:property_management/app/bloc/app_bloc.dart';
import 'package:property_management/app/widgets/box_button.dart';
import 'package:property_management/characteristics/cubit/characteristics_cubit.dart';
import 'package:property_management/dashboard/cubit/dashboard_cubit.dart';
import 'package:property_management/objects/bloc/objects_bloc.dart';
import 'package:property_management/objects/pages/list_owners_page.dart';
import 'package:property_management/objects/pages/search_objects_page.dart';
import 'package:property_management/objects/widgets/filter_bottom_sheet.dart';
import 'package:property_management/objects/widgets/search_text_field.dart';
import 'package:property_management/settings/pages/settings_page.dart';
import 'package:property_management/app/utils/utils.dart';
import 'create_object_page.dart';
import 'package:property_management/objects/widgets/object_card.dart';
import 'package:property_management/objects/widgets/object_skeleton.dart';
import 'package:property_management/app/theme/styles.dart';
import 'package:property_management/app/widgets/box_icon.dart';

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

class ListObjectsPage extends StatefulWidget {
  const ListObjectsPage({Key? key}) : super(key: key);

  @override
  State<ListObjectsPage> createState() => _ListObjectsPageState();
}

class _ListObjectsPageState extends State<ListObjectsPage> {
  bool isLoading = true;
  bool isPinned = false;

  ScrollController _controller = ScrollController();
  // PageStorageKey controllerKey = PageStorageKey<String>('controllerA');

  _scrollListener() {
    if (_controller.offset >= 110){
      setState(() {
        isPinned = true;
      });
    } else {
      setState(() {
        isPinned = false;
      });
    }
  }

  @override
  void initState() {
    _controller.addListener(_scrollListener);
    super.initState();
    // Timer(const Duration(seconds: 2), () {
    //   setState(() {
    //     isLoading = false;
    //   });
    // });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF5F7F9),
      body:  BlocConsumer<ObjectsBloc, ObjectsState>(
          listener: (context, state) {
            if (state.status == ObjectsStatus.fetched && _controller.positions.isNotEmpty) {
              _controller.jumpTo(0);
            }
          },
          builder: (context, state) {
            return NestedScrollView(
              // key: controllerKey,
              controller: _controller,
              headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
                return <Widget>[
                  SliverAppBar(
                    centerTitle: true,
                    elevation: 0,
                    forceElevated: innerBoxIsScrolled,
                    title: Row(
                      children: [
                        Spacer(),
                        BoxIcon(
                          iconPath: 'assets/icons/profile.svg',
                          iconColor: Colors.black,
                          backgroundColor: Colors.white,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => AccountPage()),
                            );
                          },
                        ),
                        if (context.read<AppBloc>().state.user.isAdminOrManager())
                          Row(
                            children: [
                              SizedBox(
                                width: 12,
                              ),
                              BoxIcon(
                                iconPath: 'assets/icons/settings.svg',
                                iconColor: Colors.black,
                                backgroundColor: Colors.white,
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => ListOwnersPage(
                                      title: 'Настройки',
                                      onTap: () {},
                                    )),
                                  );
                                },
                              ),
                            ],
                          ),
                      ],
                    ),
                    expandedHeight: 110,
                    toolbarHeight: 70,
                    collapsedHeight: 70,
                    pinned: true,
                    backgroundColor: Color(0xffF5F7F9),
                    flexibleSpace: LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
                      return FlexibleSpaceBar(
                        centerTitle: constraints.biggest.height > 70 ? false : true,
                        titlePadding: constraints.biggest.height > 70
                            ? EdgeInsets.symmetric(horizontal: horizontalPadding(context, 44))
                            : EdgeInsets.symmetric(vertical: 24),
                        title: AnimatedOpacity(
                          duration: Duration(milliseconds: 300),
                          opacity: 1.0,
                          child: Text('Объекты',
                              style: constraints.biggest.height > 70
                                  ? heading1Style.copyWith(fontSize: 24)
                                  : body,
                          ),
                        ),
                      );
                    })
                  ),
                  // if (state.status == ObjectsStatus.fetched && state.places.isNotEmpty)
                    SliverPersistentHeader(
                      pinned: false,
                      delegate: _SliverAppBarDelegate(
                        minHeight: 44,
                        maxHeight: 44,
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: horizontalPadding(context, 44)),
                          child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                    pageBuilder: (context, animation1, animation2) => SearchObjectsPage(
                                      onTapObject: (String id) {
                                        context.read<CharacteristicsCubit>().changeSelectedPlaceId(null, state.places, id: id, isJump: true);
                                        context.read<DashboardCubit>().getNavBarItem(DashboardItem.characteristics);
                                      }
                                    ),
                                    transitionDuration: Duration.zero,
                                  ),
                                );
                              },
                              child: SearchTextField()
                          ),
                        ),
                      ),
                    ),
                  // if (state.status == ObjectsStatus.fetched && state.places.isNotEmpty)
                    SliverPersistentHeader(
                      pinned: false,
                      delegate: _SliverAppBarDelegate(
                        minHeight: 24,
                        maxHeight: 24,
                        child: Container(),
                      ),
                    ),
                  if (isPinned && state.status == ObjectsStatus.fetched && state.places.isNotEmpty)
                    SliverPersistentHeader(
                      pinned: true,
                      delegate: _SliverAppBarDelegate(
                        minHeight: 56,
                        maxHeight: 56,
                        child: Container(
                          height: 56,
                          constraints: BoxConstraints(maxWidth: 1.sw),
                          padding: EdgeInsets.symmetric(horizontal: horizontalPadding(context, 44)),
                          decoration: BoxDecoration(
                            color: Color(0xffF5F7F9),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  showModalBottomSheet(
                                      context: context,
                                      backgroundColor: Colors.transparent, isScrollControlled: true,
                                      builder: (context) {
                                        return FilterBottomSheet(
                                          filterBy: state.filterBy,
                                        );
                                      }
                                  );
                                },
                                child: Row(
                                  children: [
                                    SvgPicture.asset(
                                      'assets/icons/filter.svg',
                                      color: Colors.black,
                                      height: 12,
                                    ),
                                    SizedBox(width: 4),
                                    Text(
                                      state.filterBy == 'name'
                                          ? 'По названию'
                                          : 'По адресу',
                                      style: title2.copyWith(
                                          color: Colors.black,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              if (context.read<AppBloc>().state.user.isAdminOrManager())
                                GestureDetector(
                                  onTap: (){
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => ListOwnersPage(
                                        title: 'Новый объект',
                                        onTap: () {},
                                      )),
                                    );
                                  },
                                  child: Row(
                                    children: [
                                      SvgPicture.asset(
                                        'assets/icons/plus.svg',
                                        color: Color(0xff4B81EF),
                                        height: 16,
                                      ),
                                      SizedBox(width: 4),
                                      Text(
                                        'Добавить',
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
                      ),
                    ),
                ];
              },
              // body: Container(),
              body: Container(
                decoration: BoxDecoration(
                    color: Color(0xffFCFCFC),
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(24),
                      topLeft: Radius.circular(24),
                    )
                ),
                child: state.places.isEmpty && state.status == ObjectsStatus.fetched
                    ? Stack(
                      children: [
                          CustomScrollView(
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
                                        'У Вас пока не добавлен ни один объект',
                                        textAlign: TextAlign.center,
                                        style: body.copyWith(
                                          color: Color(0xffC7C9CC),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                        if (context.read<AppBloc>().state.user.isAdminOrManager() && state.status == ObjectsStatus.fetched && state.places.isEmpty)
                          Positioned(
                            bottom: 24,
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: horizontalPadding(context, 0.25.sw), vertical: 16),
                              child: SizedBox(
                                width: 1.sw - horizontalPadding(context, 0.25.sw) * 2,
                                child: BoxButton(
                                  title: 'Добавить',
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => ListOwnersPage(
                                        title: 'Новый объект',
                                        onTap: () {},
                                      )),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                      ],
                    )
                    : Column(
                        children: [
                          if (!isPinned)
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: horizontalPadding(context, 44)),
                              height: 56,
                              decoration: BoxDecoration(
                                  color: Color(0xffFCFCFC),
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(24),
                                    topLeft: Radius.circular(24),
                                  )
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      showModalBottomSheet(
                                          context: context,
                                          backgroundColor: Colors.transparent, isScrollControlled: true,
                                          builder: (context) {
                                            return FilterBottomSheet(
                                              filterBy: state.filterBy,
                                            );
                                          }
                                      );
                                    },
                                    child: Row(
                                      children: [
                                        SvgPicture.asset(
                                          'assets/icons/filter.svg',
                                          color: Colors.black,
                                          height: 12,
                                        ),
                                        SizedBox(width: 4),
                                        Text(
                                          state.filterBy == 'name'
                                              ? 'По названию'
                                              : 'По адресу',
                                          style: title2.copyWith(
                                              color: Colors.black,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (context.read<AppBloc>().state.user.isAdminOrManager())
                                    GestureDetector(
                                      onTap: (){
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) => ListOwnersPage(
                                            title: 'Новый объект',
                                            onTap: () {},
                                          )),
                                        );
                                      },
                                      child: Row(
                                        children: [
                                          SvgPicture.asset(
                                            'assets/icons/plus.svg',
                                            color: Color(0xff4B81EF),
                                            height: 16,
                                          ),
                                          SizedBox(width: 4),
                                          Text(
                                            'Добавить',
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
                          SizedBox(
                            height: 16,
                          ),
                          Expanded(
                            child: RefreshIndicator(
                              onRefresh: () async {
                                var user = context.read<AppBloc>().state.user;
                                var owners = context.read<AppBloc>().state.owners;
                                context.read<ObjectsBloc>().add(ObjectsGetEvent(user: user, owners: owners));
                              },
                              color: Colors.white,
                              backgroundColor: Colors.blue,
                              child: ListView.builder(
                                  itemCount: state.status == ObjectsStatus.loading
                                      ? 10
                                      : state.places.length,
                                  itemBuilder: (BuildContext context, int index) {
                                    return Padding(
                                      padding: EdgeInsets.symmetric(horizontal: horizontalPadding(context, 44)),
                                      child: state.status == ObjectsStatus.loading
                                          ? ObjectSkeleton()
                                          : GestureDetector(
                                              onTap: () {
                                                context.read<CharacteristicsCubit>().changeSelectedPlaceId(index, state.places, isJump: true);
                                                context.read<DashboardCubit>().getNavBarItem(DashboardItem.characteristics);
                                              },
                                              child: ObjectCard(id: index, place: state.places[index], isLast: index == state.places.length - 1,)
                                            ),
                                    );
                                  }
                              ),
                            ),
                          ),
                        ],
                      ),
              ),
            );
          }
      ),
    );
  }
}