import 'dart:async';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:property_management/objects/pages/search_objects_page.dart';
import 'package:property_management/objects/widgets/filter_bottom_sheet.dart';
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
  const ListObjectsPage({Key? key}) : super(key: key);

  @override
  State<ListObjectsPage> createState() => _ListObjectsPageState();
}

class _ListObjectsPageState extends State<ListObjectsPage> {
  bool isLoading = true;

  @override
  void initState() {
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
                  ),
                  SizedBox(
                    width: 12.w,
                  ),
                  BoxIcon(
                    iconPath: 'assets/icons/settings.svg',
                    iconColor: Colors.black,
                    backgroundColor: Colors.white,
                  ),
                ],
              ),
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
                      : EdgeInsets.all(16),
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
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (context, animation1, animation2) => SearchObjectsPage(),
                          transitionDuration: Duration.zero,
                        ),
                      );
                    },
                    child: TextField(
                      textInputAction: TextInputAction.search,
                      enabled: false,
                      onTap: () {
                      },
                      onChanged: (text) {
                      },
                      style: TextStyle(
                        color: Color(0xff151515),
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                              Radius.circular(15) //                 <--- border radius here
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: new BorderSide(color: Color(0xffe9ecf1)),
                          borderRadius: BorderRadius.all(
                              Radius.circular(15) //                 <--- border radius here
                          ),
                        ),
                        disabledBorder: OutlineInputBorder(
                          borderSide: new BorderSide(color: Color(0xffe9ecf1)),
                          borderRadius: BorderRadius.all(
                              Radius.circular(15) //                 <--- border radius here
                          ),
                        ),
                        // prefixIconConstraints: BoxConstraints(maxWidth: 32),
                        hintText: 'Поиск',
                        hintStyle: body.copyWith(
                          color: Color(0xff3C3C43).withOpacity(0.6),
                        ),
                        prefixIcon: IconButton(
                          icon: Icon(
                            Icons.search,
                            size: 18,
                            color: Color(0xff3C3C43).withOpacity(0.6),
                          ),
                          onPressed: () {  },
                        ),
                        contentPadding: EdgeInsets.all(0),
                      ),
                    ),
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
        body: Container(
          decoration: BoxDecoration(
              color: Color(0xffFCFCFC),
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(24),
                topLeft: Radius.circular(24),
              )
          ),
          child: CustomScrollView(
            slivers: [
              SliverPersistentHeader(
                pinned: true,
                floating: true,
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
                              backgroundColor: Colors.transparent,
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
              SliverList(
                delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 16, horizontal: horizontalPadding(44)),
                      child: isLoading
                          ? ObjectSkeleton()
                          : ObjectCard(id: index),
                    );
                  },
                  childCount: 20,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}