import 'dart:async';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:property_management/home/widgets/object_card.dart';
import 'package:property_management/home/widgets/object_skeleton.dart';
import 'package:property_management/theme/colors.dart';
import 'package:property_management/theme/styles.dart';
import 'package:property_management/widgets/box_button.dart';
import 'package:property_management/widgets/box_icon.dart';
import 'package:property_management/widgets/input_field.dart';

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

class CharacteristicsPage extends StatefulWidget {
  const CharacteristicsPage({Key? key}) : super(key: key);

  @override
  State<CharacteristicsPage> createState() => _CharacteristicsPageState();
}

class _CharacteristicsPageState extends State<CharacteristicsPage> {
  bool isLoading = true;

  List<Map> objectItems = [
    {'title': 'Название объекта', 'placeholder': 'Введите название объекта'},
    {'title': 'Адрес объекта', 'placeholder': 'Введите адрес объекта'},
    {'title': 'Площадь объекта', 'placeholder': 'Введите площадь объекта'},
    {'title': 'Собственник', 'placeholder': 'Введите собственника'},
    {'title': 'Выделенная мощность (электричество)', 'placeholder': 'Введите выделенную мощность'},
    {'title': 'Выделенная мощность (тепло) ', 'placeholder': 'Введите выделенную мощность'},
    {'title': 'Начальная стоимость', 'placeholder': 'Введите начальную стоимость'},
    {'title': 'Дата приобретения', 'placeholder': 'Введите дату приоюритения'},
  ];

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
                    iconPath: 'assets/icons/edit.svg',
                    iconColor: Colors.black,
                    backgroundColor: Colors.white,
                  ),
                  SizedBox(
                    width: 12.w,
                  ),
                  BoxIcon(
                    iconPath: 'assets/icons/trash.svg',
                    iconColor: Colors.black,
                    backgroundColor: Colors.white,
                  ),
                ],
              ),
              expandedHeight: 68.h,
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
                    child: Text('Характеристики',
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
          ];
        },
        body: Container(),
        // body: Stack(
        //   children: [
        //     Container(
        //       padding: EdgeInsets.symmetric(horizontal: 24.sp, vertical: 16.sp),
        //       child: SingleChildScrollView(
        //         child: Column(
        //           children: [
        //             for (var item in objectItems)
        //               BoxInputField(
        //                 controller: TextEditingController(),
        //                 placeholder: item['placeholder'],
        //                 title: item['title'],
        //                 enabled: false,
        //                 trailing: GestureDetector(
        //                   onTap: () {
        //                   },
        //                   child: Icon(
        //                     Icons.arrow_forward_ios,
        //                     color: Color(0xff5589F1),
        //                   ),
        //                 ),
        //                 // isError: isError,
        //               ),
        //           ],
        //         ),
        //       ),
        //     ),
        //   ],
        // ),
      ),
    );
  }
}