import 'dart:async';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'create_object_page.dart';
import 'package:property_management/home/widgets/object_card.dart';
import 'package:property_management/home/widgets/object_skeleton.dart';
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
              // actions: [
              //   BoxIcon(
              //     iconPath: 'assets/icons/profile.svg',
              //     iconColor: Colors.black,
              //     backgroundColor: Colors.white,
              //   ),
              //   BoxIcon(
              //     iconPath: 'assets/icons/settings.svg',
              //     iconColor: Colors.black,
              //     backgroundColor: Colors.white,
              //   ),
              // ],
              expandedHeight: 138.h,
              toolbarHeight: 68.h,
              collapsedHeight: 68.h,
              pinned: true,
              backgroundColor: Color(0xffF5F7F9),
              flexibleSpace: LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
                return FlexibleSpaceBar(
                  centerTitle: constraints.biggest.height > 68.h ? false : true,
                  titlePadding: constraints.biggest.height > 68.h
                      ? EdgeInsets.symmetric(horizontal: 24.w)
                      : EdgeInsets.all(16.sp),
                  title: AnimatedOpacity(
                    duration: Duration(milliseconds: 300),
                    // opacity: constraints.biggest.height > 60.h ? 1.0 : 0.0,
                    opacity: 1.0,
                    child: Text('Объекты',
                        style: constraints.biggest.height > 68.h
                            ? heading1Style
                            : body,
                    ),
                  ),
                  // background: Container(
                  //   color: Colors.black,
                  // ),
                );
              })
            ),
            SliverPersistentHeader(
              pinned: false,
              delegate: _SliverAppBarDelegate(
                minHeight: 44.h,
                maxHeight: 44.h,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: TextField(
                    textInputAction: TextInputAction.search,
                    onTap: () {
                    },
                    // autofocus: true,
                    onChanged: (text) {
                    },
                    style: TextStyle(
                      color: Color(0xff151515),
                      fontWeight: FontWeight.w500,
                      fontSize: 16.sp,
                    ),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                            Radius.circular(15.sp) //                 <--- border radius here
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: new BorderSide(color: Color(0xffe9ecf1)),
                        borderRadius: BorderRadius.all(
                            Radius.circular(15.sp) //                 <--- border radius here
                        ),
                      ),
                      // prefixIconConstraints: BoxConstraints(maxWidth: 32.sp),
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
            SliverPersistentHeader(
              pinned: false,
              delegate: _SliverAppBarDelegate(
                minHeight: 24.h,
                maxHeight: 24.h,
                child: Container(),
              ),
            ),
            // SliverPersistentHeader(
            //   pinned: true,
            //   delegate: _SliverAppBarDelegate(
            //     minHeight: 56.h,
            //     maxHeight: 56.h,
            //     child: Container(
            //       padding: EdgeInsets.symmetric(horizontal: 24.sp),
            //       color: Colors.white,
            //       child: Row(
            //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //         children: [
            //           Text('asfasf'),
            //           Text('asfasf'),
            //         ],
            //       ),
            //     ),
            //   ),
            // ),
          ];
        },
        body: Container(
          decoration: BoxDecoration(
              color: Color(0xffFCFCFC),
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(24.sp),
                topLeft: Radius.circular(24.sp),
              )
          ),
          child: CustomScrollView(
            slivers: [
              SliverPersistentHeader(
                pinned: true,
                delegate: _SliverAppBarDelegate(
                  minHeight: 56.h,
                  maxHeight: 56.h,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 24.sp),
                    // color: Color(0xffFCFCFC),
                    decoration: BoxDecoration(
                        color: Color(0xffFCFCFC),
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(24.sp),
                          topLeft: Radius.circular(24.sp),
                        )
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            SvgPicture.asset(
                              'assets/icons/filter.svg',
                              color: Colors.black,
                              height: 12.h,
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              'По названию',
                              style: title2.copyWith(
                                color: Colors.black,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w400
                              ),
                            ),
                          ],
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
                                height: 16.h,
                              ),
                              SizedBox(width: 4.w),
                              Text(
                                'Добавить',
                                style: title2.copyWith(
                                  color: Color(0xff4B81EF),
                                  fontSize: 14.sp,
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
                      padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 24.w),
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