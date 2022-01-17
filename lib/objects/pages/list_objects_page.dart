import 'dart:async';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:property_management/account/pages/account_page.dart';
import 'package:property_management/objects/pages/search_objects_page.dart';
import 'package:property_management/objects/widgets/filter_bottom_sheet.dart';
import 'package:property_management/objects/widgets/search_text_field.dart';
import 'package:property_management/settings/pages/settings_page.dart';
import 'package:property_management/utils/utils.dart';
import 'create_object_page.dart';
import 'package:property_management/objects/widgets/object_card.dart';
import 'package:property_management/objects/widgets/object_skeleton.dart';
import 'package:property_management/theme/colors.dart';
import 'package:property_management/theme/styles.dart';
import 'package:property_management/widgets/box_icon.dart';

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
  final Function() goToCharacteristicsPage;
  const ListObjectsPage({Key? key, required this.goToCharacteristicsPage}) : super(key: key);

  @override
  State<ListObjectsPage> createState() => _ListObjectsPageState();
}

class _ListObjectsPageState extends State<ListObjectsPage> {
  bool isLoading = true;
  bool isPinned = false;

  ScrollController _controller = ScrollController();

  _scrollListener() {
    if (_controller.offset >= 138 + 50){
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
    Timer(const Duration(seconds: 2), () {
      setState(() {
        isLoading = false;
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF5F7F9),
      body:  NestedScrollView(
        controller: _controller,
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              centerTitle: true,
              elevation: 0,
              forceElevated: innerBoxIsScrolled,
              title: true == true /// Зависимость от ориентации
                  ? Row(
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
                              MaterialPageRoute(builder: (context) => SettingsPage()),
                            );
                          },
                        ),
                      ],
                    )
                  : null,
              expandedHeight: 138,
              toolbarHeight: 68,
              collapsedHeight: 68,
              pinned: true,
              backgroundColor: Color(0xffF5F7F9),
              flexibleSpace: LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
                return FlexibleSpaceBar(
                  centerTitle: constraints.biggest.height > 68 ? false : true,
                  titlePadding: constraints.biggest.height > 68
                      ? EdgeInsets.symmetric(horizontal: horizontalPadding(44))
                      : EdgeInsets.all(24),
                  title: AnimatedOpacity(
                    duration: Duration(milliseconds: 300),
                    opacity: 1.0,
                    child: Text('Объекты',
                        style: constraints.biggest.height > 68
                            ? heading1Style.copyWith(fontSize: 24)
                            : body,
                    ),
                  ),
                );
              })
            ),
            SliverPersistentHeader(
              pinned: false,
              delegate: _SliverAppBarDelegate(
                minHeight: 44,
                maxHeight: 44,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: horizontalPadding(44)),
                  child: true == true
                      ? SearchTextField()
                      : Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                    pageBuilder: (context, animation1, animation2) => SearchObjectsPage(),
                                    transitionDuration: Duration.zero,
                                  ),
                                );
                              },
                              child: Container(
                                width: 327,
                                child: SearchTextField(),
                              ),
                            ),
                            Spacer(),
                            Row(
                              children: [
                                BoxIcon(
                                  iconPath: 'assets/icons/profile.svg',
                                  iconColor: Colors.black,
                                  backgroundColor: Colors.white,
                                ),
                                SizedBox(
                                  width: 12,
                                ),
                                BoxIcon(
                                  iconPath: 'assets/icons/settings.svg',
                                  iconColor: Colors.black,
                                  backgroundColor: Colors.white,
                                ),
                              ],
                            ),
                          ],
                        ),
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
          child: Stack(
            children: [
              CustomScrollView(
                slivers: [
                  SliverPersistentHeader(
                    pinned: false,
                    delegate: _SliverAppBarDelegate(
                      minHeight: 56,
                      maxHeight: 56,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: horizontalPadding(44)),
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
                                    return FilterBottomSheet();
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
                                    'По названию',
                                    style: title2.copyWith(
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: (){
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => CreateObjectPage()),
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
                  SliverPersistentHeader(
                    pinned: false,
                    delegate: _SliverAppBarDelegate(
                      minHeight: 16,
                      maxHeight: 16,
                      child: Container(),
                      ),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index) {
                        return Padding(
                          padding: EdgeInsets.symmetric(horizontal: horizontalPadding(44)),
                          child: isLoading
                              ? ObjectSkeleton()
                              : GestureDetector(
                                  onTap: () {
                                    print(1);
                                    widget.goToCharacteristicsPage();
                                  },
                                  child: ObjectCard(id: index)
                                ),
                        );
                      },
                      childCount: objects.length,
                    ),
                  ),
                ],
              ),
              if (isPinned)
                Positioned(
                  top: 50,
                  child: Container(
                    height: 56,
                    constraints: BoxConstraints(maxWidth: 1.sw),
                    padding: EdgeInsets.symmetric(horizontal: horizontalPadding(44)),
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
                                  return FilterBottomSheet();
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
                                'По названию',
                                style: title2.copyWith(
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400
                                ),
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: (){
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => CreateObjectPage()),
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
            ],
          ),
        ),
      ),
    );
  }
}